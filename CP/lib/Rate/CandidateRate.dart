import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';

import '../Candidate.dart';
import '../QueriesService.dart';
import '../Footer.dart';

@Component(
  selector: 'candidaterate',
  templateUrl: 'CandidateRate.html',
  styleUrls: const ['CandidateRate.css'],
  directives: const [COMMON_DIRECTIVES, Footer],
)
class CandidateRate implements OnInit
{
  final Router router;
  Candidate candidate;
  final QueriesService queryService;
  final RouteParams routeParams;
  final Location location;
  double rating = 0.0;

  CandidateRate(this.queryService, this.routeParams, this.location, this.router);

  Future<Null> ngOnInit() async
  {
    if (!queryService.LoadToken('DashboardRate'))
    {
      router.navigate(['Login']);
    }
    else
    {
      var token = routeParams.get('id');

      if (token != null)
      {
        candidate = await (queryService.GetCandidate(token));
      }
    }
  }

  Future<Null> RateCandidate() async
  {
    await (queryService.RateCandidate(candidate.token, rating.toInt()));
    location.back();
  }

  void GoBack()
  {
    router.navigate(['DashboardRate']);
  }
}
