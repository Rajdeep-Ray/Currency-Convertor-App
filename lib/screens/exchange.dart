import 'package:flutter/material.dart';

class MyExchange extends StatefulWidget {
  @override
  _MyExchangeState createState() => _MyExchangeState();
}

class _MyExchangeState extends State<MyExchange> {
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
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          //remaining
        ],
      ),
    );
  }
}