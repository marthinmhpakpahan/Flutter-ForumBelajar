// @dart=2.9
class Users {

  final int id;
  final String username;
  final String email;
  final String full_name;
  final String gender;
  final String address;
  final String created_at;
  final String updated_at;

  Users({
    this.id, this.username, this.email, this.full_name, this.gender, this.address, this.created_at, this.updated_at
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      full_name: json['full_name'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );
  }

}
