class ResetPasswordResponse {
  final bool status;
  final String message;

  ResetPasswordResponse({required this.status, required this.message});

  factory ResetPasswordResponse.fromJson(dynamic data) {
    if (data is Map<String, dynamic>) {
      return ResetPasswordResponse(
        status: data['status'] ?? false,
        message: data['message'] ?? 'Unknown error',
      );
    } else if (data is String) {
      return ResetPasswordResponse(
        status: false,
        message: data,
      );
    } else {
      return ResetPasswordResponse(
        status: false,
        message: 'Invalid response format',
      );
    }
  }
}

class ResetPasswordRequest {
  final String userId;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }
}
