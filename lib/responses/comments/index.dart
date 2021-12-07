// @dart=2.9
import 'package:forumbelajar/models/comments.dart';
import 'package:forumbelajar/models/users.dart';

class IndexCommentResponse {
  final bool error;
  final String message;
  final List<Comments> data;

  IndexCommentResponse({
    this.error, this.message, this.data
  });

  factory IndexCommentResponse.fromJson(Map<String, dynamic> json) {
    return IndexCommentResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: List<Comments>.from(json["data"].map((topic) {
        return Comments.fromJson(topic);
      }))
    );
  }

}