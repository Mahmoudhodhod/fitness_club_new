import 'package:flutter/material.dart';

///Can be shown on the bottom of the list view when paginating.
///
class PaginationLoader extends StatelessWidget {
  const PaginationLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox.fromSize(
        size: const Size.square(50),
        child: const Center(child: const CircularProgressIndicator()),
      ),
    );
  }
}
