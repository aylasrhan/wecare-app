
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatelessWidget {
  final String appointmentId;
  final String userName;

  const VideoCallScreen({Key? key, required this.appointmentId, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 318131853, 
      appSign: "ffdf1935b7a2861419d231175d59cd6c4db4a09f342edca701fa280e7c01aff8",
      userID: "user_${DateTime.now().millisecondsSinceEpoch}",
      userName: userName,
      callID: appointmentId, 
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}