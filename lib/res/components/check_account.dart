import 'package:flutter/material.dart';

import '../colors.dart';

class CheckAccountCompo extends StatelessWidget {
  final String accountDesc;
  final Function() onTap;
  final String buttonText;

  const CheckAccountCompo(
      {super.key,
      required this.accountDesc,
      required this.onTap,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(accountDesc),
        InkWell(
          onTap: onTap,
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: AppColors.defaultColor),
          ),
        ),
      ],
    );
  }
}
