part of 'entry_bloc.dart';

abstract class EntryState extends Equatable {
  const EntryState();

  @override
  List<Object?> get props => [];
}

class EntryInitial extends EntryState {}

class EntryLoading extends EntryState {}

class EntryLoaded extends EntryState {
  final EntryReceiptModel response;

  const EntryLoaded(this.response);
}

class EntryError extends EntryState {
  final String error;

  const EntryError(this.error);
}
