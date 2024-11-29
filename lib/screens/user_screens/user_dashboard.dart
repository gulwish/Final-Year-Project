import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaamsay/providers/user_location_provider.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/dialog_widgets.dart';
import '/components/drawer_button.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/style/images.dart';
import '../../components/dashboard_drawer.dart';
import '../../utils/storage_service.dart';
import '../../utils/utilities.dart';
import 'main_page.dart';

// ignore: must_be_immutable
class HirerDashboard extends StatefulWidget {
  static const String routeName = '/hirer-dashboard';

  HirerDashboard({super.key, this.child, this.dialogMessage, this.dialogIcon});
  Widget? child;
  final String? dialogMessage;
  final String? dialogIcon;
  @override
  _HirerDashboardState createState() => _HirerDashboardState();
}

class _HirerDashboardState extends State<HirerDashboard>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool isCollapsed = true;

  double? screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  Animation<double>? _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;

  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  UserModel? _user;

  void _getUser() async {
    if (_firebaseRepository.getCurrentUser() != null) {
      StorageService.readUser().then((UserModel? user) {
        _addUserLocationListener(user);
        setState(() {
          _user = user;
        });
      });
    }
  }

  void _addUserLocationListener(user) {
    if (!Provider.of<UserLocationProvider>(context, listen: false)
        .isListenerAdded) {
      Utils.determinePosition(context, user, addListener: true);
    }
  }

  @override
  void initState() {
    Utils.changeStatusBarBrightness(Brightness.light);
    _controller = AnimationController(vsync: this, duration: duration);

    _scaleAnimation = Tween<double>(begin: 1, end: 0.7).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(_controller);
    super.initState();
    widget.child ??= MainPage(
      duration: duration,
      firebaseRepository: _firebaseRepository,
      toggleDrawer: toggleDrawer,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUser();

      if (widget.dialogMessage != null) {
        showInfoDialog(
            context, widget.dialogMessage, widget.dialogIcon ?? Images.info);
      }
    });
  }

  void setChild(Widget child) {
    setState(() {
      widget.child = child;
      toggleDrawer();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    setState(() {
      if (isCollapsed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }

      isCollapsed = !isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
            (isCollapsed) ? Colors.white : Theme.of(context).primaryColor,
        floatingActionButton: (isCollapsed)
            ? FloatingActionButton(
                elevation: 1,
                onPressed: toggleDrawer,
                mini: true,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  CupertinoIcons.sidebar_left,
                  color: Theme.of(context).colorScheme.background,
                ),
              )
            : const SizedBox(),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: <Widget>[
              DashboardDrawer(
                user: _user,
                slideAnimation: _slideAnimation,
                menuScaleAnimation: _menuScaleAnimation,
                firebaseRepository: _firebaseRepository,
                toggleDrawer: toggleDrawer,
                duration: duration,
                setChild: setChild,
              ),
              Dashboard(
                firebaseRepository: _firebaseRepository,
                duration: duration,
                toggleDrawer: toggleDrawer,
                isCollapsed: isCollapsed,
                scaleAnimation: _scaleAnimation,
                screenWidth: screenWidth,
                child: widget.child ??
                    MainPage(
                      duration: duration,
                      firebaseRepository: _firebaseRepository,
                      toggleDrawer: toggleDrawer,
                    ),
              ),
            ],
          ),
        ));
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard(
      {required this.child,
      required this.duration,
      required this.firebaseRepository,
      required this.toggleDrawer,
      required this.isCollapsed,
      required this.scaleAnimation,
      required this.screenWidth,
      Key? key})
      : super(key: key);

  final Duration duration;
  final FirebaseRepository firebaseRepository;
  final Function() toggleDrawer;
  final Widget? child;
  final bool isCollapsed;
  final Animation<double>? scaleAnimation;
  final double? screenWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.5 * screenWidth!,
      right: isCollapsed ? 0 : -0.5 * screenWidth!,
      child: ScaleTransition(
        scale: scaleAnimation!,
        child: isCollapsed
            ? Stack(children: [
                (child == null)
                    ? MainPage(
                        duration: duration,
                        firebaseRepository: firebaseRepository,
                        toggleDrawer: toggleDrawer,
                      )
                    : child!,
                SizedBox(
                  width: 15,
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) => toggleDrawer(),
                  ),
                )
              ])
            : Stack(children: [
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      double.infinity.widthBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          16.widthBox,
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onPressed: () => toggleDrawer(),
                            highlightColor: Theme.of(context).primaryColor,
                            child: Text(
                              'Back to browsing',
                              style: dashboardButtonText,
                            ),
                          ),
                        ],
                      ),
                      16.heightBox,
                    ],
                  ),
                ),
                Material(
                  elevation: 2,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12), child: child),
                ).pOnly(left: 12, bottom: 70),
              ]),
      ),
    );
  }
}
