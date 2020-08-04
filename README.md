# loop_page_view

A simple PageView builder constructor wrapper that allows for “indefinitely” scrolling on both directions. 

## Usage

Import the package into your code:

```dart
import 'package:loop_page_view/loop_page_view.dart';
```

It works exactly as a PageView builder constructor would, but it always requires an item count, and it requires LoopPageController as its controller. LoopPageController also works just as a PageController would, but it correctly handles LoopPageView indefinitely scrollable list.

## Installation

```yaml
dependencies:
  loop_page_view: ^1.0.8
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

## Author

[Wellington Soares Junior](https://github.com/wjuniorgit)

## License

[BSD](https://opensource.org/licenses/BSD-3-Clause)