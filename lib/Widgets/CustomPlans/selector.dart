import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';

//TODO: document

class MuscleSelectPreview extends SelectPreview {
  MuscleSelectPreview({
    required String imagePath,
    required int id,
    required String title,
  }) : super(
          id: id,
          title: title,
          leading: SizedBox.fromSize(
            size: const Size.square(75),
            child: NetworkImageView(url: imagePath, fit: BoxFit.cover),
          ),
        );
}

class ExerciseSelectPreview extends SelectPreview {
  ExerciseSelectPreview({
    required String imagePath,
    required int id,
    required String title,
    Widget? trailing,
    VoidCallback? onImageTapped,
  }) : super(
          id: id,
          title: title,
          trailing: trailing,
          leading: GestureDetector(
            onLongPress: onImageTapped,
            child: SizedBox.fromSize(
              size: const Size.square(130),
              child: NetworkImageView(
                url: imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
}

@immutable
class SelectPreview {
  final int id;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  const SelectPreview({
    required this.id,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });
}

class SelectDialog<T extends SelectPreview> extends StatelessWidget {
  final int? selectedID;
  final String title;
  final List<T> data;
  final ValueChanged<T> onSelect;

  const SelectDialog({
    Key? key,
    this.selectedID,
    required this.title,
    required this.data,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: KBorders.bc15),
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: BoxConstraints.loose(
          Size(
            screenSize.width,
            screenSize.height * (data.isEmpty ? 0.25 : .8),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CColors.switchable(
                    context,
                    dark: Colors.grey.shade200,
                    light: CColors.darkerBlack,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
                child: Divider(height: 25, endIndent: 20, indent: 20)),
            if (data.isEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: NoDataError(),
                ),
              ),
            ] else ...[
              SliverList(
                delegate: separatorSliverChildDelegate(
                  childCount: data.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final element = data[index];
                    final isSelected = selectedID == element.id;
                    return _SelectorListTile(
                      decoration: BoxDecoration(
                          color: isSelected ? CColors.fancyBlack : null),
                      onTap: () {
                        Navigator.pop(context);
                        return onSelect.call(element);
                      },
                      title: Text(
                        element.title,
                        style: theme(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: element.subtitle != null
                          ? Text(element.subtitle!)
                          : null,
                      leading: element.leading,
                      trailing: element.trailing,
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _SelectorListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;
  final Decoration? decoration;

  const _SelectorListTile({
    Key? key,
    this.onTap,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.contentPadding,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _defaultContentPadding = EdgeInsets.symmetric(horizontal: 10.0);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: decoration,
        padding: contentPadding ?? _defaultContentPadding,
        child: Row(
          children: [
            if (leading != null) ...[
              SizedBox.square(
                dimension: 80,
                child: leading!,
              ),
              const SizedBox(width: 7),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title ?? const SizedBox.expand(),
                  if (subtitle != null) ...[
                    const SizedBox(height: 7),
                    subtitle!,
                  ],
                ],
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
