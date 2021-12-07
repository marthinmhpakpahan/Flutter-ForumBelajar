// @dart=2.9
import 'dart:convert';
import 'package:forumbelajar/responses/users/register.dart';
import 'package:forumbelajar/responses/users/update.dart';
import 'package:http/http.dart';
import 'package:forumbelajar/responses/users/detail.dart';
import 'package:forumbelajar/responses/users/login.dart';

class UserServices {
  
  final String url = "http://api-forum.mmhp.tech/user";

  Future<DetailUserResponse> getUser(int id) async {
    final response = await get(Uri.parse(url + '/show/' + id.toString()));
    return DetailUserResponse.fromJson(json.decode(response.body));
  }

  Future<LoginResponse> login(String username, String password) async {
    final response = await post(Uri.parse(url + "/login/"), body: {
      'username': username,
      'password': password
    });
    return LoginResponse.fromJson(json.decode(response.body));
  }

  Future<RegisterResponse> register(String username, String password, String email, String full_name, String gender, String address) async {
    final response = await post(Uri.parse(url + "/register/"), body: {
      'username': username, 'password': password, 'email': email, 'full_name': full_name,
      'gender': gender, 'address': address
    });
    return RegisterResponse.fromJson(json.decode(response.body));
  }

  Future<UpdateUserResponse> updateUser(int user_id, String username, String password, String email, String full_name, String gender, String address) async {
    final response = await post(Uri.parse(url + "/update/"), body: {
      'user_id': user_id.toString(), 'username': username, 'password': password, 'email': email, 'full_name': full_name,
      'gender': gender, 'address': address
    });
    return UpdateUserResponse.fromJson(json.decode(response.body));
  }

}