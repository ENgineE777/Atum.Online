import 'dart:js';

int toInt(id) => id is int ? id : int.parse(id);

class CheckedItem
{
  String name;
  String desc;
  int    state;
  int    cur_state;

  CheckedItem(this.name, this.desc, this.state);

  CheckedItem.fromJson(JsObject js)
  {
    this.name = js['name'];
    this.desc = js['desc'];
    this.state = toInt(js['state']);
  }
  String GetState()
  {
    if (state == 1)
    {
      return "Passed";
    }
    else
    if (state == 2)
    {
      return "Failed";
    }
    else
    if (state == 3)
    {
      return "Invalid";
    }

    return "Not set";
  }

  Map toJson() => {"name": name, "desc": desc, "state": state};

/*factory Candidate.fromJson(Map<String, dynamic> candidate) =>
      new Candidate(_toInt(candidate['id']), candidate['name'], candidate['email'], candidate['link'], _toInt(candidate['status']));*/
}