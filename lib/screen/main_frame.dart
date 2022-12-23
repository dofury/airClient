import 'package:airplain_reserve/screen/reserve_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AirBar(),
        body: const ReserveScreen(),
        bottomNavigationBar: BottomAppBar(
            child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(Icons.phone),
              Icon(Icons.message),
              Icon(Icons.abc_outlined)
            ],
          ),
        )));
  }
}

