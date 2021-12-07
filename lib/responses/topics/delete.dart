// @dart=2.9
class DeleteTopicResponse {
  final bool error;
  final String message;

  DeleteTopicResponse({
    this.error, this.message
  });

  factory DeleteTopicResponse.fromJson(Map<String, dynamic> json) {
    return DeleteTopicResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }

}