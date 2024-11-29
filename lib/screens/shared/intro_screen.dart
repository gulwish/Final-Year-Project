import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '/screens/shared/user_role_selection_screen.dart';
import '/style/images.dart';

class IntroScreen extends StatefulWidget {
  static const String routeName = '/intro-screen';

  const IntroScreen({super.key});
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentIndex = 0;
  final Curve _animationCurve = Curves.ease;

  final PageController _slideController = PageController();
  final List<Map<String, String>> _onboardingItems = [
    {
      'image': Images.intro_one,
      'title': 'Welcome to KaamSay',
      'description':
          'Pakistan\'s fastest growing online marketplace for tasker services!',
    },
    {
      'image': Images.intro_two,
      'title': 'Find the best worker',
      'description':
          'Get the work done at your fingertips. Find the best tasker for your job and get hired by the best tasker.',
    },
    {
      'image': Images.intro_three,
      'title': 'Only Three taps',
      'description':
          'Hire/Get hired within 3 taps with our hassle free process. Tap to get started!',
    },
  ];

  void _gotoNextPage() {
    setState(() {
      _slideController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: _animationCurve,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 25,
                      // left: 4, right: 4, top: 4
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage(Images.introBack),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            SvgPicture.asset(
                              Images.logoVectorB,
                              height: 40,
                            ),
                            Flexible(
                              child: PageView.builder(
                                  itemCount: _onboardingItems.length,
                                  controller: _slideController,
                                  onPageChanged: (v) {
                                    setState(() {
                                      _currentIndex = v;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.all(24),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                child: LottieBuilder.asset(
                                                  _onboardingItems[index]
                                                      ['image']!,
                                                  frameRate: FrameRate(60),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _onboardingItems[index]
                                                            ['title']!
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 24),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0),
                                                    child: Text(
                                                      _onboardingItems[index]
                                                          ['description']!,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            IntroIndicationDots(
                                dotCount: _onboardingItems.length,
                                currentIndex: _currentIndex,
                                animationCurve: _animationCurve),
                            const SizedBox(
                              height: 40,
                            )
                          ]),
                    ),
                  ),
                  BuildNextSlideButton(
                    gotoNextPage: _gotoNextPage,
                    getStarted: _currentIndex == _onboardingItems.length - 1,
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Center(
                      child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, UserRoleSelectionScreen.routeName);
                    },
                    child: const Text(
                      'SKIP INTRO',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                )),
          ],
        ),
      ),
    );
  }
}

class IntroIndicationDots extends StatelessWidget {
  const IntroIndicationDots({
    Key? key,
    required this.dotCount,
    required this.currentIndex,
    required this.animationCurve,
  }) : super(key: key);

  final int dotCount;
  final int currentIndex;
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int i = 0; i <= dotCount - 1; i++)
          if (i == currentIndex)
            AnimatedContainer(
              curve: animationCurve,
              duration: const Duration(milliseconds: 600),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              width: 25,
              height: 10,
            )
          else
            AnimatedContainer(
              curve: animationCurve,
              duration: const Duration(milliseconds: 600),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              width: 10,
              height: 10,
            ),
      ]),
    );
  }
}

class BuildNextSlideButton extends StatelessWidget {
  const BuildNextSlideButton(
      {Key? key, required this.gotoNextPage, required this.getStarted})
      : super(key: key);

  final Function() gotoNextPage;
  final bool getStarted;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white, width: 0.4),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Colors.deepOrange.shade600,
              Colors.deepOrange.shade600,
            ],
          ),
        ),
        child: FittedBox(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: 50,
            child: MaterialButton(
              splashColor: Colors.amber.shade800,
              highlightColor: Theme.of(context).primaryColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300),
              ),
              onPressed: getStarted
                  ? () => Navigator.of(context)
                      .pushNamed(UserRoleSelectionScreen.routeName)
                  : gotoNextPage,
              child: Text(
                getStarted ? 'GET STARTED' : 'NEXT',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
