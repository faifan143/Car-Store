import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import '../styles/icon_brokin.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.black,
  bool isUpperCase = true,
  double radius = 12,
  required Function function,
  required String text,
  TextStyle stylee = const TextStyle(
    color: Colors.white,
  ),
}) =>
    Container(
      width: width,
      height: 45.0,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(isUpperCase ? text.toUpperCase() : text, style: stylee),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultTextButton({
  required BuildContext context,
  required String label,
  required Function onTap,
  double size = 14,
  double? width,
  double? height,
  Color? color,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        onPressed: () {
          onTap();
        },
        child: Text(
          label,
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: 18, color: Colors.white, fontFamily: 'jannah'),
        ),
      ),
    );
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  GestureTapCallback? onTap,
  bool isPassword = false,
  required FormFieldValidator<String>? validate,
  String? label,
  String? hint,
  IconData? prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
  bool readOnly = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

ShowTost({
  required String text,
  required ToastState state,
}) {
  Fluttertoast.showToast(
    msg: text,
    gravity: ToastGravity.BOTTOM,
    textColor: Colors.white,
    backgroundColor: choseColorToast(state),
    toastLength: Toast.LENGTH_SHORT,
  );
}

enum ToastState { SUCCESS, ERROR, WRINING }

Color choseColorToast(state) {
  late Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WRINING:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget textFormFields({
  required String valueKey,
  required TextEditingController controller,
  required bool enabled,
  required Function function,
  required int maxlength,
  required TextInputType type,
  FormFieldValidator<String>? validation,
  IconData? sufix,
  Function? suffixPressed,
  String? label,
}) {
  return InkWell(
    onTap: () {
      function();
    },
    child: TextFormField(
      controller: controller,
      validator: validation,
      enabled: enabled,
      key: ValueKey(valueKey),
      style: const TextStyle(
          color: Colors.black87,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          fontFamily: 'jannah'),
      maxLines: 1,
      maxLength: maxlength,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
        suffix: Icon(sufix),
        filled: true,
        fillColor: Colors.white,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

AppBar defultAppBar({
  required BuildContext context,
  String? titel,
  List<Widget>? acttin,
}) =>
    AppBar(
      elevation: 0.0,
      backgroundColor: HexColor('48C9B0'),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // ZoomDrawer.of(context)!.toggle();
          },
          icon: Icon(IconBroken.Arrow___Left_2)),
      titleSpacing: 5,
      // title:Text(titel!),
      actions: acttin,
    );
Widget myDivider() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 1,
        color: Colors.grey.shade300,
      ),
    );
