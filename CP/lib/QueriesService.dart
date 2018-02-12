import 'dart:async';
import 'dart:convert';

import 'package:angular2/angular2.dart';
import 'package:http/http.dart';
import 'package:jsonpadding/jsonpadding.dart';

import 'Candidate.dart';
import 'Tester/Types/Issue.dart';
import 'Tester/Types/UserReport.dart';
import 'Tester/Types/CheckedItem.dart';

import 'dart:html';

import 'dart:js';

@Injectable()
class QueriesService
{
  //static const _heroesUrl = 'http://atum.online/api/product/login.php?login=ENgine&pass=Se400860'; // URL to web API

  final Client _http;

  String token;
  String link;
  int    timeLeft;
  List<Issue>       issues;
  List<UserReport>  reports;
  List<CheckedItem> checklist;
  String desc;

  QueriesService(this._http);

  String GetCookie(String name)
  {
    //print(document.cookie);
    //print(name);
    
    String str = document.cookie;

    int index = 0;
    int stage = 0;

    String value = null;
    
    for (int i = 0; i<str.length;i++)
    {
      //print('stage ' + stage.toString() + ' index '+ i.toString());

      if (stage == 0 && str[i] == '=')
      {
        stage++;

        //print("go to stage 1");
        //print(str.substring(index, i));

        if (str.substring(index, i) == name)
        {
          //print("go to stage 2");

          index = i+1;
          stage++;
        }
      }

      if (stage > 0)
      {
        if (str[i] == ';' || i == str.length - 1)
        {
          //print("finish stage " + stage.toString());

          if (stage == 2)
          {
            //print("key finded");

            int sub_index = i;

            if (str[i] != ';')
            {
              sub_index++;
            }

            value = str.substring(index, sub_index);
            break;
          }

          index = i + 2;
          stage = 0;

          if (str[i] == ';')
          {
            i++;
          }
        }
      }
    }

    return value;
  }

  bool LoadToken(String needed_link)
  {
    //print(document.cookie);
    
    String lnk = GetCookie('link');

    if (lnk != null && lnk == needed_link)
    {
      String tkn = GetCookie(lnk + 'token');

      if (tkn != null)
      {
        //print(lnk);
        //print(tkn);
        link = lnk;
        token = tkn;

        return true;
      }
    }

    return false;
  }

  void SaveToken()
  {
    document.cookie = 'link=' + link;
    document.cookie = link + 'token=' + token;

    DateTime now = new DateTime.now();
    now.add(const Duration(seconds: 24 * 60 * 60 * 7));

    document.cookie="expires=" + now.toIso8601String();

  }

  Exception _handleError(dynamic e)
  {
    print(e);
    return new Exception('Server error; cause: $e');
  }

  Future<bool> CheckLogin(String login, String pass) async
  {    
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/login.php',
        queryParameters: {
          'login': login,
          'pass': pass
        });

    JsObject res = await jsonp(uri);

    if (res['message'] == 'Passed')
    {
      token = res['token'];
      link = res['link'];

      SaveToken();

      return true;
    }

    return false;
  }

  void SignOut()
  {
    token = "";
    SaveToken();

    link = "";
    SaveToken();
  }

  Future<bool> AddCandidate(String name, String email) async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/addcandidate.php',
        queryParameters: {
          'token': token,
          'name': name,
          'email': email
        });

    JsObject res = await jsonp(uri);

    if (res['message'] == 'We passed.')
    {
      return true;
    }

    return false;
  }

  Future<List<Candidate>> GetCandidates() async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/getcandidates.php',
        queryParameters: {
          'token': token });

    JsObject res = await jsonp(uri);

    JsArray candidates = res['candidates'];

    List<Candidate> list = [];

    if (candidates != null)
    {
      for (int i=0; i<candidates.length ; i++)
      {
        list.add(new Candidate.fromJson(candidates[i]));
      }
    }

    return list;

    /*

    try
    {
      final response = await _http.get(_heroesUrl);
      final candidates = _extractData(response).map((value) => new Candidate.fromJson(value)).toList();
      return candidates;
    }
    catch (e)
    {
      throw _handleError(e);
    }*/
  }

  Future<List<Candidate>> GetUnratedCandidates() async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/getunratedcandidates.php',
        queryParameters: {
          'token': token });

    JsObject res = await jsonp(uri);

    JsArray candidates = res['candidates'];

    List<Candidate> list = [];

    if (candidates != null)
    {
      for (int i=0; i<candidates.length ; i++)
      {
        list.add(new Candidate.fromJson(candidates[i]));
      }
    }

    return list;

    /*

    try
    {
      final response = await _http.get(_heroesUrl);
      final candidates = _extractData(response).map((value) => new Candidate.fromJson(value)).toList();
      return candidates;
    }
    catch (e)
    {
      throw _handleError(e);
    }*/
  }

  Future<Candidate> GetCandidate(String ctoken) async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/getcandidate.php',
        queryParameters: {
          'token': token,
          'ctoken': ctoken});

    JsObject jsCand = await jsonp(uri);

    return new Candidate.fromJson(jsCand);
  }

  Future<Null> SendLink(String email, String clink) async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/sendlink.php',
        queryParameters: {
          'email': email,
          'link': clink});

    await jsonp(uri);
  }

  Future<Null> RateCandidate(String ctoken, int rating) async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/ratecandidate.php',
        queryParameters: {
          'token': token,
          'ctoken': ctoken,
          'rating': rating.toString()});

    await jsonp(uri);
  }

  Future<bool> CheckTest(String set_link) async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/checktest.php',
        queryParameters: {
          'link': set_link
        });

    JsObject res = await jsonp(uri);

    if (res['message'] == 'Exist')
    {
      link = res['link'];

      if (link != 'Not ready')
      {
        token = res['token'];
      }

      return true;
    }

    return false;
  }

  Future<bool> CheckTestToken(String token) async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/checktesttoken.php',
        queryParameters: {
          'token': token
        });

    JsObject res = await jsonp(uri);

    if (res['message'] == 'Exist')
    {
      token = res['token'];
      timeLeft = res['timeLeft'];

      desc = res['data3'];

      issues = [];

      JsArray js_issues = JSON.decode(res['data0']);
    
      if (js_issues != null)
      {
        for (int i=0; i<js_issues.length ; i++)
        {
          issues.add(new Issue.fromJson(js_issues[i]));
        }
      }

      reports = [];

      JsArray js_reports = JSON.decode(res['data2']);
    
      if (js_reports != null)
      {
        for (int i=0; i<js_reports.length ; i++)
        {
          reports.add(new UserReport.fromJson(js_reports[i]));
        }
      }

      checklist = [];

      JsArray js_checklist = JSON.decode(res['data1']);
    
      if (js_checklist != null)
      {
        for (int i=0; i<js_checklist.length ; i++)
        {
          checklist.add(new CheckedItem.fromJson(js_checklist[i]));
        }
      }

      return true;
    }

    return false;
  }

  Future<bool> StartTest(String set_link, String email) async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/starttest.php',
        queryParameters: {
          'link': set_link,
          'email': email,
        });

    JsObject res = await jsonp(uri);

    if (res['message'] == 'Passed')
    {
      token = res['token'];
      link = res['link'];

      return true;
    }

    return false;
  }

  Future<Null> StopTest() async
  {
    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/stoptest.php',
        queryParameters: {
          'token': token
        });

    await jsonp(uri);
  }

  Future<Null> SaveIssues() async
  {
    String json = JSON.encode(issues);

    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/saveissues.php',
        queryParameters: {
          'token': token,
          'issues': json
        });

    await jsonp(uri);
  }

  Future<Null> SaveCheckList() async
  {
    String json = JSON.encode(checklist);

    Uri uri = new Uri(
        scheme: 'https',
        host: 'atum.online',
        path: 'api/savechecklist.php',
        queryParameters: {
          'token': token,
          'checklist': json
        });

    await jsonp(uri);
  }

  /*Future<Hero> getHero(int id) async {
    try {
      final response = await _http.get('$_heroesUrl/$id');
      return new Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  static final _headers = {'Content-Type': 'application/json'};

  Future<Hero> update(Hero hero) async {
    try {
      final url = '$_heroesUrl/${hero.id}';
      final response =
      await _http.put(url, headers: _headers, body: JSON.encode(hero));
      return new Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Hero> create(String name) async {
    try {
      final response = await _http.post(_heroesUrl,
          headers: _headers, body: JSON.encode({'name': name}));
      return new Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Null> delete(int id) async {
    try {
      final url = '$_heroesUrl/$id';
      await _http.delete(url, headers: _headers);
    } catch (e) {
      throw _handleError(e);
    }
  }*/
}