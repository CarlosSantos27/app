import 'package:flutter/cupertino.dart';

class OnboardingData {
  static List<String> getUrlPetCard() {
    List<String> petImageList = new List<String>();
    petImageList.add("assets/onboarding/Mascota_Ecu_Onboard4.png");
    petImageList.add("assets/onboarding/Mascota_Col_Onboard2.png");
    petImageList.add("assets/onboarding/Mascota_Eur_Onboard4.png");
    petImageList.add("assets/onboarding/Mascota_Eur_Onboard1.png");

    petImageList.add("assets/onboarding/Mascota_Ecu_Onboard3.png");
    petImageList.add("assets/onboarding/Mascota_Ecu_Onboard1.png");
    petImageList.add("assets/onboarding/Mascota_Per_Onboard2.png");
    petImageList.add("assets/onboarding/Mascota_Eur_Onboard2.png");
    petImageList.add("assets/onboarding/Mascota_Eur_Onboard4.png");
    petImageList.add("assets/onboarding/Mascota_Ecu_Onboard2.png");
    return petImageList;
  }

  static List<AlignmentGeometry> getAlignPetcard() {
    List<AlignmentGeometry> alignPetList = List<AlignmentGeometry>();

    alignPetList.add(Alignment(-1.7, -0.98));
    alignPetList.add(Alignment(-0.1, -1.1));
    alignPetList.add(Alignment(1.5, -1.5));
    alignPetList.add(Alignment(1.5, -0.75));
    alignPetList.add(Alignment(1.6, 0.25));
    alignPetList.add(Alignment(1.9, 1.0));
    alignPetList.add(Alignment(0.0, 0.50));
    alignPetList.add(Alignment(-1.6, 0.3));
    alignPetList.add(Alignment(-1.54, 1.05));
    alignPetList.add(Alignment(0.20, 1.25));
    return alignPetList;
  }
}
