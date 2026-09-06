extension MyDateTime on DateTime {
  String readableFormat({bool? day, bool? month, bool? year}) {
    final List formattedDateTime = [];
    String dateTime = this.toString().split('.')[0];
    String date = dateTime.split(' ')[0];

    if (day == null || day) {
      String day = date.split('-')[2];
      if (day[0] == '0') {
        day = day.substring(1);
      }
      formattedDateTime.add(day);
    }
    if (month == null || month) {
      const List<String> Month = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'Juli',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

      String month = date.split('-')[1];
      if (month[0] == '0') {
        month = month.substring(1);
      }
      formattedDateTime.add(Month[int.parse(month) - 1]);
    }
    if (year == null || year) {
      String year = date.split('-')[0];
      formattedDateTime.add(year);
    }

    return formattedDateTime.join(' ');

    // String time = dateTime.split(' ').last;
  }
}
