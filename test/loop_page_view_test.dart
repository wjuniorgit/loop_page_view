import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loop_page_view/loop_page_view.dart';

Widget makeTestable(Widget widget) => MaterialApp(home: widget);

void main() {
  testWidgets('ItemCount 5 initialPage 1', (WidgetTester tester) async {
    final LoopPageController controller = LoopPageController(initialPage: 1);

    await tester.pumpWidget(
      makeTestable(
        LoopPageView.builder(
          controller: controller,
          itemCount: 5,
          itemBuilder: (_, index) {
            return Container(
              child: Text('$index'),
            );
          },
        ),
      ),
    );
    expect(find.text('1'), findsOneWidget);
    controller.jumpToPage(-1);
    await tester.pumpAndSettle();
    expect(find.text('4'), findsOneWidget);
    controller.animateToPage(2,
        curve: Curves.easeIn, duration: Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
    controller.animateJumpToPage(6,
        curve: Curves.easeIn, duration: Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('ItemCount 500 initialPage 250', (WidgetTester tester) async {
    final LoopPageController controller = LoopPageController(initialPage: 250);

    await tester.pumpWidget(
      makeTestable(
        LoopPageView.builder(
          controller: controller,
          itemCount: 500,
          itemBuilder: (_, index) {
            return Container(
              child: Text('$index'),
            );
          },
        ),
      ),
    );
    expect(find.text('250'), findsOneWidget);
    controller.jumpToPage(-250);
    await tester.pumpAndSettle();
    expect(find.text('250'), findsOneWidget);
    controller.animateToPage(1000,
        curve: Curves.easeIn, duration: Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    controller.animateJumpToPage(5,
        curve: Curves.easeIn, duration: Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('5'), findsOneWidget);
  });
}
