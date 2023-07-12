import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:identity_card_scanning/models/cnic_model.dart';
import 'package:identity_card_scanning/models/enums.dart';

class CnicScanner {
  /// it will check the image source
  late ImageSource source;

  /// a model class to store cnic data
  CnicModel _cnicDetails = CnicModel();

  /// this var track record which side has been scanned
  /// and which needed to be scanned and prompt user accordingly
  bool isFrontScan = false;

  /// this method will process the images and extract information from the card
  Future<CnicModel> scanCnic({required String filePath}) async {
    var imageToScan = InputImage.fromFilePath(filePath);
    List<String> cnicDates = [];
    GoogleMlKit.vision.languageModelManager();
    TextDetector textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(imageToScan);
    bool isNameNext = false;
    bool isGenderNext = false;
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        if (isNameNext) {
          _cnicDetails.holderName = line.text;
          isNameNext = false;
        }
        if (line.text.toLowerCase() == "name" ||
            line.text.toLowerCase() == "nane" ||
            line.text.toLowerCase() == "nam" ||
            line.text.toLowerCase() == "ame") {
          isNameNext = true;
        }
        for (TextElement element in line.elements) {
          String selectedText = element.text;
          if (isGenderNext) {
            if (selectedText == "M") {
              _cnicDetails.gender = Gender.male;
            } else if (selectedText == "F") {
              _cnicDetails.gender = Gender.female;
            }
          }
          if (selectedText.length == 15 &&
              selectedText.contains("-", 5) &&
              selectedText.contains("-", 13)) {
            _cnicDetails.identityNumber = selectedText;
          } else if (selectedText.length == 10 &&
              ((selectedText.contains("/", 2) &&
                      selectedText.contains("/", 5)) ||
                  (selectedText.contains(".", 2) &&
                      selectedText.contains(".", 5)))) {
            cnicDates.add(selectedText.replaceAll(".", "/"));
          }
        }
        if (line.text.toLowerCase().contains("gender")) {
          isGenderNext = true;
        }
      }
    }
    if (cnicDates.isNotEmpty &&
        _cnicDetails.expiryDate.length == 10 &&
        !cnicDates.contains(_cnicDetails.expiryDate)) {
      cnicDates.add(_cnicDetails.expiryDate);
    }
    if (cnicDates.isNotEmpty &&
        _cnicDetails.issueDate.length == 10 &&
        !cnicDates.contains(_cnicDetails.issueDate)) {
      cnicDates.add(_cnicDetails.issueDate);
    }
    if (cnicDates.isNotEmpty &&
        _cnicDetails.expiryDate.length == 10 &&
        !cnicDates.contains(_cnicDetails.expiryDate)) {
      cnicDates.add(_cnicDetails.expiryDate);
    }
    if (cnicDates.length > 1) {
      cnicDates = sortDateList(dates: cnicDates);
    }
    if (cnicDates.length == 1 && _cnicDetails.dateOfBirth.length != 10) {
      _cnicDetails.dateOfBirth = cnicDates[0];
      // isFrontScan = true;
      // Fluttertoast.showToast(
      //     msg: "Scan Back Side Now",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.grey,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    } else if (cnicDates.length == 2) {
      _cnicDetails.issueDate = cnicDates[0];
      _cnicDetails.expiryDate = cnicDates[1];
      // if (!isFrontScan) {
      //   Fluttertoast.showToast(
      //       msg: "Scan Front Side Now",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       backgroundColor: Colors.grey,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // }
    } else if (cnicDates.length == 3) {
      _cnicDetails.dateOfBirth = cnicDates[0].replaceAll(".", "/");
      _cnicDetails.issueDate = cnicDates[1].replaceAll(".", "/");
      _cnicDetails.expiryDate = cnicDates[2].replaceAll(".", "/");
    }
    textDetector.close();
    return _cnicDetails;
  }

  /// it will sort the dates
  static List<String> sortDateList({required List<String> dates}) {
    List<DateTime> tempList = [];
    DateFormat format = DateFormat("dd/MM/yyyy");
    for (int i = 0; i < dates.length; i++) {
      tempList.add(format.parse(dates[i]));
    }
    tempList.sort((a, b) => a.compareTo(b));
    dates.clear();
    for (int i = 0; i < tempList.length; i++) {
      dates.add(format.format(tempList[i]));
    }
    return dates;
  }
}
