# loop_page_view

A simple PageView builder constructor wrapper that allows for “indefinitely” scrolling on both directions. 

## Usage

Import the package into your code:

```dart
import 'package:loop_page_view/loop_page_view.dart';
```

It works exactly as a PageView builder constructor would, but it always requires an item count, and it requires a LoopPageController as its controller. LoopPageController also works just as a PageController would, but it correctly handles LoopPageView endless scrollable list.

An animateJumpToPage method was added to LoopPageController in order to animate a jump to any page without building the pages in between if viewportFraction is 1.0.

## Installation

```yaml
dependencies:
  loop_page_view: ^1.2.0
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Loop Page View Demo'),
        ),
        body: Center(
          child: LoopPageView.builder(
            itemCount: 2,
            itemBuilder: (_, index) {
              return Card(
                child: Center(
                  child: Text('$index'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
```
## Demo

![](https://media1.giphy.com/media/f8hh4SYeyc7fDcMN77/giphy.gif)

![](https://media4.giphy.com/media/zv3rjIbf49jI9LzgvX/giphy.gif)

## Author

[Wellington Soares Junior](https://github.com/wjuniorgit)

## License

[BSD](https://opensource.org/licenses/BSD-3-Clause)