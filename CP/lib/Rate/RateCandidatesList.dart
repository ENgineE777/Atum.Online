import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import '../Candidate.dart';
import '../QueriesService.dart';
import '../Footer.dart';
import 'RateAccount.dart';

@Component(
  selector: 'rate-candidates-list',
  templateUrl: 'RateCandidatesList.html',
  styleUrls: const ['RateCandidatesList.css'],
  directives: const [COMMON_DIRECTIVES, CORE_DIRECTIVES, ROUTER_DIRECTIVES, Footer, RateAccount],
)

class RateCandidatesList implements AfterViewInit
{
  List<Candidate> candidates;
  final Router router;
  final QueriesService queryService;

  RateCandidatesList(this.queryService, this.router);

  Future<Null> ngAfterViewInit() async
  {
    candidates = await queryService.GetUnratedCandidates();
    new Timer(const Duration(seconds: 10), OnTimeout);
  }

  Future<Null> OnTimeout() async
  {
    candidates = await queryService.GetUnratedCandidates();
    new Timer(const Duration(seconds: 10), OnTimeout);
  }

  Future<Null> RateCandidate(Candidate candidate) => router.navigate(['CandidateRate', {'id': candidate.token}]);
}
