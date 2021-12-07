// @dart=2.9
import 'package:forumbelajar/models/users.dart';

class Comments {

  final int id;
  final int topic_id;
  final int user_id;
  final String content;
  final String status;
  final String created_at;
  final String updated_at;
  final Users user;

  Comments({
    this.id, this.topic_id, this.user_id, this.content, this.status, this.created_at, this.updated_at, this.user,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'] as int,
      topic_id: json['topic_id'] as int,
      user_id: json['user_id'] as int,
      content: json['content'] as String,
      status: json['status'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
      user: Users.fromJson(json['user'])
    );
  }
}