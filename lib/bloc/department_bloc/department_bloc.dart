import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:identity_card_scanning/models/department_model.dart';
import 'package:identity_card_scanning/models/login_model.dart';
import 'package:identity_card_scanning/resources/api_repository.dart';

part 'department_event.dart';

part 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  DepartmentBloc() : super(DepartmentInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<GetDepartments>((event, emit) async {
      emit(DepartmentLoading());
      final responseModel = await _apiRepository.getDepartments();
      if (responseModel.data != null) {
        emit(DepartmentLoaded(responseModel.data!));
      } else {
        emit(DepartmentError(responseModel.error));
      }
    });
  }
}
