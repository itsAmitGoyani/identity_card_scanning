part of 'entry_bloc.dart';

abstract class EntryEvent extends Equatable {
  const EntryEvent();

  @override
  List<Object> get props => [];
}

class SendEntryRequest extends EntryEvent {
  final String departmentId, mobileNumber, name, gender, address, cnic;
  final String? vehicle;
  final int? children;
  final DateTime dateOfBirth, dateOfIssue, dateOfExpiry;

  const SendEntryRequest({
    required this.departmentId,
    required this.mobileNumber,
    required this.name,
    required this.gender,
    required this.address,
    required this.cnic,
    required this.vehicle,
    required this.children,
    required this.dateOfBirth,
    required this.dateOfIssue,
    required this.dateOfExpiry,
  });
}
