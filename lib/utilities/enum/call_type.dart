enum CallType { call_audio, call_video }

enum CallStatus {
  none,
  ringing,
  accept,
  reject,
  unAnswer,
  cancel,
  end,
}

const int callDurationInSec = 45;
