import 'package:http/http.dart';
import 'dart:convert';

class CovidData{
  String country;
  String flagURL;
  int cases;
  int deaths;
  int recovered;
  Map histData;

  void getData(String query) async{
    var url = 'https://corona.lmao.ninja/countries/$query';
    Response response = await get(url);
    Map data = jsonDecode(response.body);

    country = data['country'];
    flagURL = data['countryInfo']['flag'];
    cases = data['cases'];
    deaths = data['deaths'];
    recovered = data['recovered'];
  }

  void getHistData(String query) async{
    var url = 'https://corona.lmao.ninja/v2/historical/$query';
    Response response = await get(url);
    Map data = jsonDecode(response.body);

    histData = data['timeline']['cases'];
  }

}