import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kaamsay/components/flush_bar.dart';
import 'package:kaamsay/models/hire_list_item.dart';
import 'package:kaamsay/providers/cart_list_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/dialog_buttons.dart';
import '/screens/user_screens/user_dashboard.dart';
import '/style/images.dart';
import '../models/task_ad.dart';
import '../screens/user_screens/task_details.dart';

showHireDiag({
  required BuildContext context,
}) {
  Dialog imgWarnDialog = Dialog(
    elevation: 1,
    backgroundColor: Colors.white70,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          'Are you sure to hire?'.text.size(15).center.makeCentered(),
          32.heightBox,
        ],
      ),
    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => imgWarnDialog);
}

showEmailVerificationInfoDiag({
  required BuildContext context,
}) {
  Dialog imgWarnDialog = Dialog(
    elevation: 1,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            Images.mailSent,
            width: 200,
          ),
          24.heightBox,
          const Text(
            'Verification Email has been sent to you, please verify your email address to unlock full functionality',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => imgWarnDialog);
}

showUnderDevDiag({
  required BuildContext context,
}) {
  Dialog imgWarnDialog = Dialog(
    elevation: 1,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            Images.underDevelopment,
            width: 220,
          ),
          const Text(
            'This feature is under development & will be available soon!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ).p(24)
        ],
      ),
    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => imgWarnDialog);
}

showSuccessDiag({
  required BuildContext context,
}) {
  Dialog imgWarnDialog = Dialog(
    elevation: 1,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(Images.success, height: 200),
          'Task has been added!'.text.size(15).center.makeCentered(),
          16.heightBox,
          'Please wait for the response.'.text.size(15).center.makeCentered(),
          32.heightBox,
          DialogButton(null, 'Okay', () {
            Navigator.pop(context);
          }),
        ],
      ),
    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => imgWarnDialog);
}

showLabourerAboutDiag({required BuildContext context, required TaskAd taskAd}) {
  Dialog imgWarnDialog = Dialog(
    elevation: 12,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              taskAd.thumbnailURL!,
            ),
          ),
          8.heightBox,
          taskAd.title!.text.size(17).center.bold.makeCentered(),
          4.heightBox,
          // task.totalPriceForAllUnitsDemanded.text
          //     .size(11)
          //     .gray500
          //     .center
          //     .makeCentered(),
          8.heightBox,
          RatingBar(
            itemSize: 25,
            onRatingUpdate: (d) {},
            ratingWidget: RatingWidget(
              full: const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              half: const Icon(
                Icons.star_half,
                color: Colors.yellow,
              ),
              empty: const Icon(
                Icons.star_border,
                color: Colors.yellow,
              ),
            ),
          ),

          3.heightBox,
          Text(
            '(4/5)',
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          ),
          16.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: DialogButton(
                  CupertinoIcons.info,
                  'More info',
                  () => Navigator.pushReplacementNamed(
                      context, HirerDashboard.routeName,
                      arguments: {
                        'child': TaskDetails(taskAd: taskAd),
                      }),
                ),
              ),
              24.widthBox,
              Flexible(
                child:
                    DialogButton(CupertinoIcons.add_circled, 'Quick Add!', () {
                  var taskListProvider = Provider.of<CurrentTaskListProvider>(
                      context,
                      listen: false);
                  final List<HireListItem> hireListItems =
                      taskListProvider.getHireList.where((cart) {
                    return cart.taskAd!.taskId == taskAd.taskId;
                  }).toList();
                  if (hireListItems.isNotEmpty) {
                    showFailureDialog(context, 'Task already added')
                      .show(context);
                  } else {
                    HireListItem hireListItem = HireListItem(
                      taskAd: taskAd,
                      duration: 1,
                      charges: (taskAd.baseRate! * 1).toInt(),
                    );
                    taskListProvider.addToHireList(hireListItem);
                    showSuccessDialog(context, 'Task added').show(context);
                  }
                }),
              ),
            ],
          ).px(16),
          8.heightBox,
        ],
      ),
    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => imgWarnDialog);
}
