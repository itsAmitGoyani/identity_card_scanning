import 'package:image_picker/image_picker.dart';
import 'package:identity_card_scanning/models/enums.dart';

class CnicModel {
  String _identityNumber = "";
  String _issueDate = "";
  String _holderName = "";
  String _expiryDate = "";
  String _dateOfBirth = "";
  Gender? _gender;

  String get identityNumber => _identityNumber;

  String get issueDate => _issueDate;

  String get holderName => _holderName;

  String get expiryDate => _expiryDate;

  String get dateOfBirth => _dateOfBirth;

  Gender? get gender => _gender;

  set dateOfBirth(String value) {
    _dateOfBirth = value;
  }

  set expiryDate(String value) {
    _expiryDate = value;
  }

  set holderName(String value) {
    _holderName = value;
  }

  set issueDate(String value) {
    _issueDate = value;
  }

  set identityNumber(String value) {
    _identityNumber = value;
  }

  set gender(Gender? value) {
    _gender = value;
  }
}
