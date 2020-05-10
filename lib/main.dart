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
  bool hasDate=false;
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
    if (pref.getString('currDate') != null &&
        pref.getString('currDate').split('-').length == 3 &&
        pref.getString('currDate').compareTo(data['date']) != 0 &&
        pref.getString('prevDate') != null) {
      //print("if");
      setState(() {
        prevDate = pref.getString('currDate');
        currDate = data['date'].toString();
        // print(pref.getString('prevDate'));
        // print(prevDate);
      });
    } else {
      //print("else");
      setState(() {
        currDate = data['date'].toString();
        prevDate = '2020-05-04';
        // print(prevDate);
        // print(currDate);
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
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFF2B2B52),
        child: Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    //print(data['date']);
    if (hasDate!=true) {
      _getData();
      hasDate=true;
    }
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
              // startDate: '2020-05-04',
              // endDate: '2020-05-07',
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
