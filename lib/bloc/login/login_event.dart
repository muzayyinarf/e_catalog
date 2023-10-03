part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class DoLoginEvent extends LoginEvent {
  final LoginRequestModel model;

  DoLoginEvent({required this.model});
}
