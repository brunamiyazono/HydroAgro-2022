import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_hidroponia/Page/hydro_home_agua.dart';
import 'package:sistema_hidroponia/Page/hydro_home_ambiente.dart';
import 'package:sistema_hidroponia/Page/hydro_home_nutrientes.dart';

class HydroHomeInit extends StatefulWidget {
  const HydroHomeInit({super.key});

  @override
  State<HydroHomeInit> createState() => _HydroHomeInitState();
}

class _HydroHomeInitState extends State<HydroHomeInit> {
  static const List<Widget> _widgetOptions = <Widget>[
    HydroHomeAgua(),
    HydroHomeAmbiente(),
    HydroHomeNutrientes(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 33, 243, 86).withAlpha(10),
                  blurRadius: 20,
                  spreadRadius: 12,
                ),
              ],
              border: Border.all(
                width: 6,
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              unselectedItemColor: Colors.grey.withAlpha(100),
              fixedColor: Colors.grey.shade500,
              // fixedColor: selectedColor(),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.water_drop_rounded), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.energy_savings_leaf_rounded), label: ''),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.leaf), label: ''),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }

  // Color selectedColor() {
  //   switch (_selectedIndex) {
  //     case 0:
  //       return Colors.blue;
  //     case 1:
  //       return Colors.green;
  //     case 2:
  //       return Colors.yellow;
  //     default:
  //       return Colors.grey;
  //   }
  // }
}
