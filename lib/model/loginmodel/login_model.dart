/// updated model

import 'dart:convert';

class LoginModel {
  final String? lastRenewedYear;
  final String? memberId;
  final String? memberCode;
  final String? memberName;
  final String? memberPhoto;
  final String? govtVlfareNo;
  final DateTime? dateOfBirth;
  final String? email;
  final String? phone;
  final String? whatsappNumber;
  final String? emergencyContact; 
  final String? address;
  final String? pin;
  final String? nomineeName;
  final String? nomineeRelation;
  final String? facebookLink;
  final String? instagram;
  final String? gender;
  final String? adharNumber;
  final String? mobile;
  final String? districtName;
  final String? sectorName;
  final String? unitName;
  final String? bloodGroup;
  final String? designation;
  final String? institutionName;
  final String? profession;

  LoginModel({
    this.lastRenewedYear,
    this.memberId,
    this.memberCode,
    this.memberName,
    this.memberPhoto,
    this.govtVlfareNo,
    this.dateOfBirth,
    this.email,
    this.phone,
    this.whatsappNumber,
    this.emergencyContact,
    this.address,
    this.pin,
    this.nomineeName,
    this.nomineeRelation,
    this.facebookLink,
    this.instagram,
    this.gender,
    this.adharNumber,
    this.mobile,
    this.districtName,
    this.sectorName,
    this.unitName,
    this.bloodGroup,
    this.designation,
    this.institutionName,
    this.profession,
  });

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      lastRenewedYear: map["LAST_RENEWED_YEAR"]?.toString(),
      memberId: map["pk_int_act_members_id"]?.toString(),
      memberCode: map["vchr_member_id"]?.toString(),
      memberName: map["vchr_member_name"]?.toString(),
      memberPhoto: map["vchr_member_photo"]?.toString(),
      govtVlfareNo: map["vchr_govt_vlfare_no"]?.toString(),
      dateOfBirth:
          map["date_dob"] != null ? DateTime.tryParse(map["date_dob"]) : null,
      email: map["vchr_email_id"]?.toString(),
      phone: map["vchr_phone"]?.toString(),
      whatsappNumber: map["vchr_whatsapp_number"]?.toString(),
      emergencyContact: map["vchr_emergency_contact_number"]?.toString(),
      address: map["vchr_address"]?.toString(),
      pin: map["vchr_pin"]?.toString(),
      nomineeName: map["vchr_nominee_name"]?.toString(),
      nomineeRelation: map["vchr_relation"]?.toString(),
      facebookLink: map["vchr_facebook_link"]?.toString(),
      instagram: map["vchr_insta"]?.toString(),
      gender: map["vchr_gender"]?.toString(),
      adharNumber: map["vchr_adhar_number"]?.toString(),
      mobile: map["vchr_mobile"]?.toString(),
      districtName: map["vchr_district_name"]?.toString(),
      sectorName: map["vchr_sector_name"]?.toString(),
      unitName: map["vchr_unit_name"]?.toString(),
      bloodGroup: map["vchr_blood_name"]?.toString(),
      designation: map["vchr_designation"]?.toString(),
      institutionName: map["vchr_institution_name"]?.toString(),
      profession: map["vchr_professtion"]?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "LAST_RENEWED_YEAR": lastRenewedYear,
      "pk_int_act_members_id": memberId,
      "vchr_member_id": memberCode,
      "vchr_member_name": memberName,
      "vchr_member_photo": memberPhoto,
      "vchr_govt_vlfare_no": govtVlfareNo,
      "date_dob": dateOfBirth?.toIso8601String(),
      "vchr_email_id": email,
      "vchr_phone": phone,
      "vchr_whatsapp_number": whatsappNumber,
      "vchr_emergency_contact_number": emergencyContact,
      "vchr_address": address,
      "vchr_pin": pin,
      "vchr_nominee_name": nomineeName,
      "vchr_relation": nomineeRelation,
      "vchr_facebook_link": facebookLink,
      "vchr_insta": instagram,
      "vchr_gender": gender,
      "vchr_adhar_number": adharNumber,
      "vchr_mobile": mobile,
      "vchr_district_name": districtName,
      "vchr_sector_name": sectorName,
      "vchr_unit_name": unitName,
      "vchr_blood_name": bloodGroup,
      "vchr_designation": designation,
      "vchr_institution_name": institutionName,
      "vchr_professtion": profession,
    };
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) =>
      LoginModel.fromMap(json.decode(source));

  get status => null;
}
