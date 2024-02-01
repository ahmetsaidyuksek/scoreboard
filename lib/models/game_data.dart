import 'package:scoreboard/models/group_data.dart';

class GameData {
  final String gameUID;
  final int gameDate;
  int gameRound;
  final Map<String, GroupData> gameGroupMap;

  GameData(
      {required this.gameUID,
      required this.gameDate,
      required this.gameRound,
      required this.gameGroupMap});

  getBiggestScore() {
    GroupData? biggestGroup;
    int highestScore = 0;

    for (final groupEntry in gameGroupMap.entries) {
      final int totalScore = groupEntry.value.getGroupTotalScore;

      if (highestScore == 0) {
        biggestGroup = groupEntry.value;
      }

      if (totalScore > highestScore) {
        highestScore = totalScore;
        biggestGroup = groupEntry.value;
      }
    }

    if (biggestGroup != null) {
      return biggestGroup;
    }
  }

  getLowestScore() {
    GroupData? lowestGroup;
    int lowestScore = 0;

    for (final groupEntry in gameGroupMap.entries) {
      final int totalScore = groupEntry.value.getGroupTotalScore;
      if (lowestGroup == null || totalScore < lowestScore) {
        lowestScore = totalScore;
        lowestGroup = groupEntry.value;
      }
    }

    if (lowestGroup != null) {
      return lowestGroup;
    }
  }

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      gameUID: json["gameUID"].toString(),
      gameDate: int.parse(json["gameDate"].toString()),
      gameRound: int.parse(json["gameRound"].toString()),
      gameGroupMap: Map.from(json["gameGroupMap"]).map(
        (groupUID, group) {
          int currentKey = 0;
          Map<int, List<int>> resultMap = {};
          print(group);

          GroupData groupData = GroupData.fromJson(group);

          for (var value in groupData.groupRoundData.entries) {
            resultMap[currentKey++] = List.from(value.value);
          }

          return MapEntry(
            groupUID,
            GroupData(
              groupUID,
              group["groupName"],
              resultMap,
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "gameUID": gameUID.toString(),
      "gameDate": gameDate.toInt(),
      "gameRound": gameRound.toInt(),
      "gameGroupMap": gameGroupMap.map((groupName, group) {
        return MapEntry(groupName, group.toJson());
      }),
    };
  }
}
