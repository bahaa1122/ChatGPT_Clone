import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/models_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../constants/api_consts.dart';

class ApiService {
  static Future<List<ModelsModel>> getMpdels() async {
    try {
      var response = await http.get(Uri.parse("$base_url/models"),
          headers: {'Authorization': 'Bearer $api_Key'});
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
//  print("jsonrespond $jsonResponse");
      List temp = [];
      for (var value in jsonResponse['data']) {
        temp.add(value);
        // print("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      // print('erroe $error');
      rethrow;
    }
  }

  // send msg

  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      // print('modelid $modelId');
      var response = await http.post(Uri.parse("$base_url/completions"),
          headers: {
            'Authorization': 'Bearer $api_Key',
            "Content-Type": "application/json"
          },
          body: jsonEncode(
            {
              "model": modelId,
              "prompt": message,
              "max_tokens": 100,
            },
          ));
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList =[];
    if(jsonResponse["choices"].length > 0){
      // print("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
      chatList = List.generate(
        jsonResponse["choices"].length,
         (index) => ChatModel(msg: jsonResponse["choices"][index]["text"],
          chatIndex: 1,
          ),
          );
    }return chatList;
    } catch (error) {
      // print('erroe $error');
      rethrow;
    }
  }
}
