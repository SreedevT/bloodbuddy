
import 'package:flutter/material.dart';
import '../widgets/RequestCards.dart';


class RequestPage extends StatefulWidget {
  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.red,
      appBar: AppBar(
        toolbarHeight: 60.0,
        elevation: 0,
        title: Text(
          "Request",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search for anything',
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 231, 231, 231),
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(30),
          //   topRight: Radius.circular(30),
          // ),
        ),
        child: ListView(
          children: [
          SizedBox(height: 5,),
            RequestCards(name: 'Sony K Martin',units: 10,address: 'Government Hospital Ernakulam, MG road, Kochi-12',date:'10 July 2023',time:'10.30am',),
            RequestCards(name: 'Sreedev T',units: 20,address: 'Aster Medicity Hospital,South kalamassery,Kochi -22',date:'15 July 2023',time:'11.30am',),
            RequestCards(name: 'Yadu Krishna T B',units: 7,address: 'KMMEAE Medicity Hospital,South kalamassery,Kochi -21',date:'19 July 2023',time:'09.30am',),
            RequestCards(name: 'Shafna Navas',units: 11,address: 'Government Hospital Ernakulam,MG road, Kochi-12',date:'30 July 2023',time:'10.25am',),

          ],
        ),
      ),
      
    );
  }
}
