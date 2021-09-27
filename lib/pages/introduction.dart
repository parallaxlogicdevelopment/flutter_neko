import 'package:flutter/material.dart';
import 'package:neko/common/button.dart';
import 'package:neko/pages/dashboard.dart';
import 'package:neko/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      String introduction = prefs.getString('introduction');
      String token = prefs.getString('token');
      if (introduction != null && introduction.length > 0) {
        if (token != null && token.length > 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/get-started.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * .58,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                    Text(
                      'Organize every job for\nbetter productivity',
                      style: TextStyle(fontSize: 24, color: Color(0xff132D53)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: BottomButton().button(
                  onPressed: () async {
                    final SharedPreferences prefs = await _prefs;
                    prefs.setString('introduction', 'true');

                    String token = prefs.getString('token');
                    if (token != null && token.length > 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardPage()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
