class Member {
  String? profilePicture;
  String? name;
  String? phoneNumber;
  String? role;

  Member({this.profilePicture, this.name, this.phoneNumber, this.role});

  Member.fromJson(Map<String, dynamic> json) {
    profilePicture = json['profile_picture'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_picture'] = profilePicture;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['role'] = role;
    return data;
  }
}
