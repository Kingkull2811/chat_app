class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();
  bool isShowingTerm = false;

  String? gpsInfo;
}
