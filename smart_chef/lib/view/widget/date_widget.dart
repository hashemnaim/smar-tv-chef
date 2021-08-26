import 'package:flutter/cupertino.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/consts.dart';

class DateWidget extends StatelessWidget {
  final DateTime date;

  const DateWidget({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          getDayName(),
          style: TextStyle(
            color: grey484B4E,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        Text(
          getDayNumMonthCombo(),
          style: TextStyle(
            color: grey484B4E,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String getDayName() {
    return '${days[date.weekday - 1]}';
  }

  String getDayNumMonthCombo() {
    return '${date.day} ${months[date.month - 1]}';
  }
}
