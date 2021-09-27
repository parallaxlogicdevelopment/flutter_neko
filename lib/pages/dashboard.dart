import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:neko/api/api.dart';
import 'package:neko/pages/add-expense.dart';
import 'package:neko/pages/leave-application.dart';
import 'package:neko/pages/request-details.dart';
import 'package:neko/pages/settings.dart';
import 'package:neko/responses/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isHttpWorking = true;
  DashboardResponse dashboardResponse;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingPage()),
      );
    }
  }

  void clockIn() async {
    setState(() {
      isHttpWorking = true;
    });

    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token');

    var url = APIUrl().clockIn();
    var response = await http.post(url,
        body: {'date': DateFormat('yyyy-MM-dd').format(DateTime.now())},
        headers: {'Authorization': token, 'Accept': 'application/json'});

    if (response.statusCode == 200) {
      try {
        setState(() {
          getData();
        });
      } catch (e) {
        setState(() {
          isHttpWorking = false;
        });
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
        msg: 'Something went wrong',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void clockOut() async {
    setState(() {
      isHttpWorking = true;
    });

    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token');

    var url = APIUrl().clockOut();
    var response = await http.post(url, body: {'date': DateFormat('yyyy-MM-dd').format(DateTime.now())},
        headers: {'Authorization': token, 'Accept': 'application/json'});

    if (response.statusCode == 200) {
      try {
        setState(() {
          getData();
        });
      } catch (e) {
        setState(() {
          isHttpWorking = false;
        });
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
        msg: 'Something went wrong',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void getData() async {
    setState(() {
      isHttpWorking = true;
    });

    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token');

    var url = APIUrl().index();
    var response = await http.get(url,
        headers: {'Authorization': token, 'Accept': 'application/json'});

    if (response.statusCode == 200) {
      try {
        setState(() {
          dashboardResponse =
              DashboardResponse.fromJson(jsonDecode(response.body));
          isHttpWorking = false;
        });
      } catch (e) {
        setState(() {
          isHttpWorking = false;
        });
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
        msg: 'Something went wrong',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: isHttpWorking
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('LLL d, y')
                                          .format(DateTime.now()),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('EEEE').format(DateTime.now()),
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child:
                                        Image.asset('assets/images/icon-1.png'),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddExpensePage()),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    child:
                                        Image.asset('assets/images/icon-2.png'),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeaveApplicationPage()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: dashboardResponse.timeSheetMessage
                                      ? null
                                      : () {
                                          clockIn();
                                        },
                                  child: Text('Day start'),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: !dashboardResponse.timeSheetMessage
                                      ? null
                                      : () {
                                          clockOut();
                                        },
                                  child: Text('Day End'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     right: 20,
                        //   ),
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //       contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //       prefixIcon: Icon(
                        //         Icons.search,
                        //       ),
                        //       fillColor: Color(0xffF5F5F5),
                        //       filled: true,
                        //       hintText: 'Search',
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(15.0),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(color: Color(0xffF5F5F5), width: 32.0),
                        //         borderRadius: BorderRadius.circular(25.0),
                        //       ),
                        //       hintStyle: TextStyle(fontSize: 18),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Have total ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '${dashboardResponse.totalRequest} cost request',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              padding: EdgeInsets.only(right: 20),
                              height: 25,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Color(0xff132D53),
                                      ),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      return Color(0xff132D53);
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddExpensePage()),
                                  );
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 80,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RequestDetailPage(2)),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    width: 120,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0)),
                                            color: Color(0xff12A99E),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Pending',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "${dashboardResponse.pendingRequest} items",
                                                  style: TextStyle(
                                                      color: Color(0xffB5B5BA),
                                                      fontSize: 19),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RequestDetailPage(1)),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    width: 120,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0)),
                                            color: Color(0xff0072BC),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Approve',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "${dashboardResponse.approveRequest} items",
                                                  style: TextStyle(
                                                      color: Colors.black12,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RequestDetailPage(0)),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    width: 120,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0)),
                                            color: Color(0xff132D53),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Total',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "${dashboardResponse.totalRequest} items",
                                                  style: TextStyle(
                                                      color: Colors.black12,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          'My Inventories',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 80,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                                dashboardResponse.product.length, (int index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Color(0xff0072BC),
                                  ),
                                  width: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dashboardResponse
                                            .product[index].quantity,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        dashboardResponse.product[index].name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Text(
                              'My Leave Applications',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Expanded(child: Container()),
                            Container(
                              padding: EdgeInsets.only(right: 20),
                              height: 25,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Color(0xff132D53),
                                      ),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      return Color(0xff132D53);
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LeaveApplicationPage()),
                                  );
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 135,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                                dashboardResponse.leaves.length, (int index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  width: 270,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                          ),
                                          color: dashboardResponse
                                                      .leaves[index].status ==
                                                  1
                                              ? Color(0xff12A99E)
                                              : dashboardResponse.leaves[index]
                                                          .status ==
                                                      2
                                                  ? Color(0xff12A99E)
                                                  : Color(0xff12A99E),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    // width: 20,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                            side: BorderSide(
                                                              color: dashboardResponse
                                                                          .leaves[
                                                                              index]
                                                                          .status ==
                                                                      1
                                                                  ? Color(
                                                                      0xff12A99E)
                                                                  : dashboardResponse
                                                                              .leaves[
                                                                                  index]
                                                                              .status ==
                                                                          2
                                                                      ? Color(
                                                                          0xff12A99E)
                                                                      : Color(
                                                                          0xff12A99E),
                                                            ),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            return dashboardResponse
                                                                        .leaves[
                                                                            index]
                                                                        .status ==
                                                                    1
                                                                ? Color(
                                                                    0xff12A99E)
                                                                : dashboardResponse
                                                                            .leaves[
                                                                                index]
                                                                            .status ==
                                                                        2
                                                                    ? Color(
                                                                        0xff12A99E)
                                                                    : Color(
                                                                        0xff12A99E); // Use the component's default.
                                                          },
                                                        ),
                                                      ),
                                                      onPressed: () {},
                                                      child: Text(
                                                        dashboardResponse
                                                                    .leaves[
                                                                        index]
                                                                    .status ==
                                                                1
                                                            ? 'Pending'
                                                            : dashboardResponse
                                                                        .leaves[
                                                                            index]
                                                                        .status ==
                                                                    2
                                                                ? 'Approved'
                                                                : 'Canceled',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  if (dashboardResponse
                                                          .leaves[index]
                                                          .durationType ==
                                                      1)
                                                    Text(
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(
                                                              dashboardResponse
                                                                  .leaves[index]
                                                                  .startDate),
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  if (dashboardResponse
                                                          .leaves[index]
                                                          .durationType ==
                                                      2)
                                                    Text(
                                                      DateFormat('dd/MM/yyyy').format(
                                                              dashboardResponse
                                                                  .leaves[index]
                                                                  .startDate) +
                                                          ' - ' +
                                                          DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(
                                                                  dashboardResponse
                                                                      .leaves[
                                                                          index]
                                                                      .endDate),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                dashboardResponse
                                                    .leaves[index].typeName,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                dashboardResponse
                                                        .leaves[index].reason ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
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
}

/* SF Compact, Rubik, Helvetica Neue */
