class ProfileUpdateModel {
  final String userId;
  final String name;
  final String email;
  final String mobile;
  final String whatsappNumber;
  final String address;
  final String pincode;
  final String nomineeName;

  ProfileUpdateModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.whatsappNumber,
    required this.address,
    required this.pincode,
    required this.nomineeName,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'whatsapp_number': whatsappNumber,
      'address': address,
      'pincode': pincode,
      'nominee_name': nomineeName,
    };
  }
}
