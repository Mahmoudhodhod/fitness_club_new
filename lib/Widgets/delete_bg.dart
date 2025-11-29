import 'package:flutter/material.dart';

///A background widget to use with [Dismissible] which indicates the dismiss action [delete].
///
class DismissibleDeleteBG extends StatelessWidget {
  ///A background widget to use with [Dismissible] which indicates the dismiss action [delete].
  ///
  const DismissibleDeleteBG({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Align(
        alignment: AlignmentDirectional(0.9, 0.0),
        child: Icon(Icons.delete),
      ),
    );
  }
}
