import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';

class ButtonCompo extends StatelessWidget {
  final Function() onPress;
  final String buttonName;
  final bool isLoading;

  const ButtonCompo(
      {super.key, required this.onPress, required this.buttonName, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      // width: MediaQuery.of(context).size.width / 4,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.defaultColor,
          ),
          onPressed: onPress,
          child: isLoading ?const CircularProgressIndicator(
            color: Colors.white,) : Text(buttonName,style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 16,
              color: AppColors.whiteColor
            )
          ),)),
    );
  }
}
