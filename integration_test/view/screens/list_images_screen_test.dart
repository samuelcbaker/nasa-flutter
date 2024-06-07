import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nasa_flutter/app.dart';
import 'package:nasa_flutter/di/injection.dart';
import 'package:nasa_flutter/view/screens/image_detail_screen.dart';
import 'package:nasa_flutter/view/widgets/search_bar_widget.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  setUpAll(() async {
    await AppInjection.inject();
  });

  Future<void> initialConfig(WidgetTester tester) async {
    await tester.pumpWidget(const NasaApp());

    // 300 milliseconds to await get images
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
  }

  group('Find items', () {
    testWidgets('should finds list view widget', (tester) async {
      await initialConfig(tester);

      final finder = find.byType(ListView);

      expect(finder, findsOneWidget);
    });

    testWidgets('should finds first date item on list view widget',
        (tester) async {
      await initialConfig(tester);

      final finder = find.byKey(const Key('date_key_0'));

      expect(finder, findsOneWidget);
    });

    testWidgets('should finds first title item on list view widget',
        (tester) async {
      await initialConfig(tester);

      final finder = find.byKey(const Key('title_key_0'));

      expect(finder, findsOneWidget);
    });

    testWidgets('should finds first image item on list view widget',
        (tester) async {
      await initialConfig(tester);

      final finder = find.byKey(const Key('image_key_0'));

      expect(finder, findsOneWidget);
    });

    testWidgets('should finds search bar on screen', (tester) async {
      await initialConfig(tester);

      final finder = find.byType(SearchBarWidget);

      expect(finder, findsOneWidget);
    });
  });

  group('Interact with Widgets', () {
    testWidgets('should go to image details if click on text', (tester) async {
      await initialConfig(tester);

      final finder = find.byKey(const Key('title_key_0'));

      // Click on text
      await tester.tap(finder);

      await tester.pumpAndSettle();

      final finderDetailScreen = find.byType(ImageDetailScreen);

      expect(finderDetailScreen, findsOneWidget);
    });

    testWidgets('should filter list if type on search field', (tester) async {
      await initialConfig(tester);

      final finderFirst = find.byKey(const Key('title_key_0'));
      final finderSecond = find.byKey(const Key('title_key_1'));

      // should find first and second item
      expect(finderFirst, findsOneWidget);
      expect(finderSecond, findsOneWidget);

      final textFirst = tester.widget<Text>(finderFirst);

      await tester.enterText(find.byType(TextFormField), textFirst.data!);

      await tester.pumpAndSettle();

      // should find first, but not second item
      expect(finderFirst, findsOneWidget);
      expect(finderSecond, findsNothing);
    });
  });
}
