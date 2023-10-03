part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class DoRegisterEvent extends RegisterEvent {
  final RegisterRequestModel model;

  DoRegisterEvent({required this.model});
}
