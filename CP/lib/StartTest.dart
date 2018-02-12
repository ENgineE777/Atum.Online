import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';
import 'QueriesService.dart';
import 'Footer.dart';

@Component(
  selector: 'starttest',
  templateUrl: 'StartTest.html',
  styleUrls: const ['StartTest.css'],
  directives: const [COMMON_DIRECTIVES, Footer],
)
class StartTest implements OnInit
{
  String email;
  String link;
  int link_broken = 0;
  bool wrong_email = false;

  final QueriesService queryService;
  final Router router;
  final RouteParams routeParams;
  final Location location;

  StartTest(this.queryService, this.router, this.routeParams, this.location);

  Future<Null> ngOnInit() async
  {
    link = routeParams.get('id');

    if (link != null)
    {
      if (await (queryService.CheckTest(link)))
      {
        if (queryService.link == 'Not ready')
        {
          link_broken = 2;
        }
        else
        {
          var link = [queryService.link, {'id': queryService.token}];
          router.navigate(link);
        }
      }
      else
      {
        link_broken = 1;
      }
    }
    else
    {
      link_broken = 1;
    }
  }

  Future<Null> Proceed() async
  {
    bool logged = await queryService.StartTest(link, email);

    if (logged == true)
    {
      var link = [queryService.link, {'id': queryService.token}];
      router.navigate(link);
    }
    else
    {
      wrong_email = true;
    }
  }
}
