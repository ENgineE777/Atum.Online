import 'dart:async';
import 'dart:core';

import 'package:angular2/angular2.dart';
import '../../QueriesService.dart';
import '../Types/CheckedItem.dart';

@Component(
  selector: 'tester_checklist',
  templateUrl: 'TesterChecklist.html',
  styleUrls: const ['TesterChecklist.css'],
  directives: const [COMMON_DIRECTIVES],
)
class Checklist implements AfterViewInit
{
  @ViewChildren('state') QueryList<ElementRef> stateList;
  List<CheckedItem> checklist = [];
  bool checkStarted = false;
  String item_name;
  String item_desc;

  final QueriesService queryService;

  Future<Null> ngAfterViewInit() async
  {
    checklist = queryService.checklist;

    for (int i=0;i<checklist.length;i++)
    {
      stateList.elementAt(i).nativeElement.selectedIndex = checklist[i].state;
    }
  }

  void ShowStateCB(bool show)
  {
    for (int i=0;i<checklist.length;i++)
    {
      stateList.elementAt(i).nativeElement.style.visibility = show ? "visible" : "hidden";
    }
  }

  Checklist(this.queryService);

  Future<Null> ChangeState(CheckedItem checkeditem) async
  {
    for (int i=0;i<checklist.length;i++)
    {
      if (checklist[i] == checkeditem)
      {
        checklist[i].cur_state = stateList.elementAt(i).nativeElement.selectedIndex;
        break;
      }
    }

    queryService.SaveCheckList();
  }

  void StartTest()
  {
    for (int i=0;i<checklist.length;i++)
    {
        checklist[i].cur_state = stateList.elementAt(i).nativeElement.selectedIndex = 0;
    }

    ShowStateCB(true);
    checkStarted = true;
  }

  Future<Null> SaveTest() async
  {
    for (int i=0;i<checklist.length;i++)
    {
        checklist[i].state = checklist[i].cur_state;
    }

    queryService.SaveCheckList();
    checkStarted = false;
    ShowStateCB(false);
  }

  void AddChechediItem()
  {
    queryService.checklist.add(new CheckedItem(item_name, item_desc, 0));
    queryService.SaveCheckList();

    item_name = "";
    item_desc = "";
  }
}
