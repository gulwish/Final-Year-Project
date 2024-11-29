import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/shared/intro_screen.dart';
import '../screens/shared/user_role_selection_screen.dart';

class NavigationHelpers {
  static showIntroIfFirstLoaded(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLoaded = prefs.getBool('FirstRun');
    if (isFirstLoaded == null) {
      Navigator.pushReplacementNamed(context, IntroScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(
          context, UserRoleSelectionScreen.routeName);
    }
    prefs.setBool('FirstRun', false);
  }
}
//BuildContext navigate to different screens

/*
this code is used to determine whether to show the introductory screen (IntroScreen) or 
the user role selection screen (UserRoleSelectionScreen) based on the value of a boolean
 flag stored in shared preferences. If the flag is not set or is null, 
 it shows the introductory screen and then sets the flag to false.
  If the flag is false, it shows the user role selection screen. 
  */