import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'dart:convert';
String weatherAPI = "24ad4427ef83e4f360eacb7c52caf32e";
var lat = 12.89,lng = 79.08;
String weather = "Nil",description = "Nil",temperature = "Nil";
String getdesc(String weather,String description)
  {
    String val = description[0].toString().toUpperCase() + description.toString().substring(1);
    if(description.toString().toLowerCase() == weather.toString().toLowerCase()) {
      val = 'Mild ' + val;
    }
    return val;
  }
Future<void> getWeather(String path)async
{
  await Firebase.initializeApp();
  final dBr = FirebaseDatabase.instance.ref();
  final snapshot = await dBr.child(path).get();
  var temp,t_decoded;
  if(snapshot.exists && snapshot.value != null)
  {
    temp = snapshot.value;
    lat = temp["Lat"];
    lng = temp["Lng"];
  }
  var tempurl = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=$weatherAPI');
  Response temp_response = await get(tempurl);
  if(temp_response.statusCode == 200)  
    {
      t_decoded = await jsonDecode(temp_response.body);
      weather = t_decoded["weather"][0]["main"];
      description = getdesc(weather, t_decoded["weather"][0]["description"]) ;
      temperature = (t_decoded["main"]["feels_like"] - 273.15).toStringAsPrecision(4);
      
    }
  else
    {
      print("Weather request failed due to bad response");
    }
}
Future<String> weatherText(String path) async
{
  await getWeather(path);
  String weatherTextToBeReturned = "";
  if(weather == "Nil") {
    return "Sorry, unable to fetch weather data. Please try after sometime";
  } 
  
  return "The weather can be described as " + description.toString() + ".   The temperature here feels like " + temperature + " degree celsius";
  
  
}
