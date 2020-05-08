import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './country_list.dart';

class MyConvert extends StatefulWidget {
  final String tocode, fromCode;
  MyConvert({@required this.fromCode, @required this.tocode});
  @override
  _MyConvertState createState() => _MyConvertState();
}

final myAmountController = TextEditingController();

class _MyConvertState extends State<MyConvert> {
  String baseCode, baseCurrncy = "", baseSymbol = "";
  String toCode;
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
    print(data);
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
                          subtitle: Text(baseCurrncy),
                          trailing: Icon(Icons.arrow_drop_up),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _currencySelect(),
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
                              controller: myAmountController,
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                print("First text field: $text");
                              },
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                        ],
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
                          //makeRequest(widget.startDate, widget.endDate, baseCode);
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
