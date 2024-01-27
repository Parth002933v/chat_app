import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class MyDateUtils {
  static String getFormatedTimeInHours(String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return formatDate(
      date,
      [hh, ':', nn, ' ', am],
    );
  }

  static String getFormatedTimeInDate(String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return formatDate(
      date,
      [dd, '/', mm, '/', yyyy],
    );
  }
}
