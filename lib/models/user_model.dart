class UserData {

  factory UserData.fromMap(Map<String, dynamic> map) {
    // this is for converting map to user object
    return UserData(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      createdAt: map['createdAt'],
    );
  }
  UserData({required this.uid, required this.email, this.userName, this.createdAt});
  final String uid;
  final String email;
  final String? userName;
  final String? createdAt;

  Map<String, dynamic> toMap() {
    // this is for converting user object to map
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'createdAt': createdAt,
    };
  }
}
