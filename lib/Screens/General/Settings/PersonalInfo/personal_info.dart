import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/clipboard.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Screens/Auth/login.dart';
import 'package:the_coach/Screens/Helpers/fade_page_route.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'edit_personal_info.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteUserCubit(context.read()),
      child: const _PersonalInfoView(),
    );
  }
}

class _PersonalInfoView extends StatelessWidget {
  const _PersonalInfoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteUserCubit, DeleteUserState>(
      listener: (context, state) async {
        if (state.isDeleted) {
          await IAPController.get(context).logout();
          Navigator.pushAndRemoveUntil(
            context,
            FadePageRoute(builder: (_) => LogInScreen()),
            (route) => false,
          );
        } else if (state.isFailed) {
          Navigator.pop(context);
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .showWithoutContext();
        }
      },
      child: Scaffold(
        appBar: CAppBar(header: LocaleKeys.drawer_settings_personal_info.tr()),
        floatingActionButton: Padding(
          padding:
              const EdgeInsets.only(bottom: kBottomNavigationBarHeight / 3),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => PersonalInfoEditScreen()),
              );
            },
            child: const Icon(Icons.edit),
          ),
        ),
        body: SafeArea(
          child: const _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((FetchDataCubit cubit) => cubit.state.user);
    return ListView(
      padding: KEdgeInsets.h10 + const EdgeInsets.only(top: 10),
      children: [
        CCircleAvatar(
          radius: 50,
          url: user.profileImagePath,
        ),
        Space.v20(),
        _buildDataViewFields(user),
        Space.v20(),
        if (!user.isAdmin && Platform.isIOS) ...[
          UnconstrainedBox(
            child: TextButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => _DeleteAccountDialog(),
                );
                if (result == null || !result) return;
                context.read<DeleteUserCubit>().deleteUser();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: Theme.of(context).textTheme.bodySmall,
              ),
              child: Text(LocaleKeys.auth_delete_account_title.tr()),
            ),
          )
        ],
      ],
    );
  }

  Widget _buildDataViewFields(User user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CTextField(
              enabled: false,
              initialValue: user.name,
              title: LocaleKeys.auth_general_name.tr(),
            ),
            Space.v5(),
            GestureDetector(
              onLongPress: () => copyToClipboard(user.email),
              child: CTextField(
                enabled: false,
                initialValue: user.email,
                title: LocaleKeys.auth_general_email.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({Key? key}) : super(key: key);

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  bool _canDelete = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: Text(LocaleKeys.auth_delete_account_are_you_sure.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(LocaleKeys.auth_delete_account_are_you_sure_desc.tr()),
          const Space.v15(),
          Countdown(
            seconds: 10,
            interval: Duration(seconds: 1),
            onFinished: () {
              _canDelete = true;

              if (mounted) setState(() {});
            },
            build: (context, time) {
              int _minutes = time >= 60 ? (time / 60).round() : 0;
              int _seconds = (time - _minutes * 60).round();
              return Text(
                "$_minutes:${_seconds < 10 ? 0 : ''}${_seconds.toInt()}",
                style: theme(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
              );
            },
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: !_canDelete ? null : () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          child: Text(LocaleKeys.auth_delete_account_delete.tr()),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            visualDensity: VisualDensity.comfortable,
            foregroundColor:
                CColors.nullableSwitchable(context, dark: Colors.black),
            backgroundColor: CColors.primary(context),
          ),
          child: Text(LocaleKeys.general_titles_cancel.tr()),
        ),
      ],
    );
  }
}
