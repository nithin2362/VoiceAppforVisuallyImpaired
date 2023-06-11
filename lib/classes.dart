

import 'package:translator/translator.dart';
class AllDetails
{
  static String weatherText = "",locationText = "",newsText = "";
}

class UserAllData
{
  String name = "",victimName = "",uniqueName = "";
  List<double> coordinates = [];
  UserAllData(this.name,this.victimName,this.uniqueName,this.coordinates);
}

Future<String> translate (String text,String from,String to) async{
  GoogleTranslator translator = GoogleTranslator();
  Translation translation = await translator.translate(text,from:from,to:to);
  String translatedText = translation.text;
  return translatedText;
}