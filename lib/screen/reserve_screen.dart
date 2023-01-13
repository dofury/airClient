import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:airplain_reserve/screen/reserve_result1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../dto/ticket.dart';
import '../util.dart';

class ReserveScreen extends StatefulWidget {
  ReserveScreen({super.key});

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  bool isWayPart = true;
  bool loading = false;
  var regionData1 = selectRegion(0);
  var regionData2 = selectRegion(1);
  var dateData1 = selectDate();
  var dateData2 = selectDate();
  var status = '';
  late List<Ticket> _ticketList = [];
  void clickPart() {
    setState(() {
      if (isWayPart == true) {
        isWayPart = false;
      } else {
        isWayPart = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                child: Text("쉽고 편한 최저가 항공권 예약",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(85),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: WayPart(isWayPart: isWayPart, clickPart: clickPart),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1,
                            child: Icon(Icons.local_airport,
                                size: ScreenUtil().setHeight(100))),
                        Flexible(child: regionData1, flex: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Icon(Icons.local_airport,
                              size: ScreenUtil().setHeight(100)),
                        ),
                        Flexible(child: regionData2, flex: 10),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: dateData1),
                  isWayPart == true
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: dateData2)
                      : Text(""),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      Util().callAPI(regionData1.getRegion()!,regionData2.getRegion()!,dateData1.getDate()!).then((result) {
                        setState(() {
                          if (result != 0) {
                            _ticketList.clear();
                            _ticketList.addAll((result));
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ReserveResult1(
                                  isWayPart: isWayPart,
                                  ticketList: _ticketList,
                                  regionData2:
                                      regionData2.getRegion().toString(),
                                  regionData1:
                                      regionData1.getRegion().toString(),
                                  dateData2: dateData2.getDate().toString(),
                                ),
                              ),

                            );
                            Fluttertoast.showToast(
                                msg: "데이터 불러오기 완료.",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 20,
                                toastLength: Toast.LENGTH_SHORT);
                          } else {
                            Fluttertoast.showToast(
                                msg: "데이터를 받아올 수 없습니다.",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 20,
                                toastLength: Toast.LENGTH_SHORT);
                          }
                          loading = false;
                        });
                      });
                    },
                    child: Text(
                        style: TextStyle(fontSize: ScreenUtil().setSp(50)),
                        "항공권 검색"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      loading == true ? Center(child: CircularProgressIndicator()) : Text(''),
    ]);
  }
}

class WayPart extends StatefulWidget {
  bool isWayPart;
  Color color = Colors.grey;
  Text? wayText1;
  Text? wayText2;
  WayPart({required bool this.isWayPart, required this.clickPart, Key? key})
      : super(key: key) {
    init();
  }
  final Function() clickPart;
  init() {
    wayText1 = Text(
      "왕복",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(90),
          color: isWayPart == true ? Colors.blue : Colors.grey),
    );
    wayText2 = Text(
      "편도",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(90),
          color: isWayPart == false ? Colors.blue : Colors.grey),
    );
  }

  bool getWayPart() => isWayPart;
  @override
  State<WayPart> createState() => _WayPartState();
}

class _WayPartState extends State<WayPart> {
  Row build(BuildContext context) {
    return Row(
      children: [
        TextButton(onPressed: _clickPart1, child: widget.wayText1!),
        TextButton(onPressed: _clickPart2, child: widget.wayText2!)
      ],
    );
  }

  void _clickPart1() {
    if (widget.isWayPart == false) widget.clickPart();
  }

  void _clickPart2() {
    if (widget.isWayPart == true) widget.clickPart();
  }
}

class selectRegion extends StatefulWidget {
  final int check;
  selectRegion(this.check);
  String? _selectedValue;
  selectRegion.withA({Key? key, required this.check}) : super(key: key);

  @override
  State<selectRegion> createState() => _selectRegionState();
  String? getRegion() => _selectedValue;
}

class _selectRegionState extends State<selectRegion> {
  final _valueList = [
    '광주',
    '군산',
    '김포',
    '김해',
    '대구',
    '무안',
    '사천',
    '양양',
    '여수',
    '울산',
    '원주',
    '인천',
    '제주',
    '포항',
    '청주'
  ];
  String? textName;
  @override
  Widget build(BuildContext context) {
    textCheck(widget.check);
    return DropdownButton(
      isExpanded: true,
      hint: Text(
        textName!,
        style: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(60)),
      ),
      value: widget._selectedValue,
      items: _valueList.map((e) {
        return DropdownMenuItem(
          child: Text(e),
          value: e,
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          widget._selectedValue = val as String;
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
  selectDate({Key? key}) : super(key: key);
  String? date = '날짜';
  @override
  State<selectDate> createState() => _selectDateState();
  String? getDate() {
    String? tmpDate = '';
    tmpDate = date?.replaceAll('/', '');
    tmpDate = '20' + tmpDate!;
    return tmpDate;
  }
}

class _selectDateState extends State<selectDate> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.calendar_month, color: Colors.black),
          iconSize: ScreenUtil().setSp(150),
          onPressed: () {
            showPicker();
          },
        ),
        TextButton(
          onPressed: () {
            showPicker();
          },
          child: Text(
            widget.date!,
            style: TextStyle(
                fontFamily: 'MaruBuri',
                color: widget.date == '날짜' ? Colors.grey : Colors.black,
                fontSize: ScreenUtil().setSp((60))),
          ),
        )
      ],
    );
  }

  showPicker() {
    Future<DateTime?> future = showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? child) {
          return Theme(data: ThemeData.dark(), child: child!);
        });
    future.then((date) {
      setState(() {
        widget.date = DateFormat('yy/MM/dd').format(date!);
      });
    });
  }
}
