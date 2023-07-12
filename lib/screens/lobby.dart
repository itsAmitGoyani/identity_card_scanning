import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:identity_card_scanning/screens/activity_log.dart';
import 'package:identity_card_scanning/screens/enter.dart';
import 'package:identity_card_scanning/screens/login.dart';
import 'package:identity_card_scanning/screens/scan_qr.dart';
import 'package:identity_card_scanning/util/app_text_theme.dart';
import 'package:identity_card_scanning/util/color_constants.dart';
import 'package:identity_card_scanning/util/shared_preference.dart';
import 'package:identity_card_scanning/widgets/rectangle_button.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  final _fromKey = GlobalKey<FormState>();

  final String username = getUsername ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
                SizedBox(
                  height: 25.0.h,
                ),
                Text(
                  "Hi, $username!",
                  style: AppTextTheme.headline24,
                ),
                const Expanded(flex: 2, child: SizedBox()),
                Text(
                  "What would you like to do?",
                  style: AppTextTheme.bodyText18,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: RectangleButton(
                        isLoading: false,
                        text: "Enter".toUpperCase(),
                        textColor: Colors.white,
                        buttonColor: primaryColor,
                        onPressed: () async {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const Enter()),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Expanded(
                      child: RectangleButton(
                        isLoading: false,
                        text: "Exit".toUpperCase(),
                        textColor: Colors.white,
                        buttonColor: primaryColor,
                        onPressed: () async {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const ScanQR()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Expanded(flex: 3, child: SizedBox()),
                RectangleButton(
                  isLoading: false,
                  text: "Activity Log\nReports".toUpperCase(),
                  textColor: Colors.white,
                  buttonColor: primaryColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const ActivityLog()),
                    );
                  },
                ),
                SizedBox(
                  height: 40.h,
                ),
                Text.rich(
                  TextSpan(
                    text: "Log Out",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await removeAuthData();
                        await removeUsername();
                        Fluttertoast.showToast(msg: "Logged out successfully");
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                    style: AppTextTheme.bodyText20
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
