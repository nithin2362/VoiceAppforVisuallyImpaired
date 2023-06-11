import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

String cityName = "Nil",stateName = "Nil",direction = "",placeType = "Nil";
DateTime lastViewed = DateTime.now();
String locationApi = "qNwNMrL7uXXS4MfRhdGcFpixBWQGTWbC";
double speed = 0.0;
//String locationApi = "AI42DHJnuEZmCYWcGAKfB3NKdYCdAX9j";
var lat = 12.89,lng = 79.08;
Widget textIt(String text,Color color,double size)
{
  return Text(text,style: TextStyle(color: color,fontSize: size));
}
Future<void> getData(String path)async
{
  await Firebase.initializeApp();
  final dBr = FirebaseDatabase.instance.ref();
  var lat = 12.80,lng = 79.08,temp,temp1;
  final snap = await dBr.child(path).get();
  if(snap.exists && snap.value != null)
  {
    temp = snap.value;
    speed = temp["Speed"];
    direction = temp["Direction"];
    lastViewed = DateTime.parse(temp["Last Viewed"].toString());
    lat = temp["Lat"];
    lng = temp["Lng"];
  }
  else
    {
      print("Data fetch failed in location.dart...");
      return;
    }
  int timeDifference = await DateTime.now().difference(lastViewed).inMinutes;
  if(timeDifference >= 15)
  {
    print("Making location API request");
    var location_url = Uri.parse(
      "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=$locationApi&q=$lat%2C$lng&details=false");
    Response response = await get(location_url);  
    if(response.statusCode == 200)
    {
      temp1 = await jsonDecode(response.body);
      cityName = temp1["EnglishName"];
      stateName = temp1["AdministrativeArea"]["EnglishName"];
      placeType = temp1["Type"];
      await dBr.child(path).update({"Place":cityName,"State":stateName,"Type":placeType,"Last Viewed":DateTime.now().toString()});
    }
  else 
    {
      print("Using data from Database");
      cityName = temp["Place"];
      stateName = temp["State"];
      placeType = temp["Type"] ?? "City";
      return;
    }
  }
  else 
  {
    print("Using data from Database");
    cityName = temp["Place"];
    stateName = temp["State"];
    placeType = temp["Type"] ?? "City";
  }
}
Future<String> locationText(String path) async
{
  // await Firebase.initializeApp();
  // final dBr = FirebaseDatabase.instance.ref();
  // final snapshot = await dBr.child(path).get();
  // var lastViewed = DateTime.now();
  // var temp,t_decoded;
  // if(snapshot.exists && snapshot.value != null)
  // {
  //   temp = snapshot.value;
  //   lat = temp["Lat"];
  //   lng = temp["Lng"];
  //   lastViewed = DateTime.parse(temp["Last Viewed"]);
  // }
  // else
  //   {
  //     print("Data fetch failed in location.dart...");
  //     return "Sorry, unable to fetch location data. Please try after sometime";
  //   }
  //   int timeDifference = await DateTime.now().difference(lastViewed).inMinutes;
  // if(timeDifference >= 15)
  // {
  //   print("Making location API request");
  //   var location_url = Uri.parse(
  //     "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=$locationApi&q=$lat%2C$lng&details=false");
  //   Response response = await get(location_url);  
  //   if(response.statusCode == 200)
  //   {
  //     temp = await jsonDecode(response.body);
  //     await dBr.child(path).update({"Last Viewed":DateTime.now().toString()});
  //     return "You are in the " + temp["Type"] + " of " + temp["EnglishName"] + ", located in " + temp["AdministrativeArea"]["EnglishName"];
  //   }
  // else 
  //   {
  //     print("Using data from Database since API limits reached");
  //   // cityName = temp["Place"];
  //   // stateName = temp["State"];
  //   // placeType = temp["Type"];
  //   return "You are in the " + temp["Type"] + " of " + temp["Place"] + ", located in " + temp["State"];
  //   }
  // }
  // else 
  // {
  //   print("Using data from Database");
  //   // cityName = temp["Place"];
  //   // stateName = temp["State"];
  //   // placeType = temp["Type"];
  //   return "You are in the " + temp["Type"] + " of " + temp["Place"] + ", located in " + temp["State"];
  //   // return "You are in " + temp["Place"] + ", situated in " + temp["State"];
  // }
  await getData(path);
  if(cityName == "")
  {
    return "Sorry, unable to fetch location data. Please try after sometime";
  }
  else
  {
    return "You are in the " + placeType + " of " + cityName + ", located in " + stateName;
  }
}
