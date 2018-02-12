import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import '../Candidate.dart';
import '../QueriesService.dart';

@Component(
  selector: 'candidates-list',
  templateUrl: 'CandidatesList.html',
  styleUrls: const ['CandidatesList.css'],
  directives: const [COMMON_DIRECTIVES, CORE_DIRECTIVES, ROUTER_DIRECTIVES],
)

class CandidatesList implements AfterViewInit, AfterViewChecked
{
  List<Candidate> candidates;
  String candidate_email;
  String candidate_name;
  final Router router;
  final QueriesService queryService;
  
  @ViewChildren('linktext') QueryList<ElementRef> linktexts;
  @ViewChildren('copylink') QueryList<ElementRef> copylinks;

  CandidatesList(this.queryService, this.router);

  Future<Null> ngAfterViewInit() async
  {
    await OnTimeout();
  }

  void ngAfterViewChecked()
  {
    if (candidates == null)
    {
      return;
    }

    for (int i= 0; i<linktexts.length;i++)
    {
      String id_name = 'copylink' + candidates[i].id.toString();
      linktexts.elementAt(i).nativeElement.setAttribute('id', id_name);
      copylinks.elementAt(i).nativeElement.setAttribute('data-clipboard-target', '#' + id_name);
    }
  }

  Future<Null> OnTimeout() async
  {
    candidates = await queryService.GetCandidates();

    new Timer(const Duration(seconds: 10), OnTimeout);
  }

  Future<Null> AddCandidate() async
  {
    await queryService.AddCandidate(candidate_name, candidate_email);
    candidates = await queryService.GetCandidates();
  }

  Future<Null> ViewCandidate(Candidate candidate) => router.navigate([
      'CandidateDetail',
      {'id': candidate.token }
    ]);

  Future<Null> SendLink(Candidate candidate) async
  {
    await queryService.SendLink(candidate.email, candidate.link);
  }

  Future<Null> StartTest(Candidate candidate) => router.navigate(['StartTest', {'id': candidate.link}]);
}
