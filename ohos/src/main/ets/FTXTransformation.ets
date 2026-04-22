import { TXVodPlayConfig } from 'liteavsdk';
import { FTXVodPlayConfigPlayerMsg } from './FtxPigeonMessages';

export class FTXTransformation {

  static transformToVodConfig(msg: FTXVodPlayConfigPlayerMsg): TXVodPlayConfig {
    const config = new TXVodPlayConfig();
    if (msg.connectRetryCount != null) {
      config.connectRetryCount = msg.connectRetryCount;
    }
    if (msg.connectRetryInterval != null) {
      config.connectRetryInterval = msg.connectRetryInterval;
    }
    if (msg.timeout != null) {
      config.timeout = msg.timeout;
    }
    if (msg.enableAccurateSeek != null) {
      config.enableAccurateSeek = msg.enableAccurateSeek;
    }
    if (msg.smoothSwitchBitrate != null) {
      config.smoothSwitchBitrate = msg.smoothSwitchBitrate;
    }
    if (msg.progressInterval != null) {
      config.progressInterval = msg.progressInterval;
    }
    if (msg.maxBufferSize != null) {
      config.maxBufferSize = msg.maxBufferSize;
    }
    if (msg.maxPreloadSize != null) {
      config.maxPreloadSize = msg.maxPreloadSize;
    }
    if (msg.preferredResolution != null) {
      config.preferredResolution = msg.preferredResolution;
    }
    if (msg.headers != null) {
      config.headers = msg.headers;
    }
    if (msg.mediaType != null) {
      config.mediaType = msg.mediaType;
    }
    return config;
  }
}
