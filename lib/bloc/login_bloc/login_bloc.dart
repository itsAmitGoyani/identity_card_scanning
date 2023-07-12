import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:identity_card_scanning/models/login_model.dart';
import 'package:identity_card_scanning/resources/api_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<SendLoginRequest>((event, emit) async {
      emit(LoginLoading());
      final responseModel = await _apiRepository.sendLoginRequest(
        userName: event.userName,
        password: event.password,
      );
      if (responseModel.data != null) {
        emit(LoginLoaded(responseModel.data!));
      } else {
        emit(LoginError(responseModel.error));
      }
    });
  }
}
