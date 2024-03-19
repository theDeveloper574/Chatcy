class Call {
  String? callerId;
  String? callerName;
  String? callerPic;

  String? receiverId;
  String? receiverName;
  String? receiverPic;

  String? channelId;
  bool? hasDialed;

  String? callType;
  String? callId;
  bool? isCallPick;

  // DateTime? startTime;
  // DateTime? endTime;
  // String? duration;
  Call(
      {
      // this.startTime,
      // this.endTime,
      // this.duration,
      this.callerId,
      this.callerName,
      this.callerPic,
      this.receiverId,
      this.receiverName,
      this.receiverPic,
      this.channelId,
      this.hasDialed,
      this.callType,
      this.callId,
      this.isCallPick});

  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();
    // callMap['start_time'] = call.startTime;
    // callMap['end_time'] = call.endTime;
    // callMap['duration'] = call.duration;
    callMap['caller_id'] = call.callerId;
    callMap['caller_name'] = call.callerName;
    callMap['caller_pic'] = call.callerPic;
    callMap['receiver_id'] = call.receiverId;
    callMap['receiver_name'] = call.receiverName;
    callMap['receiver_pic'] = call.receiverPic;
    callMap['channel_id'] = call.channelId;
    callMap['has_dialed'] = call.hasDialed;
    callMap['call_type'] = call.callType;
    callMap['call_id'] = call.callId;
    callMap['is_call_pick'] = call.isCallPick;
    return callMap;
  }

  // Call.fromMap(Map callMap) {
  //   this.callerId = callMap["caller_id"];
  //   this.callerName = callMap["caller_name"];
  //   this.callerPic = callMap["caller_pic"];
  //   this.receiverId = callMap["receiver_id"];
  //   this.receiverName = callMap["receiver_name"];
  //   this.receiverPic = callMap["receiver_pic"];
  //   this.channelId = callMap["channel_id"];
  //   this.hasDialed = callMap["has_dialled"];
  // }
  factory Call.fromJson(dynamic json) => Call(
      // duration: json['duration'],
      //     endTime: json['end_time'],
      //     startTime:json ['start_time'],
      callerId: json['caller_id'],
      callerName: json['caller_name'],
      callerPic: json['caller_pic'],
      channelId: json['channel_id'],
      hasDialed: json['has_dialed'],
      receiverId: json['receiver_id'],
      receiverName: json['receiver_name'],
      receiverPic: json['receiver_pic'],
      callType: json['call_type'],
      callId: json['call_id'],
      isCallPick: json['is_call_pick']);
}
