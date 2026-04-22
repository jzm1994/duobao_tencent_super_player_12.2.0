import { FTXBasePlayer } from './FTXBasePlayer';
import { FTXEvent } from './FTXEvent';
import { FTXTransformation } from './FTXTransformation';
import { FTXVodPlayConfigPlayerMsg } from './FtxPigeonMessages';
import {
  TXVodPlayer,
  TXVodDef,
  TXVodPlayConfig,
  ITXVodPlayCallback
} from 'liteavsdk';

export class FTXVodPlayer extends FTXBasePlayer {
  private vodPlayer: TXVodPlayer | null = null;
  private sendPlayerEvent: (playerId: number, event: Record<string, Object>) => void;
  private sendNetEvent: (playerId: number, event: Record<string, Object>) => void;
  private lastProgressTime: number = 0; // 进度事件节流时间戳
  private lastNetStatusTime: number = 0; // 网络状态事件节流时间戳

  constructor(context: Context,
    sendPlayerEvent: (playerId: number, event: Record<string, Object>) => void,
    sendNetEvent: (playerId: number, event: Record<string, Object>) => void) {
    super();
    this.sendPlayerEvent = sendPlayerEvent;
    this.sendNetEvent = sendNetEvent;
    this.vodPlayer = new TXVodPlayer(context);
    this.setupCallback();
  }

  private setupCallback(): void {
    if (this.vodPlayer) {
      const self = this;
      const callback: ITXVodPlayCallback = {
        onPlayEvent: (player: TXVodPlayer, event: number, eventData?: Map<string, TXVodDef.ParamType>) => {
          const eventObj: Record<string, Object> = { 'event': event as Object };
          if (eventData) {
            eventData.forEach((value, key) => {
              eventObj[key] = value as Object;
            });
          }
          // ohos SDK sends _MS keys, Dart expects non-_MS keys in seconds
          if (event === 2005 && eventData) {
            // 节流：进度事件每1000ms发送一次
            const now = Date.now();
            if (now - self.lastProgressTime < 500) {
              return;
            }
            self.lastProgressTime = now;
            const progressMs = eventData.get('EVT_PLAY_PROGRESS_MS');
            const durationMs = eventData.get('EVT_PLAY_DURATION_MS');
            if (progressMs != null) {
              eventObj['EVT_PLAY_PROGRESS'] = (Number(progressMs) / 1000.0) as Object;
            }
            if (durationMs != null) {
              eventObj['EVT_PLAY_DURATION'] = (Number(durationMs) / 1000.0) as Object;
            }
          }
          self.sendPlayerEvent(self.playerId, eventObj);
        },
        onNetStatus: (player: TXVodPlayer, statusData: Map<string, TXVodDef.ParamType>) => {
          // 节流：网络状态事件每3秒发送一次，避免高频事件阻塞触摸手势处理
          const now = Date.now();
          if (now - self.lastNetStatusTime < 1000) {
            return;
          }
          self.lastNetStatusTime = now;
          const netObj: Record<string, Object> = {};
          statusData.forEach((value, key) => {
            netObj[key] = value as Object;
          });
          self.sendNetEvent(self.playerId, netObj);
        }
      };
      this.vodPlayer.setVodPlayCallback(callback);
    }
  }

  initialize(): void {}

  startVodPlay(url: string): void {
    if (this.vodPlayer) {
      const params = TXVodDef.TXPlayInfoParams.createWithUrl(url);
      this.vodPlayer.startVodPlay(params);
    }
  }

  startVodPlayWithParams(appId: number, fileId: string, psign: string): void {
    if (this.vodPlayer) {
      const params = TXVodDef.TXPlayInfoParams.createWithFileId(appId, fileId, psign);
      this.vodPlayer.startVodPlay(params);
    }
  }

  startPlayDrm(licenseUrl: string, playUrl: string, deviceCertUrl?: string): void {
    if (this.vodPlayer) {
      const params = TXVodDef.TXPlayInfoParams.createWithUrl(playUrl);
      this.vodPlayer.startVodPlay(params);
    }
  }

  stop(isNeedClear: boolean): void {
    if (this.vodPlayer) {
      this.vodPlayer.stopPlay(isNeedClear);
    }
  }

  pause(): void {
    if (this.vodPlayer) {
      this.vodPlayer.pause();
    }
  }

  resume(): void {
    if (this.vodPlayer) {
      this.vodPlayer.resume();
    }
  }

  seek(position: number): void {
    if (this.vodPlayer) {
      this.vodPlayer.seek(position, true);
    }
  }

  seekToPdtTime(pdtTimeMs: number): void {
    if (this.vodPlayer) {
      this.vodPlayer.seek(pdtTimeMs, false);
    }
  }

  setMute(mute: boolean): void {
    if (this.vodPlayer) {
      this.vodPlayer.setMute(mute);
    }
  }

  setLoop(loop: boolean): void {
    if (this.vodPlayer) {
      this.vodPlayer.setLoop(loop);
    }
  }

  setRate(rate: number): void {
    if (this.vodPlayer) {
      this.vodPlayer.setRate(rate);
    }
  }

  setConfig(configMsg: FTXVodPlayConfigPlayerMsg): void {
    if (this.vodPlayer) {
      const config = FTXTransformation.transformToVodConfig(configMsg);
      this.vodPlayer.setConfig(config);
    }
  }

  setStartTime(startTime: number): void {
    if (this.vodPlayer) {
      this.vodPlayer.setStartTime(startTime);
    }
  }

  isPlaying(): boolean {
    if (this.vodPlayer) {
      return this.vodPlayer.isPlaying();
    }
    return false;
  }

  getCurrentPlaybackTime(): number {
    if (this.vodPlayer) {
      return this.vodPlayer.getCurrentPlaybackTime();
    }
    return 0;
  }

  getDuration(): number {
    if (this.vodPlayer) {
      return this.vodPlayer.getDuration();
    }
    return 0;
  }

  getBufferDuration(): number {
    if (this.vodPlayer) {
      return this.vodPlayer.getBufferDuration();
    }
    return 0;
  }

  getPlayableDuration(): number {
    if (this.vodPlayer) {
      return this.vodPlayer.getPlayableDuration();
    }
    return 0;
  }

  getWidth(): number {
    if (this.vodPlayer) {
      return this.vodPlayer.getWidth();
    }
    return 0;
  }

  getHeight(): number {
    if (this.vodPlayer) {
      return this.vodPlayer.getHeight();
    }
    return 0;
  }

  isLoop(): boolean {
    if (this.vodPlayer) {
      return this.vodPlayer.isLoop();
    }
    return false;
  }

  getBitrateIndex(): number {
    if (this.vodPlayer) {
      return this.vodPlayer.getBitrateIndex();
    }
    return -1;
  }

  setBitrateIndex(index: number): void {
    if (this.vodPlayer) {
      this.vodPlayer.setBitrateIndex(index);
    }
  }

  getSupportedBitrates(): Object[] {
    const result: Object[] = [];
    if (this.vodPlayer) {
      const bitrates = this.vodPlayer.getSupportedBitrates();
      if (bitrates) {
        for (const bitrate of bitrates) {
          const map: Record<string, Object> = {};
          map['index'] = bitrate.index as Object;
          map['width'] = bitrate.width as Object;
          map['height'] = bitrate.height as Object;
          map['bitrate'] = bitrate.bitrate as Object;
          result.push(map as Object);
        }
      }
    }
    return result;
  }

  setAudioPlayoutVolume(volume: number): void {
    if (this.vodPlayer) {
      this.vodPlayer.setAudioPlayoutVolume(volume);
    }
  }

  enableHardwareDecode(enable: boolean): boolean {
    // Hardware decode is managed internally by the OHOS SDK
    return true;
  }

  setAutoPlay(autoPlay: boolean): void {
    if (this.vodPlayer) {
      this.vodPlayer.setAutoPlay(autoPlay);
    }
  }

  setVideoRenderTarget(surfaceId: string): void {
    if (this.vodPlayer) {
      this.vodPlayer.setVideoRenderTarget(surfaceId);
    }
  }

  addSubtitleSource(url: string, name: string, mimeType?: string): void {
    if (this.vodPlayer) {
      this.vodPlayer.addSubtitleSource(url, name, mimeType ?? '');
    }
  }

  getSubtitleTrackInfo(): Object[] {
    if (this.vodPlayer) {
      const tracks = this.vodPlayer.getSubtitleTrackInfo();
      if (tracks) {
        const result: Object[] = [];
        for (const track of tracks) {
          const map: Record<string, Object> = {};
          map['trackIndex'] = track.trackIndex as Object;
          map['trackType'] = track.trackType as Object;
          map['trackName'] = (track.name ?? '') as Object;
          result.push(map as Object);
        }
        return result;
      }
    }
    return [];
  }

  getAudioTrackInfo(): Object[] {
    if (this.vodPlayer) {
      const tracks = this.vodPlayer.getAudioTrackInfo();
      if (tracks) {
        const result: Object[] = [];
        for (const track of tracks) {
          const map: Record<string, Object> = {};
          map['trackIndex'] = track.trackIndex as Object;
          map['trackType'] = track.trackType as Object;
          map['trackName'] = (track.name ?? '') as Object;
          result.push(map as Object);
        }
        return result;
      }
    }
    return [];
  }

  selectTrack(trackIndex: number): void {
    if (this.vodPlayer) {
      this.vodPlayer.selectTrack(trackIndex);
    }
  }

  deselectTrack(trackIndex: number): void {
    if (this.vodPlayer) {
      this.vodPlayer.deselectTrack(trackIndex);
    }
  }

  setStringOption(key: string, value: Object): void {
    // OHOS SDK does not expose setStringOption directly
  }

  setSubtitleStyle(): void {
    // OHOS TXVodPlayer public API does not expose setSubtitleStyle
  }

  destroy(): void {
    if (this.vodPlayer) {
      this.vodPlayer.stopPlay(true);
      this.vodPlayer = null;
    }
  }
}
