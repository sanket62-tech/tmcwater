import 'package:flutter_test/flutter_test.dart';
import 'package:water_collector/src/app/water_collector_app.dart';

void main() {
  testWidgets('shows splash screen first', (WidgetTester tester) async {
    await tester.pumpWidget(const WaterCollectorApp());

    expect(find.text('JAL NAMUNA'), findsOneWidget);
  });
}
