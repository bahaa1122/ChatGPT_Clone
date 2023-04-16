
import 'package:chatgpt/services/api_services.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../models/models_model.dart';
import 'package:provider/provider.dart';


import '../providers/model_provider.dart';


class ModelDropDown extends StatefulWidget {
  const ModelDropDown({super.key});

  @override
  State<ModelDropDown> createState() => _ModelDropDownState();
}

class _ModelDropDownState extends State<ModelDropDown> {
  String ?currentModel;
  @override
  Widget build(BuildContext context) {

    final modelsProvider = Provider.of<ModelsProvider>(context,listen: false);
    currentModel =modelsProvider.getCurrentModel;

    return FutureBuilder<List<ModelsModel>>(
        future: modelsProvider.getAllModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(label: snapshot.error.toString()),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                child: DropdownButton(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: List<DropdownMenuItem<String>>.generate(
                  snapshot.data!.length,
                  (index) => DropdownMenuItem(
                    value: snapshot.data![index].id,
                    child: TextWidget(
                      label: snapshot.data![index].id,
                      fontSize: 15,
                    ),
                  ),
                ),
                    value: currentModel,
                    onChanged: (value) {
                      setState(() {
                        currentModel = value.toString();
                      });
                      modelsProvider.setcurrentModel(value.toString(),);
                    }),
              );
        });
  }
}
