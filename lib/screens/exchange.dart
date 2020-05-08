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
  String baseCode = "USD",
      baseCurrncy = "United States Dollar",
      baseSymbol = "\$";
  var data;
  Future<void> makeRequest(start, end, code) async {
    String url =
        'https://api.exchangeratesapi.io/history?start_at=$start&end_at=$end&base=$code';
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      data = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    makeRequest(widget.startDate, widget.endDate, baseCode);
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
                  baseSymbol,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              title: Text(baseCode),
              subtitle: Text(baseCurrncy),
              trailing: Icon(Icons.expand_less),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _currencySelect(),
                ),
              ),
            ),
          ),
          Text(
            "${widget.startDate} to ${widget.endDate}",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          //remaining
          data != null
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: country.map((e) {
                        if (baseCode.compareTo('EUR') == 0 &&
                            e.code.compareTo('EUR') == 0) {
                          return Container();
                        } else if (baseCode.compareTo(e.code) == 0) {
                          return Container();
                        } else {
                          return _MyExchangeCard(
                            base: baseCode,
                            code: e.code,
                            symbol: e.symbol,
                            start: data['rates'][widget.startDate][e.code],
                            end: data['rates'][widget.endDate][e.code],
                            currency: e.currency,
                          );
                        }
                      }).toList(),
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                ),
          SizedBox(
            height: 18,
          )
        ],
      ),
    );
  }

  Widget _currencySelect() {
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
                            baseCode = e.code;
                            baseCurrncy = e.currency;
                            baseSymbol = e.symbol;
                          });
                          data = null;
                          makeRequest(
                              widget.startDate, widget.endDate, baseCode);
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
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
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
        trailing: roundDouble(end - start, 4) == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.trending_flat,
                    color: Colors.orange,
                    size: 28,
                  ),
                  Text(
                    "\t${roundDouble(end - start, 4)}",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )
                ],
              )
            : (roundDouble(end - start, 4) > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: Colors.green,
                        size: 28,
                      ),
                      Text(
                        "\t${roundDouble(end - start, 4)}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_down,
                        color: Colors.red,
                        size: 28,
                      ),
                      Text(
                        "\t${roundDouble(end - start, 4)}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      )
                    ],
                  )),
      ),
    );
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
