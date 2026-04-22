import { FTXBasePlayer } from './FTXBasePlayer';
import {
  V2TXLivePlayer,
  V2TXLivePlayerObserver,
  V2TXLivePlayerStatistics,
  V2TXLiveRotation,
  V2TXLiveFillMode,
  V2TXLiveProperty,
  V2TXLiveMode,
  createV2TXLivePlayer
} from 'liteavsdk';
import { image } from '@kit.ImageKit';

export class FTXLivePlayer extends FTXBasePlayer {
  private livePlayer: V2TXLivePlayer | null = null;
  private sendPlayerEvent: (playerId: number, event: Record<string, Object>) => void;
  private sendNetEvent: (playerId: number, event: Record<string, Object>) => void;

  constructor(
    sendPlayerEvent: (playerId: number, event: Record<string, Object>) => void,
    sendNetEvent: (playerId: number, event: Record<string, Object>) => void) {
    super();
    this.sendPlayerEvent = sendPlayerEvent;
    this.sendNetEvent = sendNetEvent;
  }

  init(context: Context): void {
    this.livePlayer = createV2TXLivePlayer(context);
    this.setupObserver();
  }

  private setupObserver(): void {
    if (this.livePlayer) {
      const self = this;
      const observer: V2TXLivePlayerObserver = {
        onError(player: V2TXLivePlayer, code: number, msg: string, extraInfo: Object) {
          self.sendPlayerEvent(self.playerId, {
            'event': -2301 as Object, 'errCode': code as Object, 'errMsg': msg as Object
          });
        },
        onWarning(player: V2TXLivePlayer, code: number, msg: string, extraInfo: Object) {
          self.sendPlayerEvent(self.playerId, { 'event': 2103 as Object, 'code': code as Object, 'msg': msg as Object });
        },
        onVideoResolutionChanged(player: V2TXLivePlayer, width: number, height: number) {
          self.sendPlayerEvent(self.playerId, {
            'event': 2003 as Object, 'EVT_WIDTH': width as Object, 'EVT_HEIGHT': height as Object
          });
        },
        onConnected(player: V2TXLivePlayer, extraInfo: Object) {
          self.sendPlayerEvent(self.playerId, { 'event': 2001 as Object });
        },
        onVideoPlaying(player: V2TXLivePlayer, firstPlay: boolean, extraInfo: Object) {
          self.sendPlayerEvent(self.playerId, { 'event': 2004 as Object, 'firstPlay': firstPlay as Object });
        },
        onAudioPlaying(player: V2TXLivePlayer, firstPlay: boolean, extraInfo: Object) {},
        onVideoLoading(player: V2TXLivePlayer, extraInfo: Object) {
          self.sendPlayerEvent(self.playerId, { 'event': 2002 as Object });
        },
        onAudioLoading(player: V2TXLivePlayer, extraInfo: Object) {},
        onPlayoutVolumeUpdate(player: V2TXLivePlayer, volume: number) {
          self.sendPlayerEvent(self.playerId, { 'event': 2006 as Object, 'volume': volume as Object });
        },
        onStatisticsUpdate(player: V2TXLivePlayer, statistics: V2TXLivePlayerStatistics) {
          self.sendNetEvent(self.playerId, {
            'VIDEO_WIDTH': (statistics.width ?? 0) as Object,
            'VIDEO_HEIGHT': (statistics.height ?? 0) as Object,
            'VIDEO_FPS': (statistics.fps ?? 0) as Object,
            'VIDEO_BITRATE': (statistics.videoBitrate ?? 0) as Object,
            'AUDIO_BITRATE': (statistics.audioBitrate ?? 0) as Object,
            'NET_SPEED': (statistics.netSpeed ?? 0) as Object,
            'NET_JITTER': (statistics.jitterBufferDelay ?? 0) as Object,
            'SERVER_IP': (statistics.rtt ?? 0) as Object
          });
        },
        onSnapshotComplete(player: V2TXLivePlayer, pixelMap: Object) {},
        onReceiveSeiMessage(player: V2TXLivePlayer, payloadType: number, data: ArrayBuffer) {
          self.sendPlayerEvent(self.playerId, {
            'event': 2012 as Object, 'payloadType': payloadType as Object, 'data': data as Object
          });
        },
        onStreamSwitched(player: V2TXLivePlayer, url: string, code: number) {
          self.sendPlayerEvent(self.playerId, { 'event': 2005 as Object, 'url': url as Object, 'code': code as Object });
        },
        onLocalRecordBegin(player: V2TXLivePlayer, code: number, storagePath: string) {},
        onLocalRecording(player: V2TXLivePlayer, durationMs: number, storagePath: string) {},
        onLocalRecordComplete(player: V2TXLivePlayer, code: number, storagePath: string) {}
      };
      this.livePlayer.setObserver(observer);
    }
  }

  initialize(): void {}

  startLivePlay(url: string): number {
    if (this.livePlayer) {
      return this.livePlayer.startPlay(url);
    }
    return -1;
  }

  stop(isNeedClear: boolean): boolean {
    if (this.livePlayer) {
      this.livePlayer.stopPlay();
      return true;
    }
    return false;
  }

  pause(): void {
    if (this.livePlayer) {
      this.livePlayer.pauseAudio();
      this.livePlayer.pauseVideo();
    }
  }

  resume(): void {
    if (this.livePlayer) {
      this.livePlayer.resumeAudio();
      this.livePlayer.resumeVideo();
    }
  }

  setLiveMode(mode: number): void {
    if (this.livePlayer) {
      this.livePlayer.setCacheParams(1.0, 5.0);
    }
  }

  setVolume(volume: number): void {
    if (this.livePlayer) {
      this.livePlayer.setPlayoutVolume(volume);
    }
  }

  setMute(mute: boolean): void {
    if (this.livePlayer) {
      if (mute) {
        this.livePlayer.pauseAudio();
      } else {
        this.livePlayer.resumeAudio();
      }
    }
  }

  switchStream(url: string): number {
    if (this.livePlayer) {
      return this.livePlayer.switchStream(url);
    }
    return -1;
  }

  setAppID(appId: string): void {}

  enableHardwareDecode(enable: boolean): boolean {
    if (this.livePlayer) {
      this.livePlayer.setProperty(V2TXLiveProperty.kV2EnableHardwareAcceleration, enable);
    }
    return true;
  }

  enableReceiveSeiMessage(enable: boolean, payloadType: number): number {
    if (this.livePlayer) {
      return this.livePlayer.enableReceiveSeiMessage(enable, payloadType);
    }
    return -1;
  }

  showDebugView(isShow: boolean): void {
    if (this.livePlayer) {
      this.livePlayer.showDebugView(isShow);
    }
  }

  setProperty(key: string, value: Object): number {
    if (this.livePlayer) {
      if (key === 'V2TXLiveProperty.kV2EnableHardwareAcceleration') {
        this.livePlayer.setProperty(V2TXLiveProperty.kV2EnableHardwareAcceleration, value);
      }
      return 0;
    }
    return -1;
  }

  setCacheParams(minTime: number, maxTime: number): number {
    if (this.livePlayer) {
      return this.livePlayer.setCacheParams(minTime, maxTime);
    }
    return -1;
  }

  setRenderView(viewId: string): void {
    if (this.livePlayer) {
      this.livePlayer.setRenderView(viewId);
    }
  }

  setRenderRotation(rotation: number): void {
    if (this.livePlayer) {
      let v2Rotation = V2TXLiveRotation.V2TXLiveRotation0;
      if (rotation === 90) v2Rotation = V2TXLiveRotation.V2TXLiveRotation90;
      else if (rotation === 180) v2Rotation = V2TXLiveRotation.V2TXLiveRotation180;
      else if (rotation === 270) v2Rotation = V2TXLiveRotation.V2TXLiveRotation270;
      this.livePlayer.setRenderRotation(v2Rotation);
    }
  }

  setRenderFillMode(fillMode: number): void {
    if (this.livePlayer) {
      const mode = fillMode === 0 ? V2TXLiveFillMode.V2TXLiveFillModeFit : V2TXLiveFillMode.V2TXLiveFillModeFill;
      this.livePlayer.setRenderFillMode(mode);
    }
  }

  isPlaying(): boolean {
    return this.livePlayer != null;
  }

  destroy(): void {
    if (this.livePlayer) {
      this.livePlayer.stopPlay();
      this.livePlayer = null;
    }
  }
}
