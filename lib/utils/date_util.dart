
class DateUtil {

  static String formatDateCalendar(DateTime date) {// [dd/MM/yyyy]
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatDateMonth(DateTime date) {// [10 de jan]
    String result = "${date.day} de ";
    switch(date.month) {
      case 1:
        result += "jan";
        break;
      case 2:
        result += "fev";
        break;
      case 3:
        result += "mar";
        break;
      case 4:
        result += "abr";
        break;
      case 5:
        result += "mai";
        break;
      case 6:
        result += "jun";
        break;
      case 7:
        result += "jul";
        break;
      case 8:
        result += "ago";
        break;
      case 9:
        result += "set";
        break;
      case 10:
        result += "out";
        break;
      case 11:
        result += "nov";
        break;
      case 12:
        result += "dez";
        break;
    }
    return result;
  }

  static String getMonth(DateTime date) {
    switch(date.month) {
      case 1:
        return "Janeiro";
      case 2:
        return "Fevereiro";
      case 3:
        return "Março";
      case 4:
        return "Abril";
      case 5:
        return "Maio";
      case 6:
        return "Junho";
      case 7:
        return "Julho";
      case 8:
        return "Agosto";
      case 9:
        return "Setembro";
      case 10:
        return "Outubro";
      case 11:
        return "Novembro";
      case 12:
        return "Dezembro";
    }
  }

  static String formatDateMouthHour(DateTime date) {// [10 de jan às 20:05]
    return "${formatDateMonth(date)} às ${date.hour}:${date.minute}";
  }

  static String getNumberDay(DateTime date) {// [01]
    return date.day < 10 ? "0${date.day}" : date.day.toString();
  }

  static String getNumberMonth(DateTime date) {// [01]
    return date.month < 10 ? "0${date.month}" : date.month.toString();
  }

  static String getNumberYear(DateTime date) {// [1999]
    return date.year.toString();
  }

}