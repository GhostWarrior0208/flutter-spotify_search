import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spotify_search/shared/theme/app_colors.dart';

class AppCategoryButton extends StatelessWidget {
  const AppCategoryButton({
    required this.text,
    this.actived = false,
    this.onPressed,
    super.key,
  });

  final String text;
  final bool actived;
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        side: actived ? MaterialStateProperty.all<BorderSide>(
              const BorderSide(color: AppColors.lightGreen),
            )
            : MaterialStateProperty.all<BorderSide>(
              const BorderSide(color: AppColors.lightGrey),
            ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: actived ? MaterialStateProperty.all<Color>(AppColors.green) : MaterialStateProperty.all<Color>(Colors.black),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
            ),
      ),
    );
  }
}
