import 'dart:convert';

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  ItemModel.fromJson(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'] ?? -1,
        deleted = parsedJSON['deleted'] ?? false,
        type = parsedJSON['type'] ?? false,
        by = parsedJSON['by'] ?? "",
        time = parsedJSON['time'] ?? -1,
        text = parsedJSON['text'] ?? "",
        dead = parsedJSON['dead'] ?? false,
        parent = parsedJSON['parent'] ?? -1,
        kids = parsedJSON['kids'] ?? [],
        url = parsedJSON['url'] ?? "",
        score = parsedJSON['score'] ?? -1,
        title = parsedJSON['title'] ?? "",
        descendants = parsedJSON['descendants'] ?? 0;

  ItemModel.fromDb(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        deleted = 1 == 1, //if deleted is 1 or not, return boolean
        type = parsedJSON['type'] ?? false,
        by = parsedJSON['by'] ?? "",
        time = parsedJSON['time'] ?? -1,
        text = parsedJSON['text'] ?? "",
        dead = parsedJSON['dead'] == 1, // map dead value to boolean
        parent = parsedJSON['parent'] ?? -1,
        kids = jsonDecode(parsedJSON['kids']) ??
            [], // This `blob` big arbitrary data
        url = parsedJSON['url'] ?? "",
        score = parsedJSON['score'] ?? "",
        title = parsedJSON['title'] ?? "",
        descendants = parsedJSON['descendants'] ?? 0;

  //toMap for DB
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "type": type,
      "by": "by",
      "time": time,
      "text": text,
      "parent": parent,
      "url": url,
      "score": score,
      "title": title,
      "descendants": descendants,
      "dead": dead ? 1 : 0,
      "deleted": deleted ? 1 : 0,
      "kids": jsonEncode(kids),
    };
  }
}
