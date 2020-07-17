import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class LoopPageView extends StatelessWidget {
  LoopPageView.builder({
    Key key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    PageController controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    @required this.itemBuilder,
    @required this.itemCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
  })  : assert(allowImplicitScrolling != null),
        controller = controller ?? PageController(),
        initialPage = controller != null ? controller.initialPage + 1 : 1,
        childrenDelegate =
            SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
        super(key: key);

  final bool allowImplicitScrolling;
  final SliverChildDelegate childrenDelegate;
  final PageController controller;
  final DragStartBehavior dragStartBehavior;
  final int initialPage;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ValueChanged<int> onPageChanged;
  final bool pageSnapping;
  final ScrollPhysics physics;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(
          viewportFraction: controller.viewportFraction,
          initialPage: 100000 + initialPage,
          keepPage: controller.keepPage),
      onPageChanged: (int index) {
        if (onPageChanged != null) onPageChanged((index - 1) % itemCount);
      },
      itemBuilder: (context, index) {
        return itemBuilder(context, (index - 1) % itemCount);
      },
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      physics: physics,
      pageSnapping: pageSnapping,
      dragStartBehavior: dragStartBehavior,
      allowImplicitScrolling: allowImplicitScrolling,
    );
  }
}
