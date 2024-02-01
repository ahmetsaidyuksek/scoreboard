import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scoreboard/UI/home/home_page.dart';
import 'package:scoreboard/models/game_data.dart';
import 'package:scoreboard/models/group_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  final List<String>? groupNames;
  final GameData? gameData;
  const GamePage({
    super.key,
    this.groupNames,
    this.gameData,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  GameData? gameData;

  DatabaseReference databaseReference = FirebaseDatabase.instance
      .ref("/${FirebaseAuth.instance.currentUser!.uid}/games/")
      .push();

  void addScoresForGroup(int round, int score, GroupData groupData) {
    groupData.groupRoundData.putIfAbsent(round, () => []);
    groupData.groupRoundData[round]!.add(score);

    setState(() {});
  }

  void removeSecoresForGroup(int round, int score, GroupData groupData) {
    groupData.groupRoundData.putIfAbsent(round, () => []);
    groupData.groupRoundData[round]!.remove(score);

    setState(() {});
  }

  List<int> scores = [
    101,
    202,
    404,
    1600,
    -101,
    -202,
    260,
    240,
    220,
    200,
    180,
    160,
    140,
    130,
    120,
    110,
    100,
    90,
    80,
    70,
    60,
    50,
    40,
    30,
    20,
    10,
  ];

  void addScore(GroupData groupData, int round) {
    TextEditingController scoreController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                SizedBox(
                  height: 96,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextField(
                          controller: scoreController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            prefixIcon: TextButton(
                              onPressed: () {
                                if (scoreController.text != "") {
                                  addScoresForGroup(
                                      round,
                                      int.parse(scoreController.text) * 2,
                                      groupData);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("2X"),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (scoreController.text != "") {
                                  addScoresForGroup(
                                      round,
                                      int.parse(scoreController.text),
                                      groupData);
                                  Navigator.pop(context);
                                }
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.blue,
                              ),
                            ),
                            labelText: "Score",
                            hintText: "Score",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9-]")),
                            FilteringTextInputFormatter.singleLineFormatter,
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: scoreController.text != ""
                        ? scores.contains(int.tryParse(scoreController.text))
                            ? ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 50,
                                    child: InkWell(
                                      onTap: () {
                                        addScoresForGroup(
                                            round,
                                            scores.firstWhere((element) =>
                                                element ==
                                                int.tryParse(
                                                    scoreController.text)),
                                            groupData);
                                        Navigator.pop(context);
                                      },
                                      child: Card(
                                        elevation: 4,
                                        child: Center(
                                          child: Text(scores
                                              .firstWhere((element) =>
                                                  element ==
                                                  int.tryParse(
                                                      scoreController.text))
                                              .toString()),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: scores.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      addScoresForGroup(
                                          round, scores[index], groupData);
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      height: 50,
                                      child: Card(
                                        elevation: 4,
                                        child: Center(
                                          child: Text(scores[index].toString()),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                        : ListView.builder(
                            itemCount: scores.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  addScoresForGroup(
                                      round, scores[index], groupData);
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Card(
                                    elevation: 4,
                                    child: Center(
                                      child: Text(scores[index].toString()),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addGroupRoundWidget(GroupData groupData) {
    for (int i = 0; i <= gameData!.gameRound; i++) {
      groupData.groupRoundData.putIfAbsent(i, () => []);
    }
  }

  void removeGroupRoundWidget(GroupData groupData) {
    groupData.groupRoundData.remove(gameData!.gameRound);
  }

  void endRound() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("Start new round?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                gameData!.gameRound++;
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void endGame() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("End this game?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                newGame();
              },
              child: const Text("Play with same groups"),
            ),
            TextButton(
              onPressed: () {
                if (gameData!.gameGroupMap.isNotEmpty) {
                  databaseReference.set(gameData!.toMap()).then((value) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const HomePage();
                        },
                      ),
                      (route) => false,
                    );
                  });
                } else {
                  Fluttertoast.showToast(
                    msg: "There is no data to write.",
                    toastLength: Toast.LENGTH_LONG,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Play with new groups"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> onBack() async {
    return await showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return AlertDialog(
          content: const Text("If you leave now you're data will be removed"),
          actions: [
            TextButton(
              onPressed: () {
                SharedPreferences.getInstance().then((value) {
                  try {
                    value.remove("Game");
                  } catch (error) {
                    print(error);
                  }
                });

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomePage();
                    },
                  ),
                  (route) => false,
                );
              },
              child: const Text("Main Menu"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Stay"),
            ),
          ],
        );
      },
    );
  }

  Widget buildGroupWidget(GroupData groupData) {
    groupData.groupRoundData.entries.toList().sort(
          (a, b) => a.key.compareTo(b.key),
        );
    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
      ),
      child: SizedBox(
        width: 250,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 16,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        groupData.groupName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            TextEditingController textEditingController =
                                TextEditingController();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: TextField(
                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                      labelText: "Group Name",
                                      hintText: "Group Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (textEditingController.text != "") {
                                          widget.groupNames
                                              ?.remove(groupData.groupName);
                                          widget.groupNames
                                              ?.add(textEditingController.text);

                                          groupData.groupName =
                                              textEditingController.text
                                                  .toString();

                                          setState(() {});
                                          Navigator.pop(context);
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Group name can't be null",
                                            toastLength: Toast.LENGTH_LONG,
                                          );
                                        }
                                      },
                                      child: const Text("Okay"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content:
                                      const Text("Do you wanna delete Group"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        widget.groupNames
                                            ?.remove(groupData.groupName);

                                        gameData!.gameGroupMap.removeWhere(
                                            (key, value) =>
                                                value.groupName ==
                                                groupData.groupName);

                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Okay"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: groupData.groupRoundData.entries
                            .map((groupRoundData) {
                          print(groupRoundData);
                          return buildRoundWidget(groupData, groupRoundData.key,
                              groupRoundData.value);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Total Score: ${groupData.getGroupTotalScore}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        addScore(groupData, gameData!.gameRound);
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRoundWidget(
      GroupData groupData, int round, List<int> roundScores) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: SizedBox(
        width: 175,
        height: 200,
        child: Card(
          elevation: 16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Round: ${round + 1}",
                      style: const TextStyle(),
                    ),
                    IconButton(
                      onPressed: () => addScore(groupData, round),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
                height: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: roundScores.map((score) {
                      return InkWell(
                        onTap: () {
                          removeSecoresForGroup(round, score, groupData);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              score.toString(),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                ),
                child: Text(
                  "Total Score: ${roundScores.fold(0, (previousValue, element) => previousValue + element)}",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      switch (state) {
        case AppLifecycleState.inactive || AppLifecycleState.detached:
          return;
        case AppLifecycleState.paused:
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          String game = jsonEncode(gameData!.toMap());
          sharedPreferences.setString("Game", game);
          break;
        default:
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    widget.gameData != null ? gameData = widget.gameData : newGame();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  void newGame() {
    gameData = GameData(
      gameUID: databaseReference.key.toString(),
      gameDate: DateTime.now().millisecondsSinceEpoch,
      gameRound: 0,
      gameGroupMap: widget.groupNames!.fold(
        <String, GroupData>{},
        (Map<String, GroupData> map, String groupName) {
          String random = "${Random().nextInt(999999) + 100000}";
          if (groupName.isNotEmpty) {
            map[random] = GroupData(
              random,
              groupName,
              {},
            );
          }

          return map;
        },
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    for (var group in gameData!.gameGroupMap.values) {
      addGroupRoundWidget(group);
    }

    return WillPopScope(
      onWillPop: () async {
        return await onBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
          ),
          title: const Text("Game"),
          actions: [
            Center(
              child: Text(
                "Round: ${gameData!.gameRound + 1}",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                switch (value) {
                  case "endRound":
                    endRound();
                    break;
                  case "addGroup":
                    TextEditingController textEditingController =
                        TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              labelText: "Group Name",
                              hintText: "Group Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                if (textEditingController.text != "") {
                                  Navigator.pop(context);
                                  widget.groupNames
                                      ?.add(textEditingController.text);
                                  gameData!.gameGroupMap.putIfAbsent(
                                    textEditingController.text,
                                    () => GroupData(
                                      textEditingController.text,
                                      textEditingController.text,
                                      {},
                                    ),
                                  );
                                  setState(() {});
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Group name can't be null",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                }
                              },
                              child: const Text("Okay"),
                            ),
                          ],
                        );
                      },
                    );
                    break;
                  case "endGame":
                    endGame();
                    break;
                  case "deleteThisRound":
                    if (gameData!.gameRound <= 0) {
                      Fluttertoast.showToast(
                        msg: "You can't delete this round",
                        toastLength: Toast.LENGTH_LONG,
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content:
                                const Text("Do you wanna delete this round?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Don't delete this round"),
                              ),
                              TextButton(
                                onPressed: () {
                                  for (var group
                                      in gameData!.gameGroupMap.values) {
                                    removeGroupRoundWidget(group);
                                  }

                                  gameData!.gameRound--;

                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Delete this round",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    break;
                  default:
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: "endRound",
                    child: Text(
                      "New Round",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    value: "addGroup",
                    child: Text(
                      "Add Group",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    value: "endGame",
                    child: Text(
                      "End Game",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    value: "deleteThisRound",
                    child: Text(
                      "Delete This Round",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          "Date: ${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch))}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.spaceAround,
                            runAlignment: WrapAlignment.spaceAround,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                ),
                                child: Text(
                                  "Biggest Score\n${gameData!.getBiggestScore() != null ? (gameData!.getBiggestScore() as GroupData).groupName : ""} / ${gameData!.getBiggestScore() != null ? (gameData!.getBiggestScore() as GroupData).getGroupTotalScore : ""}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                ),
                                child: Text(
                                  "Difference\n${gameData!.getBiggestScore() != null ? gameData!.getLowestScore() != null ? ((gameData!.getBiggestScore() as GroupData).getGroupTotalScore) - ((gameData!.getLowestScore() as GroupData).getGroupTotalScore) : "" : ""}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                ),
                                child: Text(
                                  "Lowest Score\n${gameData!.getLowestScore() != null ? (gameData!.getLowestScore() as GroupData).groupName : ""} / ${gameData!.getLowestScore() != null ? (gameData!.getLowestScore() as GroupData).getGroupTotalScore : ""}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                gameData!.gameGroupMap.values.isNotEmpty
                    ? SizedBox(
                        width: MediaQuery.of(context).orientation.name ==
                                "portrait"
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).orientation.name ==
                                "portrait"
                            ? MediaQuery.of(context).size.height * 0.6
                            : MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                left: 16,
                                right: 16,
                                bottom: 16,
                              ),
                              child: Row(
                                children:
                                    gameData!.gameGroupMap.values.map((group) {
                                  return buildGroupWidget(group);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
