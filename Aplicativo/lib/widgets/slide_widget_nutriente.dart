import 'package:flutter/material.dart';

class SliderWidgetNutrientes extends StatefulWidget {
  const SliderWidgetNutrientes({Key? key}) : super(key: key);

  @override
  State<SliderWidgetNutrientes> createState() => _SliderWidgetNutrientesState();
}

class _SliderWidgetNutrientesState extends State<SliderWidgetNutrientes> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Center(
            child: Image.asset(
              'assets/images/nutri.png',
              width: 220,
            ),
          ),
        ),
      ],
    );
  }
}
