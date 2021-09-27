import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neko/api/api.dart';
import 'package:neko/pages/dashboard.dart';
import 'package:neko/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F6F8),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: isHttpWorking
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        height: 110,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Container()),
                            Text(
                              'Settings',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Expanded(child: Container()),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 35),
                      child: SizedBox(
                        height: 106,
                        child: Container(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/user.png',
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jhon doe',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Text('Edit profile'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25),
                      child: SizedBox(
                        height: 70,
                        child: Container(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'About Neko',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right_sharp),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25),
                      child: SizedBox(
                        height: 70,
                        child: Container(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Privacy policy',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25),
                      child: SizedBox(
                        height: 70,
                        child: InkWell(
                          onTap: isHttpWorking
                              ? null
                              : () async {
                                  logout();
                                },
                          child: Container(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Log out',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_right)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff132D53),
        onTap: _onItemTapped,
      ),
    );
  }

  bool isHttpWorking = false;

  void logout() async {
    setState(() {
      isHttpWorking = true;
    });

    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token');

    var url = APIUrl().signOut();
    var response = await http.post(url, body: {}, headers: {'Authorization': token, 'Accept': 'application/json'});

    if (response.statusCode == 200) {
      setState(() {
        isHttpWorking = true;
      });

      prefs.remove('email');
      prefs.remove('id');
      prefs.remove('token');
      Fluttertoast.showToast(
        msg: 'Logout success',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {
        isHttpWorking = false;
      });
      Fluttertoast.showToast(
        msg: 'Something went wrong.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
