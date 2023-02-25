import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

part 'loop_page_controller.dart';

/// A PageView.builder() wrapper that creates an indefinitely scrollable list.
/// [LoopPageController] must be the controller.
class LoopPageView extends StatefulWidget {
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
  final LoopPageController controller;

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
  final ValueChanged<int>? onPageChanged;

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
  final ScrollPhysics? physics;

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

  /// [itemCount] is required by the controller to calculate the real index.
  ///
  /// [itemBuilder] will be called only with indices greater than or equal to
  /// zero and less than [itemCount].
  LoopPageView.builder({
    required this.itemBuilder,
    required this.itemCount,
    LoopPageController? controller,
    this.physics,
    this.onPageChanged,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.pageSnapping = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
  }) : controller = controller ?? LoopPageController();

  @override
  _LoopPageViewState createState() => _LoopPageViewState();
}

class _LoopPageViewState extends State<LoopPageView> {
  Widget? currentPage;

  @override
  Widget build(BuildContext context) {
    return widget.itemCount > 0
        ? NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                WidgetsBinding.instance?.addPostFrameCallback((_) async {
                  widget.controller._modJump();
                });
                widget.controller._updateCurrentShiftedPage();
              }
              return false;
            },
            child: PageView.builder(
              controller: widget.controller._pageController,
              onPageChanged: (int index) {
                if (widget.controller._isAnimatingJumpToPage != true &&
                    widget.onPageChanged != null)
                  widget.onPageChanged!(
                      widget.controller._notShiftedIndex(index));
              },
              itemBuilder: (context, index) {
                final int notShiftedIndex =
                    widget.controller._notShiftedIndex(index);

                if (widget.controller._isAnimatingJumpToPage == true &&
                    currentPage != null &&
                    notShiftedIndex ==
                        widget.controller._isAnimatingJumpToPageIndex) {
                  widget.controller._isAnimatingJumpToPage = false;
                  return currentPage ?? SizedBox.shrink();
                }

                currentPage = widget.itemBuilder(context, notShiftedIndex);

                return currentPage!;
              },
              key: widget.key,
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              physics: widget.physics,
              pageSnapping: widget.pageSnapping,
              dragStartBehavior: widget.dragStartBehavior,
              allowImplicitScrolling: widget.allowImplicitScrolling,
            ),
          )
        : SizedBox.shrink();
  }

  @override
  void didUpdateWidget(LoopPageView oldWidget) {
    if (oldWidget.itemCount != widget.itemCount)
      widget.controller._updateItemCount(widget.itemCount);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    widget.controller._updateItemCount(widget.itemCount);
    super.initState();
  }
}
