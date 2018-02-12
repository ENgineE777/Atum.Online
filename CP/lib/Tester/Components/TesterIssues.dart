import 'dart:core';

import 'package:angular2/angular2.dart';
import '../../QueriesService.dart';
import '../Types/Issue.dart';

@Component(
  selector: 'tester_issues',
  templateUrl: 'TesterIssues.html',
  styleUrls: const ['TesterIssues.css'],
  directives: const [COMMON_DIRECTIVES],
)
class TestersIssues implements OnInit
{
  List<Issue> issues = [];
  Issue selectedIssue = null;

  final QueriesService queryService;

  void ngOnInit()
  {
    issues = queryService.issues;

    if (issues.length > 0)
    {
      SelectIssue(issues.elementAt(0));
    }
  }

  TestersIssues(this.queryService);

  void SelectIssue(Issue issue)
  {
    selectedIssue = issue;
  }
}
