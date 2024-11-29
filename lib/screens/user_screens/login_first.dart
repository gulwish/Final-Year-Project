import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '/style/images.dart';
import '../auth_screens/signin.dart';

class LoginFirst extends StatelessWidget {
  const LoginFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      height: 320.0,
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Lottie.asset(Images.info, height: 120),
                const SizedBox(height: 24),
                'You will have to SignIn/Register for for this action.'
                    .text
                    .size(16)
                    .align(TextAlign.center)
                    .makeCentered(),
                24.heightBox,
                Center(
                    child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    LoginScreen.routeName,
                    arguments: {
                      'isUser': true,
                    },
                  ),
                  child: const Text(
                    'LOGIN/REGISTER',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
