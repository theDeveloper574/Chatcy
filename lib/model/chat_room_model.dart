class ChatRoomModel {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? chatTime;
  List<dynamic>? users;
  // bool? messageRead;
  int? toMessagesCount;
  String? toId;
  int? fromMessagesCount;
  String? fromId;

  ChatRoomModel(
      {this.chatRoomId,
      this.participants,
      this.lastMessage,
      this.chatTime,
      this.users,
      // this.messageRead,
      this.toMessagesCount,
      this.fromMessagesCount,
      this.toId,
      this.fromId});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map['chatroomid'];
    participants = map['participants'];
    lastMessage = map['lastmessage'];
    chatTime = map['chatTime'].toDate();
    users = map['users'];
    // messageRead = map['messageRead'];
    toMessagesCount = map['toMessageCount'];
    fromMessagesCount = map['fromMessageCount'];
    toId = map['toId'];
    fromId = map['fromId'];
  }
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatRoomId,
      "participants": participants,
      "lastmessage": lastMessage,
      'chatTime': chatTime,
      'users': users,
      // 'messageRead': messageRead,
      'toMessageCount': toMessagesCount,
      'fromMessageCount': fromMessagesCount,
      'toId': toId,
      'fromId': fromId
    };
  }
}
