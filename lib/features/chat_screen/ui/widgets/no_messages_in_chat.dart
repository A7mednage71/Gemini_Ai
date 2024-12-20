import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini_ai/core/helpers/app_assets.dart';
import 'package:lottie/lottie.dart';

class NoChatMessages extends StatelessWidget {
  const NoChatMessages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            AppAssets.geminiLottie,
            width: 250.w,
            height: 250.h,
          ),
          Text(
            "Let's get started !",
            style: TextStyle(fontSize: 20.sp),
          ),
        ],
      ),
    );
  }
}
