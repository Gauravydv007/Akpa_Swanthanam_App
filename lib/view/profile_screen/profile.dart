import 'package:akpa/model/confgmodel/config_model.dart';
import 'package:akpa/model/edit_profile_main_app/edit_profile.dart';
import 'package:akpa/model/reset_password/reset_password_model.dart';

import 'package:akpa/model/usermodel/user_model.dart';
import 'package:akpa/service/api_service.dart';
import 'package:akpa/service/store_service.dart';
import 'package:akpa/view/edit_profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  UserProfile? userProfile;
  Config? _config;
  bool isLoading = true;
  bool showFullDetails = false;
  String? profileImageUrl;
  String? userId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _nomineeController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserId();

    fetchUserProfile();
  }

  Future<void> fetchUserId() async {
    userId = await StoreService.getLoginUserId();
    print("User ID aaa: $userId");
  }

  Future<void> fetchUserProfile() async {
    final profile = await apiService.getUserProfile();
    final config = await apiService.getConfig();

    setState(() {
      userProfile = profile;
      _config = config;

      /// Construct the image URL using the config's profilePicUrl and the user's image filename
      profileImageUrl =
          '${_config?.profilePicUrl ?? ''}${userProfile?.data.vchrMemberPhoto ?? ''}';
      print("Profile Image URL: $profileImageUrl");
      isLoading = false;
    });
  }

  void updateProfileImage(String newImageUrl) {
    setState(() {
      profileImageUrl = newImageUrl;
    });
  }

  String formatDate(DateTime date) {
    final DateFormat outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(date);
  }

  Widget buildProfileImage() {
    return profileImageUrl != null
        ? Image.network(
            profileImageUrl!,
            height: 80,
            width: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {

              return const Icon(Icons.person, size: 80, color: Colors.grey);
            },
          )
        : const Icon(Icons.person, size: 80, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black))
            : userProfile != null && _config != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          buildProfileHeader(),
                          const SizedBox(height: 20),
                          buildProfileDetails(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      'Failed to load user details',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget buildProfileHeader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Stack(
              children: [
                buildProfileImage(),
                Positioned(
                  top: 40,
                  left: 45,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePicture(
                                    onImageUpdated: updateProfileImage)));
                      },
                      icon: Icon(Icons.edit)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                userProfile!.data.vchrMemberName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProfileDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Personal Details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: _showEditDialog, 
              ),
            ],
          ),
          const SizedBox(height: 10),
          buildProfileDetail('Name', userProfile!.data.vchrMemberName),
          buildProfileDetail('Mobile', userProfile!.data.vchrMobile ?? ''),
          buildProfileDetail(
              'District Name', userProfile!.data.vchrDistrictName),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              setState(() {
                showFullDetails = !showFullDetails;
              });
            },
            child: Text(
              showFullDetails ? 'Show Less' : 'Show Full Details',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          if (showFullDetails) _buildFullProfileDetails(),
          ElevatedButton(
            onPressed: _showResetPasswordDialog,
            child: const Text('Reset Password'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget buildProfileDetail(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(detail),
        ],
      ),
    );
  }

  Widget _buildFullProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildProfileDetail('Email', userProfile!.data.vchrEmailId ?? ''),
        buildProfileDetail(
            'WhatsApp', userProfile!.data.vchrWhatsappNumber ?? ''),
        buildProfileDetail('Address', userProfile!.data.vchrAddress ?? ''),
        buildProfileDetail('Pincode', userProfile!.data.vchrPin ?? ''),
        buildProfileDetail('Nominee', userProfile!.data.vchrNomineeName ?? ''),
      ],
    );
  }

  void _showEditDialog() {

    _nameController.text = userProfile!.data.vchrMemberName;
    _emailController.text = userProfile!.data.vchrEmailId ?? '';
    _mobileController.text = userProfile!.data.vchrMobile ?? '';
    _whatsappController.text = userProfile!.data.vchrWhatsApp ?? '';
    _addressController.text = userProfile!.data.vchrAddress ?? '';
    _pincodeController.text = userProfile!.data.vchrPincode ?? '';
    _nomineeController.text = userProfile!.data.vchrNomineeName ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                ),
                TextField(
                  controller: _whatsappController,
                  decoration:
                      const InputDecoration(labelText: 'WhatsApp Number'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: _pincodeController,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                ),
                TextField(
                  controller: _nomineeController,
                  decoration: const InputDecoration(labelText: 'Nominee Name'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User ID is not available.')),
                  );
                  return;
                }

                ProfileUpdateModel updateModel = ProfileUpdateModel(
                  userId: userId!,
                  name: _nameController.text,
                  email: _emailController.text,
                  mobile: _mobileController.text,
                  whatsappNumber: _whatsappController.text,
                  address: _addressController.text,
                  pincode: _pincodeController.text,
                  nomineeName: _nomineeController.text,
                );

                try {
                  final response =
                      await apiService.editUserProfile(updateModel);

                  if (response['success'] == true) {
                    setState(() {

                      userProfile!.data.vchrMemberName = updateModel.name;
                      userProfile!.data.vchrEmailId = updateModel.email;
                      userProfile!.data.vchrMobile = updateModel.mobile;
                      userProfile!.data.vchrWhatsApp =
                          updateModel.whatsappNumber;
                      userProfile!.data.vchrAddress = updateModel.address;
                      userProfile!.data.vchrPincode = updateModel.pincode;
                      userProfile!.data.vchrNomineeName =
                          updateModel.nomineeName;
                    });

                    Navigator.of(context).pop();

                    Future.delayed(Duration(milliseconds: 300), () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Profile successfully updated!')),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'])),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating profile: $e')),
                  );
                }
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Old Password'),
                ),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _resetPassword,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _resetPassword() async {
    if (userId == null) return; 

    ResetPasswordRequest request = ResetPasswordRequest(
      userId: userId!,
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    try {
      ResetPasswordResponse response = await apiService.resetPassword(request);
      if (response.status) {
        // Password reset successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
