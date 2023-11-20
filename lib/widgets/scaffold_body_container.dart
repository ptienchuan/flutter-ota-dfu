import 'package:flutter/material.dart';

class ScaffoldBodyContainer extends StatelessWidget {
  final Widget child;

  const ScaffoldBodyContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: child,
    );
  }
}
