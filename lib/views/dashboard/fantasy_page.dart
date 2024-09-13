import 'package:fantasypremiereleague/constant/styles.dart';
import 'package:fantasypremiereleague/controller/fantasy_controller.dart';
import 'package:fantasypremiereleague/controller/match_controller.dart';
import 'package:fantasypremiereleague/views/pickteam/points_page.dart';
import 'package:fantasypremiereleague/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class FantasyPage extends StatefulWidget {
  const FantasyPage({super.key});

  @override
  State<FantasyPage> createState() => _FantasyPageState();
}

class _FantasyPageState extends State<FantasyPage> {
  //Controller
  final fantasyCon = Get.put(FantasyController());
  final matchCon = Get.put(MatchController());

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise()async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await fantasyCon.getManagersList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StickyHeader(
              header: appBar(
                title: "Fantasy Premiere League"
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tableHeader(),
                    playersList(),
                    SizedBox(height: 70.0.h,)
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
  
  Widget tableHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 7.0.h),
      padding: EdgeInsets.symmetric(vertical: 7.h),
      color: tileGrey,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.w),
            width: 50.w,
            child: Center(child: Text("SN", style: interSemiBold(size: 15.sp, color: dark),)),
          ),
          SizedBox(
            width: 160.w,
            child: Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: Text("FPL Managers", style: interSemiBold(size: 15.sp, color: dark),),
            ),
          ),
          SizedBox(
            width: 72.w,
            child: Center(child: Text("Week\nPoints", style: interSemiBold(size: 15.sp, color: dark),)),
          ),
          SizedBox(
            width: 92.w,
            child: Center(child: Text("Total\nPoints", style: interSemiBold(size: 15.sp, color: dark),)),
          ),
        ],
      ),
    );
  }
  
  Widget playersList() {
    return Obx(() =>
      fantasyCon.isLoading.isTrue || matchCon.isLoading.isTrue
        ? SizedBox(
          height: 500.0.h,
          child: const Center(
            child: CircularProgressIndicator(
              color: lightgreen,
              backgroundColor: torquise,
            ),
          ),
        )
        : ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fantasyCon.managersList.length,
          shrinkWrap: true,
          itemBuilder: (context,index){
            return InkWell(
              onTap: (){
                Get.to(() => PointsPage(
                  teamId: fantasyCon.managersList[index].entry, 
                  gw: matchCon.currentGw-1, 
                  result: fantasyCon.managersList[index], 
                  teamName: fantasyCon.managersList[index].entryName.toString())
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 7.0.h),
                padding: EdgeInsets.symmetric(vertical: 7.h),
                color: tileGrey,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10.w),
                      width: 50.w,
                      child: Center(
                        child: Container(
                          height: 22.w,
                          width: 22.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                              colors: [
                                torquise,
                                lightgreen
                              ],
                              begin: Alignment.centerLeft,
                              end:  Alignment.centerRight,
                              stops: [0.3, 0.7]
                            )
                          ),
                          child: Center(child: Text(fantasyCon.managersList[index].rank.toString(), style: interMedium(size: 12.sp, color: dark),)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160.w,
                      child: Padding(
                        padding: EdgeInsets.only( left: 25.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fantasyCon.managersList[index].entryName.toString(), style: interMedium(size: 14.sp, color: dark), maxLines: 5, overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 2.h,),
                            Text(fantasyCon.managersList[index].playerName.toString(), style: interRegular(size: 12.sp, color: gray), maxLines: 5, overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 72.w,
                      child: Center(child: Text(fantasyCon.managersList[index].eventTotal.toString(), style: interMedium(size: 14.sp, color: dark),)),
                    ),
                    SizedBox(
                      width: 92.w,
                      child: Center(child: Text(fantasyCon.managersList[index].total.toString(), style: interMedium(size: 14.sp, color: dark),)),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
    );
  }
}