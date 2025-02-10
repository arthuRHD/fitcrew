import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitcrew/firebase_options.dart';

void main() {
  test('Firebase options are properly configured', () {
    final options = DefaultFirebaseOptions.currentPlatform;
    expect(options.projectId, 'fitcrew-3e16c');
    expect(options.apiKey, isNotEmpty);
    expect(options.appId, isNotEmpty);
  });
} 