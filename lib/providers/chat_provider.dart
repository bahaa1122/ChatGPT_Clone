import 'package:chatgpt/models/chat_model.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';

class ChatProdiver with ChangeNotifier{
List <ChatModel> chatList =[];

List <ChatModel>  get getchatList{
    return chatList;
  }
void addUserMessage ({required String msg }){
   chatList.add(ChatModel(msg: msg, chatIndex: 0));
   notifyListeners();
}
Future<void> sendMassageAndGetAnswers({required String msg, required String chosenModelId})async{
   chatList.addAll(await ApiService.sendMessage(
          message: msg,
          modelId: chosenModelId
          ));
        notifyListeners();
}
}