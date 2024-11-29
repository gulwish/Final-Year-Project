import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kaamsay/components/dialog_widgets.dart';
import 'package:kaamsay/components/loading_widgets.dart';
import 'package:kaamsay/screens/user_screens/pending_jobs.dart';
import 'package:kaamsay/utils/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../shared/chat_screen.dart';
import '/components/flush_bar.dart';
import '/models/user_model.dart';
import '/providers/cart_list_provider.dart';
import '/resources/firebase_repository.dart';
import '/style/images.dart';
import '/style/styling.dart';
import '../../components/buttons.dart';
import '../../models/hire_list_item.dart';
import '../../models/task_ad.dart';
import '../../utils/utilities.dart';

class TaskDetails extends StatefulWidget {
  final TaskAd? taskAd;
  final bool showAddToCartButton;

  const TaskDetails(
      {Key? key, required this.taskAd, this.showAddToCartButton = true})
      : super(key: key);

  static const String routeName = '/task-details';

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  UserModel? labourer;
  Map<String, dynamic>? rating;

  late CurrentTaskListProvider _taskListProvider;

  double _duration = 1;

  void _addToHireList() {
    final List<HireListItem> hireListItems =
        _taskListProvider.getHireList.where((cart) {
      return cart.taskAd!.taskId == widget.taskAd!.taskId;
    }).toList();
    if (hireListItems.isNotEmpty) {
      showFailureDialog(context, 'Task is already added!').show(context);
    } else {
      HireListItem hireListItem = HireListItem(
        taskAd: widget.taskAd,
        duration: _duration,
        charges: (widget.taskAd!.baseRate! * _duration).toInt(),
      );
      _taskListProvider.addToHireList(hireListItem);
      // showSuccessDialog(context, 'Task added successfully!').show(context);
      showInfoDialog(context, 'Task added to hirelist successfully!');
    }
  }

  @override
  void initState() {
    Utils.changeStatusBarBrightness(Brightness.dark);
    super.initState();
    _firebaseRepository
        .getUserDetails(widget.taskAd!.labourerId)
        .then((UserModel userModel) {
      setState(() {
        labourer = userModel;
      });
    }).catchError((error) {
      showFailureDialog(context, error.message.toString());
    });

    Utils.getAverageRatingAndCountFromQuerySnapshot(widget.taskAd!)
        .then((value) => setState(() {
              rating = value;
            }))
        .catchError((error) {
      showFailureDialog(context, error.message.toString());
    });
  }

  @override
  void dispose() {
    Utils.changeStatusBarBrightness(Brightness.light);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskListProvider = Provider.of<CurrentTaskListProvider>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductNetworkImage(imageURL: widget.taskAd!.thumbnailURL!),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.taskAd!.title!,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          'Rs ${widget.taskAd!.baseRate!.toInt().toString()}/hr',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  labourer == null
                      ? const CircularProgress()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 24),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: (labourer!.profileImage == null
                                        ? const AssetImage(Images.avatar)
                                        : NetworkImage(labourer!.profileImage!))
                                    as ImageProvider<Object>?,
                              ),
                              12.widthBox,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labourer!.name!.text.bold.size(16).make(),
                                    4.heightBox,
                                    labourer!.email!.text.size(12).make(),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    StorageService.readUser().then(
                                      (UserModel? user) {
                                        _firebaseRepository
                                            .createChatRoom(
                                                user!.uid!, labourer!.uid!)
                                            .then(
                                          (value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                  chatRoom: value,
                                                  otherUser: labourer!,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.message))
                            ],
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Task Description',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.taskAd!.description!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  rating == null
                      ? const CircularProgress()
                      : Center(
                          child: Column(
                            children: [
                              RatingBarIndicator(
                                rating: (rating!['rating'] == 0 &&
                                        rating!['rating'] == 0)
                                    ? 0
                                    : rating!['rating'] / rating!['counter'],
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 22,
                                itemPadding: EdgeInsets.zero,
                                itemBuilder: (context, _) => Icon(Icons.star,
                                    color: Colors.amber.shade600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '(${rating!['counter']}) Reviews',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                  widget.showAddToCartButton
                      ? Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Styling.blueGreyFontColor),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              12.heightBox,
                              const Text(
                                'Work Duration Estimation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).text.makeCentered(),
                              Slider(
                                value: _duration,
                                min: 1,
                                max: 8,
                                divisions: 14,
                                thumbColor:
                                    Theme.of(context).colorScheme.secondary,
                                onChanged: (value) {
                                  setState(() {
                                    _duration = value;
                                  });
                                },
                              ),
                              "${_duration.toStringAsFixed(2)} hrs - ${(_duration * widget.taskAd!.baseRate!).toStringAsFixed(2)} PKR"
                                  .text
                                  .semiBold
                                  .makeCentered(),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          widget.showAddToCartButton
              ? Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  height: 55,
                  width: double.infinity,
                  child: GlowingElevatedButton(
                    buttonText: 'Add task',
                    onPressed: _addToHireList,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class ProductNetworkImage extends StatelessWidget {
  const ProductNetworkImage({Key? key, required this.imageURL})
      : super(key: key);

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: Colors.black38,
                  blurRadius: 4,
                  spreadRadius: 1)
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
            child: CachedNetworkImage(
              imageUrl: imageURL,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.black.withOpacity(0.7),
                Colors.black12,
                Colors.transparent
              ])),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, PendingJobs.routeName);
                    },
                    child: Center(
                      child: Icon(
                        CupertinoIcons.time,
                        size: 20,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
