import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:neko/api/api.dart';
import 'package:neko/responses/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class RequestDetailPage extends StatefulWidget {
  final int status;

  RequestDetailPage(this.status);

  @override
  _RequestDetailState createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetailPage> {
  bool isHttpWorking = true;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  DashboardResponse dashboardResponse;

  void getData() async {
    setState(() {
      isHttpWorking = true;
    });

    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token');

    var url = APIUrl().index();
    var response = await http.get(url, headers: {'Authorization': token, 'Accept': 'application/json'});

    if (response.statusCode == 200) {
      try {
        setState(() {
          dashboardResponse = DashboardResponse.fromJson(jsonDecode(response.body));
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          },
        ),
        title: Text(
          '${widget.status == 1 ? 'Approve' : widget.status == 2 ? 'Pending' : 'Total'} Details',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: isHttpWorking
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: widget.status == 1
                      ? dashboardResponse.approveRequestDetails.length
                      : widget.status == 2
                          ? dashboardResponse.pendingRequestDetails.length
                          : dashboardResponse.totalRequestDetails.length,
                  itemBuilder: (context, i) {
                    TotalRequestDetail detail = widget.status == 1
                        ? dashboardResponse.approveRequestDetails[i]
                        : widget.status == 2
                            ? dashboardResponse.pendingRequestDetails[i]
                            : dashboardResponse.totalRequestDetails[i];
                    return ListTile(
                      title: Text(detail.title ?? ""),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
