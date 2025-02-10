import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitcrew/widgets/common/loading_indicator.dart';

void main() {
  testWidgets('LoadingIndicator shows spinner', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoadingIndicator(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('LoadingIndicator shows message when provided', (tester) async {
    const message = 'Loading...';
    await tester.pumpWidget(
      const MaterialApp(
        home: LoadingIndicator(message: message),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text(message), findsOneWidget);
  });

  testWidgets('LoadingIndicator shows overlay when requested', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoadingIndicator(overlay: true),
      ),
    );

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
} 