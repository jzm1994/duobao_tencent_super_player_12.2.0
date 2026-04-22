import { FTXEvent } from './FTXEvent';
import {
  TXVodDownloadManager,
  TXVodDownloadDataSource,
  TXVodDownloadMediaInfo,
  ITXVodDownloadCallback
} from 'liteavsdk';
import { TXVodDownloadMediaMsg, TXDownloadListMsg, PreLoadMsg, PreLoadInfoMsg, MapMsg } from './FtxPigeonMessages';

export class FTXDownloadManager implements ITXVodDownloadCallback {
  private downloadManager: TXVodDownloadManager | null = null;
  private sendDownloadEvent: (event: Record<string, Object>) => void;
  private sendPreDownloadEvent: (event: Record<string, Object>) => void;
  private isInitListener = false;

  constructor(context: Context,
    sendDownloadEvent: (event: Record<string, Object>) => void,
    sendPreDownloadEvent: (event: Record<string, Object>) => void) {
    this.sendDownloadEvent = sendDownloadEvent;
    this.sendPreDownloadEvent = sendPreDownloadEvent;
    this.downloadManager = TXVodDownloadManager.getInstance(context);
  }

  private initListenerIfNeeded(): void {
    if (!this.isInitListener && this.downloadManager) {
      this.isInitListener = true;
      this.downloadManager.setDownloadCallback(this);
    }
  }

  startPreLoad(msg: PreLoadMsg): number {
    return 0;
  }

  startPreLoadByParams(msg: PreLoadInfoMsg): void {}

  stopPreLoad(taskId: number): void {}

  startDownload(msg: TXVodDownloadMediaMsg): void {
    this.initListenerIfNeeded();
    if (this.downloadManager) {
      const url = msg.url;
      const appId = msg.appId;
      const fileId = msg.fileId;
      const quality = msg.quality ?? 0;
      const pSign = msg.pSign ?? '';

      if (url && url.length > 0) {
        this.downloadManager.startDownloadUrl(url);
      } else if (appId && fileId) {
        const dataSource = new TXVodDownloadDataSource(appId, fileId, quality, pSign);
        this.downloadManager.startDownloadDataSource(dataSource);
      }
    }
  }

  resumeDownload(msg: TXVodDownloadMediaMsg): void {
    this.initListenerIfNeeded();
    if (this.downloadManager) {
      const mediaInfo = this.findDownloadMediaInfo(msg);
      if (mediaInfo) {
        if (mediaInfo.getDataSource()) {
          this.downloadManager.startDownloadDataSource(mediaInfo.getDataSource());
        } else {
          this.downloadManager.startDownloadUrl(mediaInfo.getUrl());
        }
      }
    }
  }

  stopDownload(msg: TXVodDownloadMediaMsg): void {
    this.initListenerIfNeeded();
    if (this.downloadManager) {
      const mediaInfo = this.findDownloadMediaInfo(msg);
      if (mediaInfo) {
        this.downloadManager.stopDownload(mediaInfo);
      }
    }
  }

  setDownloadHeaders(headers: Map<string, string>): void {
    if (this.downloadManager) {
      this.downloadManager.setHeaders(headers);
    }
  }

  getDownloadList(): TXDownloadListMsg {
    const result = new TXDownloadListMsg();
    const mediaResults: TXVodDownloadMediaMsg[] = [];
    if (this.downloadManager) {
      const mediaList = this.downloadManager.syncGetDownloadMediaInfoList();
      if (mediaList) {
        for (const mediaInfo of mediaList) {
          mediaResults.push(this.buildMsgFromDownloadInfo(mediaInfo));
        }
      }
    }
    result.infoList = mediaResults;
    return result;
  }

  getDownloadInfo(msg: TXVodDownloadMediaMsg): TXVodDownloadMediaMsg {
    const mediaInfo = this.findDownloadMediaInfo(msg);
    if (mediaInfo) {
      return this.buildMsgFromDownloadInfo(mediaInfo);
    }
    return new TXVodDownloadMediaMsg();
  }

  deleteDownloadMediaInfo(msg: TXVodDownloadMediaMsg): boolean {
    const mediaInfo = this.findDownloadMediaInfo(msg);
    if (mediaInfo && this.downloadManager) {
      this.downloadManager.stopDownload(mediaInfo);
      return this.downloadManager.deleteDownloadMediaInfo(mediaInfo);
    }
    return false;
  }

  private findDownloadMediaInfo(msg: TXVodDownloadMediaMsg): TXVodDownloadMediaInfo | null {
    if (!this.downloadManager) return null;
    const url = msg.url;
    const appId = msg.appId;
    const fileId = msg.fileId;
    const quality = msg.quality ?? 0;

    if (appId && fileId) {
      return this.downloadManager.syncGetDownloadMediaInfoByFileId(appId, fileId, quality);
    } else if (url && url.length > 0) {
      return this.downloadManager.syncGetDownloadMediaInfoByUrl(url);
    }
    return null;
  }

  private buildMsgFromDownloadInfo(mediaInfo: TXVodDownloadMediaInfo): TXVodDownloadMediaMsg {
    const msg = new TXVodDownloadMediaMsg();
    msg.playPath = mediaInfo.getPlayPath() ?? '';
    msg.downloadState = mediaInfo.getDownloadState();
    msg.userName = mediaInfo.getUserName() ?? 'default';
    msg.duration = mediaInfo.getDuration();
    msg.playableDuration = mediaInfo.getPlayableDuration();
    msg.size = mediaInfo.getSize();
    msg.downloadSize = mediaInfo.getDownloadSize();
    msg.progress = mediaInfo.getProgress();
    msg.speed = mediaInfo.getSpeed();
    msg.isResourceBroken = mediaInfo.isResourceBroken;
    const url = mediaInfo.getUrl();
    if (url) msg.url = url;
    const dataSource = mediaInfo.getDataSource();
    if (dataSource) {
      msg.appId = dataSource.getAppId();
      msg.fileId = dataSource.getFileId();
      msg.pSign = dataSource.getPSign();
      msg.quality = dataSource.getQuality();
      msg.token = dataSource.getToken();
    }
    return msg;
  }

  private buildEventFromDownloadInfo(eventId: number, mediaInfo: TXVodDownloadMediaInfo): Record<string, Object> {
    const event: Record<string, Object> = { 'event': eventId as Object };
    event['playPath'] = (mediaInfo.getPlayPath() ?? '') as Object;
    event['progress'] = mediaInfo.getProgress() as Object;
    event['downloadState'] = mediaInfo.getDownloadState() as Object;
    event['userName'] = (mediaInfo.getUserName() ?? '') as Object;
    event['duration'] = mediaInfo.getDuration() as Object;
    event['playableDuration'] = mediaInfo.getPlayableDuration() as Object;
    event['size'] = mediaInfo.getSize() as Object;
    event['downloadSize'] = mediaInfo.getDownloadSize() as Object;
    event['speed'] = mediaInfo.getSpeed() as Object;
    const url = mediaInfo.getUrl();
    if (url) event['url'] = url as Object;
    const dataSource = mediaInfo.getDataSource();
    if (dataSource) {
      event['appId'] = dataSource.getAppId() as Object;
      event['fileId'] = dataSource.getFileId() as Object;
      event['pSign'] = (dataSource.getPSign() ?? '') as Object;
      event['quality'] = dataSource.getQuality() as Object;
      event['token'] = (dataSource.getToken() ?? '') as Object;
    }
    return event;
  }

  // ITXVodDownloadCallback implementation
  onDownloadStart(mediaInfo: TXVodDownloadMediaInfo): void {
    this.sendDownloadEvent(this.buildEventFromDownloadInfo(FTXEvent.EVENT_DOWNLOAD_START, mediaInfo));
  }

  onDownloadProgress(mediaInfo: TXVodDownloadMediaInfo): void {
    this.sendDownloadEvent(this.buildEventFromDownloadInfo(FTXEvent.EVENT_DOWNLOAD_PROGRESS, mediaInfo));
  }

  onDownloadStop(mediaInfo: TXVodDownloadMediaInfo): void {
    this.sendDownloadEvent(this.buildEventFromDownloadInfo(FTXEvent.EVENT_DOWNLOAD_STOP, mediaInfo));
  }

  onDownloadFinish(mediaInfo: TXVodDownloadMediaInfo): void {
    this.sendDownloadEvent(this.buildEventFromDownloadInfo(FTXEvent.EVENT_DOWNLOAD_FINISH, mediaInfo));
  }

  onDownloadError(mediaInfo: TXVodDownloadMediaInfo, errorCode: number, errorMsg: string): void {
    const event = this.buildEventFromDownloadInfo(FTXEvent.EVENT_DOWNLOAD_ERROR, mediaInfo);
    event['errorCode'] = errorCode as Object;
    event['errorMsg'] = errorMsg as Object;
    this.sendDownloadEvent(event);
  }

  destroy(): void {
    if (this.downloadManager) {
      this.downloadManager.setDownloadCallback(null);
    }
  }
}
