import 'package:flutter/material.dart';

class SliderWidgetAgua extends StatefulWidget {
  const SliderWidgetAgua({Key? key}) : super(key: key);

  @override
  State<SliderWidgetAgua> createState() => _SliderWidgetAguaState();
}

class _SliderWidgetAguaState extends State<SliderWidgetAgua> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Center(
            child: Image.asset(
              'assets/images/economize-agua (1).png',
              width: 200,
            ),
          ),
        ),
      ],
    );
  }
}
