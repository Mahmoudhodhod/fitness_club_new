import 'package:flutter/material.dart';

import 'package:the_coach/Widgets/CustomPlans/selector.dart';
import 'package:utilities/utilities.dart';

const _kDefaultContentPadding = EdgeInsets.symmetric(horizontal: 10.0);

class SelectorListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final ExerciseSelectPreview preview;
  final Decoration? decoration;

  const SelectorListTile({
    Key? key,
    this.onTap,
    required this.preview,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: decoration,
        padding: _kDefaultContentPadding,
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            if (preview.leading != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox.square(
                  dimension: 80,
                  child: preview.leading!,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        preview.title,
                        style: theme(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  if (preview.subtitle != null) ...[
                    const SizedBox(height: 7),
                    Text(preview.subtitle!),
                  ],
                ],
              ),
            ),
            preview.trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
