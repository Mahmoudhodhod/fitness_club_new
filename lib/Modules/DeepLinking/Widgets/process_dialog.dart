import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_coach/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:utilities/utilities.dart';

class DeepLinkingProcessDialog extends StatelessWidget {
  const DeepLinkingProcessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (kDebugMode) Navigator.pop(context);
              },
              child: SizedBox.square(
                dimension: 30,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            const Space.v20(),
            Text(LocaleKeys.general_titles_loading.tr()),
          ],
        ),
      ),
    );
  }
}
