import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomButton {
  Widget button({
    @required VoidCallback onPressed,
    @required Widget child,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 51,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(0, 114, 144, 1),
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              child: child,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
