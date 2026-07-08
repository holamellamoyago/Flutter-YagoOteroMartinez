import 'package:flutter_test/flutter_test.dart';
import 'package:hot_wheels/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HotWheelsApp());
    expect(find.text('Hot Wheels'), findsOneWidget);
  });
}
