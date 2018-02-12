import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import '../Candidate.dart';
import '../QueriesService.dart';
import '../Footer.dart';
import 'RateAccount.dart';
import 'RateCandidatesList.dart';

@Component(
  selector: 'dashboard-rate',
  templateUrl: 'DashboardRate.html',
  styleUrls: const ['DashboardRate.css'],
  directives: const [COMMON_DIRECTIVES, CORE_DIRECTIVES, ROUTER_DIRECTIVES, Footer, RateAccount, RateCandidatesList],
)

class DashboardRate implements OnInit, AfterViewInit
{
  List<Candidate> candidates;
  final Router router;
  final QueriesService queryService;

  int curTab = -1;

  @ViewChildren('tablink') QueryList<ElementRef> tablinks;
  @ViewChildren('tab') QueryList<ElementRef> tabs;

  DashboardRate(this.queryService, this.router);

  void ngOnInit()
  {
    if (!queryService.LoadToken('DashboardRate'))
    {
      router.navigate(['Login']);
    }
  }

  Future<Null> ngAfterViewInit() async
  {
    candidates = await queryService.GetUnratedCandidates();
    new Timer(const Duration(seconds: 10), OnTimeout);

    ShowTab(0);
  }

  Future<Null> OnTimeout() async
  {
    candidates = await queryService.GetUnratedCandidates();
    new Timer(const Duration(seconds: 10), OnTimeout);
  }

  Future<Null> RateCandidate(Candidate candidate) => router.navigate(['CandidateRate', {'id': candidate.token}]);

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
