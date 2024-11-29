import 'package:flutter/material.dart';
import 'package:kaamsay/enum/task_state.dart';
import 'package:kaamsay/resources/firebase_repository.dart';
import 'package:kaamsay/screens/shared/rating_screen.dart';

import 'package:velocity_x/velocity_x.dart';

import '../models/job.dart';
import '/style/styling.dart';

class JobInfoCard extends StatelessWidget {
  final Job? job;
  final String? infoButtonText;
  final String? actionButtonText;
  final bool showActionButton;
  final Function? infoButtonPressed;
  final Function? actionButtonPressed;
  final Function? declineButtonPressed;
  final bool isHirer;

  const JobInfoCard({
    Key? key,
    this.job,
    this.infoButtonText,
    this.actionButtonText,
    this.showActionButton = true,
    this.infoButtonPressed,
    this.actionButtonPressed,
    this.declineButtonPressed,
    required this.isHirer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Styling.blueGreyFontColor, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.heightBox,
          Row(
            children: [
              Text(
                job!.hireListItem!.taskAd!.title!,
              ).text.size(16).semiBold.make(),
              const Spacer(),
              ('PKR: ${job!.hireListItem!.charges}/-').text.semiBold.make()
            ],
          ),
          4.heightBox,
          Row(
            children: [
              Text(
                'Hrs: ${job!.hireListItem!.duration}',
              ).text.size(16).bold.make(),
              const Spacer(),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: jobStateToString(job!.state!).text.white.make())
            ],
          ),
          12.heightBox,
          JobCardButton(title: infoButtonText, onPressed: infoButtonPressed),
          // 8.heightBox,
          showActionButton
              ? JobCardButton(
                  title: actionButtonText,
                  onPressed: actionButtonPressed,
                  color: Theme.of(context).primaryColor,
                )
              : const SizedBox.shrink(),
          FutureBuilder<bool>(future: () async {
            var data = await FirebaseRepository().getJobRatings(job!.jobId);
            if (data.docs.isEmpty) return false;
            var map = data.docs.first.data() as Map<String, dynamic>;
            return map['ratingForLabourer'] != null ? true : false;
          }(), builder: (c, s) {
            if (!s.hasData) return const SizedBox.shrink();
            return isHirer && !s.data! && job!.state == JobState.FINISHED_JOB
                ? JobCardButton(
                    title: 'Rate Labourer',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RatingScreen.routeName,
                        arguments: {
                          'job': job!,
                        },
                      );
                    },
                    color: Theme.of(context).primaryColor)
                : const SizedBox.shrink();
          }),
          if (job!.state! == JobState.PENDING)
            JobCardButton(
              title: 'Decline',
              onPressed: declineButtonPressed,
              color: Theme.of(context).colorScheme.error.withOpacity(0.9),
            )
        ],
      ).p(0).px(12),
    ).pOnly(top: 12);
  }
}

class JobCardButton extends StatelessWidget {
  const JobCardButton(
      {this.color = Styling.blueGreyFontColor,
      this.onPressed,
      this.title,
      Key? key})
      : super(key: key);

  final String? title;
  final Function? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(0),
      elevation: 0,
      color: color,
      onPressed: onPressed as void Function()?,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title!,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
