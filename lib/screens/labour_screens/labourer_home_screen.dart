import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaamsay/style/images.dart';

import '/components/dialog_widgets.dart';
import '/screens/labour_screens/labourer_dashboard.dart';
import '/screens/labour_screens/labourer_tasks.dart';
import '/screens/shared/profile_screen.dart';
import '/style/styling.dart';

class LabourerHomeScreen extends StatefulWidget {
  static const String routeName = '/labourer-home';
  final Widget? child;
  final int? index;
  final bool showBottomBar;
  final String? dialogMessage;
  final String? dialogIcon;

  const LabourerHomeScreen({super.key, 
    this.showBottomBar = true,
    this.child,
    this.index,
    this.dialogMessage,
    this.dialogIcon,
  });

  @override
  _LabourerHomeScreenState createState() => _LabourerHomeScreenState();
}

class _LabourerHomeScreenState extends State<LabourerHomeScreen> {
  int? _currentIndex = 0;
  late List<Widget?> _body;

  @override
  void initState() {
    super.initState();
    _body = [
      const LabourDashboard(),
      const LabourerTasks(),
      const ProfileScreen(),
    ];
    _currentIndex = (widget.index == null) ? 0 : widget.index;
    (widget.index != null && widget.child != null)
        ? _body[widget.index!] = widget.child
        // ignore: unnecessary_statements
        : null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.dialogMessage != null) {
        showInfoDialog(
            context, widget.dialogMessage, widget.dialogIcon ?? Images.info);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body[_currentIndex!],
      bottomNavigationBar: _buildCurvedNavigationBar(),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  CurvedNavigationBar _buildCurvedNavigationBar() {
    return CurvedNavigationBar(
      onTap: (index) => _onTabTapped(index),
      animationCurve: Curves.easeIn,
      animationDuration: const Duration(milliseconds: 300),
      height: 75,
      backgroundColor: Colors.white,
      buttonBackgroundColor: Theme.of(context).primaryColor,
      color: Styling.blueGreyFontColor,
      items: const [
        Icon(
          CupertinoIcons.home,
          size: 33,
          color: Colors.white,
        ),
        Icon(
          CupertinoIcons.time,
          size: 33,
          color: Colors.white,
        ),
        Icon(
          CupertinoIcons.person,
          size: 33,
          color: Colors.white,
        ),
      ],
    );
  }
}
