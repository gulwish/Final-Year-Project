import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaamsay/components/dialog_widgets.dart';
import 'package:kaamsay/utils/utilities.dart';
import 'package:provider/provider.dart';

import '/components/auth_button.dart';
import '/components/flush_bar.dart';
import '/components/loading_widgets.dart';
import '/components/logo_widget.dart';
import '/components/text_input_field.dart';
import '/models/task_category.dart';
import '/models/user_model.dart';
import '/providers/task_categories_provider.dart';
import '/resources/firebase_repository.dart';
import '/screens/labour_screens/labourer_home_screen.dart';
import '/screens/shared/user_agreements.dart';
import '/screens/user_screens/user_dashboard.dart';
import '/style/images.dart';
import '/style/styling.dart';
import '../../utils/storage_service.dart';
import 'signin.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  final bool isUser;

  const SignupScreen({
    Key? key,
    required this.isUser,
  }) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoadingNow = false;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _workTypeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  File? _profileImage;

  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
    });
  }

  @override
  void initState() {
    _termsAccepted = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _workTypeController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void _validateFields() {
    if (_nameController.text.trim().isEmpty &&
        // _workTypeController.text.trim().isEmpty &&
        _addressController.text.trim().isEmpty &&
        _phoneController.text.trim().isEmpty &&
        _emailController.text.trim().isEmpty &&
        _passwordController.text.trim().isEmpty &&
        _confirmPasswordController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your complete details').show(context);
    } else if (_nameController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your full name').show(context);
      // } else if (_workTypeController.text.trim().isEmpty) {
      //   (widget.isUser)
      //       ? _workTypeController.text = 'User'
      //       : showFailureDialog(context, 'Enter your service').show(context);
    } else if (_selectedCategory == null) {
      showFailureDialog(context, 'Please selcected a category').show(context);
    } else if (_addressController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your address').show(context);
    } else if (_phoneController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your phone').show(context);
    } else if (_emailController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your email').show(context);
    } else if (_passwordController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your password').show(context);
    } else if (_confirmPasswordController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your password again to confirm')
          .show(context);
    } else if (_phoneController.text.length != 11) {
      showFailureDialog(context, 'Invalid Phone Number').show(context);
    } else if (!EmailValidator.validate(_emailController.text)) {
      showFailureDialog(context, 'Invalid Email').show(context);
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showFailureDialog(context, 'Enter same password to confirm')
          .show(context);
    }
    // else if (_profileImage == null) {
    //   showFailureDialog(context, 'Please upload a valid CNIC').show(context);
    // }
    else {
      // Regex for Pakistani number (+92 123 4567890)
      // if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(_phoneController.text)) {
      isLoading(true);
      UserModel userModel = UserModel(
        name: _nameController.text.trim(),
        serviceProvided: _selectedCategory?.id ?? 'Other',
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        isUser: widget.isUser,
      );
      _signup(userModel);
      // else
      //   _uploadProfileImage();
    }
  }

  void _signup(UserModel userModel) {
    _firebaseRepository
        .signUp(
      _emailController.text,
      _passwordController.text,
    )
        .then((User? user) {
      if (user != null) {
        userModel.uid = user.uid;
        FirebaseMessaging.instance.getToken().then((String? deviceToken) async {
          userModel.deviceToken = deviceToken;
          // userModel.CNICImage = await _firebaseRepository.uploadCNICImage(
          //     imageFile: _profileImage!, uid: userModel.uid!);
          _saveUser(user, userModel);
        }).catchError((error) {
          isLoading(false);
          showFailureDialog(context, error.message.toString());
        });
      } else {
        isLoading(false);
        showFailureDialog(context, 'Failed to Sign Up').show(context);
      }
    }).catchError((error) {
      isLoading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  void _saveUser(User firebaseUser, UserModel userModel) {
    _firebaseRepository.saveUserDataToFirestore(userModel).then((value) {
      firebaseUser.sendEmailVerification().then((value) {
        if (widget.isUser) {
          print('user Saved to Firestore');
          StorageService.saveUser(userModel).then((value) {
            isLoading(false);
            Navigator.pushNamedAndRemoveUntil(
              context,
              HirerDashboard.routeName,
              (Route<dynamic> route) => false,
              arguments: {
                'dialogMessage':
                    'You are successfully registered, please check your email for account verification to unlock all features.',
                'dialogIcon': Images.userRegistered,
              },
            );
          }).catchError((error) {
            isLoading(false);
            showFailureDialog(context, error.message.toString()).show(context);
          });
        } else {
          print('labourer Saved to Firestore');
          StorageService.saveUser(userModel).then((value) {
            isLoading(false);
            Navigator.pushNamedAndRemoveUntil(
              context,
              LabourerHomeScreen.routeName,
              (Route<dynamic> route) => false,
              arguments: {
                'dialogMessage':
                    'You are successfully registered, please check your email for account verification to unlock all features.',
                'dialogIcon': Images.userRegistered,
              },
            );
          }).catchError((error) {
            isLoading(false);
            showFailureDialog(context, error.message.toString()).show(context);
          });
        }
      }).catchError((error) {
        isLoading(false);
        showFailureDialog(context, error.message.toString()).show(context);
      });
    }).catchError((error) {
      isLoading(false);
      showFailureDialog(context, error.message.toString()).show(context);
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

  bool? _termsAccepted;
  TaskCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    var catProvider = Provider.of<TaskCategoriesProvider>(context);
    _selectedCategory ??=
        catProvider.categories.firstWhere((element) => element.name == 'All');

    var dropdownItems = catProvider.categories
        .map((e) => DropdownMenuItem(
            onTap: () {
              setState(() {
                _selectedCategory = e;
              });
            },
            value: e,
            child: Text(e.name == 'All' ? 'Other' : e.name)))
        .toList();

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Images.authBg), fit: BoxFit.cover),
              ),
            ),
            Container(
              color: Colors.black54,
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 48,
                    ),
                    const Logo(
                      height: 55,
                    ),
                    const SizedBox(height: 24.0),
                    TextInputField(
                      controller: _nameController,
                      icon: CupertinoIcons.person,
                      label: 'Full Name',
                      hintText: 'Enter Full Name',
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16.0),
                    (widget.isUser)
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    'Service',
                                    style: Styling.labelStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.square_favorites,
                                      size: 22,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Flexible(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<TaskCategory>(
                                          items: dropdownItems,
                                          value: _selectedCategory,
                                          onChanged: (v) {
                                            setState(() {
                                              _selectedCategory = v;
                                            });
                                          },
                                          dropdownColor: Colors.white,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          isExpanded: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    (widget.isUser)
                        ? const SizedBox.shrink()
                        : const SizedBox(height: 16.0),
                    TextInputField(
                      controller: _addressController,
                      icon: CupertinoIcons.location_circle,
                      label: 'Address',
                      hintText: 'Enter Address',
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 16.0),
                    TextInputField(
                      controller: _phoneController,
                      icon: CupertinoIcons.phone,
                      label: 'Phone',
                      hintText: 'Enter your Phone',
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    TextInputField(
                      controller: _emailController,
                      icon: CupertinoIcons.mail,
                      label: 'Email',
                      hintText: 'Enter your Email',
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),
                    TextInputField(
                      controller: _passwordController,
                      icon: CupertinoIcons.padlock_solid,
                      label: 'Password',
                      textInputAction: TextInputAction.next,
                      hintText: 'Enter your Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0),
                    TextInputField(
                      controller: _confirmPasswordController,
                      icon: CupertinoIcons.padlock_solid,
                      label: 'Confirm Password',
                      textInputAction: TextInputAction.done,
                      hintText: 'Confirm your Password',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    (widget.isUser)
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    'Upload CNIC',
                                    style: Styling.labelStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              // ElevatedButton(
                              //   onPressed: () {},
                              //   child: Text(
                              //     'Upload',
                              //     style: TextStyle(
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                // padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () => showImageOptionBox(
                                            context,
                                            () =>
                                                _pickImage(ImageSource.camera),
                                            () =>
                                                _pickImage(ImageSource.gallery),
                                          ),
                                          child: SizedBox(
                                            height: 45,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .creditcard,
                                                        size: 22,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        _profileImage == null
                                                            ? 'Upload'
                                                            : _profileImage!
                                                                    .path
                                                                    .split('/')
                                                                    .isNotEmpty
                                                                ? '${_profileImage!.path.split('/').last.substring(0, 15)}...'
                                                                : 'Upload',
                                                        style: TextStyle(
                                                          // color: .of(context).primaryColor,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            activeColor: Theme.of(context).primaryColor,
                            checkColor: Colors.white,
                            value: _termsAccepted,
                            onChanged: (v) {
                              setState(() {
                                _termsAccepted = v;
                              });
                            }),
                        Expanded(
                          child: RichText(
                            text: TextSpan(children: [
                              const TextSpan(text: 'I accept KaamSay PK\'s '),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      _termsAccepted =
                                          await (openAgreeDialog(context));
                                      setState(() {});
                                    },
                                  text: 'Terms & Conditions',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    isLoadingNow
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: CircularProgress(),
                          )
                        : AuthButton(
                            onPressed: _termsAccepted! ? _validateFields : null,
                            buttonName: 'Sign Up',
                          ),
                    const SizedBox(
                      height: 16,
                    ),
                    LoginButton(isUser: widget.isUser),
                    const SizedBox(
                      height: 32,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, required this.isUser}) : super(key: key);
  final bool isUser;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an Account? ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(
            context,
            LoginScreen.routeName,
            arguments: {'isUser': isUser},
          ),
          child: const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
