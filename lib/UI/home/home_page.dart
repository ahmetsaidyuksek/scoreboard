import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scoreboard/UI/account/sign_page.dart';
import 'package:scoreboard/UI/game/game_page.dart';
import 'package:scoreboard/UI/game/pre_game_page.dart';
import 'package:scoreboard/UI/game_details/game_details.dart';
import 'package:scoreboard/models/game_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameData> gameList = [];

  void get(GameData gameData) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("You have not finished game"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext buildContext) => GamePage(
                        groupNames: gameData.gameGroupMap.keys.toList(),
                        gameData: gameData),
                  ),
                );
              },
              child: const Text("Play with"),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();

                sharedPreferences.remove("Game").then((value) {
                  Navigator.pop(context);
                });
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void checkGame() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? gameJson = sharedPreferences.getString("Game");

    if (gameJson != null) {
      try {
        GameData gameData = GameData.fromJson(jsonDecode(gameJson));

        get(gameData);
      } catch (error) {
        print("Error decoding game data: $error");
      }
    }
  }

  void getValue() async {
    try {
      await FirebaseDatabase.instance
          .ref("/${FirebaseAuth.instance.currentUser!.uid}/games/")
          .get()
          .then((value) {
        if (value.exists) {
          for (var game in (value.value as Map).values) {
            gameList
                .add(GameData.fromJson(Map<String, dynamic>.from(game as Map)));
            setState(() {});
          }

          gameList.sort((a, b) => b.gameDate.compareTo(a.gameDate));
        }
      });
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(
        msg: error.message.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
    }

    setState(() {});
  }

  @override
  void initState() {
    checkGame();
    getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text("Do you wanna logout?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().catchError((error) {
                          Fluttertoast.showToast(
                            msg: error.toString(),
                            toastLength: Toast.LENGTH_LONG,
                          );
                        }).whenComplete(() {
                          Fluttertoast.showToast(
                            msg: "Succesfully loged out",
                            toastLength: Toast.LENGTH_LONG,
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SignPage();
                              },
                            ),
                            (route) => false,
                          );
                        });
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.logout_rounded,
            color: Colors.red,
          ),
        ),
        title: const Text("Scoreboard"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const PreGamePage();
                  },
                ),
              );
            },
            child: const Text(
              "New Game",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: gameList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return GameDetails(gameData: gameList[index]);
                    },
                  ),
                );
              },
              child: SizedBox(
                height: 260,
                child: Card(
                  color: Colors.blueGrey.shade400,
                  margin: const EdgeInsets.all(16),
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Game Date: ${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(gameList[index].gameDate))}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: gameList[index]
                                .gameGroupMap
                                .values
                                .map((groupData) {
                              return SizedBox(
                                height: 120,
                                child: Card(
                                  margin: const EdgeInsets.all(8),
                                  elevation: 24,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Group Name: ${groupData.groupName.toString()}",
                                        ),
                                        Text(
                                          "Group Total Score: ${groupData.getGroupTotalScore}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
