// @dart=2.9
import 'package:forumbelajar/models/users.dart';

class Topics {

  final int id;
  final int user_id;
  final String title;
  final String content;
  final String status;
  final String created_at;
  final String updated_at;
  final int commentsCount;
  final Users user;

  Topics({
    this.id, this.user_id, this.title, this.content, this.status, this.created_at, this.updated_at, this.commentsCount, this.user
  });

  factory Topics.fromJson(Map<String, dynamic> json) {
    return Topics(
      id: json['id'] as int,
      user_id: json['user_id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      status: json['status'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
      commentsCount: json['commentsCount'] as int,
      user: Users.fromJson(json['user']),
    );
  }

}