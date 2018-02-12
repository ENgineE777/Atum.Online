
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import '../QueriesService.dart';

@Component(
  selector: 'hr-account',
  templateUrl: 'HRAccount.html',
  styleUrls: const ['HRAccount.css'],
  directives: const [COMMON_DIRECTIVES],
)

class HRAccount
{
  final Router router;
  final QueriesService queryService;

  HRAccount(this.queryService, this.router);

  void SignOut()
  {
    queryService.SignOut();
    router.navigate(['Login']);
  }
}
