import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';

void main() {
  runApp(MyApp());
}

final Set<MaterialColor> colors = {
  Colors.blueGrey,
  Colors.blue,
  Colors.cyan,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.red,
  Colors.purple,
};

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<bool> isSelected =
      colors.map((e) => e == colors.last ? true : false).toList();
  LoopScrollMode selectedScrollMode = LoopScrollMode.shortest;
  final LoopPageController controller = LoopPageController(
      scrollMode: LoopScrollMode.shortest,
      activationMode: LoopActivationMode.immediate);

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = isSelected.indexOf(
      isSelected.firstWhere((element) => element == true),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Loop Page View Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Animate mode is set to ${selectedScrollMode.toString().split('.').last}"),
              SizedBox(
                height: 80,
                child: LoopPageView.builder(
                  controller: controller,
                  itemCount: colors.length,
                  itemBuilder: (_, index) {
                    return Card(
                      color: colors.elementAt(index),
                      child: Center(
                        child: Text('$index'),
                      ),
                    );
                  },
                ),
              ),
              FittedBox(
                child: ToggleButtons(
                  children: <Widget>[
                    for (int index = 0; index < isSelected.length; index++)
                      Text('$index'),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++)
                        if (buttonIndex == index)
                          isSelected[buttonIndex] = true;
                        else
                          isSelected[buttonIndex] = false;
                    });
                  },
                  isSelected: isSelected,
                ),
              ),
              ElevatedButton(
                child: Text('Animate to $selectedIndex'),
                onPressed: () {
                  controller.animateToPage(selectedIndex,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                },
              ),
              ElevatedButton(
                child: Text('Jump to $selectedIndex'),
                onPressed: () {
                  controller.jumpToPage(selectedIndex);
                },
              ),
              ElevatedButton(
                child: Text('Animate jump to $selectedIndex'),
                onPressed: () {
                  controller.animateJumpToPage(selectedIndex,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                },
              ),
              ElevatedButton(
                child: Text("Change mode to ${(() {
                  switch (selectedScrollMode) {
                    case LoopScrollMode.shortest:
                      return 'forwards';
                    case LoopScrollMode.forwards:
                      return 'backwards';
                    case LoopScrollMode.backwards:
                      return 'shortest';
                  }
                })()}"),
                onPressed: () {
                  setState(() {
                    switch (selectedScrollMode) {
                      case LoopScrollMode.shortest:
                        selectedScrollMode = LoopScrollMode.forwards;
                        break;
                      case LoopScrollMode.forwards:
                        selectedScrollMode = LoopScrollMode.backwards;
                        break;
                      case LoopScrollMode.backwards:
                        selectedScrollMode = LoopScrollMode.shortest;
                        break;
                    }
                    controller.scrollMode = selectedScrollMode;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
