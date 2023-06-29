import 'package:blood/models/request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String pname;
  late String btype;
  late int units;
  User? user;

  List<String> bloodGroups = ['A+', 'B+', 'A-', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  @override
  void initState(){
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text("Request Form"),
      ),
      body: Padding(
        padding:const EdgeInsets.fromLTRB(20,40,20,0),
        child: Form(
          key:_formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (val) {
                      if(val!.isEmpty){
                        return "Please enter your name";
                      }
                      name = val;
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_2_outlined),
                      hintText: "Your Name",
                      hintStyle: TextStyle(
                        color:Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextFormField(
                    validator: (val) {
                      if(val!.isEmpty){
                        return "Please enter the patient's name";
                      }
                      pname = val;
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon:Icon(Icons.person),
                      hintText:"Patient's Name",
                      hintStyle: TextStyle(
                        color:Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (val){
                      if(val!.isEmpty){
                        return "Please enter the number of units required";
                      }
                      else if(int.tryParse(val) == null){
                        return "Please enter units in number";
                      }
                      units = int.parse(val);
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon:Icon(Icons.bloodtype_rounded),
                      hintText: "Units",
                      hintStyle: TextStyle(
                        color:Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  DropdownButtonFormField(
                    validator: (val){
                      if(val == null){
                        return "Please select a blood group";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.bloodtype_outlined),
                      hintText: "Blood Group",
                      hintStyle: TextStyle(
                        color:Colors.grey),
                    ),
                    items: [
                      for (var bGroups in bloodGroups)
                      DropdownMenuItem(
                        value: bGroups,
                         child: Text(bGroups),
                        ),],
                        onChanged: (val){
                          setState(() {
                            btype = val.toString();
                          });
                        },
                  ),
                  const SizedBox(height: 30,),
                  Center(
                    child: ElevatedButton(onPressed: (){
                      if(_formKey.currentState!.validate()){
                        Request(id: user!.uid, bloodGroup: btype, units: units, patientName: pname,name:name).updateRequest();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 80, 131, 82))
                    ),
                     child: const Text("Submit",
                     style: TextStyle(
                       fontSize: 15,
                       fontWeight: FontWeight.bold,
                       color: Colors.white,
                     ),),
                    ),
                  ),
                ],
              )
              ),
      )
      
    );
  }
}