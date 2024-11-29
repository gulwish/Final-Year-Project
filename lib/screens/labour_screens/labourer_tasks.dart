import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaamsay/screens/shared/rating_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/flush_bar.dart';
import '/components/loading_widgets.dart';
import '/enum/task_state.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/screens/shared/order_profile_detail_screen.dart';
import '/style/styling.dart';
import '/utils/utilities.dart';
import '../../components/job_info.dart';
import '../../models/job.dart';
import '../../utils/storage_service.dart';

class LabourerTasks extends StatefulWidget {
  static const String routeName = '/labourer-tasks';

  const LabourerTasks({super.key});
  @override
  _LabourerTasksState createState() => _LabourerTasksState();
}

class _LabourerTasksState extends State<LabourerTasks> {
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

  void _acceptJob(Job order) {
    _firebaseRepository
        .updatetaskRecordtate(order, jobStateToString(JobState.ACCEPTED))
        .then((value) async {
      var deviceToken =
          await _firebaseRepository.getDeviceToken(order.hirerId!);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        Utils()
            .sendPushMessage(deviceToken,
                'Hurrah, Your task has been accepted by ${currentUser!.name}!')
            .then((value) {})
            .catchError((error) {});
      }
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  void _onTheWay(Job order) {
    _firebaseRepository
        .updatetaskRecordtate(order, jobStateToString(JobState.ON_THE_WAY))
        .then((value) async {
      var deviceToken =
          await _firebaseRepository.getDeviceToken(order.hirerId!);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        Utils()
            .sendPushMessage(
                deviceToken, 'Your tasker ${currentUser!.name} is on the way!')
            .then((value) {})
            .catchError((error) {});
      }
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  void _reached(Job order) {
    _firebaseRepository
        .updatetaskRecordtate(
            order, jobStateToString(JobState.AWAITING_ARRIVAL_CONFIRMATION))
        .then((value) async {
      var deviceToken =
          await _firebaseRepository.getDeviceToken(order.hirerId!);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        Utils()
            .sendPushMessage(deviceToken,
                'Your tasker ${currentUser!.name} has reached, please confirm!')
            .then((value) {})
            .catchError((error) {});
      }
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  // void _confirmArrival() {} // For hirer

  void _finishJob(Job order) {
    _firebaseRepository
        .updatetaskRecordtate(
            order, jobStateToString(JobState.AWAITING_COMPLETION_CONFIRMATION))
        .then((value) async {
      var deviceToken =
          await _firebaseRepository.getDeviceToken(order.hirerId!);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        Utils()
            .sendPushMessage(deviceToken,
                'Finally, your tasker ${currentUser!.name} has completed his task, please confirm!')
            .then((value) {})
            .catchError((error) {});
      }
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  // void _confirmCompletion() {} // for hirer

  void _confirmPayment(Job order) {
    _firebaseRepository
        .updatetaskRecordtate(order, jobStateToString(JobState.FINISHED_JOB))
        .then((value) async {
      var deviceToken =
          await _firebaseRepository.getDeviceToken(order.hirerId!);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        Utils()
            .sendPushMessage(deviceToken,
                'Greetings, your job has been finished successfully!')
            .then((value) {})
            .catchError((error) {});
      }
      Navigator.pushNamed(
        context,
        RatingScreen.routeName,
        arguments: {
          'job': order,
        },
      );
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  // void

  // void _updateState(Job order) {
  //   if (order.state == JobState.PENDING) {
  //     _firebaseRepository
  //         .updatetaskRecordtate(order, jobStateToString(JobState.ACCEPTED))
  //         .then((value) async {
  //       var deviceToken =
  //           await _firebaseRepository.getDeviceToken(order.userId!);
  //       if (deviceToken != null && deviceToken.isNotEmpty) {
  //         Utils()
  //             .sendPushMessage(deviceToken,
  //                 'Hurrah, Your order has been accepted by ${currentUser!.name}!')
  //             .then((value) {})
  //             .catchError((error) {});
  //       }
  //     }).catchError((error) {
  //       showFailureDialog(context, error.message.toString());
  //     });
  //   } else if (order.state == JobState.AWAITING_PAY_CONFIRMATION) {
  //     _firebaseRepository
  //         .updatetaskRecordtate(
  //             order, jobStateToString(JobState.COMPLETED_TASK))
  //         .then((value) {})
  //         .catchError((error) {
  //       showFailureDialog(context, error.message.toString());
  //     });
  //   }
  // }

  void _declineJob(Job order) {
    _firebaseRepository
        .updatetaskRecordtate(order, jobStateToString(JobState.DECLINED))
        .then((value) async {
      var deviceToken =
          await _firebaseRepository.getDeviceToken(order.hirerId!);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        Utils()
            .sendPushMessage(deviceToken,
                'Alas, Your order has been declined ${currentUser!.name}!')
            .then((value) {})
            .catchError((error) {});
      }
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Styling.blueGreyFontColor,
        elevation: 3,
        title: const Text('Hiring History'),
      ),
      body: currentUser == null
          ? Center(
              child: CircularProgress(color: Theme.of(context).primaryColor),
            )
          : StreamBuilder<QuerySnapshot>(
              stream:
                  _firebaseRepository.getLabourerTaskRecord(currentUser!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgress(
                          color: Theme.of(context).primaryColor));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Tasks to Show'));
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var newList = snapshot.data!.docs.reversed;
                    Job job = Job.fromMap(newList.elementAt(index).data()
                        as Map<String, dynamic>);
                    UserModel hirer = UserModel(
                      profileImage: job.thumbnail,
                      name: job.title,
                      serviceProvided: job.service,
                      address: job.address,
                      phone: job.contact,
                      email: job.email,
                    );

                    bool showActionButton = true;
                    void Function() actionButton = () {};
                    String actionButtonText = '';
                    if (job.state == JobState.PENDING) {
                      actionButtonText = 'Accept';
                      actionButton = () {
                        _acceptJob(job);
                      };
                    } else if (job.state == JobState.ACCEPTED) {
                      showActionButton = true;
                      actionButtonText = 'I\'m on my way!';
                      actionButton = () {
                        _onTheWay(job);
                      };
                    } else if (job.state == JobState.ON_THE_WAY) {
                      showActionButton = true;
                      actionButtonText = 'Reached Destination';
                      actionButton = () {
                        _reached(job);
                      };
                    } else if (job.state == JobState.REACHED) {
                      showActionButton = true;
                      actionButtonText = 'Completed Task';
                      actionButton = () {
                        _finishJob(job);
                      };
                    } else if (job.state ==
                        JobState.AWAITING_PAY_CONFIRMATION) {
                      showActionButton = true;
                      actionButtonText = 'Confirm Payment';
                      actionButton = () {
                        _confirmPayment(job);
                      };
                    } else {
                      showActionButton = false;
                    }

                    return JobInfoCard(
                      isHirer: false,
                      job: job,
                      infoButtonText: 'Show Client Information',
                      actionButtonText: actionButtonText,
                      showActionButton: showActionButton,
                      infoButtonPressed: () => Navigator.pushNamed(
                        context,
                        OrderProfileDetailScreen.routeName,
                        arguments: {'userModel': hirer},
                      ),
                      actionButtonPressed: () => actionButton(),
                      declineButtonPressed: () => _declineJob(job),
                    );
                  },
                );
              },
            ).p(16),
    );
  }
}
