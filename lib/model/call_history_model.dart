class CallHistoryModel {
  String? callHistoryId;
  Map<String, dynamic>? participants;
  // String? lastMessage;
  DateTime? callTime;
  List<dynamic>? users;

  CallHistoryModel(
      {this.callHistoryId,
      this.participants,
      // this.lastMessage,
      this.callTime,
      this.users});

  CallHistoryModel.fromMap(Map<String, dynamic> map) {
    callHistoryId = map['CallHistoryId'];
    participants = map['participants'];
    // lastMessage = map['lastmessage'];
    callTime = map['callTime'].toDate();
    users = map['users'];
  }
  Map<String, dynamic> toMap() {
    return {
      "CallHistoryId": callHistoryId,
      "participants": participants,
      // "lastmessage": lastMessage,
      'callTime': callTime,
      'users': users
    };
  }
}
