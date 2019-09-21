import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int coins = 0;
SharedPreferences prefs;
addDataToCollection(String from, String price) {
  Firestore.instance
      .collection('moneyRequest')
      .add({'from': from, 'price': price});
}

class TransferMoney extends StatefulWidget {
  @override
  _TransferMoneyState createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Coins : $coins',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: 'WorkSansMedium'),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.45,
            color: Colors.orange,
            child: ListView(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              children: <Widget>[
                Plan('500', '20'),
                Plan('1000', '40'),
                Plan('2000', '100'),
                Plan('5000', '250'),
                Plan('8000', '400'),
                Plan('10000', '500'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              color: Colors.yellow,
              child: Row(
                children: <Widget>[
                  Text('data'),
                  Text('data'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Plan extends StatelessWidget {
  final String coins;
  final String price;
  Plan(this.coins, this.price);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        width: MediaQuery.of(context).size.width - 200,
        height: MediaQuery.of(context).size.height * .1,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FittedBox(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$coins  ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(
                        FontAwesomeIcons.coins,
                        size: 30,
                      ),
                      Text(
                        '  ->  ',
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        '$price ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(
                        FontAwesomeIcons.rupeeSign,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.purple,
                child: Text(
                  'Chose This',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'WorkSansMedium'),
                ),
                onPressed: () => addDataToCollection('+91 9599677968', price),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
