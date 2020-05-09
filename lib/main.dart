import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/convert.dart';
import './screens/exchange.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String prevDate, currDate;
  bool isDetail = false;
  int _currentIndex = 0;

  PageController _pageController = new PageController(
    initialPage: 0,
  );

  var data;
  Future<void> _getRequest() async {
    String url = 'https://api.exchangeratesapi.io/latest?symbols=USD';
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      data = jsonDecode(response.body);
    });
  }

  Future<void> _getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      prevDate = pref.getString('prevDate') ?? '2020-05-01';
      currDate = pref.getString('currDate')??'';
    });

    if (currDate.compareTo(data['date'].toString()) != 0 && prevDate.compareTo('2020-05-01')!=0) {
      print("if");
      setState(() {
        prevDate=currDate;
        currDate=data['date'].toString();
      });
    } else {
      print("else");
      setState(() {
        currDate=data['date'].toString();
      });
    }
  }

  @override
  void initState() {
    _getRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container();
    }
    //print(data['date']);
    _getData();
    return Scaffold(
      backgroundColor: Color(0xFF2B2B52),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 55.0,
        items: <Widget>[
          Icon(Icons.compare_arrows, size: 30),
          Icon(Icons.attach_money, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 250),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 250), curve: Curves.linear);
          });
        },
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            //print(page);
            setState(() {
              _currentIndex = page;
            });
          },
          children: [
            MyConvert(
              fromCode: 'INR',
              fromCurrency: 'Indian rupee',
              fromSymbol: '\₹',
              tocode: 'USD',
              toCurrency: 'United States Dollar',
              toSymbol: '\$',
            ),
            MyExchange(
              startDate: prevDate,
              endDate: currDate,
            ),
          ],
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
