import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaamsay/components/buttons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/dialog_widgets.dart';
import '/components/flush_bar.dart';
import '/providers/cart_list_provider.dart';
import '/resources/firebase_repository.dart';
import '/screens/user_screens/payment_details_screen.dart';
import '/screens/user_screens/user_dashboard.dart';
import '/style/images.dart';
import '/style/styling.dart';
import '../../components/pending_task_list_card.dart';
import '../../models/hire_list_item.dart';
import 'task_details.dart';

class PendingJobs extends StatefulWidget {
  static const String routeName = '/pending-jobs';

  const PendingJobs({super.key});
  @override
  _PendingJobsState createState() => _PendingJobsState();
}

class _PendingJobsState extends State<PendingJobs> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  late CurrentTaskListProvider _hireListProvider;

  void _removeItem(HireListItem hireListItem) {
    _hireListProvider.removeFromCart(hireListItem);
  }

  int _getItemCount() {
    return _hireListProvider.getHireList.isEmpty
        ? 0
        : _hireListProvider.getHireList.length;
  }

  double _getTotalPrice() {
    if (_hireListProvider.getHireList.isEmpty) return 0;
    double price = 0;
    for (var hireListItem in _hireListProvider.getHireList) {
      price += hireListItem.charges! * hireListItem.duration!;
    }
    return price;
  }

  void _checkout() {
    if (_hireListProvider.getHireList.isEmpty) {
      showFailureDialog(context, 'No tasks added').show(context);
    } else if (_firebaseRepository.getCurrentUser() == null) {
      showLoginPromptDialog(context);
    } else {
      Navigator.pushNamed(
        context,
        PaymentDetailsScreen.routeName,
        arguments: {'hireList': _hireListProvider.getHireList},
      );
    }
  }

  void _clearCart() {
    showConfirmDialog(
        context, 'Are you sure you want to remove all items from queue?', () {
      Navigator.pop(context);
      _hireListProvider.clearHireList();
      showSuccessDialog(context, 'Tasks cleared');
    });
  }

  @override
  Widget build(BuildContext context) {
    _hireListProvider = Provider.of<CurrentTaskListProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: Styling.blueGreyFontColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title:
            'Pending Jobs'.text.size(20).maxLines(1).white.semiBold.make().p(8),
        actions: [
          IconButton(
              onPressed: _clearCart,
              icon: Icon(
                CupertinoIcons.delete,
                size: 25,
                color: Colors.red[400],
              )).pOnly(right: 16),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            const Text(
              'Slide left to remove item from list',
              style: TextStyle(color: Styling.blueGreyFontColor),
            ).pOnly(left: 24, right: 24, top: 12),
            Expanded(
                child: (_hireListProvider.getHireList.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LottieBuilder.asset(Images.ghost),
                            const Text(
                              'Nothing to show!\nStart adding tasks from dashboard!',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Styling.blueGreyFontColor),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _hireListProvider.getHireList.length,
                        itemBuilder: (context, index) => HireListItemCard(
                          hireListItem: _hireListProvider.getHireList[index],
                          removeItem: () =>
                              _removeItem(_hireListProvider.getHireList[index]),
                          onTap: () => Navigator.pushReplacementNamed(
                              context, HirerDashboard.routeName,
                              arguments: {
                                'child': TaskDetails(
                                  taskAd: _hireListProvider
                                      .getHireList[index].taskAd,
                                  showAddToCartButton: false,
                                ),
                              }),
                          isDismissible: true,
                        ),
                      ).p(16)),
            Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              )),
              elevation: 0,
              color: Styling.blueGreyFontColor,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildCheckoutCardEntity(
                              title: 'Total tasks:  ',
                              value: _getItemCount().toString()),
                          8.heightBox,
                          buildCheckoutCardEntity(
                            title: 'Total Amount:  ',
                            value: 'PKR ${_getTotalPrice().toInt()}',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: 1,
                      height: 80,
                    ).px(8),
                    Expanded(
                      flex: 4,
                      child: GlowingElevatedButton(
                          onPressed: _checkout, buttonText: 'Confirm Hire!'),
                    )
                  ],
                ).p(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCheckoutCardEntity({String? title, String? value}) {
    return Container(
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.fade,
        text: TextSpan(children: [
          TextSpan(
              text: title, style: const TextStyle(fontSize: 16, color: Colors.white)),
          TextSpan(
              text: value,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
