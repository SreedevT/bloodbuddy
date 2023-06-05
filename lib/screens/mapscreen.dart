import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class NewInter extends StatefulWidget {
  const NewInter({super.key});

  @override
  State<NewInter> createState() => _NewInterState();
}

class _NewInterState extends State<NewInter> {
  String location='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 36, 30),
        elevation: 0,
        title: const Text('Search your current location')
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Container(
            height:300,
              margin:  const EdgeInsets.only(top:20,left:20,right:20,bottom: 20),
              decoration:BoxDecoration(
              // shape also can be specified like this => shape: BoxShape.circle,
              color: const Color.fromARGB(255, 129, 36, 30), // use decoration for giving both color and radius
              borderRadius: BorderRadius.circular(20),   // otherwise, if we give it separately, error will show up
              border: Border.all(
              color:Colors.white,
              width:1,
              ),
              boxShadow: [
                BoxShadow(
                color: Colors.black.withOpacity(1.0),  // here, I set opacity to maximum
                spreadRadius: 3,  // this is to specify how much spread the shadow
                blurRadius: 10,   // how much blur the shadow
                //  offset: Offset(0, 3),
              ),
              ]
              ),
              child:  Center(
                child:Column(
                  children:  [
                     const SizedBox(height:50),
                     const Text("Thanks for coming so far!",
                    style: TextStyle(
                      color:Colors.white,
                      fontSize:20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    const SizedBox(height:20),
                    const Text("Please set your location by clicking the below shown button.",
                    style:TextStyle(
                      color:Colors.white,
                      fontSize:16,                   
                    ),
                    textAlign:TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(height:100),
                        Icon(Icons.info_outline_rounded,
                        color:Colors.white,
                        ),
                        SizedBox(width:10),
                        Text("We don't share your location with anyone.",
                        style:TextStyle(
                          color:Colors.white,
                        ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),   // by writing this instead of materialstateproperty, we can give dynamic colors 
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.green.withOpacity(0.3)),  // like here the button color is changed, when we tap it. COOL ;)
                      ),
                      child: const Text("Set Current Location",
                      style:TextStyle(
                        color:Color.fromARGB(255, 129, 36, 30),
                      ),
                      ),
                      onPressed: (){
                        showModalBottomSheet(
                          context:context,
                          barrierColor: Colors.black.withOpacity(0.7),  // so what this does is that it gives this color to main screen when the sheet pops up
                          builder: (BuildContext context)
                          {
                            return  Container(
                                height:500,
                                child: OpenStreetMapSearchAndPick(
                                  center:LatLong(0, 0),
                                  buttonColor: const Color.fromARGB(255, 129, 36, 30),
                                  onPicked: (PickedData){
                                    setState(() {
                                      location=PickedData.address;
                                    });
                                    Navigator.pop(context);  // this enables  to close the bottom sheet when this button is clicked
                                  },
                                )    
                              );
                          }
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height:20),
            Text(location,
            style:const TextStyle(
              color: Color.fromARGB(255, 129, 36, 30),
              fontSize:20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 10,),
            // ElevatedButton(onPressed: (){}, child: Text("Next")),
        ],
          )
      );
  }
}