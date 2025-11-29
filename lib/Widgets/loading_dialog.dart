import 'package:flutter/material.dart';

///Show a loading indicator as a dialog
///
///* Use [LoadingDialog().show(BuildContext)] to display the dialog.
///
///* Use [LoadingDialog.view(BuildContext)] to display the dialog and have the
///control to pop the current loading dialog in the same context.
///use [LoadingDialog.pop(BuildContext)] to pop the current dialog.
///
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  ///Show the loading dialog in the current context.
  ///
  Future<void> show(BuildContext context) {
    return showDialog<void>(context: context, builder: (_) => this);
  }

  static bool _displayed = false;

  ///Show the loading dialog in the current context.
  ///
  static Future<void> view(BuildContext context, {bool? dismissable}) {
    _displayed = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: dismissable ?? true,
      builder: (_) => LoadingDialog(),
    );
  }

  ///Pop the loading dialog in the current context.
  ///
  static Future<bool> pop(BuildContext context) {
    if (!_displayed) return Future.value(false);
    _displayed = false;
    Navigator.maybePop(context);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      content: SizedBox.fromSize(
        size: Size(100, 50),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
