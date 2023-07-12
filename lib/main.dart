import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:identity_card_scanning/screens/lobby.dart';
import 'package:identity_card_scanning/screens/login.dart';
import 'package:identity_card_scanning/util/color_constants.dart';
import 'package:identity_card_scanning/util/material_color_generator.dart';
import 'package:identity_card_scanning/util/shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      systemNavigationBarColor: primaryColor,
    ),
  );
  await initSharedPref();
  bool loggedIn = false;
  if (getRememberMe ?? false) {
    if (getAuthData != null) {
      loggedIn = true;
    }
  }
  runApp(MyApp(loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp(this.loggedIn, {super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        title: 'Identity Card Scanning',
        theme: ThemeData(
          primaryColor: primaryColor,
          primarySwatch: createMaterialColor(primaryColor),
        ),
        home: loggedIn ? const Lobby() : const Login(),
      ),
    );
  }
}
