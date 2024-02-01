import 'package:flutter/material.dart';
import 'package:scoreboard/UI/game/game_page.dart';

class TextFieldClass {
  final TextField textField;

  TextFieldClass({required this.textField});
}

class PreGamePage extends StatefulWidget {
  const PreGamePage({super.key});

  @override
  State<PreGamePage> createState() => _PreGamePageState();
}

class _PreGamePageState extends State<PreGamePage> {
  Map<int, TextFieldClass> textFieldClassMap = {};

  List<String> groupNamesList = [];

  sendData() {
    for (var textFieldClass in textFieldClassMap.entries) {
      groupNamesList.add(textFieldClass.value.textField.controller!.text);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return GamePage(groupNames: groupNamesList);
        },
      ),
    );
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pre Game"),
        actions: [
          TextButton(
            onPressed: () {
              index++;
              int i = index;
              textFieldClassMap.putIfAbsent(
                index,
                () => TextFieldClass(
                  textField: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      labelText: "Group Name",
                      hintText: "Group Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          textFieldClassMap.remove(i);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              );
              setState(() {});
            },
            child: const Text(
              "Add Group",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    children: textFieldClassMap.entries.map((textFieldMap) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: textFieldMap.value.textField,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey.shade700,
              height: 0,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () {
                  sendData();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Start Game",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
