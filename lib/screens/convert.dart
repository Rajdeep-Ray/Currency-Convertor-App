import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './country_list.dart';

class MyConvert extends StatefulWidget {
  final String tocode, fromCode, fromSymbol, toSymbol, fromCurrency, toCurrency;
  MyConvert(
      {@required this.fromCode,
      @required this.toCurrency,
      @required this.toSymbol,
      @required this.tocode,
      @required this.fromCurrency,
      @required this.fromSymbol});
  @override
  _MyConvertState createState() => _MyConvertState();
}

final myAmountController = TextEditingController();

class _MyConvertState extends State<MyConvert> {
  String baseCode, baseCurrency = "", baseSymbol = "";
  String toCode, toCurrency = "", toSymbol = "";
  double amount = 0;
  var data;
  Future<void> makeRequest(fromCode, toCode) async {
    String url =
        'https://api.exchangeratesapi.io/latest?base=$fromCode&symbols=$toCode';
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      data = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    setState(() {
      baseCode = widget.fromCode;
      toCode = widget.tocode;
    });
    makeRequest(baseCode, toCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(data);
    return Container(
      color: Color(0xFF2B2B52),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "Currency Converter",
              style: TextStyle(
                color: Colors.white,
                fontSize: 29,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black12,
                            foregroundColor: Colors.black,
                            child: Text(
                              baseSymbol,
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          title: Text(baseCode),
                          subtitle: Text(baseCurrency),
                          trailing: Icon(Icons.arrow_drop_up),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _currencyFromSelect(),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            baseSymbol,
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Amount',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              controller: myAmountController,
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                double exchAmt;
                                if (myAmountController.text.isEmpty) {
                                  setState(() {
                                    amount = 0;
                                  });
                                }
                                setState(() {
                                  exchAmt =
                                      double.parse(myAmountController.text) *
                                          data['rates'][toCode];
                                  amount = roundDouble(exchAmt, 3);
                                });
                                print("$text");
                              },
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black12,
                            foregroundColor: Colors.black,
                            child: Text(
                              toSymbol,
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          title: Text(toCode),
                          subtitle: Text(toCurrency),
                          trailing: Icon(Icons.arrow_drop_up),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _currencyToSelect(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              toSymbol,
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("$amount"),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _currencyFromSelect() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2B2B52),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Select Currency"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: country
              .map(
                (e) => Container(
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black12,
                          foregroundColor: Colors.black,
                          child: Text(
                            "${e.symbol}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          e.code,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          e.currency,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        onTap: () {
                          setState(() {
                            myAmountController.clear();
                            amount = 0;
                            baseCode = e.code;
                            baseCurrency = e.currency;
                            baseSymbol = e.symbol;
                          });
                          data = null;
                          makeRequest(e.code, toCode);
                          Navigator.pop(context);
                        },
                      ),
                      Divider()
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _currencyToSelect() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2B2B52),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Select Currency"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: country
              .map(
                (e) => Container(
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black12,
                          foregroundColor: Colors.black,
                          child: Text(
                            "${e.symbol}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          e.code,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          e.currency,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        onTap: () {
                          setState(() {
                            myAmountController.clear();
                            amount = 0;
                            toCode = e.code;
                            toCurrency = e.currency;
                            toSymbol = e.symbol;
                          });
                          data = null;
                          makeRequest(baseCode, e.code);
                          Navigator.pop(context);
                        },
                      ),
                      Divider()
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
