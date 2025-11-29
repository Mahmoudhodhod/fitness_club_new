import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Payment/payment.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class VIPDialog extends StatelessWidget {
  const VIPDialog({Key? key}) : super(key: key);

  Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: Text(LocaleKeys.payment_general_vip_dialog_title.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VIPIcon(
            size: 55,
          ),
          const Space.v15(),
          Text(LocaleKeys.payment_general_vip_dialog_content.tr()),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.general_titles_cancel.tr()),
        ),
        SubscribeNowButton()
      ],
    );
  }
}
