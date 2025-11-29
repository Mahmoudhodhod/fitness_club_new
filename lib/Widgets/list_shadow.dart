import 'package:flutter/material.dart';

class CShadowerWrapper extends StatefulWidget {
  final ScrollView child;
  final Offset activationOffset;
  final bool hideDebug;
  final bool enable;

  const CShadowerWrapper({
    Key? key,
    required this.child,
    this.hideDebug = true,
    this.activationOffset = const Offset(0, 0.03),
    this.enable = true,
  }) : super(key: key);

  @override
  _CShadowerWrapperState createState() => _CShadowerWrapperState();
}

class _CShadowerWrapperState extends State<CShadowerWrapper> {
  bool _showShadower = false;
  @override
  Widget build(BuildContext context) {
    if (!widget.enable) return widget.child;
    return Stack(
      children: [
        Positioned.fill(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              _showOrHideBackButton(notification);
              return false;
            },
            child: widget.child,
          ),
        ),
        if (_showShadower) ...[
          Positioned(
            top: 0,
            bottom: null,
            left: -20,
            right: -20,
            child: _shader(),
          ),
        ],
      ],
    );
  }

  void _showOrHideBackButton(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    double progress = metrics.pixels / metrics.maxScrollExtent;
    if (progress >= widget.activationOffset.dy && !_showShadower) {
      setState(() => _showShadower = true);
      if (!widget.hideDebug) debugPrint("Show Shadower");
    }
    if (progress < widget.activationOffset.dy && _showShadower) {
      setState(() => _showShadower = false);
      if (!widget.hideDebug) debugPrint("Hide Shadower");
    }
  }

  Widget _shader() {
    final double _height = 30;
    final Color _color = Theme.of(context).scaffoldBackgroundColor;
    // final Color _color = Colors.black;
    return Container(
      height: _height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _color.withOpacity(0.7),
            _color.withOpacity(0.1),
            // Colors.red,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _color.withOpacity(0.8),
            offset: const Offset(0, 15),
            spreadRadius: 10,
            blurRadius: 25,
          ),
        ],
      ),
    );
  }
}
