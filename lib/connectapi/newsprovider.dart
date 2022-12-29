import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:untitled1/models/news_model.dart';

import '../utils.dart';

class NewsProvder extends ChangeNotifier{
NewsPaper? newsPaper;

//for getting all data from api, passing a string for collecting specific category data
Future<void> getCurrentData(String cat) async {
  String url='${siteurl}${topheadings}?country=us&category=$cat&apiKey=${apikey}';
  final uri = Uri.parse(url);
  try {
    final response = await get(uri);
    //making a map of jsondata collected from the api
    final map = jsonDecode(response.body);
    //checking the api is working or not by matching status code 200
    if(response.statusCode == 200) {
      newsPaper = NewsPaper.fromJson(map);
      //print(newsPaper!.status);
      notifyListeners();
    } else {
      print(map['message']);
    }
  }catch(error) {
    rethrow;
  }
}
}