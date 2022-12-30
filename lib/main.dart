import 'package:airplain_reserve/screen/main_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1440, 2560),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context , child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // You can use the library anywhere in the app even in theme
            theme: ThemeData(
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
          );
        },
    child: MaterialApp(debugShowCheckedModeBanner: false, home: const HomeScreen(),theme: ThemeData(
      fontFamily: 'MaruBuri',
      primaryColor: Colors.grey
    ),));
  }
}

