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
  final LoopPageController controller = LoopPageController();

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
              RaisedButton(
                child: Text('Animate to $selectedIndex'),
                onPressed: () {
                  controller.animateToPage(selectedIndex,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                },
              ),
              RaisedButton(
                child: Text('Jump to $selectedIndex'),
                onPressed: () {
                  controller.jumpToPage(selectedIndex);
                },
              ),
              RaisedButton(
                child: Text('Animate jump to $selectedIndex'),
                onPressed: () {
                  controller.animateJumpToPage(selectedIndex,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
