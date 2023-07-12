import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_watermark/image_watermark.dart';

class WatermarkService {
  static Future<Uint8List> addTextWatermark({required Uint8List image}) async {
    return await ImageWatermark.addTextWatermark(
      imgBytes: image,
      watermarkText: 'Scanned by ICS',
      dstX: 20,
      dstY: 20,
      color: Colors.black,
    );
  }
}
