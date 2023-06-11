import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'liveCommands.dart';
import 'splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'weather.dart';
import 'location_details.dart';
import 'classes.dart';
import 'package:shared_preferences/shared_preferences.dart';
String userName = "Nithin",pwdd = "",uname = "";
Color thatDarkBlueColor = Color.fromARGB(240, 9, 24, 49),primaryColor = Color.fromARGB(255, 3, 171, 107);
UserAllData userAllData = new UserAllData("man", "dude", "man007",[12.96,80.08]);
String language_code = "";
var sharedPreferences,vals,val;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  vals = await keepMeSignedIn();
  userName = vals[0];
  uname = vals[1] ?? "Nithin";
  // val = false;
  val = vals[2] ?? false;
  // modeFlag = 0;
  //val = vals[3] ?? false;
  //val = false;
  print("Details from main page: $userName  $uname $val");
  runApp(MaterialApp(
  home: SplashScreen(uname,val),
  debugShowCheckedModeBanner: false,
  ));
}
Future<List> keepMeSignedIn()async
{
  String pwd,uniqueName,name;
  sharedPreferences = await SharedPreferences.getInstance();
  uniqueName = await sharedPreferences.getString("uniqueName").toString();
  name = await sharedPreferences.getString("username").toString();
  val = await sharedPreferences.getBool("Flag");
  return [name,uniqueName,val];
}
class IntroScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return LoginForm();
      },
    );
  }
}

class VoiceHomePage extends StatefulWidget {
  String uniqueName;
  VoiceHomePage(this.uniqueName);

  @override
  State<VoiceHomePage> createState() => _VoiceHomePageState();
}

class _VoiceHomePageState extends State<VoiceHomePage> {
  @override
  
  Future<void> getAllFutureCommands()async
  {
    String wT,lT = "";
    var temp;
    
    wT = await weatherText("Users/${widget.uniqueName}/Location");
    lT = await locationText("Users/${widget.uniqueName}/Location");
    AllDetails.weatherText = wT;
    AllDetails.locationText = lT;
    AllDetails.newsText = "The News data is yet to be configured";
    userAllData.name = userName;
    userAllData.uniqueName = widget.uniqueName;

    final Snapshot = await dBr.child("Users/${widget.uniqueName}").get();
    if(Snapshot.exists && Snapshot.value != null)
    {
      temp = Snapshot.value;
      userAllData.victimName = temp["Victim name"];
      userAllData.coordinates = [temp["Location"]["Lat"],temp["Location"]["Lng"]];
      language_code = temp["Language"] ?? "en";
    }
    else
    {
       userAllData.victimName = "User";
    }
  }
  
  
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllFutureCommands(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done)
        {
          return VoiceCommands(userAllData, AllDetails.weatherText, AllDetails.locationText, AllDetails.newsText);
        }
        return Scaffold(
              backgroundColor: thatDarkBlueColor,
              body: Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            );
      },
    );
  }
}