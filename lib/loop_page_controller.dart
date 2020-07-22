part of 'loop_page_view.dart';

/// A [PageController] extension to handle [LoopPageView] indefinitely scrollable list.
class LoopPageController extends PageController {
  static const int _initialShiftedPage = 100000;

  // ignore: prefer_final_fields
  int _currentShiftedPage;

  // ignore: prefer_final_fields
  int _itemCount;

  LoopPageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  })  : assert(initialPage != null),
        assert(keepPage != null),
        assert(viewportFraction != null),
        assert(viewportFraction > 0.0),
        _currentShiftedPage = _initialShiftedPage,
        _itemCount = 0,
        super(
          initialPage: initialPage + _initialShiftedPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );

  /// Animates the controlled [LoopPageView] from the current page to the given page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  @override
  Future<void> animateToPage(
    int page, {
    @required Duration duration,
    @required Curve curve,
  }) {
    return super
        .animateToPage(_shiftPage(page), duration: duration, curve: curve);
  }

  /// Changes which page is displayed in the controlled [LoopPageView].
  ///
  /// Jumps the page position from its current value to the given value,
  /// without animation.
  @override
  void jumpToPage(int page) {
    super.jumpToPage(_shiftPage(page));
  }

  /// Animates the controlled [LoopPageView] to the next page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  @override
  Future<void> nextPage({@required Duration duration, @required Curve curve}) {
    return animateToPage(_shiftPage(page.round()) + 1,
        duration: duration, curve: curve);
  }

  /// Animates the controlled [LoopPageView] to the previous page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  @override
  Future<void> previousPage(
      {@required Duration duration, @required Curve curve}) {
    return animateToPage(_shiftPage(page.round()) - 1,
        duration: duration, curve: curve);
  }

  int _currentNotShiftedPage(int instantCurrentShiftedPage) {
    final int initialIndexShift = _initialShiftedPage % _itemCount;

    final int currentIndexShift = instantCurrentShiftedPage % _itemCount;

    final int difference = currentIndexShift - initialIndexShift;

    if (difference < 0) return difference + _itemCount;

    return difference;
  }

  int _shiftPage(int page) {
    final modPage = page % _itemCount;

    final int instantCurrentShiftedPage = _currentShiftedPage;
    final int currentNotShiftedPage =
        _currentNotShiftedPage(instantCurrentShiftedPage);

    if (currentNotShiftedPage == modPage) return _currentShiftedPage;

    final int distance = modPage - currentNotShiftedPage;

    final int oppositeDistance = distance > 0
        ? (-1 * currentNotShiftedPage) - (_itemCount - modPage)
        : distance == 0 ? 0 : distance + _itemCount;

    final int shiftedPage = distance.abs() <= oppositeDistance.abs()
        ? instantCurrentShiftedPage + distance
        : instantCurrentShiftedPage + oppositeDistance;

    return shiftedPage;
  }
}
