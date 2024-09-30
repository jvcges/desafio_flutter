import 'package:desafio_flutter/core/Theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  const AppElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        maximumSize: const Size.fromHeight(56),
        minimumSize: const Size.fromHeight(56),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.1,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
