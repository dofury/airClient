import 'package:flutter/material.dart';

class AirBar extends StatelessWidget with PreferredSizeWidget{
  const AirBar({super.key});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
    title: const Text('항공 어플', style: TextStyle(fontFamily: "MaruBuri")),
  backgroundColor: Colors.indigoAccent,
  leading: const Icon(Icons.arrow_back),
  actions: const [
  Padding(padding: EdgeInsets.all(10.0), child: Icon(Icons.more_horiz),
  )
  ],
  );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

