import 'dart:convert';
import 'dart:io';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:neko/api/api.dart';
import 'package:neko/common/button.dart';
import 'package:neko/pages/success.dart';
import 'package:neko/responses/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  bool isHttpWorking = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CommonResponse commonResponse;
  List<DropdownMenuItem> _dropdownExpenseCategoryItems = [];
  int _dropdownExpenseCategoryItem;
  bool _dropdownExpenseCategoryItemError = false;
  List<DropdownMenuItem> _dropdownCustomerItems = [];
  int _dropdownCustomerItem;
  bool _dropdownCustomerItemError = false;
  List<DropdownMenuItem> _dropdownProjectItems = [];
  int _dropdownProjectItem;
  bool _dropdownProjectItemError = false;
  final _amountFormKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  final _noteFormKey = GlobalKey<FormState>();
  TextEditingController _noteController = TextEditingController();
  final _siteFormKey = GlobalKey<FormState>();
  TextEditingController _siteNameController = TextEditingController();
  PickedFile pickedFile;
  String _dateTimeStart = DateTime.now().toString();
  bool _dateTimeStartError = false;

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
        commonResponse.expenseCategoryLists.forEach((element) {
          _dropdownExpenseCategoryItems.add(
            DropdownMenuItem(
              value: element.id,
              child: Text(
                element.name,
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        });
        commonResponse.customerLists.forEach((element2) {
          _dropdownCustomerItems.add(
            DropdownMenuItem(
              value: element2.id,
              child: Text(
                element2.customerName,
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        });
        commonResponse.productLists.forEach((element3) {
          _dropdownProjectItems.add(
            DropdownMenuItem(
              value: element3.id,
              child: Text(
                element3.name,
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

  final picker = ImagePicker();

  _getFromGallery() async {
    PickedFile _pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (_pickedFile != null) {
        pickedFile = _pickedFile;
      }
    });
  }

  _getFromCamera() async {
    PickedFile _pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (_pickedFile != null) {
        pickedFile = _pickedFile;
      }
    });
  }

  void _showContent() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('To upload an image, please select an option from which you want to upload.'),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _getFromGallery();
                        },
                        child: Text('Gallery'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _getFromCamera();
                        },
                        child: Text('Camera'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [],
        );
      },
    );
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
          'Add Expenses',
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
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Expense type',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Color(0xff000000),
                                ),
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
                                  value: _dropdownExpenseCategoryItem,
                                  items: _dropdownExpenseCategoryItems,
                                  onChanged: (val) {
                                    setState(() {
                                      _dropdownExpenseCategoryItem = val;
                                    });
                                  },
                                ),
                              ),
                              if (_dropdownExpenseCategoryItemError)
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
                                'Select Project',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Color(0xff000000),
                                ),
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
                                  value: _dropdownProjectItem,
                                  items: _dropdownProjectItems,
                                  onChanged: (vaaal) {
                                    setState(() {
                                      _dropdownProjectItem = vaaal;
                                    });
                                  },
                                ),
                              ),
                              if (_dropdownProjectItemError)
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
                                'Select Customer',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Color(0xff000000),
                                ),
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
                                  value: _dropdownCustomerItem,
                                  items: _dropdownCustomerItems,
                                  onChanged: (selectedTest) {
                                    setState(() {
                                      _dropdownCustomerItem = selectedTest;
                                    });
                                  },
                                ),
                              ),
                              if (_dropdownCustomerItemError)
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
                            key: _amountFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amount',
                                  style: TextStyle(fontSize: 19),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 20),
                                  child: TextFormField(
                                    controller: _amountController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        borderSide: BorderSide(color: Color(0xffC8C8C8)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                      hintText: 'xxxxxxx',
                                    ),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff454545),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      _amountFormKey.currentState.validate();
                                    },
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: _noteFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(fontSize: 19),
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
                                        borderSide: BorderSide(color: Color(0xffC8C8C8)),
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
                          Form(
                            key: _siteFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Site Name',
                                  style: TextStyle(fontSize: 19),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 20),
                                  child: TextFormField(
                                    controller: _siteNameController,
                                    maxLines: 2,
                                    minLines: 2,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        borderSide: BorderSide(color: Color(0xffC8C8C8)),
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
                                'Date',
                                style: TextStyle(fontSize: 20),
                              ),
                              Container(
                                child: SfDateRangePicker(
                                  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                    setState(() {
                                      _dateTimeStart = args.value.toString();
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
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            height: 51,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Color(0xffF2F2F2)),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Color(0xffF2F2F2);
                                  },
                                ),
                              ),
                              onPressed: _showContent,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/upload.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Upload Image',
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (pickedFile != null)
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.file(File(pickedFile.path)),
                            ),
                          SizedBox(
                            height: 100,
                          ),
                          BottomButton().button(
                            onPressed: () async {
                              bool amountValid = _amountFormKey.currentState.validate();
                              setState(() {
                                _dropdownExpenseCategoryItemError = false;
                                _dateTimeStartError = false;
                              });
                              if (_dropdownExpenseCategoryItem == null) {
                                setState(() {
                                  _dropdownExpenseCategoryItemError = true;
                                });
                              }
                              if (_dateTimeStart == null) {
                                setState(() {
                                  _dateTimeStartError = true;
                                });
                              }
                              if (amountValid && !_dropdownExpenseCategoryItemError && !_dateTimeStartError) {
                                setState(() {
                                  isHttpWorking = true;
                                });
                                final SharedPreferences prefs = await _prefs;
                                String token = prefs.getString('token');

                                var url = APIUrl().createExpense();
                                var request = http.MultipartRequest("POST", url);
                                request.headers['authorization'] = token;
                                request.headers['accept'] = 'application/json';
                                request.fields['date'] =
                                    DateFormat("dd-MM-yyyy").format(DateTime.parse(_dateTimeStart));
                                if (_amountController.text.length > 0)
                                  request.fields['total_price'] = _amountController.text;
                                if (_noteController.text.length > 0)
                                  request.fields['description'] = _noteController.text;
                                if (_siteNameController.text.length > 0)
                                  request.fields['site_name'] = _siteNameController.text;
                                if (_dropdownExpenseCategoryItem != null)
                                  request.fields['category_id'] = _dropdownExpenseCategoryItem.toString();
                                if (_dropdownCustomerItem != null)
                                  request.fields['customer_id'] = _dropdownCustomerItem.toString();
                                if (_dropdownProjectItem != null)
                                  request.fields['product_id'] = _dropdownProjectItem.toString();
                                if (pickedFile != null)
                                  request.files.add(
                                    await http.MultipartFile.fromPath(
                                      'images',
                                      pickedFile.path,
                                      contentType: MediaType('image', 'jpeg'),
                                    ),
                                  );
                                request.send().then((response) {
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
                                });
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
