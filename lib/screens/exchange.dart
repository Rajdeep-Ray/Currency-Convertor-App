import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'country_list.dart';

class MyExchange extends StatefulWidget {
  final String startDate, endDate;
  MyExchange({@required this.startDate, @required this.endDate});
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
    makeRequest(widget.startDate, widget.endDate);
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
              onTap: (){},
            ),
          ),
          Text(
            "${widget.startDate} to ${widget.endDate}",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10,),
          //remaining
          data != null
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: country
                          .map((e) => _MyExchangeCard(
                              base: 'USD',
                              code: e.code,
                              symbol: e.symbol,
                              start: data['rates']['2020-05-05'][e.code],
                              end: data['rates']['2020-05-06'][e.code],
                              currency: e.currency))
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
      {@required this.base,
      @required this.code,
      @required this.symbol,
      @required this.start,
      @required this.end,
      @required this.currency});
  @override
  Widget build(BuildContext context) {
    print(country.length);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
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
