import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kaamsay/components/loading_widgets.dart';
import 'package:kaamsay/models/job.dart';
import 'package:kaamsay/models/user_model.dart';
import 'package:kaamsay/resources/firebase_repository.dart';
import 'package:kaamsay/screens/user_screens/user_dashboard.dart';
import 'package:kaamsay/style/images.dart';
import 'package:kaamsay/utils/storage_service.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../labour_screens/labourer_home_screen.dart';

// class Slide {
//   String title;
//   String description;
//   String imageUrl;
//   Widget rate;
//   Widget submitButton;
//   Slide({
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//     required this.rate,
//     required this.submitButton,
//   });
// }

// TODO: Code refactor + Redesign

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key, required this.job}) : super(key: key);

  static const String routeName = '/rating-scren';
  final Job job;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  UserModel? currentUser;
  bool _isSaving = false;
  final _firebaseRepository = FirebaseRepository();
  final feedbackController = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    StorageService.readUser().then((userModel) {
      setState(() {
        currentUser = userModel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade50,
        // backgroundColor: Theme.of(context).backgroundColor,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text('Rate Service'),
        //   centerTitle: true,
        //   automaticallyImplyLeading: false,
        //   leading: IconButton(
        //     icon: Icon(
        //       Icons.close,
        //       color: Colors.white,
        //     ),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        // ),
        body: SafeArea(
          child: true
              ? Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                            flex: 3,
                            child: Lottie.asset(Images.ratingFeedback)),
                        Expanded(
                          flex: 5,
                          child: Container(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                                4.widthBox,
                                'CLOSE'
                                    .text
                                    .letterSpacing(2)
                                    .color(Colors.grey)
                                    .size(18)
                                    .make(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade200,
                                            blurRadius: 20,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 32,
                                      ),
                                      child: Column(
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              style: const TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                const TextSpan(
                                                    text: 'Your valuable '),
                                                TextSpan(
                                                  text: 'feedback',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                const TextSpan(text: ' matters!')
                                              ],
                                            ),
                                          ),
                                          8.heightBox,
                                          'Please rate the service you received from KaamSay platform!'
                                              .text
                                              .center
                                              .color(Colors.grey)
                                              .size(14)
                                              .makeCentered(),
                                          16.heightBox,
                                          RatingBar(
                                            ratingWidget: RatingWidget(
                                              full: Icon(
                                                Icons.star_rate_rounded,
                                                color: Colors.amber.shade600,
                                              ),
                                              half: Icon(
                                                Icons.star_half_rounded,
                                                color: Colors.amber.shade600,
                                              ),
                                              empty: Icon(
                                                Icons.star_border_rounded,
                                                color: Colors.amber.shade600,
                                              ),
                                            ),
                                            onRatingUpdate: (d) {
                                              setState(() {
                                                rating = d;
                                              });
                                            },
                                          ),
                                          16.heightBox,
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextField(
                                              controller: feedbackController,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Please enter your feedback here, we try to read and understand your concerns all the time :)',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                              maxLines: 4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                8.heightBox,
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () {
                                      print('${widget.job.hirerId}-${widget.job.labourerId}');
                                      setState(() {
                                        _isSaving = true;
                                      });
                                      if (currentUser!.isUser!) {
                                        _firebaseRepository
                                            .addLabourerRatingByHirer(
                                          widget.job.jobId!,
                                          widget.job.hireListItem!.taskAd!
                                              .taskId!,
                                          widget.job.hirerId!,
                                          widget.job.labourerId!,
                                          rating,
                                          feedbackController.text,
                                        );
                                      } else {
                                        _firebaseRepository
                                            .addHirerRatingByLabourer(
                                          widget.job.jobId!,
                                          widget.job.hireListItem!.taskAd!
                                              .taskId!,
                                          widget.job.hirerId!,
                                          widget.job.labourerId!,
                                          rating,
                                          feedbackController.text,
                                        );
                                      }
                                      setState(() {
                                        _isSaving = false;
                                      });
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        currentUser!.isUser!
                                            ? HirerDashboard.routeName
                                            : LabourerHomeScreen.routeName,
                                        (Route<dynamic> route) => false,
                                        arguments: {
                                          'dialogMessage':
                                              'Finished job successsfully, Thanks for using KaamSay!'
                                        },
                                      );
                                    },
                                    child: const Text('SUBMIT FEEDBACK')
                                        .text
                                        .white
                                        .letterSpacing(1.5)
                                        .size(16)
                                        .make()
                                        .p8(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              // ignore: dead_code
              : Column(
                  children: [
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32.0,
                          horizontal: 16,
                        ),
                        child: Column(
                          children: [
                            const Text('Rate US').text.semiBold.size(30).white.make(),
                            16.heightBox,
                            const Text('Kindly Rate my work by selcting stars! Are you happy with my service?')
                                .text
                                .size(24)
                                .white
                                .make(),
                            16.heightBox,
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: feedbackController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your comments here',
                                  border: InputBorder.none,
                                ),
                                maxLines: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.heightBox,
                    Card(
                      child: Column(
                        children: [
                          const Text('Rate').text.bold.size(28).make(),
                          RatingBar(
                            ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star_rate_rounded,
                                color: Colors.amber.shade600,
                              ),
                              half: Icon(
                                Icons.star_half_rounded,
                                color: Colors.amber.shade600,
                              ),
                              empty: Icon(
                                Icons.star_border_rounded,
                                color: Colors.amber.shade600,
                              ),
                            ),
                            onRatingUpdate: (d) {
                              setState(() {
                                rating = d;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    16.heightBox,
                    currentUser == null || _isSaving
                        ? const CircularProgress()
                        : ElevatedButton(
                            onPressed: () {
                              print('${widget.job.hirerId}-${widget.job.labourerId}');
                              setState(() {
                                _isSaving = true;
                              });
                              if (currentUser!.isUser!) {
                                _firebaseRepository.addLabourerRatingByHirer(
                                  widget.job.jobId!,
                                  widget.job.hireListItem!.taskAd!.taskId!,
                                  widget.job.hirerId!,
                                  widget.job.labourerId!,
                                  rating,
                                  feedbackController.text,
                                );
                              } else {
                                _firebaseRepository.addHirerRatingByLabourer(
                                  widget.job.jobId!,
                                  widget.job.hireListItem!.taskAd!.taskId!,
                                  widget.job.hirerId!,
                                  widget.job.labourerId!,
                                  rating,
                                  feedbackController.text,
                                );
                              }
                              setState(() {
                                _isSaving = false;
                              });
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                currentUser!.isUser!
                                    ? HirerDashboard.routeName
                                    : LabourerHomeScreen.routeName,
                                (Route<dynamic> route) => false,
                                arguments: {
                                  'dialogMessage':
                                      'Finished job successsfully, Thanks for using KaamSay!'
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('Submit')
                                  .text
                                  .white
                                  .bold
                                  .size(24)
                                  .make(),
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}

// class RatingScreen1 extends StatefulWidget {
//   const RatingScreen1({
//     Key? key,
//     required this.job,
//   }) : super(key: key);

//   static const String routeName = '/rating-scren';

//   final taskId = 'task-Id-Here';
//   final Job job;

//   @override
//   State<RatingScreen1> createState() => _RatingScreen1State();
// }

// class _RatingScreen1State extends State<RatingScreen1> {
//   var _isSaving = false;
//   final _firebaseRepository = FirebaseRepository();
//   final feedbackController = TextEditingController();
//   UserModel? currentUser;
//   // late String hirerId, labourerId;
//   double rating = 0;
//   List<Slide> slides = List<Slide>.empty(growable: true);
//   @override
//   void initState() {
//     super.initState();
//     StorageService.readUser().then((userModel) {
//       setState(() {
//         currentUser = userModel;
//       });
//     });
//     // hirerId = widget.user.isUser! ? widget.user.uid! : widget.job.userId!;
//     // labourerId = widget.user.isUser! ? widget.job.userId! : widget.user.uid!;
//     slides.add(
//       Slide(
//         title: "RATE US",
//         description:
//             "Kindly rate my work by selecting stars! \n Are you Happy with my service?",
//         imageUrl: "assets/images/rider.png",
//         rate: RatingBar(
//           ratingWidget: RatingWidget(
//             full: Icon(
//               Icons.star_rate_rounded,
//               color: Colors.amber.shade600,
//             ),
//             half: Icon(
//               Icons.star_half_rounded,
//               color: Colors.amber.shade600,
//             ),
//             empty: Icon(
//               Icons.star_border_rounded,
//               color: Colors.amber.shade600,
//             ),
//           ),
//           onRatingUpdate: (d) {
//             setState(() {
//               rating = d;
//             });
//           },
//         ),

//         // SmoothStarRating(
//         //   starCount: 5,
//         //   size: 50,
//         //   spacing: 1,
//         //   onRated: Store_Rate_to_Firebase(),
//         //   allowHalfRating: true,
//         // ),
//         SubmitButton: _isSaving
//             ? CircularProgressIndicator()
//             : GestureDetector(
//                 child: Text(
//                   "Submit",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 25,
//                     fontFamily: 'Raleway',
//                   ),
//                 ),
//                 onTap: () {
//                   print(widget.job.hirerId.toString() +
//                       '-' +
//                       widget.job.labourerId.toString());
//                   setState(() {
//                     _isSaving = true;
//                   });
//                   if (currentUser!.isUser!) {
//                     _firebaseRepository.addLabourerRatingByHirer(
//                       widget.job.jobId!,
//                       widget.taskId,
//                       widget.job.hirerId!,
//                       widget.job.labourerId!,
//                       rating,
//                       feedbackController.text,
//                     );
//                   } else {
//                     _firebaseRepository.addHirerRatingByLabourer(
//                       widget.job.jobId!,
//                       widget.taskId,
//                       widget.job.hirerId!,
//                       widget.job.labourerId!,
//                       rating,
//                       feedbackController.text,
//                     );
//                   }
//                   setState(() {
//                     _isSaving = false;
//                   });
//                 },
//               ),
//       ),
//     );
//     slides.add(
//       Slide(
//         title: "FEEDBACK",
//         description: "Do you have any thoughts to share on my work",
//         imageUrl: "assets/images/rider.png",
//         rate: Container(
//           child: TextField(
//             controller: feedbackController,
//             decoration: InputDecoration(
//                 border: InputBorder.none, hintText: 'Share your Experience'),
//           ),
//         ),
//         SubmitButton: GestureDetector(
//           child: Text(
//             "Submit",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 25,
//               fontFamily: 'Raleway',
//             ),
//           ),
//           //  onTap: ontab(),
//         ),
//       ),
//     );
//     // slides.add(Slide(
//     //   title: "THANK YOU",
//     //   description:
//     //       "Thanku for your valuable feedback. it will help us to improve my service",
//     //   imageUrl: "assets/images/TH.png",
//     //   rate: Visibility(
//     //     visible: false,
//     //     child: Container()),
//     //   SubmitButton: Visibility(
//     //     visible: false,
//     //     child: Container()),
//     // ));
//   }

//   List<Widget> renderListCustomTabs() {
//     List<Widget> tabs = [];
//     for (int i = 0; i < slides.length; i++) {
//       Slide currentSlide = slides[i];
//       tabs.add(Scaffold(
//         appBar: AppBar(),
//         body: SingleChildScrollView(
//           child: Container(
//             color: Colors.white,
//             margin: EdgeInsets.only(
//               bottom: 60.0,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   padding: EdgeInsets.only(top: 30),
//                   height: 400,
//                   width: double.infinity,
//                   color: Theme.of(context).primaryColor,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Image.asset(
//                         //   currentSlide.imageUrl,
//                         //   height: 220,
//                         //   width: 220,
//                         // ),
//                         Container(
//                           child: Text(
//                             currentSlide.title,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 30,
//                               fontFamily: 'Raleway',
//                             ),
//                           ),
//                           margin: EdgeInsets.only(top: 20.0),
//                         ),
//                         Container(
//                           child: Text(
//                             currentSlide.description,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontFamily: 'Raleway',
//                             ),
//                           ),
//                           margin: EdgeInsets.only(top: 20.0),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 30, top: 20),
//                   child: Container(
//                     width: 350,
//                     height: 120,
//                     alignment: Alignment.center,
//                     child: currentSlide.rate,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           blurRadius: 6,
//                           spreadRadius: 4,
//                           color: Color.fromARGB(20, 0, 0, 0),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: 40, top: 20),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   width: 320,
//                   height: 50,
//                   alignment: Alignment.center,
//                   child: currentSlide.SubmitButton,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ));
//     }
//     return tabs;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return IntroSlider(
//       listCustomTabs: this.renderListCustomTabs(),
//       colorDot: Theme.of(context).primaryColor,
//       sizeDot: 10.0,
//       colorActiveDot: Styling.blueGreyFontColor,
//       scrollPhysics: BouncingScrollPhysics(),
//     );
//   }

//   Store_Rate_to_Firebase() {}
// }
