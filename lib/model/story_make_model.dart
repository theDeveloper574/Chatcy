class StoryMakeModel {
  String? name;
  String? profileUrl;
  DateTime? uploadTime;
  List? storyImage;
  String? docId;
  Map<String, dynamic>? uid;
  String? currentUserUid;

  StoryMakeModel(
      {this.name,
      this.profileUrl,
      this.storyImage,
      this.docId,
      this.uploadTime,
      this.uid,
      this.currentUserUid});

  StoryMakeModel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    profileUrl = map['profileUrl'];
    uploadTime = map['uploadTime'].toDate();
    storyImage = map['storyImage'];
    docId = map['docId'];
    uid = map['uid'];
    currentUserUid = map['userUid'];
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "profileUrl": profileUrl,
      "uploadTime": uploadTime,
      "storyImage": storyImage,
      "docId": docId,
      "uid": uid,
      "userUid": currentUserUid
    };
  }
}
