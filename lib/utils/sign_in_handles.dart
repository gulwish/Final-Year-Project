import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignInHandles {
  SignInHandles._();

  static final googleHandle = GoogleSignIn();
  static final facebookHandle = FacebookAuth.instance;
}

/*
It ensures that all parts of your application
 that require Google or Facebook authentication are using 
 the same instances of these services. 
 
*/