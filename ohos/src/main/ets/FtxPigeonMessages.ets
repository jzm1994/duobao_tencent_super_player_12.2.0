import {
  BinaryMessenger,
  BasicMessageChannel,
  StandardMessageCodec,
  MessageCodec,
  Reply
} from '@ohos/flutter_ohos';
import { ByteBuffer } from '@ohos/flutter_ohos';

// ==================== Pigeon Channel Name Prefix ====================
export const PIGEON_PREFIX = 'dev.flutter.pigeon.super_player.';

// ==================== Pigeon Response Helpers ====================
export function wrapResult(result: Object | null): Object[] {
  return [result!];
}

export function wrapError(errorCode: string, errorMsg: string, details: Object | null): Object[] {
  return [errorCode as Object, errorMsg as Object, details!];
}

export function wrapEmpty(): Object[] {
  return [];
}

// ==================== Message Classes ====================

export class PlayerMsg {
  playerId: number | null = null;
  encode(): Object[] { return [this.playerId as Object]; }
  static decode(result: Object[]): PlayerMsg {
    const msg = new PlayerMsg();
    msg.playerId = result[0] as number | null;
    return msg;
  }
}

export class LicenseMsg {
  licenseUrl: string | null = null;
  licenseKey: string | null = null;
  encode(): Object[] { return [this.licenseUrl as Object, this.licenseKey as Object]; }
  static decode(result: Object[]): LicenseMsg {
    const msg = new LicenseMsg();
    msg.licenseUrl = result[0] as string | null;
    msg.licenseKey = result[1] as string | null;
    return msg;
  }
}

export class BoolMsg {
  value: boolean | null = null;
  encode(): Object[] { return [this.value as Object]; }
  static decode(result: Object[]): BoolMsg {
    const msg = new BoolMsg();
    msg.value = result[0] as boolean | null;
    return msg;
  }
}

export class IntMsg {
  value: number | null = null;
  encode(): Object[] { return [this.value as Object]; }
  static decode(result: Object[]): IntMsg {
    const msg = new IntMsg();
    msg.value = result[0] as number | null;
    return msg;
  }
}

export class StringMsg {
  value: string | null = null;
  encode(): Object[] { return [this.value as Object]; }
  static decode(result: Object[]): StringMsg {
    const msg = new StringMsg();
    msg.value = result[0] as string | null;
    return msg;
  }
}

export class DoubleMsg {
  value: number | null = null;
  encode(): Object[] { return [this.value as Object]; }
  static decode(result: Object[]): DoubleMsg {
    const msg = new DoubleMsg();
    msg.value = result[0] as number | null;
    return msg;
  }
}

export class BoolPlayerMsg {
  playerId: number | null = null;
  value: boolean | null = null;
  encode(): Object[] { return [this.playerId as Object, this.value as Object]; }
  static decode(result: Object[]): BoolPlayerMsg {
    const msg = new BoolPlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.value = result[1] as boolean | null;
    return msg;
  }
}

export class IntPlayerMsg {
  playerId: number | null = null;
  value: number | null = null;
  encode(): Object[] { return [this.playerId as Object, this.value as Object]; }
  static decode(result: Object[]): IntPlayerMsg {
    const msg = new IntPlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.value = result[1] as number | null;
    return msg;
  }
}

export class StringPlayerMsg {
  playerId: number | null = null;
  value: string | null = null;
  encode(): Object[] { return [this.playerId as Object, this.value as Object]; }
  static decode(result: Object[]): StringPlayerMsg {
    const msg = new StringPlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.value = result[1] as string | null;
    return msg;
  }
}

export class DoublePlayerMsg {
  playerId: number | null = null;
  value: number | null = null;
  encode(): Object[] { return [this.playerId as Object, this.value as Object]; }
  static decode(result: Object[]): DoublePlayerMsg {
    const msg = new DoublePlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.value = result[1] as number | null;
    return msg;
  }
}

export class TXPlayInfoParamsPlayerMsg {
  playerId: number | null = null;
  appId: number | null = null;
  fileId: string | null = null;
  psign: string | null = null;
  url: string | null = null;
  encode(): Object[] {
    return [this.playerId as Object, this.appId as Object, this.fileId as Object,
      this.psign as Object, this.url as Object];
  }
  static decode(result: Object[]): TXPlayInfoParamsPlayerMsg {
    const msg = new TXPlayInfoParamsPlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.appId = result[1] as number | null;
    msg.fileId = result[2] as string | null;
    msg.psign = result[3] as string | null;
    msg.url = result[4] as string | null;
    return msg;
  }
}

export class PipParamsPlayerMsg {
  playerId: number | null = null;
  backIconForAndroid: string | null = null;
  playIconForAndroid: string | null = null;
  pauseIconForAndroid: string | null = null;
  forwardIconForAndroid: string | null = null;
  encode(): Object[] {
    return [this.playerId as Object, this.backIconForAndroid as Object, this.playIconForAndroid as Object,
      this.pauseIconForAndroid as Object, this.forwardIconForAndroid as Object];
  }
  static decode(result: Object[]): PipParamsPlayerMsg {
    const msg = new PipParamsPlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.backIconForAndroid = result[1] as string | null;
    msg.playIconForAndroid = result[2] as string | null;
    msg.pauseIconForAndroid = result[3] as string | null;
    msg.forwardIconForAndroid = result[4] as string | null;
    return msg;
  }
}

export class FTXVodPlayConfigPlayerMsg {
  playerId: number | null = null;
  connectRetryCount: number | null = null;
  connectRetryInterval: number | null = null;
  timeout: number | null = null;
  playerType: number | null = null;
  headers: Map<string, string> | null = null;
  enableAccurateSeek: boolean | null = null;
  autoRotate: boolean | null = null;
  smoothSwitchBitrate: boolean | null = null;
  cacheMp4ExtName: string | null = null;
  progressInterval: number | null = null;
  maxBufferSize: number | null = null;
  maxPreloadSize: number | null = null;
  firstStartPlayBufferTime: number | null = null;
  nextStartPlayBufferTime: number | null = null;
  overlayKey: string | null = null;
  overlayIv: string | null = null;
  extInfoMap: Map<string, Object> | null = null;
  enableRenderProcess: boolean | null = null;
  preferredResolution: number | null = null;
  mediaType: number | null = null;
  encryptedMp4Level: number | null = null;
  encode(): Object[] {
    return [this.playerId as Object, this.connectRetryCount as Object, this.connectRetryInterval as Object,
      this.timeout as Object, this.playerType as Object, this.headers as Object, this.enableAccurateSeek as Object,
      this.autoRotate as Object, this.smoothSwitchBitrate as Object, this.cacheMp4ExtName as Object,
      this.progressInterval as Object, this.maxBufferSize as Object, this.maxPreloadSize as Object,
      this.firstStartPlayBufferTime as Object, this.nextStartPlayBufferTime as Object,
      this.overlayKey as Object, this.overlayIv as Object, this.extInfoMap as Object,
      this.enableRenderProcess as Object, this.preferredResolution as Object,
      this.mediaType as Object, this.encryptedMp4Level as Object];
  }
  static decode(result: Object[]): FTXVodPlayConfigPlayerMsg {
    const msg = new FTXVodPlayConfigPlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.connectRetryCount = result[1] as number | null;
    msg.connectRetryInterval = result[2] as number | null;
    msg.timeout = result[3] as number | null;
    msg.playerType = result[4] as number | null;
    msg.headers = result[5] as Map<string, string> | null;
    msg.enableAccurateSeek = result[6] as boolean | null;
    msg.autoRotate = result[7] as boolean | null;
    msg.smoothSwitchBitrate = result[8] as boolean | null;
    msg.cacheMp4ExtName = result[9] as string | null;
    msg.progressInterval = result[10] as number | null;
    msg.maxBufferSize = result[11] as number | null;
    msg.maxPreloadSize = result[12] as number | null;
    msg.firstStartPlayBufferTime = result[13] as number | null;
    msg.nextStartPlayBufferTime = result[14] as number | null;
    msg.overlayKey = result[15] as string | null;
    msg.overlayIv = result[16] as string | null;
    msg.extInfoMap = result[17] as Map<string, Object> | null;
    msg.enableRenderProcess = result[18] as boolean | null;
    msg.preferredResolution = result[19] as number | null;
    msg.mediaType = result[20] as number | null;
    msg.encryptedMp4Level = result[21] as number | null;
    return msg;
  }
}

export class FTXLivePlayConfigPlayerMsg {
  playerId: number | null = null;
  cacheTime: number | null = null;
  maxAutoAdjustCacheTime: number | null = null;
  minAutoAdjustCacheTime: number | null = null;
  videoBlockThreshold: number | null = null;
  connectRetryCount: number | null = null;
  connectRetryInterval: number | null = null;
  autoAdjustCacheTime: boolean | null = null;
  enableAec: boolean | null = null;
  enableMessage: boolean | null = null;
  enableMetaData: boolean | null = null;
  flvSessionKey: string | null = null;
  encode(): Object[] {
    return [this.playerId as Object, this.cacheTime as Object, this.maxAutoAdjustCacheTime as Object,
      this.minAutoAdjustCacheTime as Object, this.videoBlockThreshold as Object, this.connectRetryCount as Object,
      this.connectRetryInterval as Object, this.autoAdjustCacheTime as Object, this.enableAec as Object,
      this.enableMessage as Object, this.enableMetaData as Object, this.flvSessionKey as Object];
  }
  static decode(result: Object[]): FTXLivePlayConfigPlayerMsg {
    const msg = new FTXLivePlayConfigPlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.cacheTime = result[1] as number | null;
    msg.maxAutoAdjustCacheTime = result[2] as number | null;
    msg.minAutoAdjustCacheTime = result[3] as number | null;
    msg.videoBlockThreshold = result[4] as number | null;
    msg.connectRetryCount = result[5] as number | null;
    msg.connectRetryInterval = result[6] as number | null;
    msg.autoAdjustCacheTime = result[7] as boolean | null;
    msg.enableAec = result[8] as boolean | null;
    msg.enableMessage = result[9] as boolean | null;
    msg.enableMetaData = result[10] as boolean | null;
    msg.flvSessionKey = result[11] as string | null;
    return msg;
  }
}

export class TXVodDownloadMediaMsg {
  playPath: string | null = null;
  progress: number | null = null;
  downloadState: number | null = null;
  userName: string | null = null;
  duration: number | null = null;
  playableDuration: number | null = null;
  size: number | null = null;
  downloadSize: number | null = null;
  url: string | null = null;
  appId: number | null = null;
  fileId: string | null = null;
  pSign: string | null = null;
  quality: number | null = null;
  token: string | null = null;
  speed: number | null = null;
  isResourceBroken: boolean | null = null;
  encode(): Object[] {
    return [this.playPath as Object, this.progress as Object, this.downloadState as Object,
      this.userName as Object, this.duration as Object, this.playableDuration as Object,
      this.size as Object, this.downloadSize as Object, this.url as Object,
      this.appId as Object, this.fileId as Object, this.pSign as Object,
      this.quality as Object, this.token as Object, this.speed as Object,
      this.isResourceBroken as Object];
  }
  static decode(result: Object[]): TXVodDownloadMediaMsg {
    const msg = new TXVodDownloadMediaMsg();
    msg.playPath = result[0] as string | null;
    msg.progress = result[1] as number | null;
    msg.downloadState = result[2] as number | null;
    msg.userName = result[3] as string | null;
    msg.duration = result[4] as number | null;
    msg.playableDuration = result[5] as number | null;
    msg.size = result[6] as number | null;
    msg.downloadSize = result[7] as number | null;
    msg.url = result[8] as string | null;
    msg.appId = result[9] as number | null;
    msg.fileId = result[10] as string | null;
    msg.pSign = result[11] as string | null;
    msg.quality = result[12] as number | null;
    msg.token = result[13] as string | null;
    msg.speed = result[14] as number | null;
    msg.isResourceBroken = result[15] as boolean | null;
    return msg;
  }
}

export class PreLoadMsg {
  playUrl: string | null = null;
  preloadSizeMB: number | null = null;
  preferredResolution: number | null = null;
  encode(): Object[] { return [this.playUrl as Object, this.preloadSizeMB as Object, this.preferredResolution as Object]; }
  static decode(result: Object[]): PreLoadMsg {
    const msg = new PreLoadMsg();
    msg.playUrl = result[0] as string | null;
    msg.preloadSizeMB = result[1] as number | null;
    msg.preferredResolution = result[2] as number | null;
    return msg;
  }
}

export class MapMsg {
  map: Map<string, string> | null = null;
  encode(): Object[] { return [this.map as Object]; }
  static decode(result: Object[]): MapMsg {
    const msg = new MapMsg();
    msg.map = result[0] as Map<string, string> | null;
    return msg;
  }
}

export class CachePathMsg {
  androidAbsolutePath: string | null = null;
  iOSAbsolutePath: string | null = null;
  encode(): Object[] { return [this.androidAbsolutePath as Object, this.iOSAbsolutePath as Object]; }
  static decode(result: Object[]): CachePathMsg {
    const msg = new CachePathMsg();
    msg.androidAbsolutePath = result[0] as string | null;
    msg.iOSAbsolutePath = result[1] as string | null;
    return msg;
  }
}

export class TXPlayerDrmMsg {
  licenseUrl: string = '';
  playUrl: string = '';
  playerId: number | null = null;
  deviceCertificateUrl: string | null = null;
  encode(): Object[] { return [this.licenseUrl as Object, this.playUrl as Object, this.playerId as Object, this.deviceCertificateUrl as Object]; }
  static decode(result: Object[]): TXPlayerDrmMsg {
    const msg = new TXPlayerDrmMsg();
    msg.licenseUrl = result[0] as string ?? '';
    msg.playUrl = result[1] as string ?? '';
    msg.playerId = result[2] as number | null;
    msg.deviceCertificateUrl = result[3] as string | null;
    return msg;
  }
}

export class StringListPlayerMsg {
  playerId: number | null = null;
  vvtUrl: string | null = null;
  imageUrls: string[] | null = null;
  encode(): Object[] { return [this.playerId as Object, this.vvtUrl as Object, this.imageUrls as Object]; }
  static decode(result: Object[]): StringListPlayerMsg {
    const msg = new StringListPlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.vvtUrl = result[1] as string | null;
    msg.imageUrls = result[2] as string[] | null;
    return msg;
  }
}

export class SubTitlePlayerMsg {
  url: string | null = null;
  name: string | null = null;
  mimeType: string | null = null;
  playerId: number | null = null;
  encode(): Object[] { return [this.url as Object, this.name as Object, this.mimeType as Object, this.playerId as Object]; }
  static decode(result: Object[]): SubTitlePlayerMsg {
    const msg = new SubTitlePlayerMsg();
    msg.url = result[0] as string | null;
    msg.name = result[1] as string | null;
    msg.mimeType = result[2] as string | null;
    msg.playerId = result[3] as number | null;
    return msg;
  }
}

export class SubTitleRenderModelPlayerMsg {
  canvasWidth: number | null = null;
  canvasHeight: number | null = null;
  familyName: string | null = null;
  fontSize: number | null = null;
  fontScale: number | null = null;
  fontColor: number | null = null;
  isBondFontStyle: boolean | null = null;
  outlineWidth: number | null = null;
  outlineColor: number | null = null;
  lineSpace: number | null = null;
  startMargin: number | null = null;
  endMargin: number | null = null;
  verticalMargin: number | null = null;
  playerId: number | null = null;
  encode(): Object[] {
    return [this.canvasWidth as Object, this.canvasHeight as Object,
      this.familyName as Object, this.fontSize as Object, this.fontScale as Object,
      this.fontColor as Object, this.isBondFontStyle as Object, this.outlineWidth as Object,
      this.outlineColor as Object, this.lineSpace as Object, this.startMargin as Object,
      this.endMargin as Object, this.verticalMargin as Object, this.playerId as Object];
  }
  static decode(result: Object[]): SubTitleRenderModelPlayerMsg {
    const msg = new SubTitleRenderModelPlayerMsg();
    msg.canvasWidth = result[0] as number | null;
    msg.canvasHeight = result[1] as number | null;
    msg.familyName = result[2] as string | null;
    msg.fontSize = result[3] as number | null;
    msg.fontScale = result[4] as number | null;
    msg.fontColor = result[5] as number | null;
    msg.isBondFontStyle = result[6] as boolean | null;
    msg.outlineWidth = result[7] as number | null;
    msg.outlineColor = result[8] as number | null;
    msg.lineSpace = result[9] as number | null;
    msg.startMargin = result[10] as number | null;
    msg.endMargin = result[11] as number | null;
    msg.verticalMargin = result[12] as number | null;
    msg.playerId = result[13] as number | null;
    return msg;
  }
}

export class StringOptionPlayerMsg {
  key: string | null = null;
  value: Object[] | null = null;
  playerId: number | null = null;
  encode(): Object[] { return [this.key as Object, this.value as Object, this.playerId as Object]; }
  static decode(result: Object[]): StringOptionPlayerMsg {
    const msg = new StringOptionPlayerMsg();
    msg.key = result[0] as string | null;
    msg.value = result[1] as Object[] | null;
    msg.playerId = result[2] as number | null;
    return msg;
  }
}

export class PreLoadInfoMsg {
  appId: number | null = null;
  fileId: string | null = null;
  pSign: string | null = null;
  playUrl: string | null = null;
  preloadSizeMB: number | null = null;
  preferredResolution: number | null = null;
  tmpPreloadTaskId: number | null = null;
  httpHeader: Map<string, string> | null = null;
  encode(): Object[] {
    return [this.appId as Object, this.fileId as Object, this.pSign as Object,
      this.playUrl as Object, this.preloadSizeMB as Object, this.preferredResolution as Object,
      this.tmpPreloadTaskId as Object, this.httpHeader as Object];
  }
  static decode(result: Object[]): PreLoadInfoMsg {
    const msg = new PreLoadInfoMsg();
    msg.appId = result[0] as number | null;
    msg.fileId = result[1] as string | null;
    msg.pSign = result[2] as string | null;
    msg.playUrl = result[3] as string | null;
    msg.preloadSizeMB = result[4] as number | null;
    msg.preferredResolution = result[5] as number | null;
    msg.tmpPreloadTaskId = result[6] as number | null;
    msg.httpHeader = result[7] as Map<string, string> | null;
    return msg;
  }
}

export class StringIntPlayerMsg {
  playerId: number | null = null;
  strValue: string | null = null;
  intValue: number | null = null;
  encode(): Object[] { return [this.playerId as Object, this.strValue as Object, this.intValue as Object]; }
  static decode(result: Object[]): StringIntPlayerMsg {
    const msg = new StringIntPlayerMsg();
    msg.playerId = result[0] as number | null;
    msg.strValue = result[1] as string | null;
    msg.intValue = result[2] as number | null;
    return msg;
  }
}

export class UInt8ListMsg {
  value: Uint8Array | null = null;
  encode(): Object[] { return [this.value as Object]; }
  static decode(result: Object[]): UInt8ListMsg {
    const msg = new UInt8ListMsg();
    msg.value = result[0] as Uint8Array | null;
    return msg;
  }
}

export class ListMsg {
  value: Object[] | null = null;
  encode(): Object[] { return [this.value as Object]; }
  static decode(result: Object[]): ListMsg {
    const msg = new ListMsg();
    msg.value = result[0] as Object[] | null;
    return msg;
  }
}

export class TXDownloadListMsg {
  infoList: TXVodDownloadMediaMsg[] | null = null;
  encode(): Object[] {
    const encoded: Object[] = [];
    if (this.infoList) {
      for (const item of this.infoList) {
        encoded.push(item.encode() as Object);
      }
    }
    return [encoded as Object];
  }
  static decode(result: Object[]): TXDownloadListMsg {
    const msg = new TXDownloadListMsg();
    const arr = result[0] as Object[] | null;
    if (arr) {
      msg.infoList = [];
      for (const item of arr) {
        msg.infoList.push(TXVodDownloadMediaMsg.decode(item as Object[]));
      }
    }
    return msg;
  }
}

// ==================== PigeonCodec ====================
// Extends StandardMessageCodec to handle Pigeon custom types (byte IDs 129-156)

const CODEC_PLAYER_MSG = 129;
const CODEC_LICENSE_MSG = 130;
const CODEC_TXPLAY_INFO_PARAMS = 131;
const CODEC_TXPLAYER_DRM = 132;
const CODEC_PIP_PARAMS = 133;
const CODEC_STRING_LIST = 134;
const CODEC_BOOL_PLAYER = 135;
const CODEC_STRING_INT = 136;
const CODEC_STRING_PLAYER = 137;
const CODEC_DOUBLE_PLAYER = 138;
const CODEC_INT_PLAYER = 139;
const CODEC_VOD_PLAY_CONFIG = 140;
const CODEC_LIVE_PLAY_CONFIG = 141;
const CODEC_VOD_DOWNLOAD_MEDIA = 142;
const CODEC_DOWNLOAD_LIST = 143;
const CODEC_UINT8LIST = 144;
const CODEC_LIST = 145;
const CODEC_BOOL_MSG = 146;
const CODEC_INT_MSG = 147;
const CODEC_STRING_MSG = 148;
const CODEC_CACHE_PATH = 149;
const CODEC_DOUBLE_MSG = 150;
const CODEC_PRELOAD = 151;
const CODEC_PRELOAD_INFO = 152;
const CODEC_MAP = 153;
const CODEC_SUBTITLE = 154;
const CODEC_SUBTITLE_RENDER = 155;
const CODEC_STRING_OPTION = 156;

class PigeonCodec extends StandardMessageCodec {
  writeValue(stream: ByteBuffer, value: Object): Object {
    if (value instanceof PlayerMsg) {
      stream.writeInt8(CODEC_PLAYER_MSG);
      super.writeValue(stream, value.encode());
    } else if (value instanceof LicenseMsg) {
      stream.writeInt8(CODEC_LICENSE_MSG);
      super.writeValue(stream, value.encode());
    } else if (value instanceof TXPlayInfoParamsPlayerMsg) {
      stream.writeInt8(CODEC_TXPLAY_INFO_PARAMS);
      super.writeValue(stream, value.encode());
    } else if (value instanceof TXPlayerDrmMsg) {
      stream.writeInt8(CODEC_TXPLAYER_DRM);
      super.writeValue(stream, value.encode());
    } else if (value instanceof PipParamsPlayerMsg) {
      stream.writeInt8(CODEC_PIP_PARAMS);
      super.writeValue(stream, value.encode());
    } else if (value instanceof StringListPlayerMsg) {
      stream.writeInt8(CODEC_STRING_LIST);
      super.writeValue(stream, value.encode());
    } else if (value instanceof BoolPlayerMsg) {
      stream.writeInt8(CODEC_BOOL_PLAYER);
      super.writeValue(stream, value.encode());
    } else if (value instanceof StringIntPlayerMsg) {
      stream.writeInt8(CODEC_STRING_INT);
      super.writeValue(stream, value.encode());
    } else if (value instanceof StringPlayerMsg) {
      stream.writeInt8(CODEC_STRING_PLAYER);
      super.writeValue(stream, value.encode());
    } else if (value instanceof DoublePlayerMsg) {
      stream.writeInt8(CODEC_DOUBLE_PLAYER);
      super.writeValue(stream, value.encode());
    } else if (value instanceof IntPlayerMsg) {
      stream.writeInt8(CODEC_INT_PLAYER);
      super.writeValue(stream, value.encode());
    } else if (value instanceof FTXVodPlayConfigPlayerMsg) {
      stream.writeInt8(CODEC_VOD_PLAY_CONFIG);
      super.writeValue(stream, value.encode());
    } else if (value instanceof FTXLivePlayConfigPlayerMsg) {
      stream.writeInt8(CODEC_LIVE_PLAY_CONFIG);
      super.writeValue(stream, value.encode());
    } else if (value instanceof TXVodDownloadMediaMsg) {
      stream.writeInt8(CODEC_VOD_DOWNLOAD_MEDIA);
      super.writeValue(stream, value.encode());
    } else if (value instanceof TXDownloadListMsg) {
      stream.writeInt8(CODEC_DOWNLOAD_LIST);
      super.writeValue(stream, value.encode());
    } else if (value instanceof UInt8ListMsg) {
      stream.writeInt8(CODEC_UINT8LIST);
      super.writeValue(stream, value.encode());
    } else if (value instanceof ListMsg) {
      stream.writeInt8(CODEC_LIST);
      super.writeValue(stream, value.encode());
    } else if (value instanceof BoolMsg) {
      stream.writeInt8(CODEC_BOOL_MSG);
      super.writeValue(stream, value.encode());
    } else if (value instanceof IntMsg) {
      stream.writeInt8(CODEC_INT_MSG);
      super.writeValue(stream, value.encode());
    } else if (value instanceof StringMsg) {
      stream.writeInt8(CODEC_STRING_MSG);
      super.writeValue(stream, value.encode());
    } else if (value instanceof CachePathMsg) {
      stream.writeInt8(CODEC_CACHE_PATH);
      super.writeValue(stream, value.encode());
    } else if (value instanceof DoubleMsg) {
      stream.writeInt8(CODEC_DOUBLE_MSG);
      super.writeValue(stream, value.encode());
    } else if (value instanceof PreLoadMsg) {
      stream.writeInt8(CODEC_PRELOAD);
      super.writeValue(stream, value.encode());
    } else if (value instanceof PreLoadInfoMsg) {
      stream.writeInt8(CODEC_PRELOAD_INFO);
      super.writeValue(stream, value.encode());
    } else if (value instanceof MapMsg) {
      stream.writeInt8(CODEC_MAP);
      super.writeValue(stream, value.encode());
    } else if (value instanceof SubTitlePlayerMsg) {
      stream.writeInt8(CODEC_SUBTITLE);
      super.writeValue(stream, value.encode());
    } else if (value instanceof SubTitleRenderModelPlayerMsg) {
      stream.writeInt8(CODEC_SUBTITLE_RENDER);
      super.writeValue(stream, value.encode());
    } else if (value instanceof StringOptionPlayerMsg) {
      stream.writeInt8(CODEC_STRING_OPTION);
      super.writeValue(stream, value.encode());
    } else {
      super.writeValue(stream, value);
    }
    return stream;
  }

  readValueOfType(type: number, buffer: ByteBuffer): Object {
    switch (type) {
      case CODEC_PLAYER_MSG:
        return PlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_LICENSE_MSG:
        return LicenseMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_TXPLAY_INFO_PARAMS:
        return TXPlayInfoParamsPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_TXPLAYER_DRM:
        return TXPlayerDrmMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_PIP_PARAMS:
        return PipParamsPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_STRING_LIST:
        return StringListPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_BOOL_PLAYER:
        return BoolPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_STRING_INT:
        return StringIntPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_STRING_PLAYER:
        return StringPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_DOUBLE_PLAYER:
        return DoublePlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_INT_PLAYER:
        return IntPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_VOD_PLAY_CONFIG:
        return FTXVodPlayConfigPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_LIVE_PLAY_CONFIG:
        return FTXLivePlayConfigPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_VOD_DOWNLOAD_MEDIA:
        return TXVodDownloadMediaMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_DOWNLOAD_LIST:
        return TXDownloadListMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_UINT8LIST:
        return UInt8ListMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_LIST:
        return ListMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_BOOL_MSG:
        return BoolMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_INT_MSG:
        return IntMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_STRING_MSG:
        return StringMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_CACHE_PATH:
        return CachePathMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_DOUBLE_MSG:
        return DoubleMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_PRELOAD:
        return PreLoadMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_PRELOAD_INFO:
        return PreLoadInfoMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_MAP:
        return MapMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_SUBTITLE:
        return SubTitlePlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_SUBTITLE_RENDER:
        return SubTitleRenderModelPlayerMsg.decode(super.readValue(buffer) as Object[]);
      case CODEC_STRING_OPTION:
        return StringOptionPlayerMsg.decode(super.readValue(buffer) as Object[]);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

const pigeonCodec = new PigeonCodec();

// ==================== Pigeon Channel Setup Helpers ====================

export type PigeonHandler = (message: Object | null) => Object[];

interface PigeonMessageHandler {
  onMessage(message: Object | null, reply: Reply<Object>): void;
}

class PigeonHandlerImpl implements PigeonMessageHandler {
  private handler: PigeonHandler;
  constructor(handler: PigeonHandler) {
    this.handler = handler;
  }
  onMessage(message: Object | null, reply: Reply<Object>): void {
    try {
      const result = this.handler(message);
      reply.reply(result);
    } catch (e) {
      reply.reply(wrapError('error', String(e), null));
    }
  }
}

export class PigeonChannelSetup {
  private messenger: BinaryMessenger;

  constructor(messenger: BinaryMessenger) {
    this.messenger = messenger;
  }

  private getChannelName(apiClass: string, method: string, suffix: string): string {
    const s = suffix.length > 0 ? '.' + suffix : '';
    return PIGEON_PREFIX + apiClass + '.' + method + s;
  }

  registerHostHandler(apiClass: string, method: string, suffix: string, handler: PigeonHandler): void {
    const channelName = this.getChannelName(apiClass, method, suffix);
    const channel: BasicMessageChannel<Object> = new BasicMessageChannel<Object>(this.messenger, channelName, pigeonCodec);
    const handlerObj: PigeonHandlerImpl = new PigeonHandlerImpl(handler);
    channel.setMessageHandler(handlerObj);
  }

  sendFlutterEvent(apiClass: string, method: string, suffix: string, arg: Object): void {
    const channelName = this.getChannelName(apiClass, method, suffix);
    const channel: BasicMessageChannel<Object> = new BasicMessageChannel<Object>(this.messenger, channelName, pigeonCodec);
    channel.send([arg]);
  }
}
