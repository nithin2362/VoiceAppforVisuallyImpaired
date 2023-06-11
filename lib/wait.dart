// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// Widget textIt(String text,Color color,double size)
// {
//   return Text(text,style: TextStyle(color: color,fontSize: size,fontWeight: FontWeight.bold));
// }

// class WaitScreen extends StatelessWidget {
//   final String flag;
//   final Color bgcolor;
//   WaitScreen(this.flag,this.bgcolor);

//   @override
//   Widget build(BuildContext context) {
    
//   if(flag == "Intro")
//   {
//     return Scaffold(
//       backgroundColor: this.bgcolor,
//       body: Container(
//         child: Column(
//           mainAxisAlignment:MainAxisAlignment.center,
//           children: [
//             textIt("LOCATION TRACKER", Colors.white, 30),
//             SizedBox(height: 30,),
//             SpinKitDoubleBounce(
//               color: Colors.white,
//               size: 80,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   else if(flag == "Weather")
//   {
//     return Scaffold(
//       backgroundColor: this.bgcolor,
//       body: Container(
//         child: Column(
//           mainAxisAlignment:MainAxisAlignment.center,
//           children: [
//             textIt("Fetching Weather Details...", Colors.white, 25),
//             SizedBox(height: 30,),
//             SpinKitFoldingCube(
//               color: Colors.white,
//               size: 80,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   else if(flag == "Location")
//   {
//     return Scaffold(
//       backgroundColor: this.bgcolor,
//       body: Container(
//         child: Column(
//           mainAxisAlignment:MainAxisAlignment.center,
//           children: [
//             textIt("Fetching Location Details...", Colors.white, 25),
//             SizedBox(height: 30,),
//             SpinKitWave(
//               color: Colors.white,
//               size: 80,
//             ),            
//           ],
//         ),
//       ),
//     );
//   }

//   return Scaffold(
//     backgroundColor: this.bgcolor,
//     body: Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           textIt("Fetching Details...", Colors.white, 30),
//           SizedBox(height: 30,),
//           SpinKitPouringHourGlass(
//                 color: Colors.white,
//                 size: 80,
//           ),
//         ],
//       ),
//     ));
// }
// }
