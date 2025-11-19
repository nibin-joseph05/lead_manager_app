import 'package:flutter_test/flutter_test.dart';

import 'package:lead_manager_app/main.dart';

void main() {
  testWidgets('renders lead list screen', (tester) async {
    await tester.pumpWidget(const LeadApp());
    expect(find.text('Lead Manager'), findsOneWidget);
  });
}
