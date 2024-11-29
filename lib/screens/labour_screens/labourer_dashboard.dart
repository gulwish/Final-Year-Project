import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/user_location_provider.dart';
import '../../utils/utilities.dart';
import '/components/dialog_widgets.dart';
import '/components/loading_widgets.dart';
import '/components/product_card.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/screens/labour_screens/add_task_screen.dart';
import '/screens/shared/search_screen.dart';
import '/style/styling.dart';
import '../../models/task_ad.dart';
import '../../utils/storage_service.dart';
import 'no_task_available.dart';

class LabourDashboard extends StatefulWidget {
  static const String routeName = '/labourer-dashboard';

  const LabourDashboard({super.key});
  @override
  _LabourDashboardState createState() => _LabourDashboardState();
}

class _LabourDashboardState extends State<LabourDashboard> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  UserModel? _user;

  @override
  void initState() {
    super.initState();
    StorageService.readUser().then((user) {
      _addUserLocationListener(user);
      setState(() {
        _user = user;
      });
    });
  }

  void _addUserLocationListener(user) {
    if (!Provider.of<UserLocationProvider>(context, listen: false)
        .isListenerAdded) {
      Utils.determinePosition(context, user, addListener: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 3,
        backgroundColor: Styling.blueGreyFontColor,
        title: 'Home'.text.size(25).white.semiBold.make().p(8),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(
                  context, SearchScreen.routeName,
                  arguments: {' worker': _user}),
              icon: const Icon(
                CupertinoIcons.search,
                size: 25,
              )).pOnly(right: 16),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: _user == null
          ? const SizedBox.shrink()
          : FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 2,
              onPressed: () => (_firebaseRepository
                      .getCurrentUser()!
                      .emailVerified)
                  ? _user!.isCNICVerified ?? false
                      ? Navigator.pushNamed(
                          context,
                          AddTaskAdScreen.routeName,
                        )
                      : showInfoDialog(context,
                          'Please wait for your CNIC to be verified, only then you can avail this functionality!\nIn case of any issue with the CNIC, you will receive an email consisting of further instructions.')
                  : showInfoDialog(context,
                      'Please verify your email to avail this functionality!\nIf you have already cliked on verification link, please logout and sign in again.'),
              label: const Text(
                'Post your ad',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
      body: Column(
        children: [
          12.heightBox,
          // Container(
          //   color: Styling.navyBlue,
          // /
          //
          //   child: Column(
          //     children: [
          //       32.heightBox,
          //       'Home'.text.size(25).white.semiBold.make().p(8),
          //       SizedBox(height: 16),
          //       Container(
          //         height: 180,
          //         child: PageView(
          //           controller: PageController(viewportFraction: 0.8),
          //           scrollDirection: Axis.horizontal,
          //           pageSnapping: true,
          //           children: <Widget>[
          //             for (int i = 1; i < 4; i++)
          //               Container(
          //                 decoration: BoxDecoration(
          //                   image: DecorationImage(
          //                       colorFilter: ColorFilter.mode(
          //                           Colors.black38, BlendMode.darken),
          //                       fit: BoxFit.cover,
          //                       image: AssetImage(
          //                           'assets/images/grocery_placeholder$i.jpg')),
          //                   boxShadow: [
          //                     BoxShadow(
          //                         blurRadius: 3,
          //                         spreadRadius: 1,
          //                         color: Colors.black54)
          //                   ],
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //                 child: 'Category $i'
          //                     .text
          //                     .bold
          //                     .size(33)
          //                     .white
          //                     .makeCentered(),
          //               ).p(8),
          //           ],
          //         ),
          //       ),
          //       16.heightBox
          //     ],
          //   ),
          // ),
          Expanded(
            child: Container(
              child: _user == null
                  ? Center(
                      child: CircularProgress(
                          color: Theme.of(context).primaryColor))
                  : StreamBuilder<QuerySnapshot>(
                      stream: _firebaseRepository.getLabourerTasks(_user!.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgress(
                                  color: Theme.of(context).primaryColor));
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return const NoProductAvailable();
                        }
                        return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.85,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              TaskAd taskAd = TaskAd.fromMap(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);
                              taskAd.taskId = snapshot.data!.docs[index].id;
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AddTaskAdScreen.routeName,
                                  arguments: {
                                    'taskAd': taskAd,
                                    'isEdit': true,
                                  },
                                ),
                                child: TaskAdCard(taskAd: taskAd),
                              );
                            });
                      }),
            ).pOnly(left: 12, right: 12, top: 8, bottom: 12),
          )
        ],
      ),
    );
  }
}
