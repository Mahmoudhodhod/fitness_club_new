import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_coach/Helpers/constants.dart';
import 'package:the_coach/generated/locale_keys.g.dart';
import 'package:utilities/utilities.dart';
import 'package:easy_localization/easy_localization.dart';

class NoDataError extends StatelessWidget {
  final bool compact;
  const NoDataError({
    Key? key,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (compact) ...[
            const Icon(Icons.visibility_off, color: Colors.grey, size: 40),
            const Space.v10(),
          ] else ...[
            SvgPicture.asset(
              kNoContent,
              width: screenSize.width * .4,
            ),
            const Space.v20(),
          ],
          Text(
            LocaleKeys.error_no_data_avaiable.tr(),
            textAlign: TextAlign.center,
            style: theme(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
