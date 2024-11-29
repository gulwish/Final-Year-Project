import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '/style/images.dart';
import '/style/styling.dart';
import '../screens/auth_screens/signin.dart';
import 'buttons.dart';

showEmailSentDialog(BuildContext context, String msg) {
  Dialog emailSentDialogue = Dialog(
    elevation: 1,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            Images.mailSent,
            width: 200,
          ),
          24.heightBox,
          Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => emailSentDialogue);
}

showInfoDialog(BuildContext context, String? message,
    [String icon = Images.info]) {
  return showDialog(
      context: context,
      builder: (context) => Material(
            color: Colors.transparent,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Lottie.asset(icon, height: 160, repeat: true),
                              const SizedBox(height: 8),
                              const Center(
                                child: Text(
                                  'INFO',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: Text(
                                  message!,
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: 130,
                                child: PrimaryButton(
                                  color: Theme.of(context).primaryColor,
                                  buttonText: 'Dismiss',
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
}

showAccountBlockedDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => Material(
            color: Colors.transparent,
            child: Center(
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(24.0),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Lottie.asset(Images.blocked, height: 120),
                            const SizedBox(height: 24),
                            const Center(
                                child: Text(
                              'Sorry! Your account has been blocked.',
                              style: TextStyle(fontSize: 15),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
}

showImageOptionBox(
    BuildContext context, Function cameraPressed, Function galleryPressed) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Center(
          child: Text('Choose Image Option'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: cameraPressed as void Function()?,
              leading: CircleAvatar(
                maxRadius: 40,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
              title: const Text('Camera'),
            ),
            const Divider(),
            ListTile(
              onTap: galleryPressed as void Function()?,
              leading: CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
              ),
              title: const Text('Gallery'),
            ),
          ],
        ),
      );
    },
  );
}

showLoginPromptDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Material(
            color: Colors.transparent,
            child: Center(
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(24.0),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                            16.heightBox,
                            Center(
                                child: MaterialButton(
                              color: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              onPressed: () => Navigator.pushNamed(
                                  context, LoginScreen.routeName,
                                  arguments: {'isUser': true}),
                              child: const Text(
                                'LOGIN/REGISTER',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
}

showConfirmDialog(BuildContext context, String question, Function yesPressed) {
  return showDialog(
      context: context,
      builder: (context) => Material(
            color: Colors.transparent,
            child: Center(
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(24.0),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(190),
                                child: Lottie.asset(Images.deleteAnim,
                                    height: 120)),
                            const SizedBox(height: 24),
                            question.text
                                .size(16)
                                .align(TextAlign.center)
                                .makeCentered(),
                            16.heightBox,
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: MaterialButton(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      onPressed: yesPressed as void Function()?,
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  24.widthBox,
                                  Flexible(
                                    child: MaterialButton(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color: Styling.blueGreyFontColor,
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'No',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
}
