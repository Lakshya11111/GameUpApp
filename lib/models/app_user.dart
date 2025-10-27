class AppUser {
  AppUser({
    required this.image,
    required this.name,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.id,
    required this.rollNumber,
    required this.phoneNumber,
    required this.gender,
    required this.batch,
    required this.department,
    required this.hostelName,
    required this.courseName,
    required this.joinedAnnounce,
    required this.pushToken,
  });
  late String image;
  late String name;
  late String createdAt;
  late String lastActive;
  late bool isOnline;
  late String id;
  late String rollNumber;
  late String phoneNumber;
  late String gender;
  late String batch;
  late String department;
  late String hostelName;
  late String courseName;
  late List<String> joinedAnnounce;
  late String pushToken;

  AppUser.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    rollNumber = json['rollNumber'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    gender = json['gender'] ?? '';
    batch = json['batch'] ?? '';
    department = json['department'] ?? '';
    hostelName = json['hostelName'] ?? '';
    courseName = json['courseName'] ?? '';
    joinedAnnounce = List<String>.from(json['joinedAnnounce'] ?? []);
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['rollNumber'] = rollNumber;
    data['phoneNumber'] = phoneNumber;
    data['gender'] = gender;
    data['batch'] = batch;
    data['department'] = department;
    data['hostelName'] = hostelName;
    data['courseName'] = courseName;
    data['joinedAnnounce'] = joinedAnnounce;
    data['push_token'] = pushToken;
    return data;
  }
}