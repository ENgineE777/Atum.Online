import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import '../QueriesService.dart';
import '../Footer.dart';
import 'CandidatesList.dart';
import 'TestBuilder.dart';
import 'HRAccount.dart';

@Component(
  selector: 'dashboard-hr',
  templateUrl: 'DashboardHR.html',
  styleUrls: const ['DashboardHR.css'],
  directives: const [COMMON_DIRECTIVES, CORE_DIRECTIVES, ROUTER_DIRECTIVES, Footer, CandidatesList, TestBuilder, HRAccount],
)

class DashboardHR implements OnInit, AfterViewInit
{
  final Router router;
  final QueriesService queryService;
  int curTab = -1;

  @ViewChildren('tablink') QueryList<ElementRef> tablinks;
  @ViewChildren('tab') QueryList<ElementRef> tabs;

  DashboardHR(this.queryService, this.router);

  void ngOnInit()
  {
    if (!queryService.LoadToken('Dashboard'))
    {
      router.navigate(['Login']);
    }
  }

  Future<Null> ngAfterViewInit() async
  {
    ShowTab(0);
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
