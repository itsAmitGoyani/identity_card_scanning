import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:identity_card_scanning/util/app_text_theme.dart';
import 'package:identity_card_scanning/util/color_constants.dart';
import 'package:identity_card_scanning/widgets/rectangle_button.dart';

class Exit extends StatefulWidget {
  final String receiptId;
  const Exit({required this.receiptId, Key? key}) : super(key: key);

  @override
  State<Exit> createState() => _ExitState();
}

class _ExitState extends State<Exit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exit from Department"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 18.h,
                ),
                Text(
                  "Scanned Receipt Id",
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyText16,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  widget.receiptId,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.headline24,
                ),
                SizedBox(
                  height: 18.h,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, primaryColor.withOpacity(0.5)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RectangleButton(
                        isLoading: false,
                        text: "Save".toUpperCase(),
                        textColor: Colors.white,
                        buttonColor: primaryColor,
                        onPressed: () async {
                          Fluttertoast.showToast(msg: "Saved successfully");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
