import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:identity_card_scanning/screens/exit.dart';
import 'package:identity_card_scanning/util/app_text_theme.dart';
import 'package:identity_card_scanning/widgets/rectangle_button.dart';

const Color scaffoldColor = Color(0xFF464646);

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<StatefulWidget> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey();
  bool isFlashOn = false;
  QRViewController? controller;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      reassemble();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      Fluttertoast.showToast(msg: 'no Permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cutOffSize = screenWidth * 0.70;
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              overlayColor: Colors.black.withOpacity(0.8),
              borderColor: Theme.of(context).primaryColor,
              borderRadius: 16,
              borderLength: (cutOffSize / 2) + 10,
              borderWidth: 5,
              cutOutSize: cutOffSize,
            ),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: const BackButton(
                    color: Colors.white,
                  ),
                  actions: [
                    IconButton(
                      splashRadius: 26,
                      icon: Icon(
                        isFlashOn ? Icons.flash_off : Icons.flash_on,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {
                          isFlashOn = !isFlashOn;
                        });
                      },
                    ),
                    // IconButton(
                    //   splashRadius: 26,
                    //   icon: Icon(
                    //     Icons.insert_photo,
                    //     color: Colors.white,
                    //   ),
                    //   onPressed: () async {
                    //     final pickedimage = await ImagePicker()
                    //         .getImage(source: ImageSource.gallery);
                    //     if (pickedimage != null) {}
                    //   },
                    // ),
                    const SizedBox(width: 10),
                  ],
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Scan QR code of the entry receipt",
                    textAlign: TextAlign.center,
                    style: AppTextTheme.bodyText20.copyWith(
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "Identity Card Scanning",
                      style:
                          AppTextTheme.headline24.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      if (scanData.format == BarcodeFormat.qrcode) {
        try {
          final scannedData = scanData.code;
          if (scannedData == null) {
            Fluttertoast.showToast(msg: "Something went wrong");
          } else {
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => Exit(receiptId: scannedData),
                ));
          }
        } on FormatException catch (e) {
          if (!mounted) return;
          Fluttertoast.showToast(msg: e.message);
        } catch (e) {
          if (!mounted) return;
          Fluttertoast.showToast(msg: "Something went wrong");
        }
      } else {
        await showQrCodeNotValidDialog(context: context);
      }
      controller.resumeCamera();
    });
  }
}

Future<bool?> showQrCodeNotValidDialog({required BuildContext context}) async {
  return await showDialog(
    context: context,
    builder: (_) => SimpleDialog(
      contentPadding: const EdgeInsets.all(20.0),
      title: const Icon(
        Icons.help_outline,
        color: Colors.red,
        size: 35,
      ),
      children: [
        Text(
          "This QR code is invalid",
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyText16.copyWith(color: Colors.red),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            RectangleButton(
              text: "Ok",
              buttonColor: Colors.red,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    ),
  );
}
