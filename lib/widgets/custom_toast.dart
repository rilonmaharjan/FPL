import 'package:fantasypremiereleague/constant/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

showToast({message, bool? isSuccess, bool? isEn}) {
  return Get.snackbar(
    "",
    "",
    colorText: Get.isDarkMode ? Colors.white : Colors.black,
    backgroundColor: const Color.fromARGB(255, 255, 250, 250),
    borderColor: isSuccess == true ? const Color(0xff266CD4) : red,
    borderWidth: 1,
    margin: EdgeInsets.symmetric(horizontal : 16.sp, vertical: 6.sp),
    duration: const Duration(seconds: 3),
    messageText: const SizedBox.shrink(),
    titleText: Padding(
      padding: EdgeInsets.only(top: 1.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Icon(isSuccess == true ? Icons.check_circle : Icons.info, color: const Color(0xff070F26),)),
          SizedBox(width: 8.w,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: isEn == true ?  4.sp : 1.5.sp),
              child: Text(
                message.toString(),
                style: interRegular(size: 13.sp, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

showErrorToast ({message}) {
  return Get.snackbar(
    "",
    "",
    colorText: Get.isDarkMode ? Colors.white : Colors.black,
    duration: const Duration(seconds: 3),
    margin: EdgeInsets.symmetric(horizontal : 16.sp, vertical: 6.sp),
    messageText: const SizedBox.shrink(),
    titleText: Padding(
      padding: EdgeInsets.only(top: 1.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Icon(Icons.info, color: Colors.red,)),
          SizedBox(width: 6.w,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                message.toString(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}