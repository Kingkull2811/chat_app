import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsServices {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleCameraAndMicrophoneInvalidPermissions(
        cameraPermissionStatus,
        microphonePermissionStatus,
      );
      return false;
    }
  }

  static Future<bool> microphonePermissionsGranted() async {
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleMicrophoneInvalidPermissions(microphonePermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await Permission.camera.status;

    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus = {};
      permissionStatus[Permission.camera] = await Permission.camera.request();
      return permissionStatus[Permission.camera] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    PermissionStatus permission = await Permission.microphone.status;
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus = {};
      permissionStatus[Permission.microphone] =
          await Permission.microphone.request();
      return permissionStatus[Permission.microphone] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static void _handleCameraAndMicrophoneInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to camera and microphone denied",
        details: null,
      );
    } else if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
        details: null,
      );
    }
  }

  static void _handleMicrophoneInvalidPermissions(
    PermissionStatus microphonePermissionStatus,
  ) {
    if (microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to microphone denied",
        details: null,
      );
    } else if (microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
        details: null,
      );
    }
  }
}
