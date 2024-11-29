import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaamsay/enum/task_state.dart';
import 'package:kaamsay/utils/utilities.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/flush_bar.dart';
import '/components/loading_widgets.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/screens/shared/order_profile_detail_screen.dart';
import '/screens/user_screens/login_first.dart';
import '/style/styling.dart';
import '../../components/job_info.dart';
import '../../models/job.dart';
import '../../utils/storage_service.dart';

class UserHirings extends StatefulWidget {
  static const String routeName = '/user_hirings';

  const UserHirings({super.key});
  @override
  _UserHiringsState createState() => _UserHiringsState();
}

class _UserHiringsState extends State<UserHirings> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    StorageService.readUser().then((userModel) {
      setState(() {
        currentUser = userModel;
      });
    });
  }

  void _confirmReached(Job order) {
    _firebaseRepository
        .updatetaskRecordtate(order, jobStateToString(JobState.REACHED))
        .then((value) async {
      var deviceToken =
          await _firebaseRepository.getDeviceToken(order.labourerId!);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        Utils()
            .sendPushMessage(deviceToken,
                'The hirer ${currentUser!.name} has confirmed your arrival!')
            .then((value) {})
            .catchError((error) {});
      }
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  void _confirmCompletion(Job order) {
    _firebaseRepository
        .updatetaskRecordtate(order, jobStateToString(JobState.COMPLETED_TASK))
        .then((value) async {
      var deviceToken =
          await _firebaseRepository.getDeviceToken(order.labourerId!);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        Utils()
            .sendPushMessage(deviceToken,
                'The hirer ${currentUser!.name} has confirmed your task completion!')
            .then((value) {})
            .catchError((error) {});
      }
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  void _payNow(Job order) {
    _firebaseRepository
        .updatetaskRecordtate(
            order, jobStateToString(JobState.AWAITING_PAY_CONFIRMATION))
        .then((value) async {
      var deviceToken =
          await _firebaseRepository.getDeviceToken(order.labourerId!);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        Utils()
            .sendPushMessage(deviceToken,
                'The hirer ${currentUser!.name} has paid you, please confirm!')
            .then((value) {})
            .catchError((error) {});
      }
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  // void _updateState(order) {
  //   if (order.state == 'Accepted') {
  //     _firebaseRepository
  //         .updatetaskRecordtate(order, 'Awaiting Pay Confirmation')
  //         .then((value) {})
  //         .catchError((error) {
  //       showFailureDialog(context, error.message.toString());
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Styling.blueGreyFontColor,
        elevation: 3,
        title: const Text('Hire History'),
      ),
      body: _firebaseRepository.getCurrentUser() == null
          ? const Center(child: LoginFirst())
          : currentUser == null
              ? Center(
                  child: CircularProgress(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream:
                      _firebaseRepository.getHirerTaskRecord(currentUser!.uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgress(
                        color: Theme.of(context).primaryColor,
                      ));
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No taskRecord to Show'));
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var newList = snapshot.data!.docs.reversed;
                        Job order = Job.fromMap(newList.elementAt(index).data()
                            as Map<String, dynamic>);
                        UserModel worker = UserModel(
                          profileImage: order.thumbnail,
                          name: order.title,
                          serviceProvided: order.service,
                          address: order.address,
                          phone: order.contact,
                          email: order.email,
                        );

                        bool showActionButton = true;
                        Function actionButton = () {};
                        String actionButtonText = '';
                        if (order.state ==
                            JobState.AWAITING_ARRIVAL_CONFIRMATION) {
                          showActionButton = true;
                          actionButtonText = 'Confirm Arrival';
                          actionButton = () {
                            _confirmReached(order);
                          };
                        } else if (order.state ==
                            JobState.AWAITING_COMPLETION_CONFIRMATION) {
                          showActionButton = true;
                          actionButtonText = 'Confirm Task Completion';
                          actionButton = () {
                            _confirmCompletion(order);
                          };
                        } else if (order.state == JobState.COMPLETED_TASK) {
                          showActionButton = true;
                          actionButtonText = 'Pay Now';
                          actionButton = () {
                            _payNow(order);
                          };
                          // } else if (order.state == JobState.FINISHED_JOB) {
                          //   showActionButton = true;
                          //   actionButtonText = 'Rate Labourer';
                          //   actionButton = () {
                          //     Navigator.pushNamed(
                          //       context,
                          //       RatingScreen.routeName,
                          //       arguments: {
                          //         'job': order,
                          //       },
                          //     );
                          //   };
                        } else {
                          showActionButton = false;
                        }

                        return JobInfoCard(
                          isHirer: true,
                          job: order,
                          infoButtonText: 'Show Labourer Information',
                          actionButtonText: actionButtonText,
                          showActionButton: showActionButton,
                          infoButtonPressed: () => Navigator.pushNamed(
                            context,
                            OrderProfileDetailScreen.routeName,
                            arguments: {
                              'userModel': worker,
                            },
                          ),
                          actionButtonPressed: () => actionButton(),
                        );
                      },
                    );
                  },
                ).p(16),
    );
  }
}
