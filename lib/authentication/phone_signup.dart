import 'dart:developer';
import 'package:blood/authentication/verify.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  static String phoneNumber = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();

  String phone = "";

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
      ),
      body: Stack(
        children:[ 
          Transform.translate(
            offset: const Offset(100,-230),
            child: Container(
              height:300,
              decoration: BoxDecoration(
                color: Colors.red[800],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red[800]!.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(-2, 7), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(-100,-400),
            child:Container(
              height:470,
              decoration: BoxDecoration(
                color:Colors.red[800],
                shape:BoxShape.circle,
                boxShadow:[
                  BoxShadow(
                    color:Colors.red[800]!.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(2,7),
                  )
                ]
              ),
            )
          ),
          Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/otp.json',
                  width: 350,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const  [
                    Icon(Icons.phonelink_setup_rounded),
                    SizedBox(width:10),
                     Text(
                      "Phone Verification",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "We need to register your phone to get started!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countryController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        onChanged: (value) {
                          phone = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade800,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      MyPhone.phoneNumber = countryController.text + phone;
                      log(MyPhone.phoneNumber);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MyVerify()));
                    },
                    child: const Text(
                      "Send the code",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}
