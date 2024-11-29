import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/dialog_widgets.dart';
import '/components/elevated_input_field.dart';
import '/components/flush_bar.dart';
import '/components/loading_widgets.dart';
import '/components/profile_button.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/screens/labour_screens/labourer_home_screen.dart';
import '/screens/user_screens/user_dashboard.dart';
import '/style/images.dart';
import '/style/styling.dart';
import '/utils/utilities.dart';
import '../../utils/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit-profile';
  final UserModel? user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serviceProvidedController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.user!.name!;
      _serviceProvidedController.text = widget.user!.serviceProvided!;
      _addressController.text = widget.user!.address!;
      _phoneController.text = widget.user!.phone!;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _serviceProvidedController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
  }

  bool _isLoading = false;
  void _loading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _pickImage(ImageSource imageSource) {
    Navigator.maybePop(context);
    Utils.pickImage(imageSource).then((selectedImage) {
      if (selectedImage != null) {
        setState(() {
          _profileImage = selectedImage;
        });
      }
    }).catchError((error) {});
  }

  void _validateFields() {
    if (_nameController.text.trim().isEmpty &&
        _serviceProvidedController.text.trim().isEmpty &&
        _addressController.text.trim().isEmpty &&
        _phoneController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your complete details').show(context);
    } else if (_nameController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your full name').show(context);
    } else if (_serviceProvidedController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your shop name').show(context);
    } else if (_addressController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your address').show(context);
    } else if (_phoneController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your phone').show(context);
    } else if (_phoneController.text.length != 11) {
      showFailureDialog(context, 'Invalid Phone Number').show(context);
    } else {
      _loading(true);
      widget.user!.name = _nameController.text.trim();
      widget.user!.serviceProvided = _serviceProvidedController.text.trim();
      widget.user!.address = _addressController.text.trim();
      widget.user!.phone = _phoneController.text.trim();
      if (_profileImage == null) {
        _saveUser(widget.user!);
      } else {
        _uploadProfileImage();
      }
    }
  }

  void _uploadProfileImage() {
    _firebaseRepository
        .uploadProfileImage(imageFile: _profileImage!, uid: widget.user!.uid!)
        .then((imageUrl) {
      widget.user!.profileImage = imageUrl;
      _saveUser(widget.user!);
    }).catchError((error) {
      _loading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  void _saveUser(UserModel userModel) {
    _firebaseRepository.saveUserDataToFirestore(userModel).then((value) {
      StorageService.saveUser(userModel);
      _loading(false);
      Navigator.pushNamedAndRemoveUntil(
        context,
        userModel.isUser!
            ? HirerDashboard.routeName
            : LabourerHomeScreen.routeName,
        (Route<dynamic> route) => false,
        arguments: {
          'dialogMessage': 'Profile Updated Successfully',
        },
      );
    }).catchError((error) {
      _loading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            30.heightBox,
            Flexible(
              child: GestureDetector(
                onTap: () => showImageOptionBox(
                  context,
                  () => _pickImage(ImageSource.camera),
                  () => _pickImage(ImageSource.gallery),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage == null
                      ? (widget.user!.profileImage == null
                              ? const AssetImage(Images.avatar)
                              : NetworkImage(widget.user!.profileImage!))
                          as ImageProvider<Object>?
                      : FileImage(_profileImage!),
                  child: Stack(
                    children: [
                      (_profileImage == null &&
                              widget.user!.profileImage == null)
                          ? const Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.camera_alt,
                                color: Styling.navyBlue,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            30.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ElevatedInputField(
                controller: _nameController,
                textInputType: TextInputType.name,
                icon: Icons.person,
                hintText: 'Name',
                textInputAction: TextInputAction.next,
              ),
            ),
            10.heightBox,
            ElevatedInputField(
              controller: _serviceProvidedController,
              textInputType: TextInputType.name,
              icon: Icons.shopping_cart_outlined,
              hintText: 'Shop Name',
              textInputAction: TextInputAction.next,
            ).px(12),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ElevatedInputField(
                controller: _addressController,
                textInputType: TextInputType.streetAddress,
                icon: Icons.location_on,
                hintText: 'Address',
                textInputAction: TextInputAction.next,
              ),
            ),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ElevatedInputField(
                controller: _phoneController,
                textInputType: TextInputType.number,
                icon: Icons.phone,
                hintText: 'Phone',
                textInputAction: TextInputAction.done,
              ),
            ),
            40.heightBox,
            _isLoading
                ? const CircularProgress(color: Styling.navyBlue)
                : ProfileButton(
                    buttonText: 'Update',
                    color: Styling.navyBlue,
                    onPressed: _validateFields,
                  ),
          ],
        ),
      ),
    );
  }
}
