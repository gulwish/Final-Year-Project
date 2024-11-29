import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaamsay/components/logo_widget.dart';
import 'package:kaamsay/style/images.dart';
import 'package:kaamsay/style/styling.dart';
import 'package:kaamsay/utils/sign_in_handles.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/auth_button.dart';
import '/components/flush_bar.dart';
import '/components/loading_widgets.dart';
import '/components/social_media_button.dart';
import '/components/text_input_field.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/screens/auth_screens/forgot_password_screen.dart';
import '/screens/auth_screens/signup_screen.dart';
import '/screens/labour_screens/labourer_home_screen.dart';
import '/screens/user_screens/user_dashboard.dart';
import '../../utils/storage_service.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({
    Key? key,
    required this.isUser,
  }) : super(key: key);
  final bool isUser;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoadingNow = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
    });
  }

  Future<void> handleFacebookSignIn() async {
    final LoginResult result = await SignInHandles.facebookHandle.login();
    switch (result.status) {
      case LoginStatus.success:
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final FirebaseAuth auth = FirebaseAuth.instance;
        final userCredential =
            await auth.signInWithCredential(facebookCredential);
        final user = userCredential.user;
        if (user != null) {
          FirebaseMessaging.instance
              .getToken()
              .then((String? deviceToken) async {
            if (!await _firebaseRepository.userExists(user.uid)) {
              if (!widget.isUser) {
                isLoading(false);
                showFailureDialog(context,
                        'Please sign up as a worker first, only then you can sign in!')
                    .show(context);
                return;
              }
              _firebaseRepository.saveUserDataToFirestore(UserModel(
                uid: user.uid,
                email: user.email,
                name: user.displayName,
                address: '',
                phone: '',
                isUser: widget.isUser,
                deviceToken: deviceToken,
              ));
            }

            _firebaseRepository
                .updateDeviceToken(user.uid, deviceToken)
                .then((value) {
              _getDetails(user.uid);
            }).catchError((error) {
              isLoading(false);
              showFailureDialog(context, 'Failed to Login').show(context);
            });
          }).catchError((error) {
            isLoading(false);
            showFailureDialog(context, 'Failed to Login').show(context);
          });
        } else {
          isLoading(false);
          showFailureDialog(context, 'Failed to Login').show(context);
        }
        break;
      case LoginStatus.cancelled:
        isLoading(false);
        showFailureDialog(context, 'Cancelled login dialog.').show(context);
        break;
      case LoginStatus.failed:
        isLoading(false);
        showFailureDialog(context, 'Failed to Login').show(context);
        break;
      default:
        isLoading(false);
        showFailureDialog(context, 'Failed to Login').show(context);
        break;
    }
  }

  Future<void> handleGoogleSignIn() async {
    final googleSignInAccount = await (SignInHandles.googleHandle.signIn());
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    final FirebaseAuth auth = FirebaseAuth.instance;

    UserCredential authResult = await auth.signInWithCredential(credential);
    var user = authResult.user;
    if (user != null) {
      FirebaseMessaging.instance.getToken().then((String? deviceToken) async {
        if (!await _firebaseRepository.userExists(user.uid)) {
          if (!widget.isUser) {
            isLoading(false);
            showFailureDialog(context,
                    'Please sign up as a worker first, only then you can sign in!')
                .show(context);
            return;
          }
          _firebaseRepository.saveUserDataToFirestore(UserModel(
            uid: user.uid,
            email: user.email,
            name: user.displayName,
            address: '',
            phone: '',
            isUser: widget.isUser,
            deviceToken: deviceToken,
          ));
        }

        _firebaseRepository
            .updateDeviceToken(user.uid, deviceToken)
            .then((value) {
          _getDetails(user.uid);
        }).catchError((error) {
          isLoading(false);
          showFailureDialog(context, 'Failed to Login').show(context);
        });
      }).catchError((error) {
        isLoading(false);
        showFailureDialog(context, 'Failed to Login').show(context);
      });
    } else {
      isLoading(false);
      showFailureDialog(context, 'Failed to Login').show(context);
    }
  }

  void _validateFields() {
    if (_emailController.text.trim().isEmpty &&
        _passwordController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your email and password').show(context);
    } else if (_emailController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your email').show(context);
    } else if (_passwordController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your password').show(context);
    } else if (!EmailValidator.validate(_emailController.text)) {
      showFailureDialog(context, 'Invalid Email').show(context);
    } else {
      isLoading(true);
      _login();
    }
  }

  void _login() {
    _firebaseRepository
        .login(_emailController.text, _passwordController.text)
        .then((User? user) {
      if (user != null) {
        FirebaseMessaging.instance.getToken().then((String? deviceToken) {
          _firebaseRepository
              .updateDeviceToken(user.uid, deviceToken)
              .then((value) {
            _getDetails(user.uid);
          }).catchError((error) {
            isLoading(false);
            showFailureDialog(context, 'Failed to Login').show(context);
          });
        }).catchError((error) {
          isLoading(false);
          showFailureDialog(context, 'Failed to Login').show(context);
        });
      } else {
        isLoading(false);
        showFailureDialog(context, 'Failed to Login').show(context);
      }
    }).catchError((error) {
      isLoading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  void _getDetails(String uid) {
    _firebaseRepository.getUserDetails(uid).then((UserModel? userModel) {
      if (userModel != null) {
        if (widget.isUser && userModel.isUser!) {
          StorageService.saveUser(userModel).then((value) {
            isLoading(false);
            Navigator.pushNamedAndRemoveUntil(
              context,
              HirerDashboard.routeName,
              (Route<dynamic> route) => false,
            );
          }).catchError((error) {
            isLoading(false);
            showFailureDialog(context, error.message.toString()).show(context);
          });
        } else if (!widget.isUser && !userModel.isUser!) {
          StorageService.saveUser(userModel).then((value) {
            isLoading(false);
            Navigator.pushNamedAndRemoveUntil(
              context,
              LabourerHomeScreen.routeName,
              (Route<dynamic> route) => false,
            );
          }).catchError((error) {
            isLoading(false);
            showFailureDialog(context, error.message.toString()).show(context);
          });
        } else if (widget.isUser && !userModel.isUser!) {
          isLoading(false);
          showFailureDialog(
                  context, 'You are not a hirer, please login as labourer!')
              .show(context);
        } else if (!widget.isUser && userModel.isUser!) {
          isLoading(false);
          showFailureDialog(
                  context, 'You are not a labourer, please login as hirer!')
              .show(context);
        } else {
          _firebaseRepository.signOut();
          isLoading(false);
          showFailureDialog(context, 'Invalid Details').show(context);
        }
      } else {
        isLoading(false);
        showFailureDialog(context, 'Failed to fetch user details')
            .show(context);
      }
    }).catchError((error) {
      isLoading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Images.authBg), fit: BoxFit.cover)),
            child: Container(
              color: Colors.black54,
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 24,
                      ),
                      const Logo(
                        height: 55,
                      ),
                      const SizedBox(height: 30.0),
                      TextInputField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'Enter your Email',
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        icon: CupertinoIcons.mail,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextInputField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Enter your Password',
                        textInputAction: TextInputAction.done,
                        icon: CupertinoIcons.padlock,
                        obscureText: true,
                      ),
                      _buildForgotPasswordBtn(),
                      isLoadingNow
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: CircularProgress(),
                            )
                          : AuthButton(
                              onPressed: _validateFields,
                              buttonName: 'LOGIN',
                            ),
                      24.heightBox,
                      'Or Sign In Using'.text.white.semiBold.make(),
                      SocialIconButtonsRow(
                        googleSignIn: () async {
                          await handleGoogleSignIn();
                        },
                        facebookSignIn: () async {
                          await handleFacebookSignIn();
                        },
                      ),
                      24.heightBox,
                      SignUpButton(isUser: widget.isUser),
                      12.heightBox,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: MaterialButton(
        highlightColor: Colors.transparent,
        onPressed: () =>
            Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
        padding: const EdgeInsets.only(right: 0.0),
        child: const Text(
          'Forgot Password?',
          style: Styling.labelStyle,
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key, required this.isUser}) : super(key: key);
  final bool isUser;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(
          child: Text(
            'Don\'t have an Account? ',
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.fade,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            SignupScreen.routeName,
            arguments: {'isUser': isUser},
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
