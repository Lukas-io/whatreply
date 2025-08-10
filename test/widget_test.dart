// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:whatreply/main.dart';

void main() {
  testWidgets('WhatReply app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WhatReplyApp());

    // Verify that our app shows the chat screen
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('online'), findsOneWidget);
    
    // Verify that sample messages are displayed
    expect(find.text('Hey! How are you doing?'), findsOneWidget);
    expect(find.text('I\'m doing great! Just finished working on a new project.'), findsOneWidget);
    
    // Verify that the input field is present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Message'), findsOneWidget);
  });
}
