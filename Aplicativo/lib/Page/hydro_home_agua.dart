import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../widgets/slider_widget_agua.dart';

class HydroHomeAgua extends StatefulWidget {
  const HydroHomeAgua({super.key});

  @override
  State<HydroHomeAgua> createState() => _HydroHomeAguaState();
}

class _HydroHomeAguaState extends State<HydroHomeAgua> {
  late final DatabaseReference databasePhAgua;
  late final DatabaseReference databaseTdsAgua;
  late final DatabaseReference databaseTemperaturaAgua;
  late final DatabaseReference databaseluz;
  final dbRf = FirebaseDatabase.instance.ref();

  late StreamSubscription<DatabaseEvent> _databaseSubscription;
  num valueSensorPh = 0.0;
  num valueSensorTds = 0;
  num valueSensorTemperaturaAgua = 0.0;
  bool valueBombaAgua = false;

  Future<void> setBombaAgua() async {
    dbRf.child("Motor").set({"controllerMotor": !valueBombaAgua});
  }

  onUpdateBombaAgua() {
    setState(() {
      valueBombaAgua = !valueBombaAgua;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    databasePhAgua = FirebaseDatabase.instance.ref("sensores").child("phAgua");
    databaseTdsAgua = FirebaseDatabase.instance.ref("sensores").child("tdsAgua");
    databaseTemperaturaAgua = FirebaseDatabase.instance.ref("sensores").child("temperaturaAgua");

    try {
      final sensorsTemperaturaAmbeinte = await databasePhAgua.get();
      valueSensorPh = sensorsTemperaturaAmbeinte.value as num;

      final sensorsTds = await databaseTdsAgua.get();
      valueSensorTds = sensorsTds.value as num;

      final sensorsTemperaturaAgua = await databaseTemperaturaAgua.get();
      valueSensorTemperaturaAgua = sensorsTemperaturaAgua.value as num;

      // final liteAgua = await databaseluz.get();
      // valueBombaAgua = liteAgua.value as bool;

    } catch (err) {
      debugPrint(err.toString());
    }

    // _databaseSubscription = databaseluz.onValue.listen((DatabaseEvent event) {
    //   setState(() {
    //     valueBombaAgua = (event.snapshot.value as bool);
    //   });
    // });

    _databaseSubscription = databasePhAgua.onValue.listen((DatabaseEvent event) {
      setState(() {
        valueSensorPh = (event.snapshot.value as num);
      });
    });

    _databaseSubscription = databaseTdsAgua.onValue.listen((DatabaseEvent event) {
      setState(() {
        valueSensorTds = (event.snapshot.value as num);
      });
    });

    _databaseSubscription = databaseTemperaturaAgua.onValue.listen((DatabaseEvent event) {
      setState(() {
        valueSensorTemperaturaAgua = (event.snapshot.value as num);
      });
    });
  }

  @override
  void dispose() {
    _databaseSubscription.cancel();
    super.dispose();
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
                  'Água',
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
              child: SliderWidgetAgua(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'PH Água',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      valueSensorPh.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'TDS Água',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$valueSensorTds ppm'.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Temperaura',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$valueSensorTemperaturaAguaº'.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: LiteRollingSwitch(
                        width: 100,
                        value: false,
                        textOn: "On",
                        textOff: "Off",
                        colorOn: Colors.greenAccent,
                        colorOff: Colors.redAccent,
                        iconOff: Icons.power_settings_new,
                        iconOn: Icons.power_settings_new,
                        textSize: 18.0,
                        onTap: () {
                          setBombaAgua();
                          onUpdateBombaAgua();
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
