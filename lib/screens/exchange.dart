import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'country_list.dart';

class MyExchange extends StatefulWidget {
  @override
  _MyExchangeState createState() => _MyExchangeState();
}

class _MyExchangeState extends State<MyExchange> {
  var data;
  Future<void> makeRequest(start, end) async {
    String url =
        'https://api.exchangeratesapi.io/history?start_at=$start&end_at=$end&base=USD';
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      data = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    makeRequest('2020-05-05', '2020-05-06');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(data['rates']);
    return Container(
      color: Color(0xFF2B2B52),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "Exchange Rates",
              style: TextStyle(
                color: Colors.white,
                fontSize: 29,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black12,
                foregroundColor: Colors.black,
                child: Text(
                  "\$",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              title: Text("USD"),
              subtitle: Text("United States Dollars"),
              trailing: Icon(Icons.expand_less),
            ),
          ),
          //remaining
          data != null
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: country
                          .map((e) => _MyExchangeCard(
                              'USD',
                              e.code,
                              e.symbol,
                              data['rates']['2020-05-05'][e.code],
                              data['rates']['2020-05-06'][e.code],
                              e.currency))
                          .toList(),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 18,
          )
        ],
      ),
    );
  }

  // Widget _currencySelect() {
  //   return Scaffold(
  //     body: Container(),
  //   );
  // }
}

class _MyExchangeCard extends StatelessWidget {
  final String base, currency, symbol, code;
  final double start, end;
  _MyExchangeCard(
      this.base, this.code, this.symbol, this.start, this.end, this.currency);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              //radius: 22,
              backgroundColor: Colors.black12,
              foregroundColor: Colors.black,
              child: Text(
                "$symbol",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
        title: Text(code.toString()),
        subtitle: Text("$currency\n1 $base = ${roundDouble(end, 4)} $code"),
        isThreeLine: true,
        trailing: Text("${roundDouble(end - start, 4)}"),
      ),
    );
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
