import 'dart:js';

int toInt(id) => id is int ? id : int.parse(id);

class Candidate
{
  int id;
  String name;
  String email;
  String link;
  int    status;
  String token;
  int    rating;

  Candidate(this.id, this.name, this.email, this.link, this.status, this.token, this.rating);

  Candidate.fromJson(JsObject js)
  {
    this.id = toInt(js['id']);
    this.name = js['name'];
    this.email = js['email'];
    this.link = js['link'];
    this.status = toInt(js['status']);
    this.token = js['token'];
    this.rating = toInt(js['rating']);
  }

  String GetStatus()
  {
    if (status == 0)
    {
      return "Not started";
    }
    else
    if (status == 1)
    {
      return "Testing";
    }
    else
    if (status == 2)
    {
      return "Analysing results";
    }
    else
    if (status == 3)
    {
      return "Results ready";
    }

    return "Unknown";
  }

/*factory Candidate.fromJson(Map<String, dynamic> candidate) =>
      new Candidate(_toInt(candidate['id']), candidate['name'], candidate['email'], candidate['link'], _toInt(candidate['status']));
  Map toJson() => {'id': id, 'name': name, 'email': email, 'link': link, 'status': status};*/
}