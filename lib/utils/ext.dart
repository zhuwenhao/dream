import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toRfc822String() {
    var str = DateFormat('EEE, dd MMM yyyy HH:mm:ss').format(this);
    if (isUtc) {
      str = '$str GMT';
    } else {
      final offset = toLocal().timeZoneOffset.inHours * 100;
      str = '$str +${offset < 1000 ? '0' : ''}$offset';
    }

    return str;
  }
}

extension StringExtension on String? {
  String toBeijingTimeString() {
    return DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime.parse(this ?? '').add(const Duration(hours: 8)));
  }
}
