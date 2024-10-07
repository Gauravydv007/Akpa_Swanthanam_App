import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:akpa/model/editprofile/edit_profile_model.dart';
import 'package:akpa/service/store_service.dart';

class ProfileService {
  final Dio dio = Dio();

  Future<EditImageResponse> updateProfilePicture(File imageFile) async {
    try {
      var userId = await StoreService.getLoginUserId();
      var formData = FormData.fromMap({
        'user_id': userId,
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      var response = await dio.post(
        'https://akpa.in/Controller_api/edit_profile_pic',
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        String responseData = response.data.toString().trim();

        List<String> jsonResponseList = responseData.split('}{');

        if (jsonResponseList.length == 2) {
          jsonResponseList[1] = '{"' + jsonResponseList[1];
          jsonResponseList[0] = jsonResponseList[0] + '}';

          EditImageResponse responsePart1 =
              EditImageResponse.fromJson(jsonDecode(jsonResponseList[0]));
          EditImageResponse responsePart2 =
              EditImageResponse.fromJson(jsonDecode(jsonResponseList[1]));

          if (responsePart2.status) {
            return responsePart2;
          } else {
            return responsePart1;
          }
        } else {
          return EditImageResponse(
              status: false, message: 'Invalid response format');
        }
      } else {
        return EditImageResponse(
            status: false, message: 'Failed to update image');
      }
    } catch (e) {
      return EditImageResponse(status: false, message: 'Error: $e');
    }
  }
}
