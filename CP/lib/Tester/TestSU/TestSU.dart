import 'dart:core';

import 'package:angular2/angular2.dart';
import '../../QueriesService.dart';

@Component(
  selector: 'test_su',
  templateUrl: 'TestSU.html',
  styleUrls: const ['TestSU.css'],
  directives: const [COMMON_DIRECTIVES],
)
class TestSU implements OnInit
{
  final QueriesService queryService;
  int page = 0;
  bool logged = false;
  bool show_login = false;
  bool failed_login = false;
  bool show_video = false;
  bool menu_dropped = false;
  String login;
  String password;
  String search;

  void ngOnInit()
  {
  }

  TestSU(this.queryService);

  void DropMenu()
  {
    menu_dropped = !menu_dropped;
  }

  void Login()
  {
    show_login = true;
  }

  void GoHome()
  {
    page = 0;
  }

  void MakeLogin()
  {
    logged = true;
    show_login = false;
  }

  void CancelLogin()
  {
    show_login = false;
  }

  void SignOut()
  {
    menu_dropped = false;
    logged = false;

    if (page == 2 || page ==3 || page == 8)
    {
      page = 0;
    }
  }

  void BecomeTeacher()
  {
    page = 1;
  }

  void Go2LK()
  {
    page = 2;
    menu_dropped = false;
  }

  void MyCourses()
  {
    page = 3;
    menu_dropped = false;
  }

  void ChangeType()
  {

  }

  void Search()
  {
    // searching string 
    page = 4;
  }

  void ViewCourses()
  {
    page = 4;
  }

  void Go2LearnngCourse()
  {
    page = 5;
  }

  void LearnCourse()
  {
    page = 6;
  }

  void ShowAuthor()
  {
    page = 7;
  }

  void EditCourse()
  {
    menu_dropped = false;
    if (!logged)
    {
      Login();

      return;
    }

    page = 8;
  }

  void ViewCourse()
  {
    show_video = true;
  }

  void StopViewCourse()
  {
    show_video = false;
  }
}
