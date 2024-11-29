import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '/components/auth_button.dart';
import '/components/dialog_widgets.dart';
import '/components/flush_bar.dart';
import '/components/loading_widgets.dart';
import '/components/text_input_field.dart';
import '/resources/firebase_repository.dart';
import '/style/images.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseRepository _repository = FirebaseRepository();
  bool isLoadingNow = false;

  void _validateEmailField() {
    if (_emailController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter your email').show(context);
    } else if (!EmailValidator.validate(_emailController.text)) {
      showFailureDialog(context, 'Invalid Email').show(context);
    } else {
      isLoading(true);
      _sendResetPasswordLink();
    }
  }

  void _sendResetPasswordLink() {
    _repository.sendResetPasswordLink(_emailController.text).then((value) {
      _emailController.clear();
      isLoading(false);
      showEmailSentDialog(
          context, 'Reset Password link has been sent to your email address.');
    }).catchError((error) {
      isLoading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.introBack),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                height: double.infinity,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        Images.logoVectorB,
                        height: 50,
                      ),
                      const SizedBox(height: 30.0),
                      TextInputField(
                        controller: _emailController,
                        label: '',
                        hintText: 'Enter your Email',
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        icon: Icons.email,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      isLoadingNow
                          ? const CircularProgress()
                          : AuthButton(
                              onPressed: _validateEmailField,
                              buttonName: 'Submit',
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
