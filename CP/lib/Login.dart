import 'dart:async';
import 'dart:core';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'QueriesService.dart';
import 'Footer.dart';

@Component(
  selector: 'login',
  templateUrl: 'Login.html',
  styleUrls: const ['Login.css'],
  directives: const [COMMON_DIRECTIVES, Footer],
)
class Login
{
  String login;
  String pass;
  bool failed_login = false;

  final QueriesService queryService;
  final Router router;

  Login(this.queryService, this.router);

  Future<Null> MakeLogin() async
  {
    //queryService.LoadToken("Dashboard");

    bool logged = await queryService.CheckLogin(login, pass);

    if (logged == true)
    {
      router.navigate([queryService.link]);
    }
    else
    {
      failed_login = true;
    }
  }
}
