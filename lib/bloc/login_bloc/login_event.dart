part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SendLoginRequest extends LoginEvent {
  final String userName, password;

  const SendLoginRequest({required this.userName, required this.password});
}
