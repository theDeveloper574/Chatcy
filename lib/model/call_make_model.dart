class CallMakeModel {
  String? callId;
  String? myPic;
  String? myName;
  String? myUid;
  DateTime? dateTime;
  String? recPic;
  String? recName;
  String? recUid;
  bool? isMissed;
  bool? isCut;
  bool? isRec;
  String? callType;

  CallMakeModel(
      {this.callId,
      this.myPic,
      this.myName,
      this.myUid,
      this.dateTime,
      this.recPic,
      this.recName,
      this.recUid,
      this.isMissed,
      this.isCut,
      this.isRec,
      this.callType});

  CallMakeModel.fromMap(Map<String, dynamic> map) {
    callId = map['callId'];
    myPic = map['myPic'];
    myName = map['myName'];
    myUid = map['myUid'];
    dateTime = map['dateTime'].toDate();
    recPic = map['recPic'];
    recName = map['recName'];
    recUid = map['recUid'];
    isMissed = map['isMissed'];
    isCut = map['isCut'];
    isRec = map['isRec'];
    callType = map['callType'];
  }

  Map<String, dynamic> toMap() {
    return {
      "callId": callId,
      "myPic": myPic,
      "myName": myName,
      "myUid": myUid,
      "dateTime": dateTime,
      "recPic": recPic,
      "recName": recName,
      "recUid": recUid,
      "isMissed": isMissed,
      "isCut": isCut,
      "isRec": isRec,
      "callType": callType
    };
  }
}
