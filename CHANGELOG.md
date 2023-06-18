## [1.2.5] - June 18, 2023

* Introduced `LoopActivationMode` with the following modes:
  * `LoopActivationMode.immediate`: This mode triggers infinite looping right from the first page, immediately after the `LoopPageView` is launched.
  * `LoopActivationMode.afterFirstLoop`: In this mode, infinite looping is only triggered after the first complete forward loop is performed.
  * `LoopActivationMode.forwardOnly`: This mode enables only forward infinite scrolling, preventing backward looping.

## [1.2.4] - June 12, 2023

* Expose the value of `initialPage` in `LoopPageController`
* Adds a new `enum` called `LoopScrollMode` to give users control over the scrolling direction in `LoopPageController`. Shortest option enables the controller to choose the shortest path to the target page. Forwards and Backwards options enforce a specific scrolling direction, regardless of which is the shortest path to the target page.

## [1.2.3] - June 11, 2023

* Fix RangeError(index): Index out of range issue when hot reloading a 'LoopPageView' without a strong reference to a 'LoopPageController'

## [1.2.2] - June 3, 2023

* Implements Listenable interface on LoopPageController
* Revert commit 48ae3f7

## [1.2.1] - February 25, 2023

* Fix WidgetsBinding null safety

## [1.2.0] - June 16, 2022

* Migrate to Flutter 3
* Swap container to sizedbox

## [1.1.1] - October 4, 2021

* Update to null safety

## [1.1.0] - October 4, 2021

* Updates min sdk to >=2.12.0.

## [1.0.11] - December 02, 2020

* Added animateJumpToPage on LoopPageViewController. It animates to a page without building the pages in between.
* Improved nearest page in animateToPage.
* Loop is really infinite now.
* Added the ScrollController interface to LoopPageViewController.

## [1.0.10] - September 14, 2020

* Correctly update item count on widget update.

## [1.0.9] - August 04, 2020

* Empty Container if itemCount is 0.

## [1.0.8] - August 04, 2020

* LoopPageViewController if itemCount is 0 error fixed.

## [1.0.7] - July 27, 2020

* LoopPageViewController is now a PageController composition.
* LoopPageViewController.page value fixed.

## [1.0.6] - July 22, 2020

* Fixed LoopPageView index forwarding value.

## [1.0.5] - July 21, 2020

* LoopPageController created.

## [1.0.4] - July 17, 2020

* Removed unrelated files from the project.

## [1.0.3] - July 17, 2020

* Added documentation comments.

## [1.0.2] - July 17, 2020

* Corrected information in readme file.

## [1.0.1] - July 17, 2020

* Corrected initialPage value.

## [1.0.0] - July 17, 2020

* Initial working release.
