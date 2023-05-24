class CallModel {
  final String? callerId;
  final String? callerName;
  final String? callerPic;
  final String? receiverId;
  final String? receiverName;
  final String? receiverPic;
  final String? channelId;
  late final bool hasDialled;
  late final String? isCall;

  CallModel({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.channelId,
    this.hasDialled = false,
    this.isCall,
  });

  // to map
  Map<String, dynamic> toMap(CallModel call) {
    Map<String, dynamic> callMap = {};

    callMap["caller_id"] = call.callerId;
    callMap["caller_name"] = call.callerName;
    callMap["caller_pic"] = call.callerPic;
    callMap["receiver_id"] = call.receiverId;
    callMap["receiver_name"] = call.receiverName;
    callMap["receiver_pic"] = call.receiverPic;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialled"] = call.hasDialled;
    callMap["is_Call"] = call.isCall;

    return callMap;
  }

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
        callerId: json["caller_id"],
        callerName: json["caller_name"],
        callerPic: json["caller_pic"],
        receiverId: json["receiver_id"],
        receiverName: json["receiver_name"],
        receiverPic: json["receiver_pic"],
        channelId: json["channel_id"],
        hasDialled: json["has_dialled"] ?? false,
        isCall: json["is_Call"],
      );
}
