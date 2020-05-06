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
      height: 100,
      width: 200,
      child: Center(
        child: Text(
          "Hello",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
