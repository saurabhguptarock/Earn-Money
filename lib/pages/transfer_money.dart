import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int coins = 0;
double rupees = 0;
double convertMoney = 0;
Color convertColor = Colors.black;
int phoneNumber = 0;
SharedPreferences prefs;

addDataToCollection() {
  Firestore.instance
      .collection('moneyRequest')
      .add({'from': phoneNumber, 'price': convertMoney});
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
      rupees = coin / 50;
    });
  }

  @override
  void initState() {
    super.initState();
    checkCoins();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FocusNode coinFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  TextEditingController coinController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Withdraw Money',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: 'WorkSansMedium'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$rupees ',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'WorkSansMedium'),
                          ),
                          Icon(
                            FontAwesomeIcons.rupeeSign,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 60,
                      color: Colors.grey,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$coins ',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'WorkSansMedium'),
                          ),
                          Icon(
                            FontAwesomeIcons.coins,
                            color: Colors.yellow,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
            ),
            Card(
              elevation: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      width: MediaQuery.of(context).size.width / 2 - 4,
                      child: TextFormField(
                        maxLengthEnforced: true,
                        autofocus: true,
                        onChanged: (val) {
                          setState(() {
                            if (val.isNotEmpty)
                              convertMoney = double.parse(val) / 50;
                            else
                              convertMoney = 0;
                            if (int.parse(val) >= 2500 &&
                                int.parse(val) <= 100000)
                              convertColor = Colors.green;
                            else
                              convertColor = Colors.red;
                          });
                        },
                        focusNode: coinFocus,
                        controller: coinController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontFamily: "WorkSansMedium",
                            fontSize: 16.0,
                            color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email Coins",
                          hintStyle: TextStyle(
                              fontFamily: "WorkSansMedium", fontSize: 17.0),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$convertMoney ',
                            style: TextStyle(
                                fontSize: 18,
                                color: convertColor,
                                fontFamily: 'WorkSansMedium',
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            FontAwesomeIcons.rupeeSign,
                            size: 20,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
            ),
            Card(
              elevation: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: TextFormField(
                      maxLengthEnforced: true,
                      onChanged: (val) {
                        setState(() {
                          phoneNumber = int.parse(val);
                        });
                      },
                      focusNode: phoneFocus,
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email Your Phone Number",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansMedium", fontSize: 17.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
            ),
            Card(
              elevation: 2,
              child: InkWell(
                onTap: () {
                  if (convertMoney * 50 < 2500)
                    infoDialog(
                        context, 'You Can Not Withdraw Less Than 2500 Coins');
                  else if (convertMoney * 50 > 100000)
                    infoDialog(context,
                        'You Can Not Withdraw More Than 100000 Coins ');
                  else if (phoneNumber.toString().length < 10 ||
                      phoneNumber.toString().length > 10)
                    infoDialog(
                        context, 'Phone Number Should be 10 Digits Long');
                  else if (convertMoney * 50 > coins)
                    infoDialog(context, 'You Have Not Enough Coins');
                  else
                    addDataToCollection();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.cashRegister,
                        size: 40,
                      ),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      Text(
                        'Withdraw Now',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'WorkSansMedium',
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '* Rules',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '   1. Minimum Transaction Amount is 2,500 Coins.',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Text(
                    '   2. Payment Transfer in 42 Working Hour.',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Text(
                    '   3. 2,500 coin = 50 INR.',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Text(
                    '   4. Fill Correct Details.',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Text(
                    '   5. Daily Spin Limit is 10',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Text(
                    '   6. Daily Scratch Limit is 10',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '  ..Thank you',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> infoDialog(BuildContext context, String review) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(review),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
}
