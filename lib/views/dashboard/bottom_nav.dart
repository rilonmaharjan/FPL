
import 'package:fantasypremiereleague/constant/styles.dart';
import 'package:fantasypremiereleague/views/dashboard/fantasy_page.dart';
import 'package:fantasypremiereleague/views/dashboard/fixture_page.dart';
import 'package:fantasypremiereleague/views/dashboard/web_view.dart';
import 'package:fantasypremiereleague/widgets/fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard extends StatefulWidget {
  final int index;
  const Dashboard({super.key, required this.index});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Duration animationDuration = const Duration(milliseconds: 250);

  List<Widget> pages = [
    const FixturePage(),
    const FantasyPage(),
    const WebViewWidget(),
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light
    ));

    // Bottom Nav Index
    selectedIndex = widget.index;

    _controller = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(int index) async{
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child : pages[selectedIndex],
                )
              ],
            ),
            //bottomnav bar
            bottomNav(context),
          ],
        ),
      ),
    );
  }

  bottomNav(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      from: 30,
      child : Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 75.0.h,
          child:  Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                height: 67.0.h,
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
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 5.0.w,),
                    buildNavItem(Icons.sports_soccer_outlined, 'Matches', 0, 93.0,),
                    buildNavItem(Icons.stadium, 'Fantasy', 1, 93.0),
                    buildNavItem(Icons.games_outlined, 'My Team', 2, 93.0),
                    SizedBox(width: 5.0.w,),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }


  buildNavItem(dynamic icon, String label, int index, double width) {
    return InkWell(
      onTap:  (){
        _handleTap(index);
      },
      child: SizedBox(
        width: width.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 28.0.w,
              height: 28.0.w,
              child: Center(
                child: Icon(icon, color: index == selectedIndex ? white : gray,)
              ),
            ),
            // Bottom Nav Icon Text
            Flexible(
              child: SizedBox(
                width: 76.w,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: interRegular(size: 10.sp, color: index == selectedIndex ? white : gray)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}