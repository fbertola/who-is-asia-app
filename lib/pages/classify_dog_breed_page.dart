import 'package:dog_breed/utils/sizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:dog_breed/models/image_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dog_breed/utils/animations.dart';
import 'package:dog_breed/utils/strings.dart';
import 'package:provider/provider.dart';

class ClassifyDogBreedPage extends StatefulWidget {
  static final style = TextStyle(
    fontSize: SizeConfig.textSP(90),
    color: Colors.black,
    fontFamily: "Billy",
    fontWeight: FontWeight.w600,
  );

  final picker = ImagePicker();
  final LiquidController liquidController;

  ClassifyDogBreedPage({this.liquidController}) : super();

  @override
  _ClassifyDogBreedPageState createState() => _ClassifyDogBreedPageState();
}

class _ClassifyDogBreedPageState extends State<ClassifyDogBreedPage> {
  final backgroundImage = SvgPicture.asset(
    "assets/image_background.svg",
    fit: BoxFit.fill,
    // alignment: Alignment.topLeft,
  );

  createResultWidget(Future<List> futureResults) {
    return FutureBuilder<List>(
        future: futureResults,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          List<Widget> children = <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Let\'s see ',
                  style: ClassifyDogBreedPage.style,
                ),
                JumpingDotsProgressIndicator(
                  numberOfDots: 3,
                  dotSpacing: 5,
                  textStyle: ClassifyDogBreedPage.style,
                )
              ],
            ),
          ];

          if (snapshot.hasData) {
            print(snapshot.data);
            if (snapshot.data.length == 0) {
              children = <Widget>[
                Text(
                  'I don\'t think this is a dog...',
                  style: ClassifyDogBreedPage.style,
                ),
              ];
            } else {
              children = <Widget>[
                Text(
                  'possible breed(s):',
                  style: TextStyle(
                      fontSize: SizeConfig.textSP(70),
                      fontFamily: ClassifyDogBreedPage.style.fontFamily,
                      color: ClassifyDogBreedPage.style.color),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 3,
                ),
              ];
              for (var i = 0; i < snapshot.data.length; i++) {
                children.add(
                  FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        '* ${cleanClassificationLabel(snapshot.data[i]['label'])} *',
                        style: ClassifyDogBreedPage.style,
                      )),
                );
              }
            }
          }

          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Center(
                key: Key(snapshot.hasData ? "new" : "old"),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              ));
        });
  }

  createClassifierWidget() {
    return Consumer<ImageModel>(
      builder: (context, imageModel, child) => Stack(
        children: [
          Positioned.fill(
            bottom: SizeConfig.safeBlockVertical * 41,
            child: Container(
              color: Colors.pinkAccent,
            ),
          ),
          Positioned.fill(
            top: SizeConfig.safeBlockVertical * 60,
            child: backgroundImage,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 10,
                        ),
                        Container(
                            height: SizeConfig.safeBlockVertical * 30,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 7, color: Colors.black),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(imageModel.getImage()),
                            )),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 5,
                        ),
                        createResultWidget(imageModel.getResults()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
                alignment: Alignment.bottomCenter,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  RawMaterialButton(
                    onPressed: () {
                      widget.liquidController
                          .animateToPage(page: 0, duration: 600);
                    },
                    elevation: 4.0,
                    fillColor: Colors.pinkAccent,
                    child: Icon(
                      Icons.refresh_sharp,
                      size: 35.0,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ])),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: createClassifierWidget(),
    );
  }
}

//2:54
