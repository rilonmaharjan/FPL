import 'package:fantasypremiereleague/constant/styles.dart';
import 'package:fantasypremiereleague/controller/fantasy_controller.dart';
import 'package:fantasypremiereleague/controller/match_controller.dart';
import 'package:fantasypremiereleague/model/bootstrap_model.dart';
import 'package:fantasypremiereleague/model/league_model.dart';
import 'package:fantasypremiereleague/widgets/appbar.dart';
import 'package:fantasypremiereleague/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class PointsPage extends StatefulWidget {
  final int teamId, gw;
  final String teamName;
  final Result result;
  const PointsPage({super.key, required this.teamId, required this.gw, required this.result, required this.teamName});

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  //Controller
  final fantasyCon = Get.put(FantasyController());
  final matchCon = Get.put(MatchController());

  List<Elements> allplayers = [];
  List<Elements> goalkeepers = [];
  List<Elements> defenders = [];
  List<Elements> midfielders = [];
  List<Elements> forwards = [];
  List<Elements> bench = [];
  List<int> livePoints = [];
  int captain = 0;
  int vicecaptain = 0;
  List playercode = [];
  
  @override
  void initState() {
    initialise();
    super.initState();
  }

  void initialise() async{
     WidgetsBinding.instance.addPostFrameCallback((_) async{
      await fantasyCon.fetchTeamPicks(widget.teamId, widget.gw);
      await fantasyCon.fetchTransfer(widget.teamId);
      await fantasyCon.fetchHistory(widget.teamId);
      await fantasyCon.fetchLive(widget.gw);
      await set();
    });
  }

  set(){
    setState(() {
      fantasyCon.isLoading.value = true;
    });
    goalkeepers.clear();
    defenders.clear();
    midfielders.clear();
    forwards.clear();
    bench.clear();
    allplayers.clear();
    for(int i = 0 ; i < matchCon.bootstrapList.elements!.length ; i ++){
      for(int j = 0 ; j < fantasyCon.pickList.picks.length; j ++){
        playercode.add(matchCon.bootstrapList.elements!.where((element) => element.id==fantasyCon.pickList.picks[j].element).map((e) => "${e.teamCode}").join(", "));
        if(matchCon.bootstrapList.elements![i].id == fantasyCon.pickList.picks[j].element){
          allplayers.add(matchCon.bootstrapList.elements![i]);
        }
        if(matchCon.bootstrapList.elements![i].elementType==1 && matchCon.bootstrapList.elements![i].id == fantasyCon.pickList.picks[j].element){
          goalkeepers.add(matchCon.bootstrapList.elements![i]);
        }
        if(matchCon.bootstrapList.elements![i].elementType==2 && matchCon.bootstrapList.elements![i].id == fantasyCon.pickList.picks[j].element){
          defenders.add(matchCon.bootstrapList.elements![i]);
        }
        if(matchCon.bootstrapList.elements![i].elementType==3 && matchCon.bootstrapList.elements![i].id == fantasyCon.pickList.picks[j].element){
          midfielders.add(matchCon.bootstrapList.elements![i]);
        }
        if(matchCon.bootstrapList.elements![i].elementType==4 && matchCon.bootstrapList.elements![i].id == fantasyCon.pickList.picks[j].element){
          forwards.add(matchCon.bootstrapList.elements![i]);
        }
        if(fantasyCon.pickList.picks[j].isCaptain){
          captain = fantasyCon.pickList.picks[j].element;
        }
        if(fantasyCon.pickList.picks[j].isViceCaptain){
          vicecaptain = fantasyCon.pickList.picks[j].element;
        }
      }
    }
    for (int j = 0; j < fantasyCon.pickList.picks.length; j++) {
      if (j != 11 && j != 12 && j != 13 && j != 14) {
        bench.addAll(
          matchCon.bootstrapList.elements!
            .where((element) => element.id == fantasyCon.pickList.picks[j].element)
        );
      }
    }
    setState(() {
      fantasyCon.isLoading.value = false;
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
                marginBottom: 5.sp,
                // radius: 0,
                title: widget.teamName,
                showback: true
              ), 
              content: Obx(() =>
                fantasyCon.isLoading.isTrue || matchCon.isLoading.isTrue
                  ? SizedBox(
                    height: 690.0.h,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: lightgreen,
                        backgroundColor: torquise,
                      ),
                    ),
                  )
                  : allplayers.isEmpty ||
                    goalkeepers.isEmpty ||
                    defenders.isEmpty ||
                    midfielders.isEmpty ||
                    forwards.isEmpty
                  ? SizedBox(
                    height: 690.0.h,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: lightgreen,
                        backgroundColor: torquise,
                      ),
                    ),
                  )
                  : Column(
                    children: [
                      SizedBox(
                        height: 690.0.h,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20.0.h),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.r),
                                child: Image.asset(
                                  "assets/images/stadium.jpg",
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            //players
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: double.infinity,
                                height: 540.h,
                                padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 14.w),
                                child: Column(
                                  children: [
                                    SizedBox(height: 35.0.h,),
                                    //goalkeeper
                                    _buildPlayerContainer(
                                      goalkeepers.firstWhere((element) => element.id == fantasyCon.pickList.picks[0].element ).code, 
                                      goalkeepers.firstWhere((element) => element.id == fantasyCon.pickList.picks[0].element ).webName, 
                                      // islivedata ?
                                      fantasyCon.liveList.elements.firstWhere((element) => element.id == fantasyCon.pickList.picks[0].element).stats.totalPoints.toString(),
                                      //   : goalkeepers.firstWhere((element) => element.id == fantasyCon.pickList.picks[0].element ).eventPoints,
                                      goalkeepers.firstWhere((element) => element.id == fantasyCon.pickList.picks[0].element ).id!.toInt() 
                                    ),
                                    //defenders
                                    SizedBox(height: 10.0.h,),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      children: List.generate(defenders.length , (index) => 
                                        Visibility(
                                          visible: bench.contains(defenders[index]),
                                          child: _buildPlayerContainer(
                                            defenders[index].code, defenders[index].webName, 
                                            // islivedata ?
                                            fantasyCon.liveList.elements.firstWhere((element) => element.id == defenders[index].id).stats.totalPoints.toString(),
                                            // : defenders[index].eventPoints,
                                            defenders[index].id!.toInt()
                                          ) 
                                        )
                                      )
                                    ),
                                    //Mids
                                    SizedBox(height: 13.0.h,),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      children: List.generate(midfielders.length , (index) =>
                                        Visibility(
                                          visible: bench.contains(midfielders[index]),
                                          child: _buildPlayerContainer(
                                            midfielders[index].code, midfielders[index].webName, 
                                            // islivedata ?
                                            fantasyCon.liveList.elements.firstWhere((element) => element.id == midfielders[index].id).stats.totalPoints.toString(),
                                            //   : midfielders[index].eventPoints,
                                            midfielders[index].id!.toInt()
                                          ),
                                        )
                                      ),
                                    ),
                                    SizedBox(height: 16.0.h,),
                                    //Forwards
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      children: List.generate(forwards.length , (index) => 
                                        Visibility(
                                          visible: bench.contains(forwards[index]),
                                          child: _buildPlayerContainer(
                                            forwards[index].code, forwards[index].webName, 
                                            // islivedata ?
                                            fantasyCon.liveList.elements.firstWhere((element) => element.id == forwards[index].id).stats.totalPoints.toString(),
                                            //   : forwards[index].eventPoints,
                                            forwards[index].id!.toInt()
                                          )
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //points and transfer
                            Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(width: 2.w,),
                                  Container(
                                    height: 40.0.h,
                                    width: 140.w,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [purple,purple3],
                                      ),
                                      borderRadius: BorderRadius.circular(30.r),
                                      border: Border.all(width: 0.5, color: dark)
                                    ),
                                    child: Center(child: Text("Points : ${fantasyCon.pickList.entryHistory['event_transfers']!.toInt() > 1 ? "${widget.result.eventTotal-fantasyCon.pickList.entryHistory['event_transfers_cost']!.toInt()}" : widget.result.eventTotal.toString()}", style: interSemiBold(size: 16.sp, color: bgGrey),)),
                                  ),
                                  Container(
                                    height: 40.0.h,
                                    width: 140.w,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [purple,purple3],
                                      ),
                                      borderRadius: BorderRadius.circular(30.r),
                                      border: Border.all(width: 0.5, color: dark)
                                    ),
                                    child: Center(child: Text("Transfers : ${fantasyCon.pickList.entryHistory['event_transfers']}${fantasyCon.pickList.entryHistory['event_transfers']!.toInt() > 1 ? "(-${fantasyCon.pickList.entryHistory['event_transfers_cost']} pts)" : "" }", style: interSemiBold(size: 16.sp, color: bgGrey),)),
                                  ),
                                  SizedBox(width: 2.w,),
                                ],
                              ),
                            ),
                            //benchplayers
                            Container(
                              height: 140.0.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: white.withOpacity(.3),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30.r),
                                  bottomRight: Radius.circular(30.r)
                                )
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 10.w,),
                                  Wrap(
                                    children: [
                                      _buildPlayerContainer(
                                        goalkeepers.firstWhere((element) => element.id == fantasyCon.pickList.picks[11].element).code, 
                                        goalkeepers.firstWhere((element) => element.id == fantasyCon.pickList.picks[11].element).webName, 
                                        // islivedata ?
                                        fantasyCon.liveList.elements.firstWhere((element) => element.id == fantasyCon.pickList.picks[11].element).stats.totalPoints.toString(),
                                        //   : goalkeepers.firstWhere((element) => element.id == fantasyCon.pickList.picks[11].element).eventPoints,
                                        goalkeepers.firstWhere((element) => element.id == fantasyCon.pickList.picks[11].element).id!.toInt()
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Wrap(
                                    children: List.generate(4, (index) => 
                                      _buildPlayerContainer(
                                        matchCon.bootstrapList.elements!.firstWhere((element) => element.id == fantasyCon.pickList.picks[index==0? 12 : index==1? 13 : 14].element).code, 
                                        matchCon.bootstrapList.elements!.firstWhere((element) => element.id == fantasyCon.pickList.picks[index==0? 12 : index==1? 13 : 14].element).webName,
                                        // islivedata ?
                                        fantasyCon.liveList.elements.firstWhere((element) => element.id == fantasyCon.pickList.picks[index==0? 12 : index==1? 13 : 14].element).stats.totalPoints.toString(),
                                        //   : matchCon.bootstrapList.elements!.firstWhere((element) => element.id == fantasyCon.pickList.picks[index==0? 12 : index==1? 13 : 14].element).eventPoints,
                                        matchCon.bootstrapList.elements!.firstWhere((element) => element.id == fantasyCon.pickList.picks[index==0? 12 : index==1? 13 : 14].element).id!.toInt(),
                                      )
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 700.h,
                      )
                    ],
                  ),
              )
            )
          ],
        ),
      ),
    );
  }

  _buildPlayerContainer(imgCode, name, points, int elementId) {
    return GestureDetector(
      onTap: () {
        // showbottomsheet(elementId);
      },
      child: SizedBox(
        width: 68.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topLeft,
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Image.network(
                    "https://resources.premierleague.com/premierleague/photos/players/110x140/p$imgCode.png",
                    loadingBuilder: (context, child, loadingProgress) => loadingProgress==null ? child : const ImageShimmerWidget(),
                    errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/pl.png",height: 65.0.h,width: 40.w,),
                    height: 65.0.h,
                    width: 40.w,
                  ),
                  SizedBox(height: 2.0.h,),
                  Container(
                    width: 70.w,
                    padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                      color: Color.fromARGB(255, 128, 128, 128),
                    ),
                    child:Center(child: Text("$name",style: interMedium(size: 10.sp, color: white),maxLines: 1, overflow: TextOverflow.ellipsis, )),
                  ),
                  Container(
                    width: 70,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
                      color: Color.fromARGB(255, 212, 212, 212),
                    ),          
                    child:Center(child: Text("${elementId == captain ? int.parse(points.toString()) *2 : points.toString()}",style: interSemiBold(size: 12.sp, color: dark),)),
                  ),
                ],
              ),
            ),
            elementId == captain || elementId == vicecaptain
              ? Positioned(
                top: 10,
                left: 3,
                child: CircleAvatar(
                  backgroundColor: white,
                  radius: 11,
                  child: Center(child: Text(elementId == captain ? "C" : "V", style: interSemiBold(size: 12.5,color: dark),)),
                ),
              )
              : Container()
          ],
        ),
      ),
    );
  }
}