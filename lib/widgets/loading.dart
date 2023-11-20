import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String waitingMessage;

  const Loading({
    super.key,
    required this.waitingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
          ),
          const SizedBox(height: 10),
          Text(waitingMessage),
        ],
      ),
    );
  }
}
