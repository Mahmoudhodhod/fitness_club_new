import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Screens/General/Settings/PersonalInfo/password_edit.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class PersonalInfoEditScreen extends StatefulWidget {
  const PersonalInfoEditScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoEditScreenState createState() => _PersonalInfoEditScreenState();
}

class _PersonalInfoEditScreenState extends State<PersonalInfoEditScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameTextController;
  late final TextEditingController _emailController;
  File? _userImage;

  late final User currentUser;

  @override
  void initState() {
    _formKey = GlobalKey();
    currentUser = context.read<FetchDataCubit>().state.user;
    _nameTextController = TextEditingController(text: currentUser.name);
    _emailController = TextEditingController(text: currentUser.email);
    super.initState();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _pickUserImage() async {
    try {
      final _images =
          await MediaController.instance.openSheetAndPickImage(context);
      if (_images == null) return;
      setState(() {
        _userImage = _images.first;
      });
    } catch (e, stacktrace) {
      appLogger.e("Error while picking user image", e, stacktrace);
    }
  }

  void _performDataUpdate() {
    final emailStr = _emailController.text.trim();
    final nameStr = _nameTextController.text.trim();
    final isSameEmail = emailStr.contains(currentUser.email);
    final isSameName = nameStr == currentUser.name;

    final newUser = UserUpdate(
      email: emailStr.isEmpty || isSameEmail ? null : emailStr,
      name: nameStr.isEmpty || isSameName ? null : nameStr,
      image: _userImage,
    );
    context.read<UpdateDataCubit>().updateUserData(newUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateDataCubit, UpdateDataState>(
      listener: (context, state) {
        if (state is UpdateDataFailed) {
          CSnackBar.failure(
            messageText: LocaleKeys.error_data_update_personal_info.tr(),
          ).showWithoutContext();
          logError(state.e);
        } else if (state is UpdateDataSucceeded) {
          Navigator.pop(context);
          CSnackBar.success(
            messageText: LocaleKeys.success_data_update_personal_info.tr(),
          ).showWithoutContext();
        }
      },
      child: KeyboardDismissed(
        child: Scaffold(
          appBar: CAppBar(actions: [
            if (!currentUser.isSocialAccount)
              _buildPasswordUpdateTextButton(context),
          ]),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: BlocBuilder<UpdateDataCubit, UpdateDataState>(
            builder: (context, state) {
              final isLoading = state is UpdateDataInProgress;
              return CustomButton(
                onPressed: _performDataUpdate,
                isLoading: isLoading,
                child: Text(LocaleKeys.general_titles_edit).tr(),
              );
            },
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: KEdgeInsets.h10 + const EdgeInsets.only(top: 10),
                children: [
                  GestureDetector(
                    onTap: _pickUserImage,
                    child: _buildUserAvatar(),
                  ),
                  Space.v20(),
                  _buildDataViewFields(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    final ImageProvider image;
    if (_userImage != null) {
      image = FileImage(_userImage!);
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: CColors.fancyBlack,
          shape: BoxShape.circle,
          image: DecorationImage(image: image),
        ),
      );
    }
    return CCircleAvatar(
      radius: 50,
      url: currentUser.profileImagePath,
    );
  }

  Widget _buildPasswordUpdateTextButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => PasswordEditScreen()));
      },
      icon: Icon(Icons.vpn_key, color: CColors.secondary(context), size: 17),
      label: Text(
        LocaleKeys.auth_password_recovery_change_password.tr(),
        style: theme(context).textTheme.labelLarge?.copyWith(fontSize: 11),
      ),
    );
  }

  Widget _buildDataViewFields() {
    return Center(
      child: Padding(
        padding: KEdgeInsets.h10,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 3.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CTextField(
                  enabled: !currentUser.isSocialAccount,
                  controller: _nameTextController,
                  title: LocaleKeys.auth_general_name.tr(),
                  validator: (value) {
                    if (!isLengthLessThan(value, 4)) {
                      return LocaleKeys.auth_general_validation_required_field
                          .tr();
                    }
                    return null;
                  },
                ),
                Space.v5(),
                CTextField(
                  enabled: false,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  title: LocaleKeys.auth_general_email.tr(),
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return LocaleKeys.auth_general_validation_invalid_email
                          .tr();
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
