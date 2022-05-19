import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/halo_image/halo_image.dart';
import 'package:futgolazo/src/components/widget/text_stroke.dart';
import 'package:futgolazo/src/pages/onboarding_page/models/OnboardingData.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class InitInfoScreen extends StateLessCustom {
  InitInfoScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/gold_frame.png"),
              fit: BoxFit.contain,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(26)),
                child: Text(
                  "Juega,",
                  textAlign: TextAlign.center,
                  style: fontSize.headline4(
                    color: colorsTheme.getColorOnButton,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(26)),
                child: Text(
                  "Pronostica",
                  textAlign: TextAlign.center,
                  style: fontSize.headline4(
                    color: colorsTheme.getColorOnButton,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(26)),
                child: Text(
                  "y  Gana",
                  textAlign: TextAlign.center,
                  style: fontSize.headline4(
                    color: colorsTheme.getColorOnButton,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class BallScreen extends StateLessCustom {
  BallScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String centerText = "Decide cuánto quieres invertir";
    double positionBallx = 6.5;
    return ClipRect(
      child: Container(
          child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(positionBallx, -1.1),
            child: this.showfirstball(),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(20)),
              child: Text(
                centerText,
                textAlign: TextAlign.center,
                style: fontSize.headline4(
                  color: colorsTheme.getColorOnButton,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(-1 * positionBallx, 1.3),
            child: this.showSecondbal(),
          ),
        ],
      )),
    );
  }

  Widget showfirstball() {
    String pathimage = "assets/onboarding/MonedaOro_Onboarding.png",
        textcontent = "Balones de oro";
    double percentH = 30, percentW = 61, textposition = -30;
    return showHaloImage(
      pathimage,
      textcontent,
      percentH,
      percentW,
      textposition,
    );
  }

  Widget showSecondbal() {
    String pathimage = "assets/onboarding/MonedaDiamante_Onboarding.png",
        textcontent = "Balones de diamante";
    double percentH = 30, percentW = 61, textposition = 30;
    return showHaloImage(
      pathimage,
      textcontent,
      percentH,
      percentW,
      textposition,
    );
  }

  Widget showHaloImage(String pathimage, String textcontent, double percentH,
      double percentW, double textposition) {
    return Container(
      height: super.responsive.hp(percentH + 30),
      width: super.responsive.wp(percentW + 30),
      child: Stack(
        children: <Widget>[
          OverflowBox(
            maxWidth: super.responsive.wp(80),
            child: HaloImage(),
          ),
          Center(
            child: showBallImage(pathimage, percentH, percentW),
          ),
          Transform.translate(
            offset: Offset(super.responsive.wp(textposition), 0),
            child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(25)),
                child: TextStroke(
                  textcontent.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: super.fontSize.headline5(),
                )),
          ),
        ],
      ),
    );
  }

  Widget showBallImage(String pathImage, double percentH, double percentW) {
    return Container(
      width: super.responsive.wp(percentW),
      height: super.responsive.hp(percentH),
      child: Image.asset(
        pathImage,
        fit: BoxFit.contain,
      ),
    );
  }
}

class PetScreen extends StateLessCustom {
  PetScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String centerText = "¡Demuestra tus conocimientos de fútbol!";
    return ClipRect(
      child: Container(
          child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(-3.1, -2.4),
            child: this.showfirstPet(),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(17)),
              child: Text(
                centerText,
                textAlign: TextAlign.center,
                style: fontSize.headline4(
                  color: colorsTheme.getColorOnButton,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(2.0, 2.8),
            child: this.showSecondPet(),
          ),
        ],
      )),
    );
  }

  Widget showfirstPet() {
    String pathimage =
        "assets/onboarding/MascotaBarcelonaEspaña_Onboarding.png";
    double percent = 70, rotate = math.pi / 4;
    return showRotateImage(pathimage, percent, rotate);
  }

  Widget showSecondPet() {
    String pathimage = "assets/onboarding/MascotaRealMadrid_Onboarding.png";
    double percent = 70, rotate = 0;
    return showRotateImage(pathimage, percent, rotate);
  }

  Widget showRotateImage(String pathimage, double percent, double rotate) {
    return Container(
      height: super.responsive.hp(percent),
      width: super.responsive.wp(percent),
      child: Stack(
        children: <Widget>[
          showRotateBox(pathimage, rotate),
        ],
      ),
    );
  }

  Widget showRotateBox(String pathImage, double rotate) {
    return Transform.rotate(
      angle: rotate,
      child: Center(
        child: showImage(pathImage),
      ),
    );
  }

  Widget showImage(String pathImage) {
    return Image.asset(
      pathImage,
      fit: BoxFit.contain,
    );
  }
}

class PetCollageScreen extends StateLessCustom {
  PetCollageScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String titleText = "¿Preparado?";
    String contentText = "Escoge tu equipo favorito";
    return ClipRect(
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              children: showListCard(),
            ),
            Container(
              child: showCenterText(contentText, titleText),
            ),
          ],
        ),
      ),
    );
  }

  Widget showCenterText(String contenText, String titleText) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(10)),
      child: Stack(
        children: [
          Container(
            alignment: Alignment(0, -0.20),
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(7)),
            child: TextStroke(
              titleText,
              textAlign: TextAlign.center,
              style: super.fontSize.headline3(),
            ),
          ),
          Container(
            alignment: Alignment(0, -0.05),
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(7)),
            child: Text(
              contenText,
              textAlign: TextAlign.center,
              style: fontSize.headline5(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> showListCard() {
    List<String> petImageList = OnboardingData.getUrlPetCard();
    List<AlignmentGeometry> alignPetList = OnboardingData.getAlignPetcard();
    int index = 0;
    List<Widget> listcard = new List<Widget>();
    petImageList.forEach((element) {
      listcard.add(
        this.showAvatarCard(element, alignPetList[index]),
      );

      index++;
    });
    return listcard;
  }

  Widget showAvatarCard(String pathImage, AlignmentGeometry alignvalue) {
    return Align(
        alignment: alignvalue,
        child: Container(
          width: super.responsive.wp(48.26), //
          height: super.responsive.hp(24.62),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(pathImage),
              fit: BoxFit.contain,
            ),
          ),
        ));
  }
}
