import 'package:blood/models/request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestLists extends StatefulWidget {
  const RequestLists({super.key});

  @override
  State<RequestLists> createState() => _RequestListsState();
}

class _RequestListsState extends State<RequestLists> {
  @override
  Widget build(BuildContext context) {
    // requests will hold the current value of stream
    //The requests variable  access the data contained in the QuerySnapshot
    // and perform any necessary operations on it.
    final requests = Provider.of<List<Request>>(context);
    // requests.forEach((req){
    //   print(req.name);
    //   print(req.status);
    //   print(req.units);
    // });
    return ListView.builder(
      itemCount: requests.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context,index){
        return ListTile(
          title: Text("Patients Name: ${requests[index].patientName!}\nRequired Blood Group : ${requests[index].bloodGroup!}"),
          subtitle: Text("Requestor name: ${requests[index].name!}\nUnits: ${requests[index].units!}"),
          contentPadding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          tileColor: Colors.red[100],

        );
      },
    );
  }
}