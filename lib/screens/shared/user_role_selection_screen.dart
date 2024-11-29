import 'package:flutter/material.dart';
import 'package:kaamsay/components/buttons.dart';

import '/screens/user_screens/user_dashboard.dart';
import '/style/images.dart';
import '../../components/user_role_selection_button.dart';
import '../auth_screens/signin.dart';

class UserRoleSelectionScreen extends StatefulWidget {
  const UserRoleSelectionScreen({super.key});

  @override
  _UserRoleSelectionScreenState createState() =>
      _UserRoleSelectionScreenState();
  static const String routeName = '/user-role-selection';
}

class _UserRoleSelectionScreenState extends State<UserRoleSelectionScreen> {
  int selectedCategory = 0;

  void navigate() {
    if (selectedCategory == 1) {
      Navigator.pushNamed(
        context,
        HirerDashboard.routeName,
        arguments: <String, dynamic>{},
      );
    }
    if (selectedCategory == 2) {
      Navigator.pushNamed(
        context,
        LoginScreen.routeName,
        arguments: {'isUser': false},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  Images.introBack,
                ),
                fit: BoxFit.cover)),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      UserRoleSelectionButton(
                        icon: Images.userRole,
                        buttonName: 'USER',
                        onPressed: () {
                          setState(() {
                            selectedCategory = 1;
                          });
                        },
                        isSelected: selectedCategory == 1,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      UserRoleSelectionButton(
                        icon: Images.workerRole,
                        buttonName: 'WORKER',
                        onPressed: () {
                          setState(() {
                            selectedCategory = 2;
                          });
                        },
                        isSelected: selectedCategory == 2,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.1, color: Colors.black),
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: GlowingElevatedButton(
                            buttonText: selectedCategory == 0
                                ? 'Please Select Your Role'
                                : 'Continue',
                            onPressed:
                                (selectedCategory == 0) ? null : navigate)),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
