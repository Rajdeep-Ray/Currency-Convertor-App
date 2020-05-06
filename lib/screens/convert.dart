import 'package:flutter/material.dart';

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
}
