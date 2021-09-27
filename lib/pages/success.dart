import 'package:flutter/material.dart';
import 'package:neko/common/button.dart';
import 'package:neko/pages/dashboard.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    'assets/images/success.png',
                    height: 183,
                    width: 183,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Success !!',
                    style: TextStyle(
                      color: Color(0xff12A99E),
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your transaction',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'has been successful',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: BottomButton().button(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
                child: Text(
                  'Return to Home',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
