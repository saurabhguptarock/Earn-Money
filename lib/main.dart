import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:watch_ads_earn_money/pages/transfer_money.dart';
import './pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watch Ads Earn Money',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/transfer': (BuildContext context) => TransferMoney(),
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
