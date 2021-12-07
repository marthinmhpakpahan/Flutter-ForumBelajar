// @dart=2.9
import 'dart:convert';
import 'package:forumbelajar/responses/topics/create.dart';
import 'package:forumbelajar/responses/topics/delete.dart';
import 'package:forumbelajar/responses/topics/update.dart';
import 'package:http/http.dart';
import 'package:forumbelajar/responses/topics/details.dart';
import 'package:forumbelajar/responses/topics/index.dart';

class TopicServices {
  
  final String url = "http://api-forum.mmhp.tech/topic";

  Future<IndexTopicResponse> index() async {
    final response = await get(Uri.parse(url + "/"));
    return IndexTopicResponse.fromJson(json.decode(response.body));
  }

  Future<DetailsTopicResponse> getTopic(int id) async {
    final response = await get(Uri.parse(url + "/show/" + id.toString()));
    return DetailsTopicResponse.fromJson(json.decode(response.body));
  }

  Future<CreateTopicResponse> create(int user_id, String title, String content) async {
    final response = await post(Uri.parse(url + "/create/"), body: {
      'user_id': user_id.toString(), 'title': title, 'content': content
    });
    return CreateTopicResponse.fromJson(json.decode(response.body));
  }

  Future<UpdateTopicResponse> update(int user_id, int topic_id, String title, String content) async {
    final response = await post(Uri.parse(url + "/update/"), body: {
      'user_id': user_id.toString(), 'topic_id': topic_id.toString(), 'title': title, 'content': content
    });
    return UpdateTopicResponse.fromJson(json.decode(response.body));
  }

  Future<DeleteTopicResponse> deleteTopic(int id) async {
    final response = await delete(Uri.parse(url + "/delete/" + id.toString()));
    return DeleteTopicResponse.fromJson(json.decode(response.body));
  }

}