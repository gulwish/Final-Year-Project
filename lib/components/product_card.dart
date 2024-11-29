import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

import '../models/task_ad.dart';
import '/style/styling.dart';

class TaskAdCard extends StatelessWidget {
  final TaskAd taskAd;

  const TaskAdCard({Key? key, required this.taskAd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(taskAd.thumbnailURL!), fit: BoxFit.cover),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Styling.blueGreyFontColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskAd.title!,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ).pOnly(left: 4, top: 4),
                const Divider(
                  height: 2,
                  color: Colors.white,
                ),
                Text(
                  'PKR: ${taskAd.baseRate.toString()}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ).p(4),
              ],
            ),
          ),
        ],
      ),
    ).p(4);
  }
}
