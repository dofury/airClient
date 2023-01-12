import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dto/ticket.dart';

class ReserveResult extends StatefulWidget {
  List<Ticket>? ticketList;
  ReserveResult({required this.ticketList, Key? key}) : super(key: key);

  @override
  State<ReserveResult> createState() => _ReserveResultState();
}

class _ReserveResultState extends State<ReserveResult> {
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
                child: FloatingActionButton(onPressed: () {
                  Navigator.pop(context);
                },child: Icon(Icons.arrow_back_rounded),),
              ),
            ],
          )),
    );
  }

  Widget lvBuilder() {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: widget.ticketList!.length,
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              launchUrl(Uri.parse("http://www.naver.com"));
              print('s');
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
                Text('${widget.ticketList![index].ticketDate} : ${widget.ticketList![index].depTime} - ${widget.ticketList![index].arrTime}'),
                Text('1시간 10분')
                ],
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text
                (style: TextStyle(color: Colors.grey),'${widget.ticketList![index].ticketName}, ${widget.ticketList![index].airlineName}')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget.ticketList![index].depAirportName} - ${widget.ticketList![index].arrAirportName}')
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
        }, separatorBuilder: (BuildContext context, int index) => const Divider(
      height: 10.0,
      color: Colors.white24,


    ));
  }

}
