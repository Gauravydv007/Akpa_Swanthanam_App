import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  bool? status;
  String message;
  Data data;

  UserProfile({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        status: json["status"] as bool?,
        message: json["message"] ?? '',
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  dynamic lastRenewedYear;
  String pkIntActMembersId;
  String vchrMemberId;
  String vchrMemberName;
  String vchrMemberPhoto;
  String? vchrGovtVlfareNo;
  DateTime dateDob;
  String? vchrEmailId;
  String? vchrPhone;
  String? vchrWhatsappNumber;
  String? vchrEmergencyContactNumber;
  String? vchrAddress;
  String? vchrPin;
  String? vchrNomineeName;
  String? vchrRelation;
  String? vchrFacebookLink;
  String? vchrInsta;
  String vchrGender;
  String? vchrAdharNumber;
  String? vchrMobile;
  String vchrDistrictName;
  String vchrSectorName;
  String vchrUnitName;
  String vchrBloodName;
  String vchrDesignation;
  String vchrInstitutionName;
  String vchrProfesstion;

  Data({
    required this.lastRenewedYear,
    required this.pkIntActMembersId,
    required this.vchrMemberId,
    required this.vchrMemberName,
    required this.vchrMemberPhoto,
    required this.vchrGovtVlfareNo,
    required this.dateDob,
    required this.vchrEmailId,
    required this.vchrPhone,
    required this.vchrWhatsappNumber,
    required this.vchrEmergencyContactNumber,
    required this.vchrAddress,
    required this.vchrPin,
    required this.vchrNomineeName,
    required this.vchrRelation,
    required this.vchrFacebookLink,
    required this.vchrInsta,
    required this.vchrGender,
    required this.vchrAdharNumber,
    required this.vchrMobile,
    required this.vchrDistrictName,
    required this.vchrSectorName,
    required this.vchrUnitName,
    required this.vchrBloodName,
    required this.vchrDesignation,
    required this.vchrInstitutionName,
    required this.vchrProfesstion,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        lastRenewedYear: json["LAST_RENEWED_YEAR"],
        pkIntActMembersId: json["pk_int_act_members_id"] as String,
        vchrMemberId: json["vchr_member_id"] as String,
        vchrMemberName: json["vchr_member_name"] as String,
        vchrMemberPhoto: json["vchr_member_photo"] as String,
        vchrGovtVlfareNo: json["vchr_govt_vlfare_no"] as String?,
        dateDob: DateTime.parse(json["date_dob"]),
        vchrEmailId: json["vchr_email_id"] as String?,
        vchrPhone: json["vchr_phone"] as String?,
        vchrWhatsappNumber: json["vchr_whatsapp_number"] as String?,
        vchrEmergencyContactNumber:
            json["vchr_emergency_contact_number"] as String?,
        vchrAddress: json["vchr_address"] as String,
        vchrPin: json["vchr_pin"] as String,
        vchrNomineeName: json["vchr_nominee_name"] as String,
        vchrRelation: json["vchr_relation"] as String?,
        vchrFacebookLink: json["vchr_facebook_link"] as String?,
        vchrInsta: json["vchr_insta"] as String?,
        vchrGender: json["vchr_gender"] as String,
        vchrAdharNumber: json["vchr_adhar_number"] as String?,
        vchrMobile: json["vchr_mobile"] as String,
        vchrDistrictName: json["vchr_district_name"] as String,
        vchrSectorName: json["vchr_sector_name"] as String,
        vchrUnitName: json["vchr_unit_name"] as String,
        vchrBloodName: json["vchr_blood_name"] as String,
        vchrDesignation: json["vchr_designation"] as String,
        vchrInstitutionName: json["vchr_institution_name"] as String,
        vchrProfesstion: json["vchr_professtion"] as String,
      );

  get vchrWhatsApp => null;

  get vchrPincode => null;

  set vchrPincode(vchrPincode) {}

  set vchrWhatsApp(vchrWhatsApp) {}

  Map<String, dynamic> toJson() => {
        "LAST_RENEWED_YEAR": lastRenewedYear,
        "pk_int_act_members_id": pkIntActMembersId,
        "vchr_member_id": vchrMemberId,
        "vchr_member_name": vchrMemberName,
        "vchr_member_photo": vchrMemberPhoto,
        "vchr_govt_vlfare_no": vchrGovtVlfareNo,
        "date_dob": dateDob.toIso8601String(),
        "vchr_email_id": vchrEmailId,
        "vchr_phone": vchrPhone,
        "vchr_whatsapp_number": vchrWhatsappNumber,
        "vchr_emergency_contact_number": vchrEmergencyContactNumber,
        "vchr_address": vchrAddress,
        "vchr_pin": vchrPin,
        "vchr_nominee_name": vchrNomineeName,
        "vchr_relation": vchrRelation,
        "vchr_facebook_link": vchrFacebookLink,
        "vchr_insta": vchrInsta,
        "vchr_gender": vchrGender,
        "vchr_adhar_number": vchrAdharNumber,
        "vchr_mobile": vchrMobile,
        "vchr_district_name": vchrDistrictName,
        "vchr_sector_name": vchrSectorName,
        "vchr_unit_name": vchrUnitName,
        "vchr_blood_name": vchrBloodName,
        "vchr_designation": vchrDesignation,
        "vchr_institution_name": vchrInstitutionName,
        "vchr_professtion": vchrProfesstion,
      };
}
