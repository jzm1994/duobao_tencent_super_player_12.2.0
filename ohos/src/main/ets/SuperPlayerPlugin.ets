import AbilityAware from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityAware';
import { AbilityPluginBinding } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityPluginBinding';

import { FlutterPlugin, FlutterPluginBinding, TextureRegistry, SurfaceTextureEntry } from '@ohos/flutter_ohos';
import { FTXBasePlayer } from './FTXBasePlayer';
import { FTXVodPlayer } from './FTXVodPlayer';
import { FTXLivePlayer } from './FTXLivePlayer';
import { FTXDownloadManager } from './FTXDownloadManager';
import { FTXEvent } from './FTXEvent';
import {
  PigeonChannelSetup,
  wrapResult, wrapEmpty,
  PlayerMsg, LicenseMsg, BoolMsg, IntMsg, StringMsg, DoubleMsg,
  BoolPlayerMsg, StringPlayerMsg, DoublePlayerMsg, IntPlayerMsg,
  TXPlayInfoParamsPlayerMsg, PipParamsPlayerMsg,
  FTXVodPlayConfigPlayerMsg, FTXLivePlayConfigPlayerMsg,
  TXVodDownloadMediaMsg, TXDownloadListMsg, PreLoadMsg, PreLoadInfoMsg, MapMsg, CachePathMsg,
  TXPlayerDrmMsg, StringListPlayerMsg, SubTitlePlayerMsg, SubTitleRenderModelPlayerMsg,
  StringOptionPlayerMsg, ListMsg, UInt8ListMsg
} from './FtxPigeonMessages';
import {
  getV2TXLivePremierShareInstance
} from 'liteavsdk';

const API_PLUGIN = 'TXFlutterSuperPlayerPluginAPI';
const API_NATIVE = 'TXFlutterNativeAPI';
const API_VOD = 'TXFlutterVodPlayerApi';
const API_LIVE = 'TXFlutterLivePlayerApi';
const API_DOWNLOAD = 'TXFlutterDownloadApi';

const FLUTTER_API_VOD = 'TXVodPlayerFlutterAPI';
const FLUTTER_API_LIVE = 'TXLivePlayerFlutterAPI';
const FLUTTER_API_DOWNLOAD = 'TXDownloadFlutterAPI';
const FLUTER_API_PLUGIN = 'TXPluginFlutterAPI';

export default class SuperPlayerPlugin implements FlutterPlugin, AbilityAware {
  private binding: FlutterPluginBinding | null = null;
  private pigeon: PigeonChannelSetup | null = null;
  private players: Map<number, FTXBasePlayer> = new Map();
  private textureRegistry: TextureRegistry | null = null;
  private textureEntries: Map<number, SurfaceTextureEntry> = new Map();
  private downloadManager: FTXDownloadManager | null = null;
  private context: Context | null = null;

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    console.info("SuperPlayerPlugin onAttachedToEngine ENTER binding=" + (binding != null));
    this.binding = binding;
    this.context = binding.getApplicationContext();
    this.pigeon = new PigeonChannelSetup(binding.getBinaryMessenger());
    this.textureRegistry = binding.getTextureRegistry();

    this.setupPluginApi();
    this.setupNativeApi();
    this.setupDownloadApi();

    this.downloadManager = new FTXDownloadManager(
      this.context,
      this.sendDownloadEvent.bind(this),
      this.sendPreDownloadEvent.bind(this)
    );
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.releaseAllPlayers();
    if (this.downloadManager) {
      this.downloadManager.destroy();
      this.downloadManager = null;
    }
    this.pigeon = null;
    this.binding = null;
    this.context = null;
  }

  getUniqueClassName(): string {
    return 'SuperPlayerPlugin';
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
  }

  onDetachedFromAbility(): void {
  }

  // ==================== TXFlutterSuperPlayerPluginAPI ====================

  private setupPluginApi(): void {
    const p = this.pigeon!;

    p.registerHostHandler(API_PLUGIN, 'getPlatformVersion', '', (msg) => {
      const r = new StringMsg();
      r.value = 'HarmonyOS';
      return wrapResult(r);
    });

    p.registerHostHandler(API_PLUGIN, 'getLiteAVSDKVersion', '', (msg) => {
      const r = new StringMsg();
      r.value = '13.2.0.8729';
      return wrapResult(r);
    });

    p.registerHostHandler(API_PLUGIN, 'createVodPlayer', '', (msg) => {
      const playerId = this.createVodPlayer();
      const r = new PlayerMsg();
      r.playerId = playerId;
      return wrapResult(r);
    });

    p.registerHostHandler(API_PLUGIN, 'createLivePlayer', '', (msg) => {
      const playerId = this.createLivePlayer();
      const r = new PlayerMsg();
      r.playerId = playerId;
      return wrapResult(r);
    });

    p.registerHostHandler(API_PLUGIN, 'releasePlayer', '', (msg) => {
      const args = msg as Object[];
      const playerMsg = args[0] as PlayerMsg;
      this.releasePlayer(playerMsg.playerId);
      return wrapResult(null);
    });

    p.registerHostHandler(API_PLUGIN, 'setConsoleEnabled', '', (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_PLUGIN, 'setGlobalMaxCacheSize', '', (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_PLUGIN, 'setGlobalCacheFolderPath', '', (msg) => {
      const r = new BoolMsg();
      r.value = true;
      return wrapResult(r);
    });

    p.registerHostHandler(API_PLUGIN, 'setGlobalCacheFolderCustomPath', '', (msg) => {
      const r = new BoolMsg();
      r.value = true;
      return wrapResult(r);
    });

    p.registerHostHandler(API_PLUGIN, 'setGlobalLicense', '', (msg) => {
      const args = msg as Object[];
      const licenseMsg = args[0] as LicenseMsg;
      this.setGlobalLicense(licenseMsg.licenseUrl ?? '', licenseMsg.licenseKey ?? '');
      return wrapResult(null);
    });

    p.registerHostHandler(API_PLUGIN, 'setLogLevel', '', (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_PLUGIN, 'setGlobalEnv', '', (msg) => {
      const r = new IntMsg();
      r.value = 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_PLUGIN, 'startVideoOrientationService', '', (msg) => {
      const r = new BoolMsg();
      r.value = false;
      return wrapResult(r);
    });

    p.registerHostHandler(API_PLUGIN, 'setUserId', '', (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_PLUGIN, 'setLicenseFlexibleValid', '', (msg) => {
      return wrapResult(null);
    });
  }

  // ==================== TXFlutterNativeAPI ====================

  private setupNativeApi(): void {
    const p = this.pigeon!;

    p.registerHostHandler(API_NATIVE, 'setBrightness', '', (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_NATIVE, 'restorePageBrightness', '', (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_NATIVE, 'getBrightness', '', (msg) => {
      const r = new DoubleMsg();
      r.value = 0.5;
      return wrapResult(r);
    });

    p.registerHostHandler(API_NATIVE, 'getSysBrightness', '', (msg) => {
      const r = new DoubleMsg();
      r.value = 0.5;
      return wrapResult(r);
    });

    p.registerHostHandler(API_NATIVE, 'setSystemVolume', '', (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_NATIVE, 'getSystemVolume', '', (msg) => {
      const r = new DoubleMsg();
      r.value = 0.5;
      return wrapResult(r);
    });

    p.registerHostHandler(API_NATIVE, 'abandonAudioFocus', '', (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_NATIVE, 'requestAudioFocus', '', (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_NATIVE, 'isDeviceSupportPip', '', (msg) => {
      const r = new IntMsg();
      r.value = 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_NATIVE, 'registerSysBrightness', '', (msg) => {
      return wrapResult(null);
    });
  }

  // ==================== TXFlutterVodPlayerApi (per player) ====================

  private setupVodApi(suffix: string, playerId: number): void {
    const p = this.pigeon!;

    p.registerHostHandler(API_VOD, 'initialize', suffix, (msg) => {
      this.getVodPlayer(playerId)?.initialize();
      const entry = this.textureEntries.get(playerId);
      const r = new IntMsg();
      r.value = entry?.getTextureId() ?? playerId;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'startVodPlay', suffix, (msg) => {
      const args = msg as Object[];
      const playerMsg = args[0] as StringPlayerMsg;
      this.getVodPlayer(playerId)?.startVodPlay(playerMsg.value ?? '');
      const r = new BoolMsg();
      r.value = true;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'startVodPlayWithParams', suffix, (msg) => {
      const args = msg as Object[];
      const paramsMsg = args[0] as TXPlayInfoParamsPlayerMsg;
      this.getVodPlayer(playerId)?.startVodPlayWithParams(
        paramsMsg.appId ?? 0, paramsMsg.fileId ?? '', paramsMsg.psign ?? '');
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'startPlayDrm', suffix, (msg) => {
      const args = msg as Object[];
      const drmMsg = args[0] as TXPlayerDrmMsg;
      const player = this.getVodPlayer(playerId);
      if (player && drmMsg.deviceCertificateUrl) {
        player.startPlayDrm(drmMsg.licenseUrl, drmMsg.playUrl, drmMsg.deviceCertificateUrl);
      } else if (player) {
        player.startPlayDrm(drmMsg.licenseUrl, drmMsg.playUrl);
      }
      const r = new IntMsg();
      r.value = 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'setAutoPlay', suffix, (msg) => {
      const args = msg as Object[];
      const boolMsg = args[0] as BoolPlayerMsg;
      this.getVodPlayer(playerId)?.setAutoPlay(boolMsg.value ?? false);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'stop', suffix, (msg) => {
      const args = msg as Object[];
      const boolMsg = args[0] as BoolPlayerMsg;
      this.getVodPlayer(playerId)?.stop(boolMsg.value ?? false);
      const r = new BoolMsg();
      r.value = true;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'isPlaying', suffix, (msg) => {
      const r = new BoolMsg();
      r.value = this.getVodPlayer(playerId)?.isPlaying() ?? false;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'pause', suffix, (msg) => {
      this.getVodPlayer(playerId)?.pause();
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'resume', suffix, (msg) => {
      this.getVodPlayer(playerId)?.resume();
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'setMute', suffix, (msg) => {
      const args = msg as Object[];
      const boolMsg = args[0] as BoolPlayerMsg;
      this.getVodPlayer(playerId)?.setMute(boolMsg.value ?? false);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'setLoop', suffix, (msg) => {
      const args = msg as Object[];
      const boolMsg = args[0] as BoolPlayerMsg;
      this.getVodPlayer(playerId)?.setLoop(boolMsg.value ?? false);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'seek', suffix, (msg) => {
      const args = msg as Object[];
      const doubleMsg = args[0] as DoublePlayerMsg;
      this.getVodPlayer(playerId)?.seek(doubleMsg.value ?? 0);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'seekToPdtTime', suffix, (msg) => {
      const args = msg as Object[];
      const intMsg = args[0] as IntPlayerMsg;
      this.getVodPlayer(playerId)?.seekToPdtTime(intMsg.value ?? 0);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'setRate', suffix, (msg) => {
      const args = msg as Object[];
      const doubleMsg = args[0] as DoublePlayerMsg;
      this.getVodPlayer(playerId)?.setRate(doubleMsg.value ?? 1.0);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'setConfig', suffix, (msg) => {
      const args = msg as Object[];
      const configMsg = args[0] as FTXVodPlayConfigPlayerMsg;
      this.getVodPlayer(playerId)?.setConfig(configMsg);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'getCurrentPlaybackTime', suffix, (msg) => {
      const r = new DoubleMsg();
      r.value = this.getVodPlayer(playerId)?.getCurrentPlaybackTime() ?? 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'getBufferDuration', suffix, (msg) => {
      const r = new DoubleMsg();
      r.value = this.getVodPlayer(playerId)?.getBufferDuration() ?? 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'getPlayableDuration', suffix, (msg) => {
      const r = new DoubleMsg();
      r.value = this.getVodPlayer(playerId)?.getPlayableDuration() ?? 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'getDuration', suffix, (msg) => {
      const r = new DoubleMsg();
      r.value = this.getVodPlayer(playerId)?.getDuration() ?? 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'getWidth', suffix, (msg) => {
      const r = new IntMsg();
      r.value = this.getVodPlayer(playerId)?.getWidth() ?? 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'getHeight', suffix, (msg) => {
      const r = new IntMsg();
      r.value = this.getVodPlayer(playerId)?.getHeight() ?? 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'setToken', suffix, (msg) => {
      // OHOS SDK does not expose setToken directly
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'isLoop', suffix, (msg) => {
      const r = new BoolMsg();
      r.value = this.getVodPlayer(playerId)?.isLoop() ?? false;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'enableHardwareDecode', suffix, (msg) => {
      const args = msg as Object[];
      const boolMsg = args[0] as BoolPlayerMsg;
      const r = new BoolMsg();
      r.value = this.getVodPlayer(playerId)?.enableHardwareDecode(boolMsg.value ?? true) ?? true;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'getBitrateIndex', suffix, (msg) => {
      const r = new IntMsg();
      r.value = this.getVodPlayer(playerId)?.getBitrateIndex() ?? -1;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'getSupportedBitrate', suffix, (msg) => {
      const r = new ListMsg();
      const bitrates = this.getVodPlayer(playerId)?.getSupportedBitrates();
      r.value = bitrates ?? [];
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'setBitrateIndex', suffix, (msg) => {
      const args = msg as Object[];
      const intMsg = args[0] as IntPlayerMsg;
      this.getVodPlayer(playerId)?.setBitrateIndex(intMsg.value ?? 0);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'setStartTime', suffix, (msg) => {
      const args = msg as Object[];
      const doubleMsg = args[0] as DoublePlayerMsg;
      this.getVodPlayer(playerId)?.setStartTime(doubleMsg.value ?? 0);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'setAudioPlayOutVolume', suffix, (msg) => {
      const args = msg as Object[];
      const intMsg = args[0] as IntPlayerMsg;
      this.getVodPlayer(playerId)?.setAudioPlayoutVolume(intMsg.value ?? 100);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'setRequestAudioFocus', suffix, (msg) => {
      const r = new BoolMsg();
      r.value = true;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'enterPictureInPictureMode', suffix, (msg) => {
      const r = new IntMsg();
      r.value = -101;
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'exitPictureInPictureMode', suffix, (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'initImageSprite', suffix, (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'getImageSprite', suffix, (msg) => {
      const r = new UInt8ListMsg();
      r.value = new Uint8Array(0);
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'addSubtitleSource', suffix, (msg) => {
      const args = msg as Object[];
      const subMsg = args[0] as SubTitlePlayerMsg;
      this.getVodPlayer(playerId)?.addSubtitleSource(
        subMsg.url ?? '', subMsg.name ?? '', subMsg.mimeType ?? undefined);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'getSubtitleTrackInfo', suffix, (msg) => {
      const r = new ListMsg();
      r.value = this.getVodPlayer(playerId)?.getSubtitleTrackInfo() ?? [];
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'getAudioTrackInfo', suffix, (msg) => {
      const r = new ListMsg();
      r.value = this.getVodPlayer(playerId)?.getAudioTrackInfo() ?? [];
      return wrapResult(r);
    });

    p.registerHostHandler(API_VOD, 'selectTrack', suffix, (msg) => {
      const args = msg as Object[];
      const intMsg = args[0] as IntPlayerMsg;
      this.getVodPlayer(playerId)?.selectTrack(intMsg.value ?? 0);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'deselectTrack', suffix, (msg) => {
      const args = msg as Object[];
      const intMsg = args[0] as IntPlayerMsg;
      this.getVodPlayer(playerId)?.deselectTrack(intMsg.value ?? 0);
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'setSubtitleStyle', suffix, (msg) => {
      this.getVodPlayer(playerId)?.setSubtitleStyle();
      return wrapResult(null);
    });

    p.registerHostHandler(API_VOD, 'setStringOption', suffix, (msg) => {
      const args = msg as Object[];
      const optMsg = args[0] as StringOptionPlayerMsg;
      this.getVodPlayer(playerId)?.setStringOption(optMsg.key ?? '', optMsg.value!);
      return wrapResult(null);
    });
  }

  // ==================== TXFlutterLivePlayerApi (per player) ====================

  private setupLiveApi(suffix: string, playerId: number): void {
    const p = this.pigeon!;

    p.registerHostHandler(API_LIVE, 'initialize', suffix, (msg) => {
      this.getLivePlayer(playerId)?.initialize();
      const entry = this.textureEntries.get(playerId);
      const r = new IntMsg();
      r.value = entry?.getTextureId() ?? playerId;
      return wrapResult(r);
    });

    p.registerHostHandler(API_LIVE, 'startLivePlay', suffix, (msg) => {
      const args = msg as Object[];
      const strMsg = args[0] as StringPlayerMsg;
      const ret = this.getLivePlayer(playerId)?.startLivePlay(strMsg.value ?? '') ?? -1;
      const r = new BoolMsg();
      r.value = ret === 0;
      return wrapResult(r);
    });

    p.registerHostHandler(API_LIVE, 'stop', suffix, (msg) => {
      const args = msg as Object[];
      const boolMsg = args[0] as BoolPlayerMsg;
      const ret = this.getLivePlayer(playerId)?.stop(boolMsg.value ?? false) ?? false;
      const r = new BoolMsg();
      r.value = ret;
      return wrapResult(r);
    });

    p.registerHostHandler(API_LIVE, 'isPlaying', suffix, (msg) => {
      const r = new BoolMsg();
      r.value = this.getLivePlayer(playerId)?.isPlaying() ?? false;
      return wrapResult(r);
    });

    p.registerHostHandler(API_LIVE, 'pause', suffix, (msg) => {
      this.getLivePlayer(playerId)?.pause();
      return wrapResult(null);
    });

    p.registerHostHandler(API_LIVE, 'resume', suffix, (msg) => {
      this.getLivePlayer(playerId)?.resume();
      return wrapResult(null);
    });

    p.registerHostHandler(API_LIVE, 'setLiveMode', suffix, (msg) => {
      const args = msg as Object[];
      const intMsg = args[0] as IntPlayerMsg;
      this.getLivePlayer(playerId)?.setLiveMode(intMsg.value ?? 0);
      return wrapResult(null);
    });

    p.registerHostHandler(API_LIVE, 'setVolume', suffix, (msg) => {
      const args = msg as Object[];
      const intMsg = args[0] as IntPlayerMsg;
      this.getLivePlayer(playerId)?.setVolume(intMsg.value ?? 100);
      return wrapResult(null);
    });

    p.registerHostHandler(API_LIVE, 'setMute', suffix, (msg) => {
      const args = msg as Object[];
      const boolMsg = args[0] as BoolPlayerMsg;
      this.getLivePlayer(playerId)?.setMute(boolMsg.value ?? false);
      return wrapResult(null);
    });

    p.registerHostHandler(API_LIVE, 'switchStream', suffix, (msg) => {
      const args = msg as Object[];
      const strMsg = args[0] as StringPlayerMsg;
      const ret = this.getLivePlayer(playerId)?.switchStream(strMsg.value ?? '') ?? -1;
      const r = new IntMsg();
      r.value = ret;
      return wrapResult(r);
    });

    p.registerHostHandler(API_LIVE, 'setAppID', suffix, (msg) => {
      const args = msg as Object[];
      const strMsg = args[0] as StringPlayerMsg;
      this.getLivePlayer(playerId)?.setAppID(strMsg.value ?? '');
      return wrapResult(null);
    });

    p.registerHostHandler(API_LIVE, 'setConfig', suffix, (msg) => {
      // Live config - decode but OHOS SDK has limited live config support
      return wrapResult(null);
    });

    p.registerHostHandler(API_LIVE, 'enableHardwareDecode', suffix, (msg) => {
      const args = msg as Object[];
      const boolMsg = args[0] as BoolPlayerMsg;
      const ret = this.getLivePlayer(playerId)?.enableHardwareDecode(boolMsg.value ?? true) ?? true;
      const r = new BoolMsg();
      r.value = ret;
      return wrapResult(r);
    });

    p.registerHostHandler(API_LIVE, 'enterPictureInPictureMode', suffix, (msg) => {
      const r = new IntMsg();
      r.value = -101;
      return wrapResult(r);
    });

    p.registerHostHandler(API_LIVE, 'exitPictureInPictureMode', suffix, (msg) => {
      return wrapResult(null);
    });

    p.registerHostHandler(API_LIVE, 'enableReceiveSeiMessage', suffix, (msg) => {
      const args = msg as Object[];
      const isEnabled = args[1] as boolean ?? false;
      const payloadType = args[2] as number ?? 5;
      const ret = this.getLivePlayer(playerId)?.enableReceiveSeiMessage(isEnabled, payloadType) ?? -1;
      return [ret as Object];
    });

    p.registerHostHandler(API_LIVE, 'showDebugView', suffix, (msg) => {
      // Wire format: [PlayerMsg, bool isShow]
      const args = msg as Object[];
      const isShow = args[1] as boolean ?? false;
      this.getLivePlayer(playerId)?.showDebugView(isShow);
      return wrapResult(null);
    });

    p.registerHostHandler(API_LIVE, 'setProperty', suffix, (msg) => {
      const args = msg as Object[];
      const key = args[1] as string ?? '';
      const value = args[2];
      const ret = this.getLivePlayer(playerId)?.setProperty(key, value!) ?? -1;
      return [ret as Object];
    });

    p.registerHostHandler(API_LIVE, 'getSupportedBitrate', suffix, (msg) => {
      const r = new ListMsg();
      r.value = [];
      return wrapResult(r);
    });

    p.registerHostHandler(API_LIVE, 'setCacheParams', suffix, (msg) => {
      const args = msg as Object[];
      const minTime = args[1] as number ?? 1.0;
      const maxTime = args[2] as number ?? 5.0;
      const ret = this.getLivePlayer(playerId)?.setCacheParams(minTime, maxTime) ?? -1;
      return [ret as Object];
    });

    p.registerHostHandler(API_LIVE, 'enablePictureInPicture', suffix, (msg) => {
      return [-101 as Object];
    });
  }

  // ==================== TXFlutterDownloadApi ====================

  private setupDownloadApi(): void {
    const p = this.pigeon!;

    p.registerHostHandler(API_DOWNLOAD, 'startPreLoad', '', (msg) => {
      const args = msg as Object[];
      const preLoadMsg = args[0] as PreLoadMsg;
      const r = new IntMsg();
      if (this.downloadManager) {
        r.value = this.downloadManager.startPreLoad(preLoadMsg);
      } else {
        r.value = 0;
      }
      return wrapResult(r);
    });

    p.registerHostHandler(API_DOWNLOAD, 'startPreLoadByParams', '', (msg) => {
      const args = msg as Object[];
      const preLoadInfoMsg = args[0] as PreLoadInfoMsg;
      if (this.downloadManager) {
        this.downloadManager.startPreLoadByParams(preLoadInfoMsg);
      }
      return wrapResult(null);
    });

    p.registerHostHandler(API_DOWNLOAD, 'stopPreLoad', '', (msg) => {
      const args = msg as Object[];
      const intMsg = args[0] as IntMsg;
      if (this.downloadManager) {
        this.downloadManager.stopPreLoad(intMsg.value ?? 0);
      }
      return wrapResult(null);
    });

    p.registerHostHandler(API_DOWNLOAD, 'startDownload', '', (msg) => {
      const args = msg as Object[];
      const downloadMsg = args[0] as TXVodDownloadMediaMsg;
      if (this.downloadManager) {
        this.downloadManager.startDownload(downloadMsg);
      }
      return wrapResult(null);
    });

    p.registerHostHandler(API_DOWNLOAD, 'resumeDownload', '', (msg) => {
      const args = msg as Object[];
      const downloadMsg = args[0] as TXVodDownloadMediaMsg;
      if (this.downloadManager) {
        this.downloadManager.resumeDownload(downloadMsg);
      }
      return wrapResult(null);
    });

    p.registerHostHandler(API_DOWNLOAD, 'stopDownload', '', (msg) => {
      const args = msg as Object[];
      const downloadMsg = args[0] as TXVodDownloadMediaMsg;
      if (this.downloadManager) {
        this.downloadManager.stopDownload(downloadMsg);
      }
      return wrapResult(null);
    });

    p.registerHostHandler(API_DOWNLOAD, 'setDownloadHeaders', '', (msg) => {
      const args = msg as Object[];
      const mapMsg = args[0] as MapMsg;
      if (this.downloadManager && mapMsg.map) {
        this.downloadManager.setDownloadHeaders(mapMsg.map);
      }
      return wrapResult(null);
    });

    p.registerHostHandler(API_DOWNLOAD, 'getDownloadList', '', (msg) => {
      if (this.downloadManager) {
        return wrapResult(this.downloadManager.getDownloadList());
      }
      return wrapResult(new TXDownloadListMsg());
    });

    p.registerHostHandler(API_DOWNLOAD, 'getDownloadInfo', '', (msg) => {
      const args = msg as Object[];
      const downloadMsg = args[0] as TXVodDownloadMediaMsg;
      if (this.downloadManager) {
        return wrapResult(this.downloadManager.getDownloadInfo(downloadMsg));
      }
      return wrapResult(new TXVodDownloadMediaMsg());
    });

    p.registerHostHandler(API_DOWNLOAD, 'deleteDownloadMediaInfo', '', (msg) => {
      const args = msg as Object[];
      const downloadMsg = args[0] as TXVodDownloadMediaMsg;
      const r = new BoolMsg();
      if (this.downloadManager) {
        r.value = this.downloadManager.deleteDownloadMediaInfo(downloadMsg);
      } else {
        r.value = false;
      }
      return wrapResult(r);
    });
  }

  // ==================== Player Management ====================

  private createVodPlayer(): number {
    if (!this.context || !this.pigeon || !this.textureRegistry) {
      return -1;
    }
    const player = new FTXVodPlayer(
      this.context,
      this.sendVodPlayerEvent.bind(this),
      this.sendVodNetEvent.bind(this)
    );
    const playerId = player.getPlayerId();
    // Create texture for video rendering
    const textureId = this.textureRegistry.getTextureId();
    const entry = this.textureRegistry.registerTexture(textureId);
    this.textureEntries.set(playerId, entry);
    // Bind render target to player
    player.setVideoRenderTarget(entry.getSurfaceId().toString());
    this.players.set(playerId, player);
    this.setupVodApi(playerId.toString(), playerId);
    return playerId;
  }

  private createLivePlayer(): number {
    if (!this.pigeon || !this.context || !this.textureRegistry) {
      return -1;
    }
    const player = new FTXLivePlayer(
      this.sendLivePlayerEvent.bind(this),
      this.sendLiveNetEvent.bind(this)
    );
    player.init(this.context);
    const playerId = player.getPlayerId();
    // Create texture for video rendering
    const textureId = this.textureRegistry.getTextureId();
    const entry = this.textureRegistry.registerTexture(textureId);
    this.textureEntries.set(playerId, entry);
    // Bind render view to player
    player.setRenderView(entry.getSurfaceId().toString());
    this.players.set(playerId, player);
    this.setupLiveApi(playerId.toString(), playerId);
    return playerId;
  }

  private releasePlayer(playerId: number | null): void {
    if (playerId == null) return;
    const player = this.players.get(playerId);
    if (player) {
      player.destroy();
      this.players.delete(playerId);
    }
    const entry = this.textureEntries.get(playerId);
    if (entry) {
      entry.release();
      this.textureEntries.delete(playerId);
    }
  }

  private releaseAllPlayers(): void {
    this.players.forEach((player) => {
      player.destroy();
    });
    this.players.clear();
    this.textureEntries.forEach((entry) => {
      entry.release();
    });
    this.textureEntries.clear();
  }

  private getVodPlayer(playerId: number): FTXVodPlayer | null {
    return this.players.get(playerId) as FTXVodPlayer ?? null;
  }

  private getLivePlayer(playerId: number): FTXLivePlayer | null {
    return this.players.get(playerId) as FTXLivePlayer ?? null;
  }

  // ==================== Global Settings ====================

  private setGlobalLicense(licenceUrl: string, licenceKey: string): void {
    if (this.context) {
      try {
        const premier = getV2TXLivePremierShareInstance(this.context);
        premier.setLicence(licenceUrl, licenceKey);
        premier.setObserver({
          onLicenceLoaded: (result: number, reason: string) => {
            const event: Record<string, Object> = {
              'event': FTXEvent.EVENT_ON_LICENCE_LOADED as Object,
              'result': result as Object,
              'reason': reason as Object
            };
            this.pigeon?.sendFlutterEvent(FLUTER_API_PLUGIN, 'onSDKListener', '', event);
          }
        });
      } catch (e) {
        // License setup may fail gracefully
      }
    }
  }

  // ==================== Event Callbacks to Flutter ====================

  private sendVodPlayerEvent(playerId: number, event: Record<string, Object>): void {
    this.pigeon?.sendFlutterEvent(FLUTTER_API_VOD, 'onPlayerEvent', playerId.toString(), event);
  }

  private sendVodNetEvent(playerId: number, event: Record<string, Object>): void {
    this.pigeon?.sendFlutterEvent(FLUTTER_API_VOD, 'onNetEvent', playerId.toString(), event);
  }

  private sendLivePlayerEvent(playerId: number, event: Record<string, Object>): void {
    this.pigeon?.sendFlutterEvent(FLUTTER_API_LIVE, 'onPlayerEvent', playerId.toString(), event);
  }

  private sendLiveNetEvent(playerId: number, event: Record<string, Object>): void {
    this.pigeon?.sendFlutterEvent(FLUTTER_API_LIVE, 'onNetEvent', playerId.toString(), event);
  }

  private sendDownloadEvent(event: Record<string, Object>): void {
    this.pigeon?.sendFlutterEvent(FLUTTER_API_DOWNLOAD, 'onDownloadEvent', '', event);
  }

  private sendPreDownloadEvent(event: Record<string, Object>): void {
    this.pigeon?.sendFlutterEvent(FLUTTER_API_DOWNLOAD, 'onPreDownloadEvent', '', event);
  }
}
