import 'dart:async';
import 'dart:core';

import 'package:angular2/angular2.dart';
import '../../QueriesService.dart';
import '../Types/Issue.dart';

@Component(
  selector: 'tester_new_issue',
  templateUrl: 'TesterNewIssue.html',
  styleUrls: const ['TesterNewIssue.css'],
  directives: const [COMMON_DIRECTIVES],
)
class TestersNewIssue implements OnInit
{
  Issue issue = null;

  @ViewChild('priorityList') ElementRef refPriorityList;
  @ViewChild('typeList') ElementRef refTypeList;
  @ViewChild('repoList') ElementRef refRepoList;

  final QueriesService queryService;

  void ngOnInit()
  {
    int id = 0;

    for (int i = 0; i < queryService.issues.length; i++)
    {
      if (id < queryService.issues.elementAt(i).id)
      {
        id = queryService.issues.elementAt(i).id;
      }
    }

    issue = new Issue(id+1, 0, 0, "", "", 0, "", "");
  }
  
  Future<Null>  AddIssue() async
  {
    queryService.issues.add(issue);
    queryService.SaveIssues();

    issue = new Issue(issue.id+1, 0, 0, "", "", 0, "", "");

    refTypeList.nativeElement.selectedIndex = 0;
    refPriorityList.nativeElement.selectedIndex = 0;
    refRepoList.nativeElement.selectedIndex = 0;
  }

  void ChangeType()
  {
    issue.type = refTypeList.nativeElement.selectedIndex;
  }

  void ChangePriority()
  {
    issue.priority = refPriorityList.nativeElement.selectedIndex;
  }

  void ChangeRepoRate()
  {
    issue.repoRate = (refRepoList.nativeElement.selectedIndex + 1) * 10;
  }

  TestersNewIssue(this.queryService);
}
