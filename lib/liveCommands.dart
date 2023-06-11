import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:voice_assistant/commandProcessing.dart';
import 'package:voice_assistant/login.dart';
import 'package:voice_assistant/main.dart';
import 'package:voice_assistant/classes.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:telephony/telephony.dart';
import 'package:translator/translator.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';



String num1 = "",num2 = "",num3 = "";
final dBr1 = FirebaseDatabase.instance.ref();
List responseContent = [];
bool panic = false, logOutFlag = false;
String words = "";
GoogleTranslator translator = GoogleTranslator();
class VoiceCommands extends StatelessWidget {
  String weatherText1,locationText1,newsText1;
  UserAllData userAllData;
  VoiceCommands(this.userAllData,this.weatherText1,this.locationText1,this.newsText1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thatDarkBlueColor,
      body: SpeechScreen(this.userAllData,this.weatherText1,this.locationText1,this.newsText1),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  String weatherText1,locationText1,newsText1;
  UserAllData userAllData;
  SpeechScreen(this.userAllData,this.weatherText1,this.locationText1,this.newsText1);
  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText? _speech;
  var tim;
  bool _isListening = false,speechFlag = false,isViewed = false,exitFlag = false;
  String _text = "Tap twice on the center of the screen to start talking. After speaking, wait for 2 to 3 seconds for the response. In case of an emergency, press and hold the screen to activate panic button. Drag from \"center to right of the screen\" to log out of your account.";
  final FlutterTts flutterTts = FlutterTts();
  List<String> lastTwoResponses = ["Tap twice on the center of the screen to start talking. After speaking, wait for 2 to 3 seconds for the response. In case of an emergency, press and hold the screen to activate panic button. Drag from \"center to right of the screen\" to log out of your account.",
                                    "Tap twice on the center of the screen to start talking. After speaking, wait for 2 to 3 seconds for the response. In case of an emergency, press and hold the screen to activate panic button. Drag from \"center to right of the screen\" to log out of your account."
                                  ];

  @override
  void initState()
  {
    super.initState();
    _speech = stt.SpeechToText();
    audioProcess(true);
  }

  @override
  void dispose() {
    // isViewed = true;
    // tim.cancel();
    super.dispose();
  }
  void sendMessage() async
  {
    final Telephony telephony = Telephony.instance;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int i1  = widget.locationText1.lastIndexOf("of") + 3,i2 = widget.locationText1.lastIndexOf(",");
    String place1 = widget.locationText1.substring(i1,i2);
    
    num1 = await sharedPreferences.getString("num1").toString();
    num2 = await sharedPreferences.getString("num2").toString();
    num3 = await sharedPreferences.getString("num3").toString();
    print("Numbers: ${[num1,num2,num3]}");
    if(num1 != "Nil")
      await telephony.sendSms(to: num1, message: "I feel something wrong around me. I am near $place1. Click this to know my accurate location: https://maps.google.com/?q=" + widget.userAllData.coordinates[0].toString() + ","+widget.userAllData.coordinates[1].toString());
    if(num2 != "Nil")
      await telephony.sendSms(to: num2, message: "I feel something wrong around me. I am near $place1. Click this to know my accurate location: https://maps.google.com/?q=" + widget.userAllData.coordinates[0].toString() + ","+widget.userAllData.coordinates[1].toString());
    if(num3 != "Nil")
      await telephony.sendSms(to: num3, message: "I feel something wrong around me. I am near $place1. Click this to know my accurate location: https://maps.google.com/?q=" + widget.userAllData.coordinates[0].toString() + ","+widget.userAllData.coordinates[1].toString());
    // List<String> recipients = ["+919710211402"];
    
    // await sendSMS(message: "I feel something wrong around me. I am near $place1. Click this to know my accurate location: https://maps.google.com/?q=" + widget.userAllData.coordinates[0].toString() + ","+widget.userAllData.coordinates[1].toString(), recipients: recipients);
  }
  List<String> writeResponse(String response)
  {
    String temp = lastTwoResponses[1];
    // lastTwoResponses.clear();
    lastTwoResponses[0] = temp;
    lastTwoResponses[1] = response;
    return lastTwoResponses;
  }
  Future<List> audioProcess(bool flag) async
  {
    String response = "";
    Map<String,String> futureResponses = {"weather":widget.weatherText1,"location":widget.locationText1,"news":widget.newsText1,"uniqueName":widget.userAllData.uniqueName,"userName":widget.userAllData.name,"myName":widget.userAllData.victimName};
    if (!flag)
    {
      flutterTts.stop();
      _text = language_code == "ta" ? "கேட்கிறது..." :"Listening...";
      if (!_isListening) {
        bool available = await _speech!.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
        );
        //print("During function call: ${_speech!.lastStatus}");
        if (available) {
          setState(() => _isListening = true);
          await _speech!.listen(
              localeId: language_code,
              onResult: (val) async{
                  setState(() {
                    _text = val.recognizedWords;
                  });
                  }
                  );

          setState(() => _isListening = false);
        }
      }
      else {
        setState(() => _isListening = false);
        _speech!.stop();
      }
  }
    else
      {
        _speech!.stop();
        if(language_code == "ta")
        {
          await translator.translate(_text,to:"en").then((value) {
          setState(() {
            _text = value.text.toString();
          });
          });
          await flutterTts.setSpeechRate(0.5);
        }
        else 
        {
          await flutterTts.setSpeechRate(0.37);
        }
        await flutterTts.setLanguage(language_code);
        print("Text: $_text");
        String text1 = _text.toLowerCase();
        if(panic)
        {
          response = "Panic button is pressed... Panic button is pressed... Please stand still for an image capture... I am alerting your friend !";
          panic = false;
        }
        else if(text1 == "" || text1.contains("tap twice on the center of the screen"))
        {
            response = "Tap twice on the center of the screen to start talking. After speaking, wait for 2 to 3 seconds for the response. In case of an emergency, press and hold the screen to activate panic button. Drag from \"center to right of the screen\" to log out of your account.";
        }
        else if(text1.contains("exit") || text1.contains("quit")|| text1.contains("leave")||text1.contains("bye"))
        {
          response = "Thank you, see you later. Bye !";
          exitFlag = true;
        }
        else if(text1.contains("call") && text1.contains("friend"))
        {
          response = "Ok. I am calling your friend.";
          Future.delayed(Duration(seconds: 2),() async{
            final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              String callUser = await sharedPreferences.getString("num1").toString();
              Future.delayed(Duration(seconds: 4),()=>FlutterPhoneDirectCaller.callNumber(callUser));

          });        }
        else if(text1 == "yes")
        {
          print("Last two responses: ${lastTwoResponses}");
          if(lastTwoResponses[1].toLowerCase().contains("exit") || lastTwoResponses[1].toLowerCase().contains("bye")|| lastTwoResponses[1].toLowerCase().contains("quit")||lastTwoResponses[1].toLowerCase().contains("leave"))
          {
            response = "Thank you, see you later. Bye !";
            exitFlag = true;
          }
          else if(lastTwoResponses[1].toLowerCase().contains("log") && lastTwoResponses[1].toLowerCase().contains("out"))
          {
            response = "Logging out";
            logOutFlag = true;
          }
          else
          {
            response = await voiceResponse(futureResponses,lastTwoResponses,_text,""); 
          }
          lastTwoResponses = writeResponse(response);
        }
        // else if(_text == "bye" || _text == "goodbye"||_text == "close the app"|| _text == "close app"||_text == "thank you"||_text == "thanks"||_text == "exit")
        // {
        //   response = "Bye!";
        // }
        else
        {
          response = await voiceResponse(futureResponses,lastTwoResponses,_text,"");
          lastTwoResponses = writeResponse(response);
        } 
          if(language_code == "ta")
          {
            response = await translate(response,"en",language_code);
          }
          await flutterTts.speak(response);
          setState(() {
            _text = response;
            print(response);
          });
          
      }
    return [_text,!flag,response];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: thatDarkBlueColor,
            appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: AppBar(
              backgroundColor: primaryColor,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(5, 70, 50, 40),
                child: Text(language_code == "ta" ? "வணக்கம்!":"Hello ${widget.userAllData.victimName}!",style: GoogleFonts.karla(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
              ))),
            body: Container(
            padding: const EdgeInsets.fromLTRB(40, 70, 40, 150),
            child: Stack(children: [
            GestureDetector(
            // onDoubleTap: () async {
            //   flutterTts.stop();
            //   await audioProcess();
            //   speechFlag = !speechFlag;
            // },
            onDoubleTap: () async {
            if(!speechFlag)
        {
            responseContent = await audioProcess(speechFlag);
            speechFlag = true;
            words = responseContent[0];
        }
            if(speechFlag)
            {
              await Future.delayed(Duration(seconds: 6),() async{
              responseContent = await audioProcess(speechFlag);
              });
              if(exitFlag)
              {
                exitFlag = false;
                Future.delayed(Duration(seconds: 3),()=>FlutterExitApp.exitApp());
              }
              else if(logOutFlag)
              {
                logOutFlag = false;
                Future.delayed(Duration(seconds: 2),()=>Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => LoginForm()),(route)=> false));
              }
              speechFlag = false;
            }
        
        },
            onHorizontalDragStart: (DragStartDetails dragStartDetails){
              // Log out code
                print("Dragging...");
            },
            onHorizontalDragEnd: (DragEndDetails dragEndDetails) async{
                final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                await sharedPreferences.setBool("Flag",false);
                lastTwoResponses = writeResponse("Shall I log out ? Say yes if so.");
                setState(() {
                  _text = language_code == "ta" ? "நான் வெளியேற வேண்டுமா? இருந்தால் ஆம் என்று சொல்லுங்கள்.": "Shall I log out ? Say yes if so.";
                });
                await flutterTts.speak(language_code == "ta" ? "நான் வெளியேற வேண்டுமா? இருந்தால் ஆம் என்று சொல்லுங்கள்.": "Shall I log out ? Say yes if so.");
                
            },
            onLongPress: () async{
              speechFlag = true;
              panic = true;
              responseContent = await audioProcess(speechFlag);
              speechFlag = responseContent[1];
              sendMessage();
              await dBr1.child("Users/${widget.userAllData.uniqueName}").update({"Panic":2});
              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              String callUser = await sharedPreferences.getString("num1").toString();
              Future.delayed(Duration(seconds: 8),()=>FlutterPhoneDirectCaller.callNumber(callUser));
            },
        //     onTap: () async{
        //     if(speechFlag) {
        //       speechFlag = await audioProcess(speechFlag);
        //       if(exitFlag)
        //       {
        //         exitFlag = false;
        //         Future.delayed(Duration(seconds: 1),()=>Navigator.pushAndRemoveUntil(context,
        //                         MaterialPageRoute(builder: (context) => LoginForm()),(route)=> false));
        //       }
        //     }
        // },
        ),
            GestureDetector(

            // onDoubleTap: () async {
            //   flutterTts.stop();
            //   await audioProcess();
            //   speechFlag = !speechFlag;
            //   },
            onDoubleTap: () async {
            if(!speechFlag)
        {
            responseContent = await audioProcess(speechFlag);
            speechFlag = true;
            words = responseContent[0];
        }
            if(speechFlag)
            {
              print("Words length: ${words.length}");
              await Future.delayed(Duration(seconds: 6),() async{
              responseContent = await audioProcess(speechFlag);
              });
              if(exitFlag)
              {
                exitFlag = false;
                Future.delayed(Duration(seconds: 3),()=>FlutterExitApp.exitApp());
              }
              else if(logOutFlag)
              {
                logOutFlag = false;
                Future.delayed(Duration(seconds: 2),()=>Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => LoginForm()),(route)=> false));
              }
              speechFlag = false;
                
            }
        
        },
            onHorizontalDragStart: (DragStartDetails dragStartDetails){
              // Log out code
                print("Dragging...");
            },
            onHorizontalDragEnd: (DragEndDetails dragEndDetails) async{
                final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                await sharedPreferences.setBool("Flag",false);
                lastTwoResponses = writeResponse("Shall I log out ? Say yes if so.");
                setState(() {
                  _text = language_code == "ta" ? "நான் வெளியேற வேண்டுமா? இருந்தால் ஆம் என்று சொல்லுங்கள்.": "Shall I log out ? Say yes if so.";
                });
                await flutterTts.speak(language_code == "ta" ? "நான் வெளியேற வேண்டுமா? இருந்தால் ஆம் என்று சொல்லுங்கள்.": "Shall I log out ? Say yes if so.");
                
            },
            onLongPress: () async{
              speechFlag = true;
              panic = true;
              responseContent = await audioProcess(speechFlag);
              speechFlag = responseContent[1];
              sendMessage();
              await dBr1.child("Users/${widget.userAllData.uniqueName}").update({"Panic":2});
              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              String callUser = await sharedPreferences.getString("num1").toString();
              Future.delayed(Duration(seconds: 8),()=>FlutterPhoneDirectCaller.callNumber(callUser));
            },
        //     onTap: () async{
        //     if(speechFlag)
        //     speechFlag = await audioProcess(speechFlag);
        //     if(exitFlag)
        //     {
        //       exitFlag = false;
        //       Future.delayed(Duration(seconds: 1),()=>Navigator.pushAndRemoveUntil(context,
        //                         MaterialPageRoute(builder: (context) => LoginForm()),(route)=> false));
        //     }
        // },
            child: Center(
              child: SingleChildScrollView(
              reverse: true,
              child:Center(
                  child: Text(
                        _text,
                        style: GoogleFonts.karla(
                        color: Colors.white,
                        fontSize: 35,
                        //fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
            ),
                      ),
                    ),
                ),
        ),
        ),
            ]),
        ),
        );
      }
       

    
  }


