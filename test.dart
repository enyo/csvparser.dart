import 'lib/csvparser.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

main()
{
  useVMConfiguration();
  test('', ()
  {
    String raw = '''
  "first_name","last_name","company_name","address","city","county","state","zip","phone1","phone2","email","web"
  "James","Butt","Benton, John B Jr","6649 N Blue Gum St","New Orleans","Orleans","LA",70116,"504-621-8927","504-845-1427","jbutt@gmail.com","http://www.bentonjohnbjr.com"
  "Josephine","Darakjy","Chanay, Jeffrey A Esq","4 B Blue Ridge Blvd","Brighton","Livingston","MI",48116,"810-292-9388","810-374-9840","josephine_darakjy@darakjy.org","http://www.chanayjeffreyaesq.com"
  "Art","Venere","Chemel, James L Cpa","8 W Cerritos Ave #54","Bridgeport","Gloucester","NJ","08014","856-636-8749","856-264-4130","art@venere.org","http://www.chemeljameslcpa.com"
  ''';

    CsvParser data = new CsvParser(raw, hasHeader: true);
    expect(data.iterator, isNotNull);
    expect(data.header, isNotNull);
    expect(data.header.indexOf('last_name'), 1);

    /* internal separator */
    expect(data.data[0][2], 'Benton, John B Jr');

    /* empty data */
    raw = '';
    data = new CsvParser(raw);
    expect(data.iterator.moveNext(), isTrue);
    /* null data */
    raw = null;
    data = new CsvParser(raw);
    expect(data.iterator.moveNext(), isFalse);

    raw = '''
"James","Butt","Benton, John B Jr","6649 N Blue Gum St","New Orleans","Orleans","LA",70116,"504-621-8927","504-845-1427","jbutt@gmail.com","http://www.bentonjohnbjr.com"
''';
    data = new CsvParser(raw);
    for(var row in data)
    {
      Iterator i = row.iterator;
      expect(i, isNotNull);
    }

  });
  test('', ()
  {
    String raw = '''
;;James;;,;;Butt;;,;;Benton, John B Jr;;,;;6649 N Blue Gum St;;,;;New Orleans;;,;;Orleans;;,;;LA;;,70116,;;504-621-8927;;,;;504-845-1427;;,;;jbutt@gmail.com;;,;;http://www.bentonjohnbjr.com;;
''';
    CsvParser data = new CsvParser(raw, quotemark: ';;',  hasHeader: false);
    expect(data.header, isNull);
    /* internal separator */
    expect(data.data[0][2], 'Benton, John B Jr');
    raw = '''
;;James;;___;;Butt;;___;;Benton, John B Jr;;___;;6649 N Blue Gum St;;___;;New Orleans;;___;;Orleans;;___;;LA;;___70116,;;504-621-8927;;___;;504-845-1427;;___;;jbutt@gmail.com;;___;;http://www.bentonjohnbjr.com;;
''';
    data = new CsvParser(raw, quotemark: ';;', separator: '___', hasHeader: false);
    expect(data.header, isNull);
    /* internal separator */
    expect(data.data[0][2], 'Benton, John B Jr');
  });

}