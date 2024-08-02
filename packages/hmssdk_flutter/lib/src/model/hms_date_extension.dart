///100ms HMSDateExtension
///
///[HMSDateExtension] is used to convert android and ios native time format to DateTime type
///in local time zone format.

///Dart imports
import 'dart:developer';
import 'package:intl/intl.dart';

class HMSDateExtension {
  ///Returns DateTime object from String
  DateTime convertDateFromString(String date) {
    try {
      DateTime _dateTime = DateTime.parse(date).toLocal();
      return _dateTime;
    } catch (e) {
      DateFormat format = DateFormat("yyyy-MM-dd h:mm:ss a Z");
      return format.parse(date.replaceAll('\u202F', ' '));
    }
  }

  ///Returns optional DateTime object from epoch in milliseconds
  static DateTime? convertDateFromEpoch(int date) {
    try {
      DateTime _dateTime =
          DateTime.fromMillisecondsSinceEpoch(date, isUtc: false);
      return _dateTime;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
