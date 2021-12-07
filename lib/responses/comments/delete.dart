// @dart=2.9
class DeleteCommentResponse {
  final bool error;
  final String message;

  DeleteCommentResponse({
    this.error, this.message
  });

  factory DeleteCommentResponse.fromJson(Map<String, dynamic> json) {
    return DeleteCommentResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }

}