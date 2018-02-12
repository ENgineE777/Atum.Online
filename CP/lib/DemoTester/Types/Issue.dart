import 'dart:js';

int toInt(id) => id is int ? id : int.parse(id);

class Issue
{
  int    id;
  int    type;
  int    priority;
  String name;
  String desc;
  int    repoRate;
  String component;
  String date;

  Issue(this.id, this.type, this.priority, this.name, this.desc, this.repoRate, this.component, this.date);

  Issue.fromJson(JsObject js)
  {
    this.id = toInt(js['id']);
    this.type = toInt(js['type']);
    this.priority = toInt(js['priority']);
    this.name = js['name'];
    this.desc = js['desc'];
    this.repoRate = toInt(js['repoRate']);
    this.component = js['component'];
    this.date = js['date'];
  }

  String GetType()
  {
    if (type == 0)
    {
      return "Task";
    }
    else
    if (type == 1)
    {
      return "Bug";
    }
    else
    if (type == 2)
    {
      return "Note";
    }

    return "Unknown";
  }

  String GetPriority()
  {
    if (priority == 0)
    {
      return "Critical";
    }
    else
    if (priority == 1)
    {
      return "Major";
    }
    else
    if (priority == 2)
    {
      return "Minor";
    }
    else
    if (priority == 3)
    {
      return "Trivial";
    }

    return "Unknown";
  }

  Map toJson() => {"id": id, "type": type, "priority": priority,"name": name, "desc": desc, "repoRate": repoRate, "component": component, "date": date};

/*factory Candidate.fromJson(Map<String, dynamic> candidate) =>
      new Candidate(_toInt(candidate['id']), candidate['name'], candidate['email'], candidate['link'], _toInt(candidate['status']));*/
}