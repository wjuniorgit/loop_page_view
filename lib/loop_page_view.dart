import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// A PageView.builder() wrapper that creates an indefinitely scrollable list.
class LoopPageView extends StatelessWidget {
  /// [itemCount] is required to calculate the real index.
  ///
  /// [itemBuilder] will be called only with indices greater than or equal to
  /// zero and less than [itemCount].
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
        _initialPage = controller != null ? controller.initialPage : 0;

  /// Controls whether the widget's pages will respond to
  /// [RenderObject.showOnScreen], which will allow for implicit accessibility
  /// scrolling.
  ///
  /// With this flag set to false, when accessibility focus reaches the end of
  /// the current page and the user attempts to move it to the next element, the
  /// focus will traverse to the next widget outside of the page view.
  ///
  /// With this flag set to true, when accessibility focus reaches the end of
  /// the current page and user attempts to move it to the next element, focus
  /// will traverse to the next page in the page view.
  final bool allowImplicitScrolling;

  /// An object that can be used to control the position to which this page
  /// view is scrolled.
  final PageController controller;

  /// Configuration of offset passed to [DragStartDetails].
  ///
  /// The settings determines when a drag formally starts when the user
  /// initiates a drag.
  final DragStartBehavior dragStartBehavior;

  /// Function that creates a widget for a given index.
  final IndexedWidgetBuilder itemBuilder;

  /// Total number of items to be displayed.
  final int itemCount;

  /// Callbacks that report that page value has changed
  final ValueChanged<int> onPageChanged;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  final bool pageSnapping;

  /// How the page view should respond to user input.
  ///
  /// For example, determines how the page view continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics physics;

  /// Whether the page view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the page view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the page view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// The axis along which the page view scrolls.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// The page to show when first creating the [LoopPageView].
  final int _initialPage;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(
          viewportFraction: controller.viewportFraction,
          initialPage: 100000 + _initialPage,
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
