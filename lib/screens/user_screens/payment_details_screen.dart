import 'package:flutter/material.dart';
import 'package:kaamsay/enum/task_state.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/flush_bar.dart';
import '/components/loading_widgets.dart';
import '/models/user_model.dart';
import '/providers/cart_list_provider.dart';
import '/resources/firebase_repository.dart';
import '/screens/labour_screens/labourer_home_screen.dart';
import '/screens/user_screens/user_dashboard.dart';
import '/style/styling.dart';
import '/utils/utilities.dart';
import '../../components/buttons.dart';
import '../../models/hire_list_item.dart';
import '../../models/job.dart';
import '../../utils/storage_service.dart';

class PaymentDetailsScreen extends StatefulWidget {
  static const String routeName = '/payment-details';
  final List<HireListItem> hireList;

  const PaymentDetailsScreen({Key? key, required this.hireList})
      : super(key: key);

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  late UserModel currentUser;

  late CurrentTaskListProvider _cartListProvider;

  @override
  void initState() {
    super.initState();
    StorageService.readUser().then((UserModel? userModel) {
      setState(() {
        currentUser = userModel!;
      });
    });
  }

  bool _isLoading = false;
  void _loading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _hireNow() {
    int count = 0;
    _loading(true);

    for (var hireListItem in widget.hireList) {
      _firebaseRepository
          .getUserDetails(hireListItem.taskAd!.labourerId)
          .then((UserModel worker) {
        Job labourerSide = Job(
          state: JobState.PENDING,
          hirerId: currentUser.uid,
          labourerId: worker.uid,
          thumbnail: currentUser.profileImage,
          title: currentUser.name,
          service: currentUser.serviceProvided,
          address: currentUser.address,
          contact: currentUser.phone,
          email: currentUser.email,
        );

        Job hirerSide = Job(
          state: JobState.PENDING,
          hirerId: currentUser.uid,
          labourerId: worker.uid,
          thumbnail: worker.profileImage,
          title: worker.name,
          service: worker.serviceProvided,
          address: worker.address,
          contact: worker.phone,
          email: worker.email,
        );

        labourerSide.hireListItem = hireListItem;
        hirerSide.hireListItem = hireListItem;

        String orderId = DateTime.now().millisecondsSinceEpoch.toString();
        labourerSide.jobId = orderId;
        hirerSide.jobId = orderId;

        _firebaseRepository.addTaskToLabourerSide(labourerSide).then((value) {
          _firebaseRepository.addTaskToHirerSide(hirerSide).then((value) {
            if (worker.deviceToken != null && worker.deviceToken!.isNotEmpty) {
              Utils()
                  .sendPushMessage(
                      worker.deviceToken, 'You have received an order')
                  .then((value) {})
                  .catchError((error) {});
            }
            count++;
            if (count == widget.hireList.length) {
              _loading(false);
              _cartListProvider.clearHireList();
              Navigator.pushNamedAndRemoveUntil(
                context,
                currentUser.isUser!
                    ? HirerDashboard.routeName
                    : LabourerHomeScreen.routeName,
                (Route<dynamic> route) => false,
                arguments: {'dialogMessage': 'Task booked successfully'},
              );
            }
          }).catchError((error) {
            _loading(false);
            showFailureDialog(context, error.message.toString());
          });
        }).catchError((error) {
          _loading(false);
          showFailureDialog(context, error.message.toString());
        });
      }).catchError((error) {
        _loading(false);
        showFailureDialog(context, error.message.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _cartListProvider = Provider.of<CurrentTaskListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Styling.blueGreyFontColor,
        title: const Text(
          'Confirm Hire',
        ),
      ),
      body: Column(
        children: [
          buildTaskListTile(
              serialNumber: 'S.no', taskName: 'Task Name', amount: 'Amount'),
          const Divider(
            color: Styling.navyBlue,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.hireList.length,
                itemBuilder: (context, index) {
                  return buildTaskListTile(
                    serialNumber: (index + 1).toString(),
                    taskName: widget.hireList[index].taskAd!.title!,
                    amount: widget.hireList[index].charges.toString(),
                  );
                }),
          ),
          16.heightBox,
          const Divider(
            color: Styling.navyBlue,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'Total amount:'.text.size(16).semiBold.make(),
              _getTotalAmount().toString().text.size(16).semiBold.make(),
            ],
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'Service charges:'.text.size(16).semiBold.make(),
              150.toString().text.size(16).semiBold.make(),
            ],
          ),
          24.heightBox,
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Total bill including service charges is ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                        text: 'PKR ${_getTotalAmount() + 150}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black)),
                    const TextSpan(
                      text: ', the labourer will soon be there.',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )
                  ])),
          24.heightBox,
          _isLoading
              ? CircularProgress(color: Theme.of(context).primaryColor)
              : PrimaryButton(
                  buttonText: 'Confirm booking',
                  onPressed: _hireNow,
                ),
        ],
      ).p(24),
    );
  }

  ListTile buildTaskListTile(
      {required String taskName,
      required String serialNumber,
      required String amount}) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.all(0),
      leading: Text(
        serialNumber,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ).pOnly(top: 4),
      title: Text(
        taskName,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: Text(
        amount,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  int _getTotalAmount() {
    int total = 0;
    for (var cartItem in widget.hireList) {
      total += cartItem.charges!;
    }
    return total;
  }
}
