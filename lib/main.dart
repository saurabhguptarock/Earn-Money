import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watch Ads Earn Money',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final MobileAdTargetingInfo mobileAdTargetingInfo =
      MobileAdTargetingInfo(testDevices: <String>[], childDirected: false);

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.smartBanner,
        targetingInfo: mobileAdTargetingInfo,
        listener: (MobileAdEvent event) {
          print(event);
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: mobileAdTargetingInfo,
        listener: (MobileAdEvent event) {
          print(event);
        });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }

  load() {
    _interstitialAd = createInterstitialAd()
      ..load()
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: load,
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
