import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:voice_assistant/weather.dart';
import 'liveCommands.dart';
import 'main.dart';

//String weatherResponse = "Sorry, unable to fetch weathers data. Please try after sometime",locationResponse = "Sorry, unable to fetch location data. Please try after sometime";
final dBr = FirebaseDatabase.instance.ref();
bool found = false;
List<String> keyWords = ["use the cane","hi","weather","location","sos","date","time","repeat","stick","commands"];
Map getDateResponse()
{
  Map response = {};
  String dateResponse = "";
  DateTime date = DateTime.now();
  var days = {1:'Monday',2:'Tuesday',3:'Wednesday',4:'Thursday',5:'Friday',6:'Saturday',7:'Sunday'};
  var month = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December'
};
response["date"] = "Today is " + days[date.weekday].toString() + ', ' + month[date.month].toString() + ' ' + date.day.toString() + ', ' + date.year.toString();

int hrs1,hrs= date.hour;
String meridian = hrs >= 12 ? "P.M." : "A.M.";
hrs1 = hrs;
hrs = hrs > 12 ? hrs - 12 : hrs;
if(language_code == "en")
  response["time"] = "It is " + hrs.toString() + ":" + (date.minute < 10 ? "0"+date.minute.toString():date.minute.toString()) + " $meridian now";
else
  {
    if(hrs1 >= 12 && hrs1 <= 15)
    {
      response["time"] = "Time is afternoon " + hrs.toString() + " hours " + date.minute.toString() + " minutes ";
    }
    else if(hrs1 >= 16 && hrs1 <= 19)
    {
      response["time"] = "Time is evening " + hrs.toString() + " hours " + date.minute.toString() + " minutes ";
    }
    else if(hrs1 >= 20 && hrs1 <= 23)
    {
      response["time"] = "Time is night " + hrs.toString() + " hours " + date.minute.toString() + " minutes ";
    }
    else if(hrs1 == 24 || hrs1 == 0)
    {
      response["time"] = "Time is midnight " + hrs.toString() + " hours " + date.minute.toString() + " minutes ";
    }
    else  
      response["time"] = "Time is morning " + hrs.toString() + " hours " + date.minute.toString() + " minutes ";

  }
return response;
}

// Future<void> getAllFutureCommands(String path)async
// {
//   weatherResponse = await weatherText(path);

// }
bool negativeCheck(String text)
{
  List<String> negativeWords = ["don\'t","no","won\'t","cannot","will not","ok"];
  for(int i = 0;i<negativeWords.length;++i)
  {
    if(text.contains(negativeWords[i])) {
      return true;
    }
  }
  return false;
}
bool hiCheck(String text)
{
  List<String> waysToSayHi = ["who are you","your name","what is your name","your name please","hello","hi","hai","hello there","ni"];
  for(String way in waysToSayHi)
    {
      if(text == way)
        return true;
    }
  return false;
}
String findCommand(String text)
{

String type = "not_understandable";
text = text.toLowerCase();

int i;
if(hiCheck(text))
{
  type = "hi";
}
else if(text == "" || text == "no" || text == "yes")
{
  type = text;
}
else if(negativeCheck(text))
{
  type = "no";
}
else if(text.contains("weather") || text.contains("climate")) {
  List<String> weatherCommands = [
    "weather now",
    "what is the weather now",
    "current weather",
    "climate now",
    "what is the climate now",
    "what is the weather here",
    "how is the weather right now",
    "how is the weather"
    "here what is the weather",
    "what is the weather",
    "weather",
    "climate"
  ];
  for (String command in weatherCommands) {
    if (text.contains(command) || text == command) {
      return "weather";
    }
  }
  type = "suggest_weather";
}
else if(text.contains("command") || text.contains("basic"))
{
  List<String> basicCommands = [
    "commands",
    "orders",
    "basic orders",
    "basic commands",
    "what are the basic commands",
    "what can you do",
    "what are your features",
    "how to use you",
    "can you say the basic commands",
  ];
  for (String command in basicCommands) {
    if (text.contains(command) || text == command) {
      return "basic_commands";
    }
  }
  type = "suggest_basic_commands";
}
else if(text.contains("language") && text.contains("change"))
{
  List<String> langCommands = [
    "change language",
    "change the language",
    "language change",
  ];
  for (String command in langCommands) {
    if (text.contains(command) || text == command) {
      return "language_commands";
    }
  }
  type = "suggest_language_commands";
}



else if(text.contains("repeat") || text.contains("say again") || text.contains("again"))
{
  List<String> repeatCommands = ["repeat what you said","please repeat","can you repeat","repeat please","can you just repeat",
                                  "can you repeat again","can you repeat","can you just repeat what you said",
                                  "will you repeat","can you just repeat again",
                                  "come again","say again","say again please","please say again",
                                  "again","repeat","repeat it again","repeat again"];
  for(String command in repeatCommands)
  {
    if(text.contains(command) || text == command) {
      return "repeat";
    }
  }
  type = "suggest_repeat";

}
else if(text.contains("tutorial")||text.contains("how")||text.contains("use")||text.contains("training"))
{
  List<String> tutorialCommands = [
    "how to use the stick",
    "how to use my stick",
    "stick tutorial",
    "how to use stick",
    "tutorial",
    "stick training",
    "training"
    ];
  for(String command in tutorialCommands)
  {
    if(text == command) {
      return "tutorial";
    }
  }
  type = "suggest_tutorial";

}
else if(text.contains("stick"))
{
  
  if(text.contains("find") || text.contains("where"))
  {
    List<String> stickOnCommands = [
    "find my stick",
    "where is my stick",
    "turn on stick buzzer",
    "turn on the stick buzzer",
    "find the stick",
    "find stick",
    "where\'s my stick"
  ];  
  for(String command in stickOnCommands)
  {
    if(text.contains(command) || text == command) {
      return "stick_on";
    }
  }
  type = "suggest_stick_on";
  }
  else
  {
    List<String> stickOffCommands = [
    "off stick buzzer",
    "turn off find my stick",
    "turn off stick buzzer",
    "turn off buzzer",
    "i found my stick",
    "turn the stick buzzer off"
  ];
   for(String command in stickOffCommands)
  {
    if(text.contains(command) || text == command) {
      return "stick_off";
    }
  }
  type = "suggest_stick_off";
  }
}
else if(text.contains("sos") || text.contains("light"))
{
  
  if(text.contains("off"))
  {
    List<String> sosOffCommands = [
    "turn off sos",
    "off sos",
    "sos off",
    "sos light off",
    "light off"
  ];
  for(String command in sosOffCommands)
  {
    if(text.contains(command) || text == command) {
      return "sos_off";
    }
  }
  type = "suggest_sos_off";
  }
  else
  {List<String> sosOnCommands = [
    "turn on sos",
    "on sos",
    "sos on",
    "sos light on",
    "light on"
  ];
  for(String command in sosOnCommands)
  {
    if(text.contains(command) || text == command) {
      return "sos_on";
    }
  }
  type = "suggest_sos_on";}
  
}
else if(text.contains("location") || text.contains("place") || text.contains("where"))
{
  List<String> locationCommands = [
    "where am i",
    "where i am",
    "my location",
    "my current location",
    "location",
    "name of the place i am in",
    "what is the name of this place",
    "name of my place",
    "what is this place",
    "what place is this",
    "what is this place called",
    "place"
  ];
  for(String command in locationCommands)
  {
    if(text.contains(command) || text == command) {
      return "location";
    }
  }
  type = "suggest_location";
}
else if(text.contains("date") || text.contains("today"))
{
  List<String> dateCommands = [
    "what is today\'s date",
    "date",
    "what day is today",
    "today/'s date",
    "date of this day",
    "tell me the date",
    "tell me today\'s date"
  ];
  for(String command in dateCommands)
  {
    if(text.contains(command) || text == command) {
      return "date";
    }
  }
  type = "suggest_date";

}
else if(text.contains("thank"))
{
  return "thank";
}
else if(text.contains("time"))
{
  List<String> timeCommands = [
    "what is the time now",
    "time now",
    "time please",
    "what is the time",
    "what's the time now",
    "time",
    "can you check the time",
    "tell me the time"
  ];
  for(String command in timeCommands)
  {
    if(text.contains(command) || text == command) {
      return "time";
    }
  }
  type = "suggest_time";
}
return type;

}

Future<String> voiceResponse(Map<String,String> futureResponses,List<String> lastTwoResponses,String command,String commandType) async
{
  if(commandType == "") {
    commandType = findCommand(command);
  }
  String response = "";
  print("Command Type: " + commandType);
  switch(commandType)
  {
    case "hi":  response = "Hello " + futureResponses["myName"].toString() + ", I am Wanda, the voice assistant. You can say \"basic commands\" to get to know more about me";
                break;
    case "nil": response = "Please say something after double tapping the screen";
                break;
    case "date": response = getDateResponse()["date"];
                 break;
    case "time": response = getDateResponse()["time"];
                print("Time response: $response");
                 break;
    case "weather": response = futureResponses["weather"].toString();

                    // Future.delayed(const Duration(seconds: 2), () async{
                    //   String path = "Users/nithinsuresh23602/abcd/Location";
                    //   response =  await weatherText(path).toString();
                    // });
                    break;

    case "not_understandable": response = "Sorry, I can\'t understand";
                               break;
    case "repeat": response = lastTwoResponses[1];
                   break;
    case "location": response = futureResponses["location"].toString();
                     break;
    case "thank": response = "It is my pleasure !";
                     break;
    case "tutorial": response = ''' Turn ON the stick and wait for a 3 repetitive buzzer alerts in order to store your current location. 
                                    While using, firmly hold the stick handle to perceive the vibratory alerts due to obstacles in the path. The frequency of vibration will denote the distance between you and the obstacle. If the vibration is continuous, it means that an obstacle is present very close to you. 
                                    Please move the stick slowly, as the friend user may capture an image from the stick camera.
                                    If you feel a sense of danger, please long press the screen to activate panic button, which alerts people around you, and sends an alert SMS and an image to the friend users. 
                                    SOS light will be turned ON only during the night. You can manually turn it OFF by saying \"Turn off the light\" command. Unless you manually turn it ON again by saying the command \"Turn on the light\", it won't glow.
                                    Types of buzzer alerts:
                                    Buzzer will beep 3 times after turning on the stick is for storing the initial GPS data
                                    Buzzer will beep 5 times when the friend-user is trying to alert you to stay careful.
                                    Buzzer will fastly beep when the stick detects fire
                                    Buzzer will slowly beep when the stick detects moist road
                                    Buzzer will ring for 20 seconds when you press the panic button
                                    And finally, when you say \"find-my-stick\" command, the buzzer will continuously beep until you turn it off again.
                                ''';         
                     break;
    
    case "sos_on":   await dBr.child("Users/${futureResponses["uniqueName"]}").update({"SOS":true});
                     response = "SOS light will be turned ON shortly";
                     if(DateTime.now().hour > 6 && DateTime.now().hour < 18)
                      {
                        response = response + ". It is advisable to use SOS light in the night. So please try to avoid using it in the day time";
                      }
                     break;
    
    case "sos_off":  await dBr.child("Users/${futureResponses["uniqueName"]}").update({"SOS":false});
                     response = "SOS light will be turned OFF shortly";
                     break;
    case "stick_on": response = "Stick buzzer will ring shortly. Please try to locate the stick using the buzzer sound";
                     await dBr.child("Users/${futureResponses["uniqueName"]}").update({"Find My Stick":true});
                     break;
    case "stick_off": response = "Alright, stick buzzer will turn off shortly";
                      await dBr.child("Users/${futureResponses["uniqueName"]}").update({"Find My Stick":false});
                      break;                    
    case "exit": response = "Are you sure you want to exit ? Say yes if so";
                    break;
    case "no": response = "Ok";
                    break;
    case "basic_commands": response = '''You can say a command and I will respond to you. Request you to take note of the commands and their corresponding responses I am going to say now       
                          to know how to use the stick you can say \"how to use my stick\"
                          or say \"stick tutorial\"
                          
                          you can say \"turn ON SOS or turn OFF SOS\" to control SOS light 
                          but SOS light can only be accessed in the night
                          
                          to know your current location you can say \"location\" 
                          or say what is this place
                          
                          to get to know me you can say \"who are you\"
                          or say what is your name 
                          
                          to know about the weather in this place you can say \"weather now\" 
                          or say how is the weather 
                          
                          to call your friend, just say \"call your friend\"
                          
                          to enable \"Find-my-stick feature\" you can say \"find my stick\" 
                          or say where is my stick 
                          
                          to disable \"Find-my-stick feature\" you can say \"OFF stick buzzer\" 
                          or say \"I found my stick\".
                          
                          to get to know today's date you can say \"date\" 
                          or say what is today's date 
                          
                          to check the time you can say \"what is the time now\"
                          or just say \"time\"
                          
                          to change voice language you can say \"change the language\"

                          and finally, to log out of your account you can say \"leave the account\".
                          
                          If I partially understand your command, I will suggest options to your command which you can answer accordingly. If I don't understand the command, I will just say, \"Sorry, I can't understand\" Remember, you can say \"repeat\" to make me say this or any other answer again.''';
                          break;
    case "language_commands": if(language_code == "en")
                              {
                               response = "I changed voice language to Tamil";
                               language_code = "ta";
                              }
                              else
                              {
                                response = "I changed voice language to English";
                                language_code = "en";
                              }
                              await dBr.child("Users/${futureResponses["uniqueName"]}").update({"Language":language_code});
                              break;
                
    case "yes": 
              found = false;
              lastTwoResponses[1] = lastTwoResponses[1].toLowerCase();
              for(String keyWord in keyWords)
              {
                if(lastTwoResponses[1].contains(keyWord))
                {
                  if(keyWord == "repeat")
                  {
                    response = await lastTwoResponses[0];
                  }
                  else if(keyWord == "commands")
                  {
                      //if(lastTwoResponses[1].contains("commands"))
                      //{
                        response = await voiceResponse(futureResponses,lastTwoResponses, "", "basic_commands");
                      //}
                  }
                  else if(keyWord == "use the cane")
                  {
                    response = await voiceResponse(futureResponses,lastTwoResponses, "", "tutorial");
                  }
                  else if(keyWord == "stick")
                  {
                    if(lastTwoResponses[1].contains("find"))
                      {
                        response = await voiceResponse(futureResponses,lastTwoResponses, "", "stick_on");
                      }
                    else
                    {
                      response = await voiceResponse(futureResponses,lastTwoResponses, "", "stick_off");
                    }
                  }
                  else if(keyWord == "sos")
                  {
                    if(lastTwoResponses[1].contains("on"))
                      {
                        response = await voiceResponse(futureResponses,lastTwoResponses, "", "sos_on");
                      }
                    else
                    {
                      response = await voiceResponse(futureResponses,lastTwoResponses, "", "sos_off");
                    }
                  }
                  else
                  {
                    response = await voiceResponse(futureResponses,lastTwoResponses, "", keyWord);
                  }
                  found = true;
                  break;
                }
              }
              if(!found)
                {
                  response = await voiceResponse(futureResponses,lastTwoResponses, "", "not_understandable");
                }
                print("Response: $response");
                break;
  case "suggest_repeat": response =  'Did you mean to ' + commandType.substring(8) + ' what I said ? Say yes if so';
                         break;
                      
  case "suggest_weather": response =  'Did you mean to ask the ' + commandType.substring(8) + ' of this place ? Say yes if so';
                           break;
  
  case "suggest_location": response =  'Did you mean to ask your ' + commandType.substring(8) + ' ? Say yes if so';
                           break;

  case "suggest_date": response =  'Did you mean to ask today\'s ' + commandType.substring(8) + ' ? Say yes if so';
                       break;                      
  
  case "suggest_time": response =  'Did you mean to ask the ' + commandType.substring(8) + ' now ? Say yes if so';
                       break;         

  
  case "suggest_sos_on":   response =  'Did you mean to say, Turn on SOS ? Say yes if so';
                           break;   
  case "suggest_sos_off":   response =  'Did you mean to say, Turn off SOS ? Say yes if so';
                           break;   
  
  case "suggest_stick_on": response =  'Did you mean to say, Find my stick ? Say yes if so';
                           break;                        
  case "suggest_tutorial": response =  'Did you mean to ask how to use the cane ? Say yes if so';
                           break;  
  case "suggest_stick_off": response =  'Did you mean to say Turn OFF my stick buzzer ? Say yes if so';
                           break;
  case "suggest_basic_commands": response = 'Did you mean to say basic commands ? Say yes if so';
                          break;

  default: response = "Sorry, I can\'t understand";
           break;


  }
  return response;

}