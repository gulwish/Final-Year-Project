import 'package:flutter/material.dart';
import 'package:kaamsay/components/buttons.dart';
import 'package:kaamsay/components/loading_widgets.dart';
import 'package:kaamsay/models/user_model.dart';
import 'package:kaamsay/resources/firebase_repository.dart';
import 'package:kaamsay/style/images.dart';
import 'package:kaamsay/style/styling.dart';
import 'package:kaamsay/utils/storage_service.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class ReportBug extends StatefulWidget {
  const ReportBug({Key? key}) : super(key: key);

  static const String routeName = '/report-bug';

  @override
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  UserModel? user;
  bool isReporting = false;
  bool hasText = false;
  final reportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    StorageService.readUser().then((userModel) {
      setState(() {
        user = userModel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Styling.blueGreyFontColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Report a Bug'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Lottie.asset(
                        Images.ratingFeedback,
                        repeat: false,
                        width: MediaQuery.of(context).size.width * 0.75,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextField(
                      controller: reportController,
                      onChanged: (s) => setState(() {
                        s.isEmpty ? hasText = false : hasText = true;
                      }),
                      decoration: InputDecoration(
                        hintText: 'Enter your bug description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      maxLines: 5,
                    ),
                    24.heightBox,
                    isReporting
                        ? const CircularProgress()
                        : SizedBox(
                            width: 200,
                            child: GlowingElevatedButton(
                              onPressed: hasText
                                  ? () async {
                                      setState(() {
                                        isReporting = true;
                                      });
                                      await FirebaseRepository().reportBug(
                                          reportController.text,
                                          user?.name ?? 'Unknown');
                                      setState(() {
                                        isReporting = false;
                                      });
                                      Navigator.pop(context);
                                    }
                                  : null,
                              buttonText: 'Report',
                            ),
                          ),
                  ],
                ),
              ),
            ),
            'Thank you ${user?.name ?? 'dear tester'} for reporting bug to us, we will fix it in our next update!'
                .text
                .center
                .color(Styling.blueGreyFontColor)
                .make()
                .p(32),
          ],
        ),
      ),
    );
  }
}
