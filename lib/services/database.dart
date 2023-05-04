import 'package:flutter/material.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  GlobalKey? mainKey;
  GlobalKey? chatKey;
  GlobalKey? newsKey;
  GlobalKey? transcriptKey;
  GlobalKey? profileKey;
  bool isShowingTerm = false;

  String? gpsInfo;
}
