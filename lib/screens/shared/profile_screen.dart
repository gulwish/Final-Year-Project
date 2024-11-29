import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaamsay/utils/sign_in_handles.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/flush_bar.dart';
import '/components/profile_button.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/screens/shared/edit_profile_screen.dart';
import '/screens/shared/user_role_selection_screen.dart';
import '/screens/user_screens/login_first.dart';
import '/style/images.dart';
import '/style/styling.dart';
import '../../utils/storage_service.dart';

// ignore: must_be_immutable
class AboutReviewsTabs extends StatefulWidget {
  AboutReviewsTabs({
    Key? key,
    required this.user,
    required this.color,
  }) : super(key: key);

  int current = 0;
  var reviews;
  UserModel user;
  Color color;

  @override
  State<AboutReviewsTabs> createState() => _AboutReviewsTabsState();
}

class _AboutReviewsTabsState extends State<AboutReviewsTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.current = 0;
                          });
                        },
                        child: const Text('About'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.current = 1;
                          });
                        },
                        child: const Text('Reviews'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget.current == 0
                ? Column(
                    children: [
                      'Name'.text.bold.make(),
                      (widget.user.name ?? 'Unknown Name').text.make(),
                      16.heightBox,
                      'Service'.text.bold.make(),
                      (widget.user.serviceProvided ?? 'Unknown Service')
                          .text
                          .make(),
                      16.heightBox,
                      'Email'.text.bold.make(),
                      (widget.user.email ?? 'Unknown Email').text.make(),
                      16.heightBox,
                      'Phone'.text.bold.make(),
                      (widget.user.phone ?? 'Unknown Phone').text.make(),
                      16.heightBox,
                      'Address'.text.bold.make(),
                      (widget.user.address ?? 'Unknown Address').text.make(),
                      16.heightBox,
                    ],
                  )
                : ListView.separated(
                    itemBuilder: (c, i) => const SizedBox(),
                    separatorBuilder: (c, i) => 16.heightBox,
                    itemCount: widget.reviews.length,
                  ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile-screen';

  const ProfileScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    if (_firebaseRepository.getCurrentUser() != null) {
      StorageService.readUser().then((UserModel? user) {
        setState(() {
          _user = user;
        });
      });
    }
  }

  void _signOut() {
    _firebaseRepository.signOut().then((value) {
      StorageService.clear();
      SignInHandles.googleHandle.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserRoleSelectionScreen.routeName,
        (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      showFailureDialog(context, 'Failed to Logout').show(context);
    });
  }

  // Function to get the name field from the taskCategories collection by its ID.
  Future<String> getTaskCategoryNameById(String categoryId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot snapshot =
          await firestore.collection('taskCategories').doc(categoryId).get();

      // Check if the document exists
      if (snapshot.exists) {
        // Extract the 'name' field from the document data
        String categoryName = snapshot.get('name');
        return categoryName;
      } else {
        // Document with the given ID does not exist
        return '';
      }
    } catch (e) {
      // Handle any errors that might occur during the retrieval process
      print('Error getting task category name: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _firebaseRepository.getCurrentUser() == null
          ? Colors.white10
          : Colors.white,
      body: _firebaseRepository.getCurrentUser() == null
          ? const Center(child: LoginFirst())
          : _user == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: context.percentHeight * 25,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    Images.helpMoving,
                                  ),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black38, BlendMode.darken))),
                          child: const Text('PROFILE')
                              .text
                              .size(20)
                              .white
                              .makeCentered()
                              .pOnly(bottom: context.percentHeight * 10),
                        ),
                        SizedBox(
                          height: context.percentHeight * 10,
                        ),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              buildProfileInfoRow(
                                      title: 'Name', content: _user!.name!)
                                  .px(32),
                              _user!.isUser!
                                  ? const SizedBox.shrink()
                                  : FutureBuilder(
                                      future: getTaskCategoryNameById(
                                          _user!.serviceProvided!),
                                      builder: (context,
                                              AsyncSnapshot<String> snapshot) =>
                                          buildProfileInfoRow(
                                              title: 'Service',
                                              content: snapshot.hasData
                                                  ? snapshot.data!
                                                  : "")).px(32),
                              buildProfileInfoRow(
                                      title: 'Email Address',
                                      content: _user!.email!)
                                  .px(32),
                              buildProfileInfoRow(
                                      title: 'Phone Number',
                                      content: _user!.phone!)
                                  .px(32),
                              buildProfileInfoRow(
                                      title: 'Address',
                                      content: _user!.address!)
                                  .px(32),
                            ],
                          ),
                        ),
                        32.heightBox,
                        ProfileButton(
                          buttonText: 'LOGOUT',
                          color: Theme.of(context).colorScheme.error,
                          onPressed: _signOut,
                        ),
                        32.heightBox,
                      ],
                    ),
                    Container(
                      height: context.percentHeight * 20,
                      width: double.infinity,
                      margin: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                                spreadRadius: 0.1,
                                blurRadius: 3,
                                color: Colors.black38)
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
                                    backgroundImage: (_user!.profileImage ==
                                                null
                                            ? const AssetImage(Images.avatar)
                                            : NetworkImage(
                                                _user!.profileImage!))
                                        as ImageProvider<Object>?,
                                  ),
                                ),
                                8.heightBox,
                                _user!.name!.text
                                    .align(TextAlign.center)
                                    .size(17)
                                    .semiBold
                                    .makeCentered(),
                                4.heightBox,
                                _user!.email!.text
                                    .align(TextAlign.center)
                                    .size(15)
                                    .makeCentered(),
                              ],
                            ),
                            Positioned(
                              right: 16,
                              top: 16,
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfileScreen(user: _user),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).pOnly(top: context.percentHeight * 13),
                  ],
                ),
    );
  }

  Widget buildProfileInfoRow({required String title, required String content}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title.text.semiBold.size(15).make(),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: content.text.semiBold
                    .color(Styling.blueGreyFontColor)
                    .size(13)
                    .make(),
              ),
            ),
          ],
        ),
        const Divider(
          height: 32,
          thickness: 0.5,
          color: Styling.blueGreyFontColor,
        )
      ],
    );
  }
}
