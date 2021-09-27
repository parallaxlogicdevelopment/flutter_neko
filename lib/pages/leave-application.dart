import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neko/api/api.dart';
import 'package:neko/common/button.dart';
import 'package:neko/pages/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:neko/pages/success.dart';
import 'package:neko/responses/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:http/http.dart' as http;

class LeaveApplicationPage extends StatefulWidget {
  @override
  _LeaveApplicationPageState createState() => _LeaveApplicationPageState();
}

class _LeaveApplicationPageState extends State<LeaveApplicationPage> {
  List<DropdownMenuItem> _dropdownLeaveTypeItems = [];
  List<DropdownMenuItem> _dropdownDurationTypeItems = [
    DropdownMenuItem(
      value: '2',
      child: Text(
        "Multiple Dates",
        style: TextStyle(color: Colors.black),
      ),
    ),
    DropdownMenuItem(
      value: '1',
      child: Text(
        "Single Date",
        style: TextStyle(color: Colors.black),
      ),
    ),
  ];
  int _dropdownLeaveTypeItem;
  String _dropdownDurationTypeItem = '1';
  bool isHttpWorking = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CommonResponse commonResponse;
  final _noteFormKey = GlobalKey<FormState>();
  TextEditingController _noteController = TextEditingController();
  bool _dropdownLeaveTypeItemError = false;
  bool _dropdownDurationTypeItemError = false;
  bool _dateTimeStartError = false;
  bool _dateTimeEndError = false;
  String _dateTimeStart = DateTime.now().toString();
  String _dateTimeEnd = DateTime.now().toString();

  void getCommonData() async {
    setState(() {
      isHttpWorking = true;
    });

    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token');

    var url = APIUrl().getCommonInfo();
    var response = await http.get(url, headers: {'Authorization': token, 'Accept': 'application/json'});

    if (response.statusCode == 200) {
      try {
        setState(() {
          commonResponse = CommonResponse.fromJson(jsonDecode(response.body));
          isHttpWorking = false;
        });
        commonResponse.leaveTypes.forEach((element) {
          _dropdownLeaveTypeItems.add(
            DropdownMenuItem(
              value: element.id,
              child: Text(
                element.name,
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
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
    getCommonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          'Add Leave Application',
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
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Duration type',
                                style: TextStyle(fontSize: 19),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 10),
                                child: DropdownBelow(
                                  itemWidth: 350,
                                  itemTextstyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  boxTextstyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0XFFbbbbbb),
                                  ),
                                  boxPadding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                                  boxWidth: double.infinity,
                                  boxHeight: 58,
                                  hint: Text('choose item'),
                                  value: _dropdownDurationTypeItem,
                                  items: _dropdownDurationTypeItems,
                                  onChanged: (selectedTest) {
                                    setState(() {
                                      _dropdownDurationTypeItem = selectedTest;
                                      _dropdownDurationTypeItemError = false;
                                    });
                                  },
                                ),
                              ),
                              if (_dropdownDurationTypeItemError)
                                Padding(
                                  padding: EdgeInsets.only(left: 10, bottom: 20),
                                  child: Text(
                                    'Please select',
                                    style: TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Leave type',
                                style: TextStyle(fontSize: 20),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 20),
                                child: DropdownBelow(
                                  itemWidth: 350,
                                  itemTextstyle:
                                      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                  boxTextstyle:
                                      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0XFFbbbbbb)),
                                  boxPadding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                                  boxWidth: double.infinity,
                                  boxHeight: 60,
                                  hint: Text('choose item'),
                                  value: _dropdownLeaveTypeItem,
                                  items: _dropdownLeaveTypeItems,
                                  onChanged: (selectedTest) {
                                    setState(() {
                                      _dropdownLeaveTypeItem = selectedTest;
                                      _dropdownLeaveTypeItemError = false;
                                    });
                                  },
                                ),
                              ),
                              if (_dropdownLeaveTypeItemError)
                                Padding(
                                  padding: EdgeInsets.only(left: 10, bottom: 20),
                                  child: Text(
                                    'Please select',
                                    style: TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          Form(
                            key: _noteFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notes',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 20),
                                  child: TextFormField(
                                    controller: _noteController,
                                    maxLines: 5,
                                    minLines: 5,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Color(0xff454545),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      _noteFormKey.currentState.validate();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(fontSize: 20),
                              ),
                              Container(
                                child: SfDateRangePicker(
                                  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                    setState(() {
                                      _dateTimeStart = args.value.toString();
                                      if (!DateTime.parse(_dateTimeStart).isBefore(DateTime.parse(_dateTimeEnd))) {
                                        String _start = _dateTimeStart, _end = _dateTimeStart;
                                        _dateTimeStart = _end;
                                        _dateTimeEnd = _start;
                                      }
                                    });
                                  },
                                  selectionMode: DateRangePickerSelectionMode.single,
                                  initialSelectedDate: DateTime.parse(_dateTimeStart),
                                ),
                              ),
                              if (_dateTimeStartError)
                                Padding(
                                  padding: EdgeInsets.only(left: 10, bottom: 20),
                                  child: Text(
                                    'Please select',
                                    style: TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          if (_dropdownDurationTypeItem == "2")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Date',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Container(
                                  child: SfDateRangePicker(
                                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                      setState(() {
                                        _dateTimeEnd = args.value.toString();
                                        if (!DateTime.parse(_dateTimeStart).isBefore(DateTime.parse(_dateTimeEnd))) {
                                          String _start = _dateTimeStart, _end = _dateTimeStart;
                                          _dateTimeStart = _end;
                                          _dateTimeEnd = _start;
                                        }
                                      });
                                    },
                                    selectionMode: DateRangePickerSelectionMode.single,
                                    initialSelectedDate: DateTime.parse(_dateTimeEnd),
                                  ),
                                ),
                                if (_dateTimeEndError)
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, bottom: 20),
                                    child: Text(
                                      'Please select',
                                      style: TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'We have ',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    if (_dropdownDurationTypeItem == "1")
                                      TextSpan(text: '1 day', style: TextStyle(fontWeight: FontWeight.bold)),
                                    if (_dropdownDurationTypeItem == "2" &&
                                        _dateTimeEnd != null &&
                                        _dateTimeStart != null)
                                      TextSpan(
                                        text:
                                            '${(DateTime.parse(_dateTimeEnd).difference(DateTime.parse(_dateTimeStart)).inDays + 1)} days',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '${DateFormat('MMMM ').format(DateTime.parse(_dateTimeStart))}',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${DateFormat('dd ').format(DateTime.parse(_dateTimeStart))}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: DateFormat(', yyyy').format(DateTime.parse(_dateTimeStart)),
                                    ),
                                    TextSpan(
                                      text: ' - ${DateFormat('MMMM ').format(DateTime.parse(_dateTimeEnd))}',
                                    ),
                                    TextSpan(
                                      text: '${DateFormat('dd ').format(DateTime.parse(_dateTimeEnd))}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: DateFormat(', yyyy').format(DateTime.parse(_dateTimeEnd)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          BottomButton().button(
                            onPressed: () async {
                              setState(() {
                                _dateTimeEndError = false;
                                _dateTimeStartError = false;
                                _dropdownLeaveTypeItemError = false;
                                _dropdownDurationTypeItemError = false;
                              });
                              if (_dropdownDurationTypeItem == null) {
                                setState(() {
                                  _dropdownDurationTypeItemError = true;
                                });
                              }
                              if (_dropdownLeaveTypeItem == null) {
                                setState(() {
                                  _dropdownLeaveTypeItemError = true;
                                });
                              }
                              if (_dropdownDurationTypeItem == '2' && _dateTimeEnd == null) {
                                setState(() {
                                  _dateTimeEndError = true;
                                });
                              }
                              if (_dateTimeStart == null) {
                                setState(() {
                                  _dateTimeStartError = true;
                                });
                              }
                              bool noteValid = _noteFormKey.currentState.validate();
                              if (noteValid &&
                                  !_dateTimeEndError &&
                                  !_dateTimeStartError &&
                                  !_dropdownDurationTypeItemError &&
                                  !_dropdownLeaveTypeItemError) {
                                setState(() {
                                  isHttpWorking = true;
                                });
                                final SharedPreferences prefs = await _prefs;
                                String token = prefs.getString('token');

                                var url = APIUrl().applyLeave();
                                var response = await http.post(
                                  url,
                                  body: {
                                    'start_date': _dateTimeStart,
                                    'end_date': _dateTimeEnd,
                                    'leave_type_id': _dropdownLeaveTypeItem.toString(),
                                    'duration_type': _dropdownDurationTypeItem,
                                    'reason': _noteController.text,
                                  },
                                  headers: {
                                    'Authorization': token,
                                    'Accept': 'application/json',
                                  },
                                );

                                if (response.statusCode == 200) {
                                  setState(() {
                                    isHttpWorking = false;
                                  });
                                  Fluttertoast.showToast(
                                    msg: 'Success',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => SuccessPage()),
                                  );
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
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
