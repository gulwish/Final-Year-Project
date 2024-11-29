import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaamsay/components/dialog_widgets.dart';
import 'package:kaamsay/utils/messaging_notifications.dart';
import 'package:kaamsay/utils/utilities.dart';
import 'package:velocity_x/velocity_x.dart';

import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/screens/labour_screens/labourer_home_screen.dart';
import '/screens/user_screens/user_dashboard.dart';
import '/style/images.dart';
import '../utils/navigation_helpers.dart';
import '../utils/storage_service.dart';

FirebaseRepository _firebaseRepository = FirebaseRepository();

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final MessagingAndNotifications _messagingAndNotifications =
      MessagingAndNotifications();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _messagingAndNotifications.notitficationPermission();
    _messagingAndNotifications.initMessaging();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_firebaseRepository.getCurrentUser() != null) {
        StorageService.readUser().then((UserModel? user) {
          if (user == null) {
            NavigationHelpers.showIntroIfFirstLoaded(context);
          } else {
            Utils.determinePosition(context, user, addListener: true)
                .then((value) => print(value))
                .onError(
                  (error, stackTrace) => showInfoDialog(
                    context,
                    error.toString(),
                    Images.error,
                  ),
                );
            if (user.isUser!) {
              Navigator.pushReplacementNamed(context, HirerDashboard.routeName);
            } else {
              Navigator.pushReplacementNamed(
                  context, LabourerHomeScreen.routeName);
            }
          }
        });
      } else {
        NavigationHelpers.showIntroIfFirstLoaded(context);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    Utils.changeStatusBarBrightness(Brightness.light);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            TweenAnimationBuilder(
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 700),
              tween: Tween<double>(
                begin: 0,
                end: 1,
              ),
              builder: (context, dynamic val, child) => Container(
                width: context.percentWidth * (val * 50),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(4, 4))
                    ]),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Images.logoVectorB,
                          width: context.percentWidth * (val * 50),
                        ),
                        'www.kaamsay.pk'
                            .text
                            .color(Theme.of(context).primaryColor)
                            .size(10)
                            .makeCentered(),
                      ],
                    ).p(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
