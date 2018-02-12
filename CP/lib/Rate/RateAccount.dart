
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import '../QueriesService.dart';

@Component(
  selector: 'rate-account',
  templateUrl: 'RateAccount.html',
  styleUrls: const ['RateAccount.css'],
  directives: const [COMMON_DIRECTIVES],
)

class RateAccount
{
  final Router router;
  final QueriesService queryService;

  RateAccount(this.queryService, this.router);

  void SignOut()
  {
    queryService.SignOut();
    router.navigate(['Login']);
  }
}
