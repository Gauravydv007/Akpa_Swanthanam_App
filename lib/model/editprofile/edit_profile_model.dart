import 'dart:convert';

class EditImageResponse {
  final bool status;
  final String message;
  final String? imageFileName;

  EditImageResponse({
    required this.status,
    required this.message,
    this.imageFileName,
  });

  factory EditImageResponse.fromJson(Map<String, dynamic> json) {
    return EditImageResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      imageFileName: json['imageFileName'],
    );
  }

  static List<EditImageResponse> parseConcatenatedResponse(
      String responseString) {
    List<String> jsonResponseList = responseString.split('}{');  /// as the response come in two parts

    return jsonResponseList.map((responsePart) {
      String validJson = responsePart;

      if (!validJson.startsWith('{')) validJson = '{' + validJson;
      if (!validJson.endsWith('}')) validJson = validJson + '}';

      return EditImageResponse.fromJson(jsonDecode(validJson));
    }).toList();
  }
}
