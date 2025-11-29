import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/utils.dart' hide Trans;
import 'package:utilities/utilities.dart';
import 'package:the_coach/Widgets/widgets.dart';

import 'package:the_coach/generated/locale_keys.g.dart';

class PasswordEditScreen extends StatefulWidget {
  const PasswordEditScreen({Key? key}) : super(key: key);

  @override
  _PasswordEditScreenState createState() => _PasswordEditScreenState();
}

class _PasswordEditScreenState extends State<PasswordEditScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _oldPasswordTextController;
  late final TextEditingController _newPasswordTextController;
  late final TextEditingController _newPasswordConfirmTextController;

  @override
  void initState() {
    _formKey = GlobalKey();
    _oldPasswordTextController = TextEditingController();
    _newPasswordTextController = TextEditingController();
    _newPasswordConfirmTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordTextController.dispose();
    _newPasswordTextController.dispose();
    _newPasswordConfirmTextController.dispose();
    super.dispose();
  }

  void _clearTextControllers() {
    _oldPasswordTextController.clear();
    _newPasswordTextController.clear();
    _newPasswordConfirmTextController.clear();
    FocusScope.of(context).unfocus();
  }

  void _performPasswordUpadate() {
    if (!_formKey.currentState!.validate()) return;
    final oldPassword = _oldPasswordTextController.text.trim();
    final newPassword = _newPasswordTextController.text.trim();
    final newPasswordConfirm = _newPasswordConfirmTextController.text.trim();
    final passwordUpdate = PasswordUpdate(
      oldPassword: oldPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirm,
    );
    context.read<UpdatePasswordCubit>().updateUserPassword(passwordUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdatePasswordCubit, UpdatePasswordState>(
      listener: (context, state) {
        if (state is UpdatePasswordFailed) {
          CSnackBar.failure(
            messageText: LocaleKeys.error_data_update_password.tr(),
          ).showWithoutContext();
          logError(state.e);
          _clearTextControllers();
        } else if (state is UpdateDataSucceeded) {
          Navigator.pop(context);
          CSnackBar.success(
            messageText: LocaleKeys.success_data_update_password.tr(),
            avoidNavigationBar: false,
          ).showWithoutContext();
        }
      },
      child: KeyboardDismissed(
        child: Scaffold(
          appBar: CAppBar(
            header: LocaleKeys.auth_password_recovery_change_password.tr(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: BlocBuilder<UpdatePasswordCubit, UpdatePasswordState>(
            builder: (context, state) {
              final isLoading = state is UpdatePasswordInProgress;
              return CustomButton(
                isLoading: isLoading,
                onPressed: _performPasswordUpadate,
                child: Text(LocaleKeys.general_titles_edit).tr(),
              );
            },
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: KEdgeInsets.h10,
              children: [
                _buildPasswordEditFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordEditFields() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CTextField(
              controller: _oldPasswordTextController,
              keyboardType: TextInputType.visiblePassword,
              title: LocaleKeys.auth_general_password.tr(),
              validator: (value) {
                if (isLengthLessThan(value, 6)) {
                  return LocaleKeys.auth_general_validation_invalid_password.tr();
                }
                return null;
              },
            ),
            CTextField(
              controller: _newPasswordTextController,
              keyboardType: TextInputType.visiblePassword,
              title: LocaleKeys.auth_password_recovery_new_password.tr(),
              validator: (value) {
                if (isLengthLessThan(value, 6)) {
                  return LocaleKeys.auth_general_validation_invalid_password.tr();
                }
                return null;
              },
            ),
            CTextField(
              controller: _newPasswordConfirmTextController,
              keyboardType: TextInputType.visiblePassword,
              title: LocaleKeys.auth_password_recovery_new_password_confirmation.tr(),
              validator: (value) {
                final _password = _newPasswordTextController.text.trim();
                if (_password != value!) {
                  return LocaleKeys.auth_general_validation_password_not_match.tr();
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
