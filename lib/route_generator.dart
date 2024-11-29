import 'package:flutter/material.dart';
import 'package:kaamsay/screens/auth_screens/forgot_password_screen.dart';
import 'package:kaamsay/screens/auth_screens/signin.dart';
import 'package:kaamsay/screens/auth_screens/signup_screen.dart';
import 'package:kaamsay/screens/labour_screens/add_task_screen.dart';
import 'package:kaamsay/screens/labour_screens/labourer_dashboard.dart';
import 'package:kaamsay/screens/labour_screens/labourer_home_screen.dart';
import 'package:kaamsay/screens/labour_screens/labourer_tasks.dart';
import 'package:kaamsay/screens/shared/chats_lobby.dart';
import 'package:kaamsay/screens/shared/edit_profile_screen.dart';
import 'package:kaamsay/screens/shared/order_profile_detail_screen.dart';
import 'package:kaamsay/screens/shared/profile_screen.dart';
import 'package:kaamsay/screens/shared/rating_screen.dart';
import 'package:kaamsay/screens/shared/report_bug_screen.dart';
import 'package:kaamsay/screens/shared/search_screen.dart';
import 'package:kaamsay/screens/shared/user_agreements.dart';
import 'package:kaamsay/screens/user_screens/main_page.dart';
import 'package:kaamsay/screens/user_screens/notifications_screen.dart';
import 'package:kaamsay/screens/user_screens/payment_details_screen.dart';
import 'package:kaamsay/screens/user_screens/pending_jobs.dart';
import 'package:kaamsay/screens/user_screens/user_dashboard.dart';
import 'package:kaamsay/screens/user_screens/users_history.dart';

import '/screens/shared/intro_screen.dart';
import '/screens/splash_screen.dart';
import 'screens/shared/user_role_selection_screen.dart';
import 'screens/user_screens/task_details.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    //  final args = settings.arguments;

    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case IntroScreen.routeName:
        return MaterialPageRoute(builder: (context) => const IntroScreen());

      case UserRoleSelectionScreen.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const UserRoleSelectionScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case RatingScreen.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => RatingScreen(
            job: args['job'],
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case ReportBug.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const ReportBug(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case ForgotPasswordScreen.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const ForgotPasswordScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case LoginScreen.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => LoginScreen(
            isUser: args['isUser'],
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case SignupScreen.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => SignupScreen(
            isUser: args['isUser'],
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case AddTaskAdScreen.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => AddTaskAdScreen(
            taskAd: args['taskAd'],
            isEdit: args['isEdit'] ?? false,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case LabourDashboard.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const LabourDashboard(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      case NotificationsScreen.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const NotificationsScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case LabourerHomeScreen.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => LabourerHomeScreen(
            showBottomBar: args['showBottomBar'] ?? true,
            child: args['child'],
            index: args['index'],
            dialogMessage: args['dialogMessage'],
            dialogIcon: args['dialogIcon'],
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case LabourerTasks.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const LabourerTasks(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case ChatsHomeScreen.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const ChatsHomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case EditProfileScreen.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => EditProfileScreen(
            user: args['user'],
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case IntroScreen.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const IntroScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case OrderProfileDetailScreen.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => OrderProfileDetailScreen(
            userModel: args['userModel'],
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case ProfileScreen.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const ProfileScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case SearchScreen.routeName:
        // final args = settings.arguments == null
        //     ? <String, dynamic>{}
        //     : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const SearchScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case CreateAgreement.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const CreateAgreement(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case MainPage.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => MainPage(
            duration: args['duration'],
            firebaseRepository: args['firebaseRepository'],
            toggleDrawer: args['toggleDrawer'],
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case PaymentDetailsScreen.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => PaymentDetailsScreen(
            hireList: args['hireList'] ?? [],
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case TaskDetails.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => TaskDetails(
            taskAd: args['taskAd'],
            showAddToCartButton: args['showAddToCartButton'] ?? true,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case PendingJobs.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const PendingJobs(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case HirerDashboard.routeName:
        final args = settings.arguments == null
            ? <String, dynamic>{}
            : settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => HirerDashboard(
            child: args['child'],
            dialogIcon: args['dialogIcon'],
            dialogMessage: args['dialogMessage'],
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case UserHirings.routeName:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const UserHirings(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }
}

        //case UserCategorySelectionScreen.id:
        // final args = settings.arguments;
        // return PageRouteBuilder(
        //   settings: settings,
        //   pageBuilder: (_, __, ___) => MainTabbedHomeScreen(
        //     isFirstLogin: args as bool,
        //   ),
        //   transitionsBuilder: (_, animation, __, child) {
        //     return FadeTransition(
        //       opacity: animation,
        //       child: child,
        //     );
        //   },
        // );