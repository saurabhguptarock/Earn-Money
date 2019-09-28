import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
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
    testDevices: <String>['36451F1875A8B63DE36BF6E55DFDEC43'],
    childDirected: false,
  );

  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        targetingInfo: mobileAdTargetingInfo);
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

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
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
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/earnmoneyviapaytm-75862.appspot.com/o/1545027356.png?alt=media&token=72574f7e-54bf-4e6f-9a69-68c4dc4a271f'),
                fit: BoxFit.fill)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    disabledColor: Colors.grey,
                    color: Colors.yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: null,
                    child: Text(
                      'Spin',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/scratch'),
                    child: Text(
                      'Scratch',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/transfer'),
                    child: Text(
                      'Withdraw',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.share,
                    color: Colors.yellowAccent,
                    size: 40,
                  ),
                  onPressed: () => Share.share(
                      'Download App and Earn Paytm Money. \n https://drive.google.com/open?id=1fEJ24Pt6hAOdi8Ervjp3xV0ixJ5lcGZN'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
