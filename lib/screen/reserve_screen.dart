import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReserveScreen extends StatelessWidget {
  const ReserveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: const SizedBox(
                child: Text("쉽고 편한 최저가 항공권 예약",
                    style: TextStyle(fontSize: 30, fontFamily: "MaruBuri")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  TextButton(
                      onPressed: null,
                      child: Text(
                        "왕복",
                        style: TextStyle(
                            fontFamily: "MaruBuri",
                            fontSize: 30,
                            color: Colors.blue),
                      )),
                  TextButton(
                      onPressed: null,
                      child: Text(
                        "편도",
                        style: TextStyle(
                          fontFamily: "MaruBuri",
                          fontSize: 30,
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            child: Icon(Icons.gps_fixed, size: 25.0),
                            flex: 1),
                        Flexible(child: selectRegion(0), flex: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            child: Icon(Icons.gps_fixed, size: 25.0),
                            flex: 1),
                        Flexible(child: selectRegion(1), flex: 10),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: selectDate()),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: '인원'),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: null,
                    child: Text("항공권 검색"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class selectRegion extends StatefulWidget {
  final int check;
  const selectRegion(this.check);
  selectRegion.withA({Key? key, required this.check}) : super(key: key);

  @override
  State<selectRegion> createState() => _selectRegionState();
}

class _selectRegionState extends State<selectRegion> {
  final _valueList = ['서울', '부산', '제주', '김포', '김해', '인천'];
  String? _selectedValue;
  String? textName = 't';
  @override
  Widget build(BuildContext context) {
    textCheck(widget.check);
    return DropdownButton(
      isExpanded: true,
      hint: Text(textName!),
      value: _selectedValue,
      items: _valueList.map((e) {
        return DropdownMenuItem(
          child: Text(e),
          value: e,
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selectedValue = val as String;
        });
      },
    );
    ;
  }

  textCheck(check) {
    if (check == 0)
      textName = "출발 공항";
    else
      textName = "도착 공항";
  }
}

class selectDate extends StatefulWidget {
  const selectDate({Key? key}) : super(key: key);

  @override
  State<selectDate> createState() => _selectDateState();
}

class _selectDateState extends State<selectDate> {
  String? date = '날짜';
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Future<DateTime?> future = showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2018),
              lastDate: DateTime(2030),
              builder: (BuildContext context, Widget? child) {
                return Theme(data: ThemeData.dark(), child: child!);
              });
          future.then((date) {
            setState(() {
              this.date = DateFormat('yy/MM/dd').format(date!);
            });
          });
        },
        child: Text(date!));

    /* DatePicker 띄우기 */
    void showDatePickerPop() {
      Future<DateTime?> selectedDate = showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //초기값
        firstDate: DateTime(2020),
        //시작일
        lastDate: DateTime(2022),
        //마지막일
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark(), //다크 테마
            child: child!,
          );
        },
      );
    }
  }
}
