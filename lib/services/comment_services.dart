// @dart=2.9
import 'dart:convert';
import 'package:forumbelajar/responses/comments/create.dart';
import 'package:forumbelajar/responses/comments/delete.dart';
import 'package:forumbelajar/responses/comments/index.dart';
import 'package:http/http.dart';

class CommentServices {
  
  final String url = "http://api-forum.mmhp.tech/comment";

  Future<IndexCommentResponse> index(int id) async {
    final response = await get(Uri.parse(url + "/" + id.toString()));
    return IndexCommentResponse.fromJson(json.decode(response.body));
  }

  Future<CreateCommentResponse> create(int topic_id, int user_id, String comment) async {
    final response = await post(Uri.parse(url + "/create/"), body: {
      'topic_id': topic_id.toString(), 'user_id': user_id.toString(), 'content': comment
    });
    return CreateCommentResponse.fromJson(json.decode(response.body));
  }

  Future<DeleteCommentResponse> deleteComment(int id) async {
    final response = await delete(Uri.parse(url + "/delete/" + id.toString()));
    return DeleteCommentResponse.fromJson(json.decode(response.body));
  }

}