// @dart=2.9

class UpdateUserResponse {
  final bool error;
  final String message;

  UpdateUserResponse({
    this.error, this.message
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }

}