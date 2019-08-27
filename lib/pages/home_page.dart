import 'dart:async';
import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

int coins = 0;
SharedPreferences prefs;

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final MobileAdTargetingInfo mobileAdTargetingInfo =
      MobileAdTargetingInfo(
          testDevices: <String>[],
          childDirected: false,
          keywords: <String>[
            'firebase',
            'google',
            'facebook',
            'watch ads',
            'money',
            'earn money'
          ]);

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

  checkCoins() async {
    prefs = await SharedPreferences.getInstance();
    var coin = prefs.getInt("coins") ?? 0;
    setState(() {
      coins = coin;
    });
  }

  @override
  void initState() {
    super.initState();
    checkCoins();
    _bannerAd = createBannerAd()
      ..load()
      ..show();
  }

  void showInSnackBar(String value) {} // TODO: Complete alert Dialog

  showInterstitialAd() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _interstitialAd = createInterstitialAd()
          ..load()
          ..show().then((val) {
            setState(() {
              coins += 5;
              prefs.setInt('coins', coins);
            });
          });
      }
    } on SocketException catch (_) {
      showInSnackBar("Please connect to Internet");
    }
  }

  showRewardAd() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        RewardedVideoAd.instance.load(
          adUnitId: RewardedVideoAd.testAdUnitId,
          targetingInfo: mobileAdTargetingInfo,
        );
        Timer(Duration(seconds: 3), () => RewardedVideoAd.instance.show());
        RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.rewarded) {
            setState(() {
              coins += rewardAmount;
              prefs.setInt('coins', coins);
            });
          }
        };
      }
    } on SocketException catch (_) {
      showInSnackBar("Please connect to Internet");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Your Coins : $coins',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: 'WorkSansMedium'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.attach_money,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pushNamed('/transfer'),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .5,
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              color: Colors.purpleAccent,
              child: Text(
                'Watch Interstitial Ad',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'WorkSansMedium'),
              ),
              onPressed: showInterstitialAd,
            ),
            RaisedButton(
              color: Colors.purpleAccent,
              child: Text(
                'Watch Rewarded Ad',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'WorkSansMedium'),
              ),
              onPressed: showRewardAd,
            )
          ],
        ),
      ),
    );
  }
}
