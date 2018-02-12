import 'dart:js';

int toInt(id) => id is int ? id : int.parse(id);

class UserReport
{
  String name;
  String date;
  String author;
  String desc;

  UserReport(this.name, this.date, this.author, this.desc);

  UserReport.fromJson(JsObject js)
  {
    this.name = js['name'];
    this.date = js['date'];
    this.author = js['author'];
    this.desc = js['desc'];
  }

  Map toJson() => {"name": name, "date": date, "author": author, "desc": desc};

/*factory Candidate.fromJson(Map<String, dynamic> candidate) =>
      new Candidate(_toInt(candidate['id']), candidate['name'], candidate['email'], candidate['link'], _toInt(candidate['status']));*/
}