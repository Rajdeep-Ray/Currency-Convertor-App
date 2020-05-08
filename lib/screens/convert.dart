import 'package:flutter/material.dart';

import './country_list.dart';

class MyConvert extends StatefulWidget {
  @override
  _MyConvertState createState() => _MyConvertState();
}

class _MyConvertState extends State<MyConvert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2B2B52),
      child: Column(
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
              //remaining
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
                          // setState(() {
                          //   baseCode = e.code;
                          //   baseCurrncy = e.currency;
                          //   baseSymbol = e.symbol;
                          // });
                          // data = null;
                          // makeRequest(
                          //     widget.startDate, widget.endDate, baseCode);
                          // Navigator.pop(context);
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
