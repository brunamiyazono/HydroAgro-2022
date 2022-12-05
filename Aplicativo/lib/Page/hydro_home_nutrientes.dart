import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../widgets/slide_widget_nutriente.dart';

class HydroHomeNutrientes extends StatefulWidget {
  const HydroHomeNutrientes({super.key});

  @override
  State<HydroHomeNutrientes> createState() => _HydroHomeNutrientesState();
}

class _HydroHomeNutrientesState extends State<HydroHomeNutrientes> {
  final dbRf = FirebaseDatabase.instance.ref();

  bool valueNutrienteA = false;
  bool valueNutrienteB = false;

  Future<void> setValueNutrienteA() async {
    dbRf.child("nutrienteA").set({"nutrienteA": !valueNutrienteA});
  }

  onUpdateValueNutrienteA() {
    setState(() {
      valueNutrienteA = !valueNutrienteA;
    });
  }

  Future<void> setValueNutrienteB() async {
    dbRf.child("nutrienteB").set({"nutrienteB": !valueNutrienteA});
  }

  onUpdateValueNutrienteB() {
    setState(() {
      valueNutrienteA = !valueNutrienteA;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.grey,
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.login,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: const [
                Text(
                  'Nutrientes',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                  ),
                ),
                Text(
                  'HydroAgro',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Expanded(
              child: SliderWidgetNutrientes(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Nutriente A'),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: LiteRollingSwitch(
                        width: 100,
                        value: false,
                        colorOn: Colors.greenAccent,
                        colorOff: Colors.redAccent,
                        iconOff: Icons.power_settings_new,
                        iconOn: Icons.power_settings_new,
                        textSize: 18.0,
                        onTap: () {
                          setValueNutrienteA();
                          onUpdateValueNutrienteA();
                        },
                        onDoubleTap: () {},
                        onSwipe: () {},
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Nutriente B'),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: LiteRollingSwitch(
                        width: 100,
                        value: false,
                        colorOn: Colors.greenAccent,
                        colorOff: Colors.redAccent,
                        iconOff: Icons.power_settings_new,
                        iconOn: Icons.power_settings_new,
                        textSize: 18.0,
                        onTap: () {
                          setValueNutrienteB();
                          onUpdateValueNutrienteB();
                        },
                        onDoubleTap: () {},
                        onSwipe: () {},
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
