// @dart=2.9

class CreateCommentResponse {
  final bool error;
  final String message;

  CreateCommentResponse({
    this.error, this.message
  });

  factory CreateCommentResponse.fromJson(Map<String, dynamic> json) {
    return CreateCommentResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }

}