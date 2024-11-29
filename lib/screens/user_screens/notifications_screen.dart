import 'package:flutter/material.dart';
import 'package:kaamsay/style/styling.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notification-page';

  const NotificationsScreen({super.key});
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifications',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Styling.ksOrange,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Driving',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                5.heightBox,
                                const Text(
                                  'Completed',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ],
                            ).px(24).py(12),
                          ),
                          Container(
                            height: 62,
                            width: 0.2,
                            color: Colors.white,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Time: 06:30 PM',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              5.heightBox,
                              const Text(
                                'Date: 16-09-2023s',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ).px(24).py(12),
                        ],
                      ),
                    ),
                    (index == 2 || index == 5)
                        ? buildDateDivider('Date')
                        : const SizedBox.shrink()
                  ],
                );
              },
            ).p(16),
          ),
        ],
      ),
    );
  }

  Widget buildDateDivider(String date) {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 0.5,
              color: Colors.black,
            ),
          ),
          40.widthBox,
          Text(
            date,
            style: const TextStyle(fontSize: 12),
          ),
          40.widthBox,
          Expanded(
            child: Container(
              height: 0.5,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
