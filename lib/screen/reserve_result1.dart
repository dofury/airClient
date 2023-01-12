import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:airplain_reserve/screen/reserve_result2.dart';
import 'package:airplain_reserve/screen/reserve_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../dto/ticket.dart';

class ReserveResult1 extends StatefulWidget {
  List<Ticket> ticketList;
  String regionData1;
  String regionData2;
  String dateData2;
  bool isWayPart;
  ReserveResult1(
      {required this.isWayPart,
      required this.ticketList,
      required this.regionData2,
      required this.regionData1,
      required this.dateData2,
      Key? key})
      : super(key: key);

  @override
  State<ReserveResult1> createState() => _ReserveResult1State();
}

class _ReserveResult1State extends State<ReserveResult1> {
  late List<Ticket> ticketList2 = [];
  var status;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white70,
          body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              lvBuilder(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.isWayPart
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              loading = true;
                            });
                            _callAPI().then((result) {
                              setState(() {
                                if (result != 0) {
                                  ticketList2.clear();
                                  ticketList2.addAll(result);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ReserveResult2(
                                        ticketList: ticketList2,
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
                                }
                                else{
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
                          child: const Icon(Icons.arrow_forward_rounded),
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomLeft,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_rounded),
                        ),
                      ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: widget.isWayPart
                      ? FloatingActionButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_rounded),
                        )
                      : Text(''),
                ),
              ),
              loading == true
                  ? Center(child: CircularProgressIndicator())
                  : Text(''),
            ],
          )),
    );
  }

  Widget lvBuilder() {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: widget.ticketList!.length,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              String link = _getWeb(widget.ticketList![index].airlineName)!;
              if (link != 'error') {
                launchUrl(Uri.parse(link));
              }
            },
            child: Container(
              height: 200,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${_transTime(widget.ticketList![index].ticketDate)} - ${_transTime(widget.ticketList![index].depTime)} - ${_transTime(widget.ticketList![index].arrTime)}'),
                        Text(
                            '${_getTime(widget.ticketList![index].depTime!, widget.ticketList![index].arrTime!)}')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            style: TextStyle(color: Colors.grey),
                            '${widget.ticketList![index].ticketName}, ${widget.ticketList![index].airlineName}')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${widget.ticketList![index].depAirportName} - ${widget.ticketList![index].arrAirportName}')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${widget.ticketList![index].ticketCharge}원')
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
              height: 10.0,
              color: Colors.white24,
            ));
  }

  String? _getWeb(String airLine) {
    String? link;
    switch (airLine) {
      case '진에어':
        link = 'https://www.jinair.com/booking/index';
        break;
      case '제주항공':
        link = 'https://www.jejuair.net/ko/main/base/index.do';
        break;
      case '대한항공':
        link = 'https://www.koreanair.com/kr/ko';
        break;
      case '에어부산':
        link = 'https://www.airbusan.com/content/individual/?';
        break;
      default:
        link = 'error';
    }
    return link;
  }

  String? _transTime(String time) {
    String transData = '';
    if (time.length == 4) {
      String hour, minute;

      hour = time.substring(0, 2);
      minute = time.substring(2, 4);
      transData = '$hour:$minute';
    } else if (time.length == 8) {
      String year, month, day;

      year = time.substring(0, 4);
      month = time.substring(4, 6);
      day = time.substring(6, 8);
      transData = '$year/$month/$day';
    } else {
      transData = 'error';
    }

    return transData;
  }

  String? _getTime(var dep, var arr) {
    var depHour, arrHour;
    var depMinute, arrMinute;
    var hour, minute;

    depHour = int.parse(dep.substring(0, 2));
    depMinute = int.parse(dep.substring(2, 4));
    arrHour = int.parse(arr.substring(0, 2));
    arrMinute = int.parse(arr.substring(2, 4));

    if (arrMinute - depMinute < 0) //분이 0보다 작을시
    {
      arrMinute += 60;
      arrHour -= 1;
    }
    if (arrHour - depHour < 0) //시가 0보다 작을시
    {
      arrHour += 24;
    }

    hour = arrHour - depHour;
    minute = arrMinute - depMinute;

    return '$hour시간 $minute분';
  }

  Future _callAPI() async {
    var url = Uri.parse('http://203.232.193.169:8080/air?depName=' +
        widget.regionData2! +
        '&arrName=' +
        widget.regionData1! +
        '&date=' +
        widget.dateData2!);
    final response = await http.get(url);
    String responseBody = utf8.decode(response.bodyBytes);
    status = jsonDecode(responseBody)['status'].toString();
    log(status);
    if (status == "200") {
      var dataObjJson = jsonDecode(responseBody)['data'] as List;
      List<Ticket> parsedResponse =
          dataObjJson.map((dataJson) => Ticket.fromJson(dataJson)).toList();
      return parsedResponse;
    } else {
      return 0;
    }
  }
}
