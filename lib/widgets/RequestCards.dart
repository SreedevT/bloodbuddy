import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RequestCards extends StatefulWidget {

  final String name;
  final int units;
  final String address;
  final String date;
  final String time;
  RequestCards({required this.name,required this.units,required this.address,required this.date,required this.time});

  @override
  State<RequestCards> createState() => _RequestCardsState();
}

class _RequestCardsState extends State<RequestCards> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ListTile(
        leading: Icon(
          Icons.bloodtype_sharp,
          color: Colors.red,
          size: 50,
        ),
        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              Text('${widget.units} units', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5,),
              Text('${widget.address}'),
              SizedBox(height: 5,),
             Text('${widget.date}'),
             Text('${widget.time}'),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      onPressed: () {},
                      child: Text("Accept"),
                    ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Background color
                        foregroundColor: Colors.black, // Text color
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: Colors.red,
                              width: 2), // Border color and width
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Share",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ),
        trailing: Text(
          'O +ve',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}

class DateTimeInfo extends StatelessWidget {
  final String date;
  final String time;

  const DateTimeInfo({required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: $date'),
          Text('Time: $time'),
        ],
      ),
    );
  }
}
