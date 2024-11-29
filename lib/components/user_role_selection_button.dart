import 'package:flutter/material.dart';

class UserRoleSelectionButton extends StatelessWidget {
  final String buttonName;

  final String icon;
  final Function()? onPressed;
  final bool isSelected;

  const UserRoleSelectionButton({
    Key? key,
    required this.buttonName,
    required this.icon,
    required this.isSelected,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 12,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(icon),
              fit: BoxFit.cover,
              opacity: isSelected ? 0.8 : 0.1,
              colorFilter: isSelected
                  ? const ColorFilter.mode(
                      Colors.black38,
                      BlendMode.darken,
                    )
                  : null,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: isSelected ? 2 : 0.2,
            ),
            boxShadow: !isSelected
                ? null
                : [
                    BoxShadow(
                      offset: const Offset(6, 6),
                      color: (!isSelected)
                          ? Colors.grey
                          : Theme.of(context).primaryColor.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    )
                  ]),
        child: RawMaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: onPressed,
          splashColor: Theme.of(context).primaryColor.withAlpha(60),
          elevation: 5,
          highlightElevation: 0,
          child: Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: !isSelected
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  buttonName,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
