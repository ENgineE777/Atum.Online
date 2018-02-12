import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';

import '../Candidate.dart';
import '../QueriesService.dart';
import '../Footer.dart';

@Component(
  selector: 'candidate-detail',
  templateUrl: 'CandidateDetail.html',
  styleUrls: const ['CandidateDetail.css'],
  directives: const [COMMON_DIRECTIVES, Footer],
)

class CandidateDetail implements OnInit
{
  final Router router;
  Candidate candidate;
  final QueriesService queryService;
  final RouteParams routeParams;
  final Location location;

  CandidateDetail(this.queryService, this.routeParams,this.router, this.location);

  Future<Null> ngOnInit() async
  {
    if (!queryService.LoadToken('Dashboard'))
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

  void GoBack() => router.navigate(['Dashboard']);
}
