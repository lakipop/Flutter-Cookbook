import 'package:flutter_test/flutter_test.dart';

import 'package:dog_management/main.dart' as app;

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
