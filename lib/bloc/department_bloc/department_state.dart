part of 'department_bloc.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<DepartmentModel> response;
  const DepartmentLoaded(this.response);
}

class DepartmentError extends DepartmentState {
  final String error;
  const DepartmentError(this.error);
}
