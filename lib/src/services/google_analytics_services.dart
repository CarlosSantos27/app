import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class GoogleAnalyticsServices {
  // final FirebaseAnalyticsObserver firebaseAnalyticsObserver;
  FirebaseAnalytics _analytics;

  GoogleAnalyticsServices(){
    _analytics = FirebaseAnalytics();
  }

  Future<void> setCurrentScreen(String screen,{screenClassOverride = 'Flutter'}) async{
    return await this._analytics
          .setCurrentScreen(screenName: screen, screenClassOverride:screenClassOverride);
  }

  Future<void> setAnalyticsEvent(String eventName,[Map<String, dynamic> parameters]) async {
    await this._analytics.setUserProperty(name: 'carlos', value: 'extra');
    return await this._analytics
      .logEvent(
        name: eventName,
        parameters: parameters
      );
  }

  Future<void> campaignDetails() async{
    return await this._analytics.logCampaignDetails(source: null, medium: null, campaign: null);
  }

  Future<void> purchase({@required double value, @required String transactionId, String coupon = ''}) async{
    return await this._analytics.logEcommercePurchase(
      currency: 'USD',
      value: value,
      transactionId: transactionId,
      coupon: coupon
    );
  }

  Future<void> setUserId(String userId) async{
    return await this._analytics.setUserId(userId);
  }
}