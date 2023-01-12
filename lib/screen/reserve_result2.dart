import 'dart:io';

import 'package:airplain_reserve/screen/reserve_result1.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dto/ticket.dart';
import '../util.dart';

class ReserveResult2 extends StatefulWidget {
  List<Ticket>? ticketList;
  ReserveResult2({required this.ticketList, Key? key}) : super(key: key);

  @override
  State<ReserveResult2> createState() => _ReserveResult2State();
}

class _ReserveResult2State extends State<ReserveResult2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
          body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              lvBuilder(),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(onPressed: () {
                    Navigator.pop(context);
                  },child: Icon(Icons.arrow_back_rounded),),
                ),
              ),
            ],
          )),
    );
  }

  Widget lvBuilder() {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: widget.ticketList!.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              String link = Util().getWeb(widget.ticketList![index].airlineName)!;
              if(link != 'error') {
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
                Text('${Util().transTime(widget.ticketList![index].ticketDate)} - ${Util().transTime(widget.ticketList![index].depTime)} - ${Util().transTime(widget.ticketList![index].arrTime)}'),
                Text('${Util().getTime(widget.ticketList![index].depTime!, widget.ticketList![index].arrTime!)}')
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
                      Text(Util().getCharge(
                          widget.ticketList![index].ticketCharge.toString()))
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
