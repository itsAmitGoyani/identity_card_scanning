import 'package:identity_card_scanning/models/department_model.dart';
import 'package:identity_card_scanning/models/entry_receipt_model.dart';
import 'package:identity_card_scanning/models/login_model.dart';
import 'package:identity_card_scanning/resources/api_response.dart';

import 'api_provider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<ApiResponse<LoginModel>> sendLoginRequest({
    required String userName,
    required String password,
  }) {
    return _provider.sendLoginRequest(userName: userName, password: password);
  }

  Future<ApiResponse<List<DepartmentModel>>> getDepartments() {
    return _provider.getDepartments();
  }

  Future<ApiResponse<EntryReceiptModel>> sendEntryRequest({
    required String departmentId,
    required String mobileNumber,
    required String name,
    required String gender,
    required String address,
    required String cnic,
    required String? vehicle,
    required int? children,
    required DateTime dateOfBirth,
    required DateTime dateOfIssue,
    required DateTime dateOfExpiry,
  }) {
    return _provider.sendEntryRequest(
      departmentId: departmentId,
      mobileNumber: mobileNumber,
      name: name,
      gender: gender,
      address: address,
      cnic: cnic,
      vehicle: vehicle,
      children: children,
      dateOfBirth: dateOfBirth,
      dateOfIssue: dateOfIssue,
      dateOfExpiry: dateOfExpiry,
    );
  }
}

class NetworkError extends Error {}
