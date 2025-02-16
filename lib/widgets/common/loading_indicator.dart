import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final bool overlay;

  const LoadingIndicator({
    super.key,
    this.message,
    this.overlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (!overlay) return content;

    return Container(
      color: Colors.black54,
      child: Center(child: content),
    );
  }
} 
