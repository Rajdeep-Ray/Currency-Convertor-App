import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//import 'package:shared_preferences/shared_preferences.dart';
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
  String startDate, endDate;

  int _currentIndex = 0;

  PageController _pageController = new PageController(
    initialPage: 0,
  );

  // Future<void> _getData() async{
  //   SharedPreferences pref= await SharedPreferences.getInstance();
  //  setState(() {
  //    startDate=pref.getString('startDate');
  //    endDate=pref.getString('endDate');
  //  });
  // }

  @override
  void initState() {
    //_getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              startDate: '2020-05-06',
              endDate: '2020-05-07',
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
