import 'package:flutter/material.dart';
  import 'package:blood/authentication/signin.dart';

  class SignUpScreen extends StatefulWidget {
    const SignUpScreen({Key? key}) : super(key: key);

    @override
    State<SignUpScreen> createState() => _SignUpScreenState();
  }

  class _SignUpScreenState extends State<SignUpScreen> {
    final _formKey = GlobalKey<FormState>();
    double screenHeight = 0;
    double screenWidth = 0;
    int phno=0;
    String email='';
    String password='';
    String confirmpassword='';

    @override
    Widget build(BuildContext context) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;

      return Scaffold(
        backgroundColor: Colors.red[900],
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight / 8,
                  ),
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: screenWidth / 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              square(-30, 0.12),
              square(-10, 0.3),
              square(10, 1),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: screenHeight / 2,
                  width: screenWidth,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth / 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              onChanged: (val){
                                phno = int.parse(val);
                              },
                              validator:(val){
                                if(val!.isEmpty){
                                  return 'Please enter your phone number';
                                }
                                final phoneExp = RegExp(r'^\d{10}$');
                                if(!phoneExp.hasMatch(val)){
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                              decoration:const InputDecoration(
                                hintText: 'Phone number',
                                hintStyle:  TextStyle(
                                  fontSize: 14,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              prefixIcon: Icon(
                              Icons.phone,
                                color: Colors.black26,
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 14,
                              ),
                            ),
                            ),
                            const SizedBox(height: 3),
                              TextFormField(
                                onChanged: (val){
                                  email=val;
                                },
                                validator:(val)=>val!.isEmpty?"Please enter email":null,
                                decoration:const InputDecoration(
                                  hintText: 'Email',
                                  hintStyle:  TextStyle(
                                    fontSize: 14,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                                prefixIcon: Icon(
                                Icons.email_outlined,
                                  color: Colors.black26,
                                ),
                                contentPadding: EdgeInsets.only(
                                  top: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                              TextFormField(
                                onChanged: (val){
                                  password=val;
                                },
                                obscureText: true,
                                validator:(val)=>val!.length<6?"Password should contain atleast 6 characters":null,
                                decoration:const InputDecoration(
                                  hintText: 'Password',
                                  hintStyle:  TextStyle(
                                    fontSize: 14,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                                prefixIcon: Icon(
                                Icons.password,
                                  color: Colors.black26,
                                ),
                                contentPadding: EdgeInsets.only(
                                  top: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                              TextFormField(
                                onChanged: (val){
                                  confirmpassword = val;
                                },
                                obscureText: true,
                                validator:(val){
                                  if(val!.length<6){
                                    return 'Password should contain atleast 6 characters';
                                  }
                                  if(confirmpassword!=password){
                                    return 'Passwords do not match !';
                                  }
                                  confirmpassword=val;
                                  return null;
                                },
                                decoration:const InputDecoration(
                                  hintText: 'Confirm Password',
                                  hintStyle:  TextStyle(
                                    fontSize: 14,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                                prefixIcon: Icon(
                                Icons.password_sharp,
                                  color: Colors.black26,
                                ),
                                contentPadding: EdgeInsets.only(
                                  top: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                      ElevatedButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){}
                            
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade900),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                              const  TextStyle(fontSize: 20),
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  side: const BorderSide(color: Color.fromARGB(255, 49, 11, 8)),
                                ),
                              ),
                            ),
                            child: const Text('Sign Up'),
                          ),

                          const SizedBox(height: 10.0),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 30,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Already have an account? Login",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    Widget square(double y, double opacity) {
      return Center(
        child: Transform.translate(
          offset: Offset(screenWidth / 30, y),
          child: Transform.rotate(
            angle: -0.4,
            child: Container(
              height: screenHeight / 3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(opacity),
                borderRadius: BorderRadius.circular(55),
              ),
            ),
          ),
        ),
      );
    }
  }