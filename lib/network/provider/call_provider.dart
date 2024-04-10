import 'dart:async';
import 'dart:convert';

import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

import '../api/api_path.dart';
import '../model/call_cubit_model.dart';

class CallApi with ProviderMixin {
  String callsCollection = 'calls_collection';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      listenToInComingCall() {
    return _firestore
        .collection(callsCollection)
        .where('receiverId',
            isEqualTo: SharedPreferencesStorage().getUserId().toString())
        .snapshots()
        .listen((event) {});
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listenToCallStatus(
      {required String callId}) {
    return _firestore
        .collection(callsCollection)
        .doc(callId)
        .snapshots()
        .listen((event) {});
  }

  Future<void> postCallToFirestore({required CallCubitModel callModel}) {
    return _firestore
        .collection(callsCollection)
        .doc(callModel.id)
        .set(callModel.toMap());
  }

  Future<void> updateUserBusyStatusFirestore(
      {required CallCubitModel callModel, required bool busy}) {
    Map<String, dynamic> busyMap = {'busy': busy};
    return _firestore
        .collection(AppConstants.userCollection)
        .doc('user_id_${callModel.callerId}')
        .update(busyMap)
        .then((value) {
      _firestore
          .collection(AppConstants.userCollection)
          .doc('user_id_${callModel.receiverId}')
          .update(busyMap);
    });
  }

  //Sender
  Future<dynamic> generateCallToken({
    required String channelName,
    required String uid,
  }) async {
    try {
      final String tokenUrl = join(
        ApiPath.agoraServerDomain,
        'rtc',
        channelName,
        'publisher/uid',
        uid,
      );
      final response = await dio.get(tokenUrl);
      debugPrint('fireVideoCallResp: ${response.data}');
      if (response.statusCode == 200) {
        return jsonDecode(response.data)['rtcToken'];
      } else {
        throw Exception(
            'Error: ${response.data} Status Code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint("fireVideoCallError: ${error.toString()}");
    }
  }

  Future<void> updateCallStatus(
      {required String callId, required String status}) {
    return _firestore
        .collection(callsCollection)
        .doc(callId)
        .update({'status': status});
  }

  Future<void> endCurrentCall({required String callId}) {
    return _firestore
        .collection(callsCollection)
        .doc(callId)
        .update({'current': false});
  }
}
