import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaamsay/components/dialog_widgets.dart';
import 'package:kaamsay/screens/user_screens/pending_jobs.dart';
import 'package:kaamsay/utils/sign_in_handles.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/drawer_button.dart';
import '/components/flush_bar.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/screens/shared/chats_lobby.dart';
import '/screens/shared/profile_screen.dart';
import '/screens/user_screens/users_history.dart';
import '/style/images.dart';
import '../../utils/storage_service.dart';
import '../screens/auth_screens/signin.dart';
import '../screens/shared/report_bug_screen.dart';
import '../screens/shared/user_role_selection_screen.dart';
import '../screens/user_screens/main_page.dart';

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer(
      {required this.user,
      required this.firebaseRepository,
      required this.menuScaleAnimation,
      required this.slideAnimation,
      required this.toggleDrawer,
      required this.duration,
      required this.setChild,
      Key? key})
      : super(key: key);

  final FirebaseRepository firebaseRepository;
  final Animation<Offset> slideAnimation;
  final Animation<double> menuScaleAnimation;
  final UserModel? user;
  final Duration duration;
  final Function() toggleDrawer;
  final Function(Widget child) setChild;

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  @override
  Widget build(BuildContext context) {
    print('menu build');
    return SlideTransition(
      position: widget.slideAnimation,
      child: ScaleTransition(
        scale: widget.menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 48, bottom: 32),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        (widget.user == null)
                            ? Navigator.pushReplacementNamed(
                                context,
                                LoginScreen.routeName,
                                arguments: {'isUser': true},
                              )
                            : widget.firebaseRepository.signOut().then((value) {
                                StorageService.clear();
                                SignInHandles.googleHandle.signOut();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  UserRoleSelectionScreen.routeName,
                                  (Route<dynamic> route) => false,
                                );
                              }).catchError((error) {
                                showFailureDialog(context, 'Failed to Logout')
                                    .show(context);
                              });
                        setState(() {});
                      },
                      highlightColor: Theme.of(context).primaryColor,
                      child: Text(
                        (widget.user == null) ? 'Sign In' : 'Sign Out',
                        style: dashboardButtonText,
                      ),
                    ).px(16)
                  ],
                ),
                48.heightBox,
                GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.user == null) {
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName,
                                  arguments: {'isUser': true});
                            } else {
                              Navigator.pushNamed(
                                context,
                                ProfileScreen.routeName,
                              );
                            }
                            widget.toggleDrawer();
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: widget.user == null
                                ? const AssetImage(Images.avatar)
                                : (widget.user!.profileImage == null
                                        ? const AssetImage(Images.avatar)
                                        : NetworkImage(
                                            widget.user!.profileImage!))
                                    as ImageProvider<Object>?,
                          ),
                        ),
                      ),
                      14.widthBox,
                      Text(
                        (widget.user != null) ? widget.user!.name! : 'Guest',
                        style: dashboardButtonText,
                      ),
                      4.widthBox,
                      (widget.user != null &&
                              widget.firebaseRepository.getCurrentUser() !=
                                  null)
                          ? widget.firebaseRepository
                                  .getCurrentUser()!
                                  .emailVerified
                              ? Container(
                                  height: 15,
                                  width: 15,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                  child: const Icon(
                                    Icons.check,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.warning,
                                  color: Colors.white,
                                  size: 15,
                                )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
                const OrangeDivider(),
                8.heightBox,
                DrawerrButton(
                    text: 'Dashboard',
                    icon: CupertinoIcons.home,
                    onTap: () {
                      widget.setChild(MainPage(
                        duration: widget.duration,
                        firebaseRepository: widget.firebaseRepository,
                        toggleDrawer: widget.toggleDrawer,
                      ));
                    }),
                const OrangeDivider(),
                DrawerrButton(
                    text: 'Pending Jobs',
                    icon: CupertinoIcons.time,
                    onTap: () {
                      Navigator.pushNamed(context, PendingJobs.routeName);
                    }),
                const OrangeDivider(),
                DrawerrButton(
                    text: 'Hire History',
                    icon: CupertinoIcons.book,
                    onTap: widget.user == null
                        ? () => showInfoDialog(
                            context, 'Please login to avail this functionality')
                        : () {
                            widget.setChild(const UserHirings());
                          }),
                const OrangeDivider(),
                DrawerrButton(
                    text: 'Chats',
                    icon: CupertinoIcons.chat_bubble,
                    onTap: widget.user == null
                        ? () => showInfoDialog(
                            context, 'Please login to avail this functionality')
                        : () {
                            widget.setChild(const ChatsHomeScreen());
                          }),
                const OrangeDivider(),
                Row(
                  children: [
                    DrawerrButton(
                        text: 'Settings',
                        icon: CupertinoIcons.settings,
                        onTap: () {
                          showInfoDialog(context, 'Coming Soooooon!');
                        }),
                    24.widthBox,
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KaamSay',
                      style: dashboardButtonText,
                    ),
                    8.heightBox,
                    Text(
                      'Version 1.0',
                      style: dashboardButtonText.copyWith(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ReportBug.routeName);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.bug_report_outlined,
                              color: Theme.of(context).colorScheme.surface,
                              size: 18),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Report a bug',
                            style: dashboardButtonText.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).pOnly(left: 8),
                const Spacer(),
              ],
            ).pOnly(left: 8),
          ),
        ),
      ),
    );
  }
}

class OrangeDivider extends StatelessWidget {
  const OrangeDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 180,
      child: Divider(
        color: Colors.white,
        height: 25,
        thickness: 0.5,
        indent: 48,
      ),
    );
  }
}
