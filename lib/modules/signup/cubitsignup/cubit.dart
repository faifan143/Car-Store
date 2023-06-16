import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carent/modules/signup/cubitsignup/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/siginup_model/users_model.dart';
import '../../../shared/componants/snackbar.dart';

class SigningUpCubit extends Cubit<SiginUpState> {
  SigningUpCubit() : super(SiginUpInetialState());

  static SigningUpCubit get(context) => BlocProvider.of(context);
  late UsersModel model;

  Future<void> userSigningUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(SiginUpLodingState());

    // Check if user with the given email already exists
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        emit(SiginUpErorrState(
            error: 'User with this email already exists. Please try again.'));
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code != 'user-not-found') {
        emit(SiginUpErorrState(error: e.toString()));
        return;
      }
    }
    // Create new user and send verification email
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user!.sendEmailVerification();
      userCreate(
        name: name,
        phone: phone,
        email: email,
      );
      snackBar(
          context: context,
          title: "Congrats !",
          body: "Signed up successfully check your email to verify it ..",
          contentType: ContentType.success);
      emit(SiginUpSacsessState());
    } on FirebaseAuthException catch (e) {
      emit(SiginUpErorrState(error: e.toString()));
    }
  }

  Future<void> userCreate({
    required String name,
    required String phone,
    required String email,
  }) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc();

    model = UsersModel(
        email: email,
        name: name,
        phone: phone,
        uId: docRef.id,
        image:
            'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png');

    docRef.set(model.tomap()).then((value) {
      emit(SiginUpCreetSacsessState(uId: docRef.id));
    }).catchError((error) {
      print(error.toString());
      emit(SiginUpCreetErorrState());
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_off_outlined;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SiginUpIconState());
  }
}
