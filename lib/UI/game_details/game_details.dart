import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoreboard/models/game_data.dart';
import 'package:scoreboard/models/group_data.dart';

class GameDetails extends StatefulWidget {
  final GameData gameData;
  const GameDetails({super.key, required this.gameData});

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  GameData? gameData;

  @override
  void initState() {
    gameData = widget.gameData;
    super.initState();
  }

  Widget buildGroupData(GroupData groupData) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 200,
        child: Row(
          children: [
            const VerticalDivider(
              thickness: 2,
            ),
            Expanded(
              child: Column(
                children: [
                  const Divider(
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Group Name: ${groupData.groupName}",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: Column(
                        children: groupData.groupRoundData.entries.map((entry) {
                          return buildRoundData(entry.key, entry.value);
                        }).toList(),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Total Score: ${groupData.getGroupTotalScore}",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRoundData(
    int round,
    List<int> scores,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 200,
        height: 150,
        child: Card(
          elevation: 16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("Round: $round"),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: scores.map((score) {
                      return Card(
                        elevation: 16,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            score.toString(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Total Score: ${scores.fold(0, (previousValue, element) => previousValue + element)}",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game"),
      ),
      body: SafeArea(
        child: Center(
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          "Game Date: ${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(gameData!.gameDate))}",
                          textAlign: TextAlign.center,
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
              ),
              SizedBox(
                width: MediaQuery.of(context).orientation.name == "portrait" ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).orientation.name == "portrait" ? MediaQuery.of(context).size.height * 0.6 : MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: gameData!.gameGroupMap.values.map((groupData) {
                        return buildGroupData(groupData);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
