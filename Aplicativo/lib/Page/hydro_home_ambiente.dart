import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:sistema_hidroponia/widgets/slider_widget_ambiente.dart';

class HydroHomeAmbiente extends StatefulWidget {
  const HydroHomeAmbiente({super.key});

  @override
  State<HydroHomeAmbiente> createState() => _HydroHomeAmbienteState();
}

class _HydroHomeAmbienteState extends State<HydroHomeAmbiente> {
  late final DatabaseReference databaseCo2;
  late final DatabaseReference databaseTemperaturaAmbiente;
  late final DatabaseReference databaseTemperaturaHumidade;
  final dbRf = FirebaseDatabase.instance.ref();

  late StreamSubscription<DatabaseEvent> _databaseSubscription;
  num valueSensorCo2 = 0;
  num valueSensortemperaturaAmbiente = 0;
  num valueSensorUmidadeAmbiente = 0;
  bool valueLuz = false;

  Future<void> setLuz() async {
    dbRf.child("luz").set({"controllerLuz": !valueLuz});
  }

  onUpdate() {
    setState(() {
      valueLuz = !valueLuz;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    databaseCo2 = FirebaseDatabase.instance.ref("sensores").child("co2Ambiente");
    databaseTemperaturaAmbiente = FirebaseDatabase.instance.ref("sensores").child("temperaturaAmbiente");
    databaseTemperaturaHumidade = FirebaseDatabase.instance.ref("sensores").child("umidadeAmbiente");

    try {
      final sensorsCo2 = await databaseCo2.get();
      valueSensorCo2 = sensorsCo2.value as double;

      final sensorsTemperaturaAmbiente = await databaseTemperaturaAmbiente.get();
      valueSensortemperaturaAmbiente = sensorsTemperaturaAmbiente.value as int;

      final sensorsTemperaturaUmidadeAmbiente = await databaseTemperaturaHumidade.get();
      valueSensorUmidadeAmbiente = sensorsTemperaturaUmidadeAmbiente.value as double;
    } catch (err) {
      debugPrint(err.toString());
    }

    _databaseSubscription = databaseCo2.onValue.listen((DatabaseEvent event) {
      setState(() {
        valueSensorCo2 = (event.snapshot.value as num);
      });
    });

    _databaseSubscription = databaseTemperaturaAmbiente.onValue.listen((DatabaseEvent event) {
      setState(() {
        valueSensortemperaturaAmbiente = (event.snapshot.value as num);
      });
    });

    _databaseSubscription = databaseTemperaturaHumidade.onValue.listen((DatabaseEvent event) {
      setState(() {
        valueSensorUmidadeAmbiente = (event.snapshot.value as num);
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
                  'Ambiente',
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
              child: SliderWidgetAmbiente(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '    CO2      ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$valueSensorCo2 ppm'.toString(),
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
                      'Temperatura',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$valueSensortemperaturaAmbienteº'.toString(),
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
                      'Umidade',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$valueSensorUmidadeAmbiente %'.toString(),
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
                          setLuz();
                          onUpdate();
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
