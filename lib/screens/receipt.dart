import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:identity_card_scanning/util/app_text_theme.dart';
import 'package:identity_card_scanning/util/color_constants.dart';
import 'package:identity_card_scanning/util/extensions.dart';
import 'package:identity_card_scanning/widgets/rectangle_button.dart';

class Receipt extends StatefulWidget {
  final String receiptId;

  const Receipt({required this.receiptId, Key? key}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  DateTime entryDateTime = DateTime.now();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 18.h,
                    ),
                    Text(
                      "Entry Receipt",
                      textAlign: TextAlign.center,
                      style: AppTextTheme.headline32,
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: QrImageView(
                              data: widget.receiptId,
                              version: QrVersions.auto,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Text(
                      widget.receiptId,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.headline24,
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Text(
                      "Entry Date: ${entryDateTime.toStandardDate()}",
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyText16,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Entry Time: ${entryDateTime.toStandardTime()}",
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyText16,
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                  ],
                ),
              ),
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
                        text: "Download/Share".toUpperCase(),
                        textColor: Colors.white,
                        buttonColor: primaryColor,
                        onPressed: () async {
                          var image = await screenshotController.capture();
                          if (image == null) {
                            Fluttertoast.showToast(
                                msg: "Unable to take screenshot.");
                            return;
                          }
                          try {
                            await Share.file("Entry Receipt",
                                "EntryReceipt.png", image.toList(), 'image/png',
                                text: "Entry Receipt"
                                    "\n\nReceipt ID: ${widget.receiptId}"
                                    "\nDate: ${entryDateTime.toStandardDate()}"
                                    "\nTime: ${entryDateTime.toStandardTime()}");
                            Fluttertoast.showToast(msg: "Shared successfully");
                          } catch (e) {
                            Fluttertoast.showToast(msg: "Something went wrong");
                          }
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
