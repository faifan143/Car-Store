abstract class SiginUpState {}

class SiginUpInetialState extends SiginUpState {}

class SiginUpLodingState extends SiginUpState {}

class SiginUpSacsessState extends SiginUpState {

}

class SiginUpErorrState extends SiginUpState {
 late final String error;

  SiginUpErorrState({required this.error});
}

class SiginUpCreetSacsessState extends SiginUpState {
  
late final String uId;
  SiginUpCreetSacsessState({
    required this.uId,
  });
}

class SiginUpCreetErorrState extends SiginUpState {}

class SiginUpIconState extends SiginUpState {}
