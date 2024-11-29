import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialIconButtonsRow extends StatelessWidget {
  const SocialIconButtonsRow({
    Key? key,
    required this.googleSignIn,
    required this.facebookSignIn,
  }) : super(key: key);

  final Function googleSignIn, facebookSignIn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(),
          const SizedBox(),
          SocialButtonWithShadow(
            icon: FontAwesomeIcons.facebookF,
            color: const Color(0xFF4267B2),
            onPressed: () => facebookSignIn(),
          ),
          SocialButtonWithShadow(
            icon: FontAwesomeIcons.twitter,
            color: const Color(0xFF1DA1F2),
            onPressed: () {},
          ),
          SocialButtonWithShadow(
            icon: FontAwesomeIcons.google,
            color: const Color(0xFFDB4437),
            onPressed: () => googleSignIn(),
          ),
          const SizedBox(),
          const SizedBox(),
        ],
      ),
    );
  }
}

class SocialButtonWithShadow extends StatelessWidget {
  const SocialButtonWithShadow(
      {Key? key, required this.icon, required this.color, this.onPressed})
      : super(key: key);

  final Color color;
  final IconData icon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          elevation: MaterialStateProperty.all(4),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
          backgroundColor: MaterialStateProperty.all(color),
          shadowColor: MaterialStateProperty.all(color),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
