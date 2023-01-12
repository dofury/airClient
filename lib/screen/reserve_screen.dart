import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:airplain_reserve/screen/reserve_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../dto/ticket.dart';

class ReserveScreen extends StatefulWidget {
  ReserveScreen({super.key});

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  bool is_wayPart = true;
  bool loading = false;
  var regionData1 = selectRegion(0);
  var regionData2 = selectRegion(1);
  var dateDate1 = selectDate();
  var dateDate2 = selectDate();
  late List<Ticket> _ticketList = [];
  void clickPart() {
    setState(() {
      if (is_wayPart == true) {
        is_wayPart = false;
      } else {
        is_wayPart = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
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
              child: wayPart(is_wayPart: is_wayPart, clickPart: clickPart),
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
                  loading == true ? CircularProgressIndicator() : Text(''),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: dateDate1),
                  is_wayPart == true
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: dateDate2)
                      : Text(""),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      //progress indicator start show
                      _callAPI().then((result) {
                        setState(() {
                          _ticketList.clear();
                          _ticketList.addAll((result));
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ReserveResult(ticketList: _ticketList,),
                            ),
                          );
                        });
                        loading = false;
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
    );
  }

Future<List<Ticket>> _callAPI() async {
    var url = Uri.parse(
      'http://203.232.193.169:8080/air?depName='
          +regionData1.getRegion()!
          +'&arrName='
          +regionData2.getRegion()!
          +'&date='
          +dateDate1.getDate()!
    );
    final response = await http.get(url);
    String responseBody = utf8.decode(response.bodyBytes);
    var dataObjJson = jsonDecode(responseBody) as List;
    List<Ticket> parsedResponse = dataObjJson.map((dataJson) => Ticket.fromJson(dataJson)).toList();
    return parsedResponse;


  }


}

class wayPart extends StatefulWidget {
  bool is_wayPart;
  Color color = Colors.grey;
  Text? wayText1;
  Text? wayText2;
  wayPart({required bool this.is_wayPart, required this.clickPart, Key? key})
      : super(key: key) {
    init();
  }
  final Function() clickPart;
  init() {
    wayText1 = Text(
      "왕복",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(90),
          color: is_wayPart == true ? Colors.blue : Colors.grey),
    );
    wayText2 = Text(
      "편도",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(90),
          color: is_wayPart == false ? Colors.blue : Colors.grey),
    );
  }

  bool getWayPart() => is_wayPart;
  @override
  State<wayPart> createState() => _wayPartState();
}

class _wayPartState extends State<wayPart> {
  Row build(BuildContext context) {
    return Row(
      children: [
        TextButton(onPressed: _clickPart1, child: widget.wayText1!),
        TextButton(onPressed: _clickPart2, child: widget.wayText2!)
      ],
    );
  }

  void _clickPart1() {
    if (widget.is_wayPart == false) widget.clickPart();
  }

  void _clickPart2() {
    if (widget.is_wayPart == true) widget.clickPart();
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
  final _valueList = ['서울', '부산', '제주', '김포', '김해', '인천'];
  String? textName;
  @override
  Widget build(BuildContext context) {
    textCheck(widget.check);
    return DropdownButton(
      isExpanded: true,
      hint: Text(
        textName!,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: ScreenUtil().setSp(60)),
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
  String? getDate()
  {
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
                fontWeight: FontWeight.bold,
                color: Colors.grey,
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
