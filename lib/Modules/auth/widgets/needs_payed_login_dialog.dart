import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_coach/Modules/Payment/payment.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/constants.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class LoginPaymentNeededDialog extends StatelessWidget {
  final VoidCallback onLoginPressed;
  const LoginPaymentNeededDialog({Key? key, required this.onLoginPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.auth_guest_user_needs_payed_login_title.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: CColors.primary(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Space.v15(),
            SvgPicture.asset(kLoginSVG, height: 160),
            const Space.v30(),
            Row(
              children: [
                const VIPIcon(size: 50),
                const Spacer(),
                CustomButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onLoginPressed();
                  },
                  child: Text(LocaleKeys.auth_guest_user_login_now.tr()),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
