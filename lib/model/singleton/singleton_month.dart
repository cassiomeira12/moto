import '../month.dart';

class SingletonMonth {

  static final Month _instance = Month();

  static Month get instance => _instance;

}