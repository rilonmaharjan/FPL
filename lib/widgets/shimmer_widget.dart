import 'package:fantasypremiereleague/constant/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: gray,
                  highlightColor: gray1,
                  period: const Duration(milliseconds: 1000),
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: primary,
                  )
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: gray,
                      highlightColor: gray1,
                      period: const Duration(milliseconds: 1000),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        height: 25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primary,
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: gray,
                      highlightColor: gray1,
                      period: const Duration(milliseconds: 1000),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        height: 18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primary,
                        ),
                      ),
                    ),
                  ],
                ) 
              )
            ],
          );
        },
      ),
    );
  }
}
class TableShimmerWidget extends StatelessWidget {
  const TableShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: gray,
            highlightColor: gray1,
            period: const Duration(milliseconds: 1000),
            child: Container(
              height: 100,
              margin: const EdgeInsets.all(20),
            ),
          );
        },
      ),
    );
  }
}

class ImageShimmerWidget extends StatelessWidget {
  const ImageShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: gray,
      highlightColor: gray1,
      period: const Duration(milliseconds: 1000),
      child: SizedBox(
        height: 65.h,
        width: 40.w,
        child: Image.asset("assets/images/dummy.png"),
      ),
    );
  }
}
class TeamImageShimmerWidget extends StatelessWidget {
  const TeamImageShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: gray,
      highlightColor: gray1,
      period: const Duration(milliseconds: 1000),
      child: SizedBox(
        height: 30,
        width: 30,
        child: Image.asset("assets/images/team.png"),
      ),
    );
  }
}

class PointTabShimmerWidget extends StatelessWidget {
  const PointTabShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPlayerContainer(),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: List.generate(4, (index) => _buildPlayerContainer()),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: List.generate(4, (index) => _buildPlayerContainer()),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: List.generate(2, (index) => _buildPlayerContainer()),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const SizedBox(width: 10,),
            _buildPlayerContainer(),
            const Spacer(),
            Wrap(
              children: List.generate(3, (index) => 
                _buildPlayerContainer()
              ),
            ),
            const SizedBox(width: 10,),
          ],
        )
      ],
    );
  }

  _buildPlayerContainer() {
    return Shimmer.fromColors(
      baseColor: gray,
      highlightColor: gray1,
      period: const Duration(milliseconds: 1000),
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          children: [
            Image.asset(
              "assets/images/dummy.png",
              errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/logo.png",height: 80,width: 60,color: Colors.grey, colorBlendMode: BlendMode.darken,),
              height: 80,
              width: 60,
            ),
            Container(
              width: 70,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                color: Colors.grey.shade500,
              ),
              child:Center(child: Text("Player",style: interMedium(size: 12.sp,color: dark),maxLines: 1, overflow: TextOverflow.ellipsis, )),
            ),
            Container(
              width: 70,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
                color: Colors.grey.shade600,
              ),          
              child:Center(child: Text("0",style: interMedium(size: 12.sp,color: dark),)),
            ),
          ],
        ),
      )
    );
  }
}

class FixtureShimmerWidget extends StatelessWidget {
  const FixtureShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: gray,
            highlightColor: gray1,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}