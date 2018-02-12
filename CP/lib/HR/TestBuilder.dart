
import 'package:angular2/angular2.dart';
import '../QueriesService.dart';

@Component(
  selector: 'test-builder',
  templateUrl: 'TestBuilder.html',
  styleUrls: const ['TestBuilder.css'],
  directives: const [COMMON_DIRECTIVES],
)

class TestBuilder
{
  final QueriesService queryService;

  TestBuilder(this.queryService);
}
