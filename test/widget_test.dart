import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janride_app/navigation/app_router.dart';

void main() {
  testWidgets('Settings route loads settings and privacy screen', (WidgetTester tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(1200, 2200));

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRouter.settingsPrivacy,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );

    expect(find.text('Settings & Privacy'), findsOneWidget);
    expect(find.text('Language / भाषा'), findsOneWidget);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Support route loads help support screen', (WidgetTester tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(1200, 2200));

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRouter.support,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );

    expect(find.text('Help & Support'), findsWidgets);
    expect(find.text('Call Support'), findsOneWidget);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Bottom nav Alerts tab opens notifications screen', (WidgetTester tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(1200, 2200));

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );

    await tester.tap(find.text('Alerts'));
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);

    await binding.setSurfaceSize(null);
  });
}
