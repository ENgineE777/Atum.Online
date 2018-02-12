import 'dart:core';

import 'package:angular2/angular2.dart';
import '../../QueriesService.dart';
import '../Types/UserReport.dart';

@Component(
  selector: 'tester_user_reports',
  templateUrl: 'TesterUserReport.html',
  styleUrls: const ['TesterUserReport.css'],
  directives: const [COMMON_DIRECTIVES],
)
class TestersUserReports implements OnInit
{
  List<UserReport> reports = [];
  UserReport selectedReport = null;

  final QueriesService queryService;

  void ngOnInit()
  {
    reports = queryService.reports;

    if (reports.length > 0)
    {
      SelectReport(reports.elementAt(0));
    }
  }

  TestersUserReports(this.queryService);

  void SelectReport(UserReport report)
  {
    selectedReport = report;
  }
}
