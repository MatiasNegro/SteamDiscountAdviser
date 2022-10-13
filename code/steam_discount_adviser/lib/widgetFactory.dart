import 'package:flutter/material.dart';

class WidgetFactory {
  Widget styledCircularIndicator() {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey,
        ),
        child: const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        )));
  }
}
