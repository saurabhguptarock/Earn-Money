import 'dart:async';
import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:scratcher/scratcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart' as home;
import 'home_page.dart';

class ScratchCard extends StatefulWidget {
  @override
  _ScratchCardState createState() => _ScratchCardState();
}

int coins = 0;
int randomCoin = 0;

class _ScratchCardState extends State<ScratchCard> {
  checkCoins() async {
    var prefs = await SharedPreferences.getInstance();
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
    if (home.scratchTime <= 0) {
      Timer.run(() {
        infoDialog(
            context, 'Your limit is reached come back again in 4 hours.');
      });
    }
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Text(
                '$scratchTime',
                style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: 20),
              ),
            ),
          ),
        ],
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
                var prefs = await SharedPreferences.getInstance();

                scratchKey.currentState.reveal();
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    infoDialog(context, 'You have won $randomCoin');
                    showInterstitialAd();
                    setState(() {
                      coins += randomCoin;
                      prefs.setInt('coins', coins);
                      home.coins = coins;
                      scratchTime -= 1;
                      prefs.setInt('scratchTime', scratchTime);
                    });
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
