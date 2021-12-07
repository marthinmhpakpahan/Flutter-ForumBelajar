// @dart=2.9

class RegisterResponse {
  final bool error;
  final String message;

  RegisterResponse({
    this.error, this.message
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }

}