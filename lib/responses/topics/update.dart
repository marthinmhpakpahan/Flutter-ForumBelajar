// @dart=2.9
class UpdateTopicResponse {
  final bool error;
  final String message;

  UpdateTopicResponse({
    this.error, this.message
  });

  factory UpdateTopicResponse.fromJson(Map<String, dynamic> json) {
    return UpdateTopicResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }

}