//import 'dart:io';
import 'package:angular/angular.dart';
import '../lib/csvparser.dart';
// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(override: '*')
import 'dart:mirrors';

@NgController(
    selector: '[spreadsheet]',
    publishAs: 'ctrl')
class SpreadsheetCtrl
{
//  "first_name","last_name","company_name","address","city","county","state","zip","phone1","phone2","email","web"

  String raw = '''
"James","Butt","Benton, John B Jr","6649 N Blue Gum St","New Orleans","Orleans","LA",70116,"504-621-8927","504-845-1427","jbutt@gmail.com","http://www.bentonjohnbjr.com"
"Josephine","Darakjy","Chanay, Jeffrey A Esq","4 B Blue Ridge Blvd","Brighton","Livingston","MI",48116,"810-292-9388","810-374-9840","josephine_darakjy@darakjy.org","http://www.chanayjeffreyaesq.com"
"Art","Venere","Chemel, James L Cpa","8 W Cerritos Ave #54","Bridgeport","Gloucester","NJ","08014","856-636-8749","856-264-4130","art@venere.org","http://www.chemeljameslcpa.com"
''';
  CsvParser data;

  SpreadsheetCtrl()
  {
//    File file = new File('../us-500.csv');
    data = new CsvParser(raw);
  }
}

class MyAppModule extends Module {
  MyAppModule() {
    type(SpreadsheetCtrl);
  }
}

void main() {
  ngBootstrap(module: new MyAppModule());
}



