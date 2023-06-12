part of 'loop_page_view.dart';

/// A [PageController] extension to handle [LoopPageView] indefinitely scrollable list.
class LoopPageController implements Listenable {
  static const int _initialShiftedPage = 1000000;

  // ignore: prefer_final_fields
  int _currentShiftedPage;

  // ignore: prefer_final_fields
  int _itemCount;

  // ignore: prefer_final_fields
  int _initialIndexShift;

  late PageController _pageController;

  final int initialPage;

  bool _isAnimatingJumpToPage = false;

  int _isAnimatingJumpToPageIndex = 0;

  LoopScrollMode scrollMode;

  LoopPageController(
      {int initialPage = 0,
      bool keepPage = true,
      double viewportFraction = 1.0,
      LoopScrollMode scrollMode = LoopScrollMode.shortest})
      : assert(viewportFraction > 0.0),
        _currentShiftedPage = _initialShiftedPage,
        _itemCount = 0,
        _initialIndexShift = 0,
        initialPage = initialPage,
        scrollMode = scrollMode,
        _pageController = PageController(
          initialPage: initialPage + _initialShiftedPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );

  bool get hasClients => _pageController.hasClients;

  // ignore: invalid_use_of_protected_member
  bool get hasListeners => _pageController.hasListeners;

  ScrollPosition get position => _pageController.position;

  double get initialScrollOffset => _pageController.initialScrollOffset;

  double get offset => _pageController.offset;

  // ignore: invalid_use_of_protected_member
  Iterable<ScrollPosition> get positions => _pageController.positions;

  bool get keepScrollOffset => _pageController.keepScrollOffset;

  void addListener(VoidCallback listener) {
    _pageController.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _pageController.removeListener(listener);
  }

  void notifyListeners() {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _pageController.notifyListeners();
  }

  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition oldPosition) {
    return _pageController.createScrollPosition(physics, context, oldPosition);
  }

  void attach(ScrollPosition position) {
    _pageController.attach(position);
  }

  /// The current page displayed in the controlled [LoopPageView].
  ///
  /// There are circumstances that this [LoopPageController] can't know the current
  /// page. Reading [page] will throw an [AssertionError] in the following cases:
  ///
  /// 1. No [LoopPageView] is currently using this [LoopPageController]. Once a
  /// [LoopPageView] starts using this [LoopPageController], the new [page]
  /// position will be derived:
  ///
  ///   * First, based on the attached [LoopPageView]'s [BuildContext] and the
  ///     position saved at that context's [PageStorage] if [keepPage] is true.
  ///   * Second, from the [LoopPageController]'s [initialPage].
  ///
  /// 2. More than one [LoopPageView] using the same [LoopPageController].
  ///
  /// The [hasClients] property can be used to check if a [LoopPageView] is attached
  /// prior to accessing [page].
  ///
  double get page =>
      _notShiftedIndex(_pageController.page!.floor()).toDouble() +
      (_pageController.page! - _pageController.page!.truncate());

  /// Jumps to imediate before or after given page and then
  /// animates the controlled [LoopPageView] from the imediate page to the given page.
  /// This is done in order to build only the given page while still animating its transition.
  ///
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<void> animateJumpToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) {
    final shiftedPage = _shiftPage(page);

    if (shiftedPage == _currentShiftedPage) return Future.value();

    if (shiftedPage == _currentShiftedPage + 1 ||
        shiftedPage == _currentShiftedPage - 1)
      return animateToPage(page, duration: duration, curve: curve);

    if (_pageController.viewportFraction == 1.0) _isAnimatingJumpToPage = true;
    if (_pageController.viewportFraction == 1.0)
      _isAnimatingJumpToPageIndex = _currentShiftedPage < shiftedPage
          ? _notShiftedIndex(shiftedPage - 1)
          : _notShiftedIndex(shiftedPage + 1);

    jumpToPage(_currentShiftedPage < shiftedPage ? page - 1 : page + 1);
    return animateToPage(page, duration: duration, curve: curve);
  }

  /// Animates the controlled [LoopPageView] from the current page to the given page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<void> animateToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) {
    final int shiftedPage = _shiftPage(page);
    if (_currentShiftedPage != shiftedPage) {
      _currentShiftedPage = shiftedPage;
      return _pageController.animateToPage(shiftedPage,
          duration: duration, curve: curve);
    }
    return Future.value();
  }

  void dispose() {
    _pageController.dispose();
  }

  /// Changes which page is displayed in the controlled [LoopPageView].
  ///
  /// Jumps the page position from its current value to the given value,
  /// without animation.
  void jumpToPage(int page) {
    final int shiftedPage = _initialShiftedPage + page;

    if (_currentShiftedPage != shiftedPage) {
      _currentShiftedPage = shiftedPage;
      _pageController.jumpToPage(shiftedPage);
    }
  }

  /// Animates the controlled [LoopPageView] to the next page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<void> nextPage({required Duration duration, required Curve curve}) {
    return animateToPage(_shiftPage(page.round()) + 1,
        duration: duration, curve: curve);
  }

  /// Animates the controlled [LoopPageView] to the previous page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<void> previousPage(
      {required Duration duration, required Curve curve}) {
    return animateToPage(_shiftPage(page.round()) - 1,
        duration: duration, curve: curve);
  }

  /// Changes index for which page is displayed in the controlled [LoopPageView]
  /// in order to enable infinite scrolling
  void _modJump() {
    final int shiftedPage =
        _initialShiftedPage + _notShiftedIndex(_currentShiftedPage);
    if (_currentShiftedPage != shiftedPage) {
      _currentShiftedPage = shiftedPage;
      _pageController.jumpToPage(shiftedPage);
    }
  }

  /// Changes a shifted index to a not shifted index.
  int _notShiftedIndex(int shiftedIndex) {
    final int currentIndexShift =
        _itemCount > 0 ? shiftedIndex % _itemCount : shiftedIndex;

    final int difference = currentIndexShift - _initialIndexShift;

    if (difference < 0) return difference + _itemCount;
    return difference;
  }

  int _shiftPage(int page) {
    final modPage = _itemCount > 0 ? (page % _itemCount) : page;

    final int instantCurrentShiftedPage = _currentShiftedPage;

    final int currentNotShiftedPage =
        _notShiftedIndex(instantCurrentShiftedPage);

    if (currentNotShiftedPage == modPage) return instantCurrentShiftedPage;

    final int distance = modPage - currentNotShiftedPage;

    final int oppositeDistance = distance > 0
        ? (-1 * currentNotShiftedPage) - (_itemCount - modPage)
        : distance == 0
            ? 0
            : distance + _itemCount;

    switch (scrollMode) {
      case LoopScrollMode.shortest:
        return distance.abs() <= oppositeDistance.abs()
            ? instantCurrentShiftedPage + distance
            : instantCurrentShiftedPage + oppositeDistance;
      case LoopScrollMode.forwards:
        return distance > oppositeDistance
            ? instantCurrentShiftedPage + distance
            : instantCurrentShiftedPage + oppositeDistance;
      case LoopScrollMode.backwards:
        return distance < oppositeDistance
            ? instantCurrentShiftedPage + distance
            : instantCurrentShiftedPage + oppositeDistance;
    }
  }

  /// Updates _currentShiftedPage to be equal current [PageController] page.
  void _updateCurrentShiftedPage() {
    _currentShiftedPage = _pageController.page!.roundToDouble().toInt();
  }

  void _updateItemCount(int itemCount) {
    _itemCount = itemCount;
    _initialIndexShift =
        _itemCount > 0 ? _initialShiftedPage % _itemCount : _initialShiftedPage;
    _currentShiftedPage = _initialShiftedPage + initialPage;
  }
}

/// Enum representing different scroll directions for a LoopPageController.
///
/// Values:
/// * `shortest`: The LoopPageController will animate to the closest page. For example, if the current page is 1 and the target page is 5, but the total number of pages is 6, the LoopPageController will go backwards (from 1 to 6 to 5) instead of forwards (from 1 to 2 to 3 to 4 to 5). This is because the shortest path from 1 to 5 in this case is to go backwards.
/// * `forwards`: The LoopPageController will always animate forwards to reach the target page. Even if the target page is technically closer when moving backwards, this option will make the controller move forwards until it reaches the target page.
/// * `backwards`: The LoopPageController will always animate backwards to reach the target page. Similar to `forwards`, but in the opposite direction. Even if the target page is technically closer when moving forwards, this option will make the controller move backwards until it reaches the target page.
enum LoopScrollMode {
  shortest,
  forwards,
  backwards,
}
