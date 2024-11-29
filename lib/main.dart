import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaamsay/providers/task_categories_provider.dart';
import 'package:kaamsay/providers/user_location_provider.dart';
import 'package:kaamsay/route_generator.dart';
import 'package:kaamsay/screens/splash_screen.dart';
import 'package:kaamsay/style/styling.dart';
import 'package:kaamsay/utils/utilities.dart';
import 'package:provider/provider.dart';

import '/providers/cart_list_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// <!-- TODO: There is one more thing to be added in info.plist, check out iOS setup for geolocator -->

// TODO: implement signing functionality using social media accounts
// TODO: Phone Number Verification
// TODO: Add functionality for workers to upload NIC images while signining up
// TODO: Add all the services in dashboard of hirer
// TODO: Drawer opening rebuilds the screen - fix this
// TODO: Use provider for userdata
// TODO: Removal of curved navigationbar, use native one instead (in labourer flow)

// TODO: Add Login with Apple to make G-Sign In work with apple

// TODO: In case of cnic being declined, user must be sent an email with further steps!

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentTaskListProvider()),
        ChangeNotifierProvider(create: (_) => TaskCategoriesProvider()),
        ChangeNotifierProvider(create: (_) => UserLocationProvider()),
      ],
      child: const KaamSay(),
    );
  }
}

class KaamSay extends StatefulWidget {
  const KaamSay({Key? key}) : super(key: key);

  @override
  State<KaamSay> createState() => _KaamSayState();
}

class _KaamSayState extends State<KaamSay> {
  @override
  void initState() {
    Utils.fetchAndSaveTaskCategories(context);
    Utils.determinePosition(context, null,
        addListener:
            false); // To save location to provider, wont save on user side (no user access here)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KaamSay',
      theme: Styling.appTheme,
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
