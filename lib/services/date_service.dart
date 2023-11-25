import 'package:intl/intl.dart';

class DateService {

  static String format(DateTime now) {
    return DateFormat('dd/MM/yyyy - HH:mm').format(now);;
  }

}