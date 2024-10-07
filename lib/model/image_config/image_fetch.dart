import 'package:flutter/material.dart';


class Config {
  final bool status;
  final String message;
  final ConfigData data;

  Config({required this.status, required this.message, required this.data});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      status: json['status'],
      message: json['message'],
      data: ConfigData.fromJson(json['data']),
    );
  }
}

class ConfigData {
  final String appUrl;
  final String profilePicUrl;

  ConfigData({required this.appUrl, required this.profilePicUrl});

  factory ConfigData.fromJson(Map<String, dynamic> json) {
    return ConfigData(
      appUrl: json['app_url'],
      profilePicUrl: json['profile_pic_url'],
    );
  }
}
