class User {
  Data data;

  User({this.data});

  User.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.data != null) {
  //     data['data'] = this.data.toJson();
  //   }
  //   return data;
  // }
}

class Data {
  int id;
  String firstName;
  String lastName;
  String login;
  String email;
  bool isActivated;
  int roleId;
  String createdAt;
  String updatedAt;
  int isSuperuser;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.login,
    this.email,
    this.isActivated,
    this.roleId,
    this.createdAt,
    this.updatedAt,
    this.isSuperuser,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['userData']['id'];
    firstName = json["userData"]['first_name'];
    lastName = json['userData']['last_name'];
    login = json['userData']['login'];
    email = json['userData']['email'];
    isActivated = json["userData"]['is_activated'];
    roleId = json["userData"]['role_id'];
    createdAt = json["userData"]['created_at'];
    updatedAt = json["userData"]['updated_at'];
    isSuperuser = json["userData"]['is_superuser'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['first_name'] = this.firstName;
  //   data['last_name'] = this.lastName;
  //   data['login'] = this.login;
  //   data['email'] = this.email;
  //   data['is_activated'] = this.isActivated;
  //   data['role_id'] = this.roleId;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   data['is_superuser'] = this.isSuperuser;
  //   data['auth_token'] = this.authToken;
  //   return data;
  // }
}
