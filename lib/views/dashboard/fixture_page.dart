import 'package:carousel_slider/carousel_slider.dart';
import 'package:fantasypremiereleague/constant/styles.dart';
import 'package:fantasypremiereleague/controller/match_controller.dart';
import 'package:fantasypremiereleague/model/bootstrap_model.dart';
import 'package:fantasypremiereleague/model/fixture_model.dart';
import 'package:fantasypremiereleague/widgets/appbar.dart';
import 'package:fantasypremiereleague/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class FixturePage extends StatefulWidget {
  const FixturePage({super.key});

  @override
  State<FixturePage> createState() => _FixturePageState();
}

class _FixturePageState extends State<FixturePage> {
  //Controller
  final CarouselSliderController _carouselController = CarouselSliderController();
  final matchCon = Get.put(MatchController());
  int? previousDay;

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise()async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await matchCon.getBootstrapList();
      await matchCon.getMatchList();
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
                title: "Premiere League Fixtures"
              ),
              content: Obx(() =>
                matchCon.isLoading.isTrue 
                ? SizedBox(
                  height: 550.0.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: lightgreen,
                      backgroundColor: torquise,
                    ),
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCarousel(),
                      SizedBox(
                        height: 8.h,
                      ),
                      GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) {
                          if (details.primaryVelocity! > 0) {
                            if(
                              matchCon.currentGw != 1 ){
                                setState(() {
                                  matchCon.currentGw = matchCon.currentGw - 1;
                                });
                              _carouselController.previousPage(
                                curve: Curves.linearToEaseOut
                              );
                            }
                          } else if (details.primaryVelocity! < 0) {
                            if(
                              matchCon.currentGw != 38){
                              setState(() {
                                matchCon.currentGw = matchCon.currentGw + 1;
                              });
                              _carouselController.nextPage(
                                curve: Curves.linearToEaseOut
                              );
                            }
                          }
                        },
                        child: Column(
                          children: List.generate(
                            matchCon.matchLength,
                            (index) => _buildTeamContainer(matchCon.bootstrapList, matchCon.matchList.where((element) => element.event == 
                            matchCon.currentGw).toList(), index)
                          )
                        ),
                      ),
                      SizedBox(height: 70.0.h,)
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCarousel() {
    return Container(    
      height: 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        gradient: LinearGradient(
          colors: [dark.withOpacity(0.6),Colors.transparent, dark.withOpacity(0.6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.1,0.5,0.9]
        )
      ),
      child: CarouselSlider(
        items: List.generate(38, (index) => 
          Container(
            padding: EdgeInsets.fromLTRB(14.sp,12.sp,14.sp,8.sp),
            decoration: BoxDecoration(
              color: tileGrey,
              borderRadius: BorderRadius.circular(30.r),
              border: index +1 == 
              matchCon.currentGw 
                ? GradientBoxBorder(
                  gradient: const LinearGradient(colors: [torquise, primary]),
                  width: 1.8.sp
                )
                : Border.all(width: 0)
            ),
            child: Text("Gameweek ${index + 1}",style: interSemiBold(size: 15.sp, color: dark),)
          ),
        ), 
        carouselController: _carouselController,
        options: CarouselOptions(
          reverse: false,
          height: 50.h,
          viewportFraction: 0.4,
          enableInfiniteScroll: false,
          initialPage: matchCon.currentGw - 1,
          enlargeCenterPage: true, 
          onPageChanged: (index, reason) {
            setState(() {
              matchCon.currentGw = index+1;
            });
          },
        )
      ),
    );
  }

  Widget _buildTeamContainer(BootStrapModel firstdata, List<FixtureModel> seconddata, int index) {
    DateTime currentDate = seconddata[index].kickoffTime.toLocal();
    int currentDay = currentDate.day;
    bool showDate = previousDay == null || previousDay != currentDay;
    previousDay = currentDay;
    return Column(
      children: [
      if (showDate)
        Padding(
          padding: EdgeInsets.only(top: 10.0.h, bottom: 14.h),
          child: Text(
            DateFormat.MMMMEEEEd().format(currentDate),
            style: interSemiBold(size: 16.sp,color: dark),
          ),
        ),
        InkWell(
          onTap: seconddata[index].teamHScore == -1 && seconddata[index].teamAScore == -1
            ? (){}
            : () {
              showbottomsheet(firstdata, seconddata, index);
            },
          child: Container(
            margin: EdgeInsets.only(bottom: 7.h),
            padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 8.w),
            decoration: BoxDecoration(
              color: tileGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 154.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 100.w,
                        child: Text(firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamH).name.toString(), style: interSemiBold(size: 14.sp, color: dark), textAlign: TextAlign.end, overflow: TextOverflow.ellipsis, maxLines: 1,)),
                      SizedBox(
                        width: 10.w,
                      ),
                      Image.network("https://resources.premierleague.com/premierleague/badges/t${firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamH).code}.png",
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress==null ? child : const TeamImageShimmerWidget(),
                        errorBuilder: (context, error, stackTrace) => Image.asset("assets/logo.png",height: 80,width: 60,color: Colors.grey, colorBlendMode: BlendMode.darken,),
                        height: 30.h,
                        width: 30.h,
                      ),
                      SizedBox(width: 10.w,)
                    ],
                  ),
                ),
                seconddata[index].teamHScore == -1 && seconddata[index].teamAScore == -1
                ? SizedBox(
                  height: 30.h,
                  width: 59.w,
                  child: Center(
                    child: Text(DateFormat.jm().format(seconddata[index].kickoffTime.toLocal()),style: interMedium(size: 12.sp, color: dark), )
                  ),
                )
                : Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 224, 224, 224),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  height: 30.h,
                  width: 59.w,
                  child: Center(
                    child: Text("${seconddata[index].teamHScore} - ${seconddata[index].teamAScore}",style: interSemiBold(size: 16.sp, color: dark), )
                  ) 
                ),
                SizedBox(
                  width: 146.w,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Image.network("https://resources.premierleague.com/premierleague/badges/t${firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamA).code}.png",
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress==null ? child : const TeamImageShimmerWidget(),
                        errorBuilder: (context, error, stackTrace) => Image.asset("assets/logo.png",height: 80,width: 60,color: Colors.grey, colorBlendMode: BlendMode.darken,),
                        height: 30.h,
                        width: 30.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      SizedBox(
                        width: 96.w,
                        child: Text(firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamA).name.toString(), style: interSemiBold(size: 14.sp, color: dark), maxLines: 1, overflow: TextOverflow.ellipsis,)
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ],
    );
  }

  showbottomsheet(BootStrapModel firstdata, List<FixtureModel> seconddata, index) {
    showModalBottomSheet(
      context: context, 
      elevation: 5,
      isScrollControlled: true,
      useSafeArea: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      builder: (context) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              gradient: const LinearGradient(
                colors: [
                  purple,
                  purple3, 
                ],
              ),
            ),
            padding: EdgeInsets.symmetric(vertical : 15.h, horizontal: 10.w),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.sp),
                  width: 100.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20.r)
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: seconddata[index].stats.length,
                  itemBuilder: (context, statsindex) => Column(
                    children: [
                      seconddata[index].stats[statsindex].a.isNotEmpty || seconddata[index].stats[statsindex].h.isNotEmpty
                        ? Visibility(
                            visible: seconddata[index].stats[statsindex].identifier != "bps" && seconddata[index].stats[statsindex].identifier != "bonus",
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8.sp),
                              margin: EdgeInsets.only(top: 9.0.h,bottom: 5.0.h),
                              decoration: BoxDecoration(
                                color: white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.r)
                              ),
                              child: Text(seconddata[index].stats[statsindex].identifier.replaceAll(RegExp(r'_'), ' ').toUpperCase(), style: interSemiBold(size: 14.sp, color: tileGrey))
                            ),
                         )
                        : const SizedBox(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  seconddata[index].stats[statsindex].identifier == "bps" || seconddata[index].stats[statsindex].identifier == "bonus"
                                    ? 0
                                    : seconddata[index].stats[statsindex].h.length, (hindex) => 
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0.sp),
                                        child: Text("${firstdata.elements!.firstWhere((element) => element.id == seconddata[index].stats[statsindex].h[hindex].element).webName}${seconddata[index].stats[statsindex].h[hindex].value == 1 ? "" : "(${seconddata[index].stats[statsindex].h[hindex].value.toString()})"}", style: interRegular(size: 14.sp, color :bgGrey) ),
                                      )
                                )
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(
                                  seconddata[index].stats[statsindex].identifier == "bps" || seconddata[index].stats[statsindex].identifier == "bonus" 
                                    ? 0
                                    : seconddata[index].stats[statsindex].a.length , (aindex) => 
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0.sp),
                                        child: Text("${firstdata.elements!.firstWhere((element) => element.id==seconddata[index].stats[statsindex].a[aindex].element ).webName}${seconddata[index].stats[statsindex].a[aindex].value == 1 ? "" : "(${seconddata[index].stats[statsindex].a[aindex].value})"}", style: interRegular(size: 14.sp, color :bgGrey) ),
                                      )
                                )
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }, 
    );
  }
}