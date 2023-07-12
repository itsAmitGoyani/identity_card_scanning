import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:identity_card_scanning/models/entry_receipt_model.dart';
import 'package:identity_card_scanning/models/login_model.dart';
import 'package:identity_card_scanning/resources/api_repository.dart';

part 'entry_event.dart';

part 'entry_state.dart';

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  EntryBloc() : super(EntryInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<SendEntryRequest>((event, emit) async {
      emit(EntryLoading());
      final responseModel = await _apiRepository.sendEntryRequest(
        departmentId: event.departmentId,
        mobileNumber: event.mobileNumber,
        name: event.name,
        gender: event.gender,
        address: event.address,
        cnic: event.cnic,
        vehicle: event.vehicle,
        children: event.children,
        dateOfBirth: event.dateOfBirth,
        dateOfIssue: event.dateOfIssue,
        dateOfExpiry: event.dateOfExpiry,
      );
      if (responseModel.data != null) {
        emit(EntryLoaded(responseModel.data!));
      } else {
        emit(EntryError(responseModel.error));
      }
    });
  }
}
