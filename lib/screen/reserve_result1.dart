import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:airplain_reserve/screen/reserve_result2.dart';
import 'package:airplain_reserve/util.dart';
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
                            Util().callAPI(widget.regionData2,widget.regionData1,widget.dateData2).then((result) {
                              setState(() {
                                if (result != 404) {
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
                          child: const Icon(Icons.arrow_forward_rounded),
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomLeft,
                        child: FloatingActionButton(
                          heroTag: "prev",
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
                    heroTag: "next",
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
              String link = Util().getWeb(widget.ticketList![index].airlineName)!;
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
                            '${Util().transTime(widget.ticketList![index].ticketDate)} - ${Util().transTime(widget.ticketList![index].depTime)} - ${Util().transTime(widget.ticketList![index].arrTime)}'),
                        Text(
                            '${Util().getTime(widget.ticketList![index].depTime!, widget.ticketList![index].arrTime!)}')
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
                        Text(Util().getCharge(
                            widget.ticketList![index].ticketCharge.toString())),
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
}
