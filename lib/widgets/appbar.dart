import 'package:fantasypremiereleague/constant/styles.dart';
import 'package:fantasypremiereleague/widgets/fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget appBar({String? title,bool? showback,Widget? action}){
  return FadeInUp(
    duration: const Duration(milliseconds: 800),
    from: -30,
    child: Container(
      height: 110.h,
      margin: EdgeInsets.only(bottom: 15.h),
      width: double.infinity,
      padding: EdgeInsets.only(bottom:4.0.sp),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            purple,
            purple3, 
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        )
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 5.h),
        child: Row(
          children: [
            Visibility(
              visible: showback == true,
              child: GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios, color: white,)
              ),
            ),
            SizedBox(width: 15.w,),
            Text(title ?? "", style: interSemiBold(size: 17.sp, color: white),),
            const Spacer(),
            action ?? const SizedBox()
          ],
        ),
      ),
    ),
  );
}