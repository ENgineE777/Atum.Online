import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';
import '../QueriesService.dart';
import 'Components/TesterIssues.dart';
import 'Components/TesterNewIssue.dart';
import 'Components/TesterUserReport.dart';
import 'Components/TesterChecklist.dart';
import 'TestSU/TestSU.dart';

@Component(
  selector: 'tester',
  templateUrl: 'Tester.html',
  styleUrls: const ['Tester.css'],
  directives: const [COMMON_DIRECTIVES, TestersIssues, TestersNewIssue, TestersUserReports, Checklist, TestSU]
)
class Tester implements OnInit
{
  String token;

  @ViewChild('sidenav') ElementRef ref;
  @ViewChildren('tablink') QueryList<ElementRef> tablinks;
  @ViewChildren('tab') QueryList<ElementRef> tabs;

  int curTab = -1;

  int    seconds = 0;
  String timeStr = "";

  final QueriesService queryService;
  final Router router;
  final RouteParams routeParams;
  final Location location;
  int   link_broken = 0;
  bool  test_finished = false;

  Tester(this.queryService, this.router, this.routeParams, this.location);

  Future<Null> ngOnInit() async
  {
    token = routeParams.get('id');

    if (token != null)
    {
      if (await (queryService.CheckTestToken(token)))
      {
        link_broken = 2;
        new Timer(const Duration(seconds: 1), OnTimeout);
        seconds = queryService.timeLeft;
      }
      else
      {
        link_broken = 1;
      }
    }
    else
    {
      link_broken = 1;
    }
  }

  Future<Null> OnTimeout() async
  {
    seconds--;
    timeStr = seconds.toString();

    if (seconds > 0)
    {
      new Timer(const Duration(seconds: 1), OnTimeout);
    }
    else
    {
      queryService.StopTest();
      test_finished = true;
    }
  }

  void OpenNav()
  {
    if (curTab == -1)
    {
      ShowTab(0);
    }

    ref.nativeElement.style.left = "0%";
  }

  void CloseNav()
  {
    ref.nativeElement.style.left = "-100%";
  }

  void ShowTab(int index)
  {
    if (curTab == index)
    {
      return;
    }

    if (curTab != -1)
    {
      tablinks.elementAt(curTab).nativeElement.className = tablinks.elementAt(curTab).nativeElement.className.replaceAll(" active", "");
      tabs.elementAt(curTab).nativeElement.style.display = "none";
    }

    tablinks.elementAt(index).nativeElement.className += " active";
    tabs.elementAt(index).nativeElement.style.display = "block";

    curTab = index;
  }
}
