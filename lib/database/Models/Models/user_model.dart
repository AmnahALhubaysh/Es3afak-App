class UserModel{
int? userId;
String? name;
String? email;
String? firebaseUid;
int     isGuest;
String? createdAt;

UserModel({this.userId, required this.name, this.email, this.firebaseUid, this.isGuest = 1, this.createdAt,});

Map<String, dynamic> toMap(){
  return{
    'user_id': userId,
    'name': name,
    'email': email,
    'firebase_uid': firebaseUid,
    'is_guest':     isGuest,
    'created_at': createdAt ?? DateTime.now().toIso8601String(),
  };
}

static UserModel fromMap(Map<String, dynamic>map){
return UserModel(
  userId: map['user_id'],
  name: map['name']?? 'زائر',
  email: map['email'],
  firebaseUid: map['firebase_uid'],
  isGuest:     map['is_guest'] ?? 1,
  createdAt: map['created_at'],
);
}
}