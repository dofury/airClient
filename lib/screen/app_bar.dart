import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AirBar extends StatelessWidget with PreferredSizeWidget{
  const AirBar({super.key});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
    title: const Text('항공 어플',
        style: TextStyle(fontFamily: 'MaruBuri',fontSize: 25,fontWeight: FontWeight.w600 ),),
  centerTitle: true,
  backgroundColor: Colors.indigoAccent,
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

