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
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(
      DateTime.parse(this ?? '').toUtc().add(const Duration(hours: 8)),
    );
  }

  String toDomainDeleteTimeString() {
    var date = DateTime.parse(this ?? '').toUtc();
    date = DateTime(date.year, date.month, date.day);
    final date1 = date.add(const Duration(days: 65));
    final date1String = DateFormat('yyyy-MM-dd').format(date1);
    final date2 = date.add(const Duration(days: 75));
    final date2String = DateFormat('yyyy-MM-dd').format(date2);

    return '北京时间$date1String或$date2String，凌晨2点到4点，仅供参考';
  }
}
