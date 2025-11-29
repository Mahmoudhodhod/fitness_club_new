import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_coach/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:utilities/utilities.dart';

class ErrorHappened extends StatelessWidget {
  final bool asSliver;
  final VoidCallback? onRetry;
  const ErrorHappened({
    Key? key,
    this.asSliver = false,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var child = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.exclamationmark_circle,
            color: Colors.red,
            size: 50,
          ),
          Space.v10(),
          Text(
            LocaleKeys.error_error_happened.tr(),
            textAlign: TextAlign.center,
            style: theme(context).textTheme.titleLarge,
          ),
          Space.v10(),
          if (onRetry != null)
            OutlinedButton(
              onPressed: onRetry,
              child: Text(
                LocaleKeys.error_retry.tr(),
                style: theme(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
    if (asSliver) return SliverFillRemaining(child: child);
    return child;
  }
}
