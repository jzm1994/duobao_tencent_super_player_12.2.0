export class FTXEvent {
  static readonly EVENT_VOLUME_CHANGED = 1;
  static readonly EVENT_AUDIO_FOCUS_PAUSE = 2;
  static readonly EVENT_AUDIO_FOCUS_PLAY = 3;
  static readonly EVENT_BRIGHTNESS_CHANGED = 4;

  static readonly EVENT_PREDOWNLOAD_ON_COMPLETE = 200;
  static readonly EVENT_PREDOWNLOAD_ON_ERROR = 201;
  static readonly EVENT_PREDOWNLOAD_ON_START = 202;

  static readonly EVENT_DOWNLOAD_START = 301;
  static readonly EVENT_DOWNLOAD_PROGRESS = 302;
  static readonly EVENT_DOWNLOAD_STOP = 303;
  static readonly EVENT_DOWNLOAD_FINISH = 304;
  static readonly EVENT_DOWNLOAD_ERROR = 305;

  static readonly NO_ERROR = 0;

  static readonly PIP_CHANNEL_NAME = "cloud.tencent.com/playerPlugin/componentEvent";

  static readonly EVENT_PIP_MODE_ALREADY_ENTER = 1;
  static readonly EVENT_PIP_MODE_ALREADY_EXIT = 2;
  static readonly EVENT_PIP_MODE_REQUEST_START = 3;
  static readonly EVENT_PIP_MODE_UI_STATE_CHANGED = 4;
  static readonly EVENT_PIP_MODE_RESTORE_UI = 5;

  static readonly PLAYER_VOD = 1;
  static readonly PLAYER_LIVE = 2;

  static readonly EVENT_ORIENTATION_CHANGED = 401;
  static readonly EVENT_ON_LOG = 501;
  static readonly EVENT_ON_UPDATE_NETWORK_TIME = 502;
  static readonly EVENT_ON_LICENCE_LOADED = 503;
  static readonly EVENT_ON_CUSTOM_HTTP_DNS = 504;

  static readonly EVENT_SUBTITLE_DATA = 601;
}
