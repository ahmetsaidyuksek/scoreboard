class GroupData {
  String groupUID;
  String groupName;
  Map<int, List<int>> groupRoundData;

  GroupData(this.groupUID, this.groupName, this.groupRoundData);

  int get getGroupTotalScore => groupRoundData.values.fold(
      0,
      (previousValue, element) =>
          previousValue +
          element.fold(0, (previousValue, element) => previousValue + element));

  factory GroupData.fromJson(Map<Object?, Object?> json) {
    return GroupData(
      json["gameUID"].toString(),
      json["gameName"].toString(),
      json["groupRoundData"] != null
          ? Map<int, List<int>>.from(
              (json["groupRoundData"] as Map).map(
                (key, value) => MapEntry(
                  int.parse(key.toString()),
                  List<int>.from(value),
                ),
              ),
            )
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "groupUID": groupUID,
      "groupName": groupName,
      "groupRoundData": groupRoundData.map((key, value) {
        return MapEntry(key.toString(), value);
      }),
    };
  }
}
