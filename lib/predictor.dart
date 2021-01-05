import 'dart:math';

import 'package:dog_breed/utils/sizing.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:dog_breed/pages/classify_dog_breed_page.dart';
import 'package:dog_breed/pages/select_image_page.dart';
import 'package:provider/provider.dart';

import 'models/image_model.dart';

class Predictor extends StatefulWidget {
  static final style = TextStyle(
    fontSize: SizeConfig.textSP(80),
    fontFamily: "Billy",
    fontWeight: FontWeight.w600,
  );

  @override
  _PredictorState createState() => _PredictorState();
}

class _PredictorState extends State<Predictor> {
  int page = 0;
  LiquidController liquidController;
  UpdateType updateType;
  List<Widget> pages = <Widget>[];

  @override
  void initState() {
    liquidController = LiquidController();
    pages = [SelectImagePage(
      liquidController: liquidController,
    ),
      ClassifyDogBreedPage(
        liquidController: liquidController,
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);

    return ChangeNotifierProvider<ImageModel>(
      create: (context) => ImageModel(),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            LiquidSwipe(
              pages: pages,
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true,
              disableUserGesture: true,
            ),
          ],
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}
//2:54
