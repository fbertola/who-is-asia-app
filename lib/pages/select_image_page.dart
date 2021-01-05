import 'dart:io';

import 'package:dog_breed/utils/sizing.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:dog_breed/models/image_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SelectImagePage extends StatelessWidget {
  static final style = TextStyle(
    fontSize: SizeConfig.textSP(115),
    fontFamily: "Billy",
    fontWeight: FontWeight.w600,
  );

  final picker = ImagePicker();
  final LiquidController liquidController;

  SelectImagePage({this.liquidController}) : super();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical * 22,
            ),
            Text('Let\'s see', style: SelectImagePage.style),
            RichText(
              text: TextSpan(
                text: 'What ',
                style: SelectImagePage.style,
                children: <TextSpan>[
                  TextSpan(
                      text: 'breed',
                      style: TextStyle(color: Colors.yellowAccent)),
                ],
              ),
            ),
            Text(
              'is your dog',
              style: SelectImagePage.style,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 13,
            ),
            Container(
              child: Column(
                children: [
                  RawMaterialButton(
                    onPressed: () async {
                      final image =
                          await picker.getImage(source: ImageSource.camera);

                      if (image != null) {
                        liquidController.animateToPage(page: 1, duration: 1000);
                        Provider.of<ImageModel>(context, listen: false)
                            .setImage(File(image.path));
                      }
                    },
                    elevation: 4.0,
                    fillColor: Colors.pinkAccent,
                    child: Container(
                      width: SizeConfig.safeBlockHorizontal * 65,
                      alignment: Alignment.center,
                      child: Text(
                        'Take a photo',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Billy",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 20, bottom: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      final image =
                          await picker.getImage(source: ImageSource.gallery);

                      if (image != null) {
                        liquidController.animateToPage(page: 1, duration: 1000);
                        Provider.of<ImageModel>(context, listen: false)
                            .setImage(File(image.path));
                      }
                    },
                    elevation: 4.0,
                    fillColor: Colors.pinkAccent,
                    child: Container(
                      width: SizeConfig.safeBlockHorizontal * 65,
                      alignment: Alignment.center,
                      child: Text(
                        'Import from Gallery',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Billy",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 20, bottom: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//2:54
