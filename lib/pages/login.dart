import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neko/api/api.dart';
import 'package:neko/common/button.dart';
import 'package:neko/pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:neko/responses/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_config/flutter_config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isHttpWorking = false;

  @override
  void initState() {
    if (FlutterConfig.get('APP_ENV') == 'local') {
      _emailController.text = "ucb@gmail.com";
      _passwordController.text = "123456";
    }
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      String token = prefs.getString('token');
      if (token != null && token.length > 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      }
    });
  }

  void login() async {
    setState(() {
      isHttpWorking = true;
    });
    var url = APIUrl().signIn();

    print(url);

    var response = await http.post(url, body: {'email': _emailController.text, 'password': _passwordController.text});

    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        isHttpWorking = false;
      });

      try {
        LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        final SharedPreferences prefs = await _prefs;
        prefs.setString('email', loginResponse.user.email);
        prefs.setInt('id', loginResponse.user.id);
        prefs.setString('token', loginResponse.token);

        Fluttertoast.showToast(
          msg: 'Login success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Api Parse error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.deepOrange,
          textColor: Colors.white,
        );
      }
    } else {
      setState(() {
        isHttpWorking = false;
      });
      Fluttertoast.showToast(
        msg: 'Invalid username password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: isHttpWorking
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                        child: Form(
                          key: _emailFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff999999),
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Jhondoe@email.com',
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff454545),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  bool isEmail =
                                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                  if (!isEmail) {
                                    return 'Please enter valid email';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _emailFormKey.currentState.validate();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                        child: Form(
                          key: _passwordFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff999999),
                                ),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: '********',
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff454545),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _passwordFormKey.currentState.validate();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                        child: Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (newValue) {},
                            ),
                            Expanded(
                              child: Text(
                                'Remember Me',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff7D7D7D),
                                ),
                              ),
                            ),
                            /*Text(
                      'Recover password',
                      style: TextStyle(
                        color: Color(0xff454545),
                      ),
                    ),*/
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: BottomButton().button(
                          onPressed: isHttpWorking
                              ? null
                              : () {
                                  bool emailValid = _emailFormKey.currentState.validate();
                                  bool passwordValid = _passwordFormKey.currentState.validate();
                                  if (emailValid && passwordValid) {
                                    login();
                                  }
                                },
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
