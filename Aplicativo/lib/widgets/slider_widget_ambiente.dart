import 'package:flutter/material.dart';

class SliderWidgetAmbiente extends StatefulWidget {
  const SliderWidgetAmbiente({Key? key}) : super(key: key);

  @override
  State<SliderWidgetAmbiente> createState() => _SliderWidgetAmbienteState();
}

class _SliderWidgetAmbienteState extends State<SliderWidgetAmbiente> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Center(
            child: Image.asset(
              'assets/images/meio-ambiente.png',
              width: 200,
            ),
          ),
        ),
      ],
    );
  }
}
