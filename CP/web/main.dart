import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';
import 'package:atumonline/App.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

void main()
{
  bootstrap(AppComponent, [provide(Client, useFactory: () => new BrowserClient(), deps: [])]);
}