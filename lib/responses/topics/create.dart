// @dart=2.9
class CreateTopicResponse {
  final bool error;
  final String message;

  CreateTopicResponse({
    this.error, this.message
  });

  factory CreateTopicResponse.fromJson(Map<String, dynamic> json) {
    return CreateTopicResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }

}