import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

import '/models/user_model.dart';
import '/style/images.dart';
import '/style/styling.dart';

class OrderProfileDetailScreen extends StatelessWidget {
  static const String routeName = '/order-profile-detail';
  final UserModel? userModel;

  const OrderProfileDetailScreen({Key? key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: context.percentHeight * 30,
                  width: double.infinity,
                  color: Styling.navyBlue,
                  child: const Text('PROFILE')
                      .text
                      .size(20)
                      .white
                      .makeCentered()
                      .pOnly(bottom: context.percentHeight * 10),
                ),
                SizedBox(
                  height: context.percentHeight * 20,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      buildProfileInfoRow(
                              title: 'Name', content: userModel!.name!)
                          .px(32),
                      buildProfileInfoRow(
                              title: 'Shop Name',
                              content: userModel!.serviceProvided!)
                          .px(32),
                      buildProfileInfoRow(
                              title: 'Email Address',
                              content: userModel!.email!)
                          .px(32),
                      buildProfileInfoRow(
                              title: 'Phone Number', content: userModel!.phone!)
                          .px(32),
                      buildProfileInfoRow(
                              title: 'Address', content: userModel!.address!)
                          .px(32),
                    ],
                  ),
                ),
                32.heightBox,
              ],
            ),
            Container(
              height: context.percentHeight * 25,
              width: double.infinity,
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        spreadRadius: 1, blurRadius: 10, color: Colors.black54)
                  ]),
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: (userModel!.profileImage == null
                                    ? const AssetImage(Images.avatar)
                                    : NetworkImage(userModel!.profileImage!))
                                as ImageProvider<Object>?,
                          ),
                        ),
                        8.heightBox,
                        userModel!.name!.text
                            .align(TextAlign.center)
                            .size(17)
                            .semiBold
                            .makeCentered(),
                        4.heightBox,
                        userModel!.email!.text
                            .align(TextAlign.center)
                            .size(13)
                            .makeCentered(),
                      ],
                    ),
                  ],
                ),
              ),
            ).pOnly(top: context.percentHeight * 15),
          ],
        ),
      ),
    );
  }

  Widget buildProfileInfoRow({required String title, required String content}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title.text.semiBold.size(16).make(),
            const SizedBox(width: 10.0),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: content.text.semiBold.size(15).make(),
              ),
            ),
          ],
        ),
        const Divider(
          height: 32,
          thickness: 0.5,
          color: Styling.navyBlue,
        )
      ],
    );
  }
}
