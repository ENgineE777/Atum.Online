import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'Rate/DashboardRate.dart';
import 'Rate/CandidateRate.dart';
import 'HR/DashboardHR.dart';
import 'HR/CandidateDetail.dart';
import 'QueriesService.dart';
import 'Login.dart';
import 'StartTest.dart';
import 'Tester/Tester.dart';

@Component(
    selector: 'app',
    template: '''
      <router-outlet></router-outlet>''',
    styleUrls: const ['App.css'],
    directives: const [ROUTER_DIRECTIVES],
    providers: const [QueriesService, ROUTER_PROVIDERS])
@RouteConfig(const [
  const Route(
      path: '/login',
      name: 'Login',
      component: Login,
      useAsDefault: true),
  const Route(
      path: '/dashboard',
      name: 'Dashboard',
      component: DashboardHR),
  const Route(
      path: '/dashboardrate',
      name: 'DashboardRate',
      component: DashboardRate),
  const Route(
      path: '/candidate/:id', name: 'CandidateDetail', component: CandidateDetail),
  const Route(
      path: '/rate/:id', name: 'CandidateRate', component: CandidateRate),
  const Route(
    path: '/starttest/:id', name: 'StartTest', component: StartTest),
  const Route(
      path: '/tester/:id', name: 'Tester', component: Tester)
])
class AppComponent {
  String title = 'Atum.Online';
}
