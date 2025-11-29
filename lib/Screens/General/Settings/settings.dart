import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:the_coach/Helpers/app_rating.dart';
import 'package:the_coach/app.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/localization_utilities.dart';
import 'package:the_coach/Helpers/network.dart';
import 'package:the_coach/Helpers/theme_notifier.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import '../Subscriptions/my_subscriptions.dart';
import 'PersonalInfo/personal_info.dart';
import 'credits.dart';
import 'font_scale.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<FetchDataCubit>().state.user;
    return Scaffold(
      appBar: CAppBar(header: LocaleKeys.drawer_settings_title.tr()),
      body: SafeArea(
        child: Column(
          children: [
            if (currentUser.isLoggedIn) ...[
              TitleListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PersonalInfoScreen()),
                  );
                },
                trailing: const SizedBox.shrink(),
                leading: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 5),
                  child: Icon(FontAwesomeIcons.user,
                      size: 20, color: CColors.primary(context)),
                ),
                title: LocaleKeys.drawer_settings_personal_info.tr(),
              ),
              const Divider(),
              if (!currentUser.isAdmin) ...[
                TitleListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => MySubscription())),
                  trailing: const SizedBox.shrink(),
                  leading: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 5),
                    child: Icon(FontAwesomeIcons.star,
                        size: 20, color: CColors.primary(context)),
                  ),
                  title: LocaleKeys.payment_general_subscriptions.tr(),
                ),
                const Divider(),
              ],
            ],

            _buildThemeChange(),
            const Divider(),
            TitleListTile(
              onTap: () => _changeLang(context),
              trailing: const SizedBox.shrink(),
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: Icon(FontAwesomeIcons.language,
                    size: 20, color: CColors.primary(context)),
              ),
              title: LocaleKeys.drawer_settings_change_lang_title.tr(),
            ),
            const Divider(),
            TitleListTile(
              onTap: launchPrivacyPolicy,
              trailing: const SizedBox.shrink(),
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: Icon(FontAwesomeIcons.userLock,
                    size: 18, color: CColors.primary(context)),
              ),
              title: LocaleKeys.drawer_settings_privacy_policy.tr(),
            ),
            const Divider(),
            TitleListTile(
              onTap: launchTermsOfService,
              trailing: const SizedBox.shrink(),
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: Icon(FontAwesomeIcons.file,
                    size: 20, color: CColors.primary(context)),
              ),
              title: LocaleKeys.drawer_settings_terms_of_service.tr(),
            ),
            const Divider(),

            // TitleListTile(
            //   onTap: () => _changeAppColorTheme(context),
            //
            //   trailing: const SizedBox.shrink(),
            //   leading: Padding(
            //     padding: const EdgeInsetsDirectional.only(end: 5),
            //     child: Icon(CupertinoIcons.film, color: CColors.primary(context)),
            //   ),
            //   title: LocaleKeys.drawer_settings_change_theme_color_title.tr(),
            // ),
            // const Divider(),
            TitleListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CreditsScreen()));
              },
              trailing: const SizedBox.shrink(),
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: Icon(CupertinoIcons.exclamationmark_circle,
                    color: CColors.primary(context)),
              ),
              title: LocaleKeys.about_credits.tr(),
            ),

            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FlutterLogo(size: 18),
                        Text(
                          'Made with Flutter',
                          style: theme(context).textTheme.bodySmall?.copyWith(
                                color: CColors.nullableSwitchable(
                                  context,
                                  light: Colors.black,
                                ),
                              ),
                        ),
                      ],
                    ),
                    Text(
                      '${AppPackageInfo.instance().appVersion()}',
                      style: theme(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: CColors.primary(context)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeChange() {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) {
        return TitleListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const AppThemeDialog(),
            );
          },
          leading:
              Icon(CupertinoIcons.paintbrush, color: CColors.primary(context)),
          title: LocaleKeys.drawer_settings_theme_title.tr(),
          trailing: const SizedBox.shrink(),
          subtitle: Text.rich(
            TextSpan(
              text: LocaleKeys.drawer_settings_theme_current_theme.tr(),
              children: [
                const TextSpan(text: '\t'),
                TextSpan(
                  text: notifier.mode.localized(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _changeLang(BuildContext context) async {
    final pickedLocale = await showDialog<Locale>(
      context: context,
      builder: (_) => ChangeLanguageDialog(currentLocale: context.locale),
    );
    if (pickedLocale == null) return;
    await context.changeLang(pickedLocale);
    Future.delayed(Duration(seconds: 1), () {
      if (Platform.isAndroid) {
        Restart.restartApp();
      } else {
        Phoenix.rebirth(context);
      }
    });
  }
}

class AppThemeDialog extends StatelessWidget {
  const AppThemeDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: Text(LocaleKeys.drawer_settings_theme_title.tr()),
      content: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) {
          final themes = [ThemeMode.dark, ThemeMode.light];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: themes.map((mode) {
              return RadioListTile<ThemeMode>(
                value: mode,
                groupValue: notifier.mode,
                onChanged: (value) {
                  if (value != null) notifier.switchTheme(value);
                  Future.delayed(Duration(seconds: 1), () {
                    if (Platform.isAndroid) {
                      Restart.restartApp();
                    } else {
                      Phoenix.rebirth(context);
                    }
                  });
                  // WidgetInspectorService.instance.performReassemble();
                },
                activeColor: CColors.primary(context),
                title: Text(
                  mode.localized(),
                  style: TextStyle(
                    color: CColors.nullableSwitchable(context,
                        light: CColors.darkerBlack, dark: Colors.grey.shade100),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
