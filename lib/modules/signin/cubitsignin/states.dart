abstract class SignInState {}

class SignInInetialState extends SignInState {}

class SignInLodingState extends SignInState {}

class SignInSacsessState extends SignInState {
  late final String uId;
   SignInSacsessState({
    required this.uId,
  });
}

class SignInErorrState extends SignInState {
  final String error;

  SignInErorrState({required this.error});
}

class SignInIconState extends SignInState {}
