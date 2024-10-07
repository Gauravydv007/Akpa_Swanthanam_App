// class Config {
//   final String companyPhone;
//   final String companyName;
//   final String companyWebLogo;
//   final String companyEmail;
//   final String shopAddress;
//   final String downloadAppAppleStore;
//   final String downloadAppGoogleStore;
//   final String appUrl;
//   final String profilePicUrl;

//   Config({
//     required this.companyPhone,
//     required this.companyName,
//     required this.companyWebLogo,
//     required this.companyEmail,
//     required this.shopAddress,
//     required this.downloadAppAppleStore,
//     required this.downloadAppGoogleStore,
//     required this.appUrl,
//     required this.profilePicUrl,

    
//   });

//   factory Config.fromJson(Map<String, dynamic> json) {
//     return Config(
//       companyPhone: json['company_phone'],
//       companyName: json['company_name'],
//       companyWebLogo: json['company_web_logo'],
//       companyEmail: json['company_email'],
//       shopAddress: json['shop_address'],
//       downloadAppAppleStore: json['download_app_apple_stroe'],
//       downloadAppGoogleStore: json['download_app_google_stroe'],
//        appUrl: json['app_url'],
//       profilePicUrl: json['profile_pic_url'],

//     );
//   }
// }

// class BaseUrls {
//   final String customerImageUrl;
//   final String companyImageUrl;

//   BaseUrls({
//     required this.customerImageUrl,
//     required this.companyImageUrl,
//   });

//   factory BaseUrls.fromJson(Map<String, dynamic> json) {
//     return BaseUrls(
//       customerImageUrl: json['customer_image_url'],
//       companyImageUrl: json['company_image_url'],
//     );
//   }
// }






class Config {
  final String appUrl;
  final String profilePicUrl;

  Config({
    required this.appUrl,
    required this.profilePicUrl,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      appUrl: json['app_url'] ?? '',  
      profilePicUrl: json['profile_pic_url'] ?? '', 
    );
  }
}
