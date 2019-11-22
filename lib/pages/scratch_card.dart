import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:scratcher/scratcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'home_page.dart' as home;

class ScratchCard extends StatefulWidget {
  @override
  _ScratchCardState createState() => _ScratchCardState();
}

SharedPreferences prefs;
int coins = 0;
int randomCoin = 0;

class _ScratchCardState extends State<ScratchCard> {
  checkCoins() async {
    prefs = await SharedPreferences.getInstance();
    var coin = prefs.getInt("coins") ?? 0;
    setState(() {
      coins = coin;
    });
  }

  InterstitialAd _interstitialAd;

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkCoins();
    setState(() {
      randomCoin = Random().nextInt(80) + 20;
    });
  }

  static final MobileAdTargetingInfo mobileAdTargetingInfo =
      MobileAdTargetingInfo(
    testDevices: <String>['36451F1875A8B63DE36BF6E55DFDEC43'],
    childDirected: false,
  );

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: mobileAdTargetingInfo);
  }

  showInterstitialAd() async {
    _interstitialAd = createInterstitialAd()
      ..load()
      ..show();
  }

  // showRewardAd() async {
  //   RewardedVideoAd.instance.load(
  //     adUnitId: RewardedVideoAd.testAdUnitId,
  //     targetingInfo: mobileAdTargetingInfo,
  //   );
  //   RewardedVideoAd.instance.listener =
  //       (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
  //     if (event == RewardedVideoAdEvent.rewarded) {
  //       setState(() {
  //         coins += rewardAmount;
  //         prefs.setInt('coins', coins);
  //       });
  //     }
  //     if (event == RewardedVideoAdEvent.loaded) {
  //       RewardedVideoAd.instance.show();
  //     }
  //   };
  // }

  final scratchKey = GlobalKey<ScratcherState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scratch and Earn',
          style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: 20),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .1, top: 30),
            child: Scratcher(
              key: scratchKey,
              brushSize: 40,
              threshold: 20,
              color: Colors.grey,
              onThreshold: () async {
                scratchKey.currentState.reveal();
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    infoDialog(context, 'You have won $randomCoin');
                    setState(() {
                      coins += randomCoin;
                      prefs.setInt('coins', coins);
                      home.coins = coins;
                    });
                    showInterstitialAd();
                  }
                } on SocketException catch (_) {
                  infoDialog(context, 'Please Enable Internet');
                }
              },
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: Text(
                    '$randomCoin',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> infoDialog(BuildContext context, String review) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(review),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
