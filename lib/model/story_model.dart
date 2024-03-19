// class StoryModel {
//   String? storyId;
//   Map<String, dynamic>? participants;
//   DateTime? createTime;
//   List<dynamic>? users;
//
//   StoryModel({this.participants, this.storyId, this.createTime, this.users});
//
//   StoryModel.fromMap(Map<String, dynamic> map) {
//     storyId = map['storyId'];
//     participants = map['participants'];
//     createTime = map['createTime'].toDate();
//     users = map['users'];
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       "storyId": storyId,
//       "participants": participants,
//       'createTime': createTime,
//       'users': users
//     };
//   }
// }
