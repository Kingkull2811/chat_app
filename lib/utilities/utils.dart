import 'package:chat_app/utilities/enum/biometrics_button_type.dart';

String getBiometricsButtonPath({BiometricButtonType? buttonType,}){
  if(buttonType == BiometricButtonType.face){
    return 'assets/images/ic_face_id.png';
  }
  if(buttonType == BiometricButtonType.touch){
    return 'assets/images/ic_touch_id.png';
  }
  return 'assets/images/ic_face_touch_id.png';
}