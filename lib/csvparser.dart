library csvparser;

import 'dart:collection';


class CsvParser extends Object with IterableMixin
{
  List<List<String>> data = [];
  String separator;
  String quotemark;

  List<String> header;

  Iterator get iterator => data.iterator;

  CsvParser(String sheet, {String separator:",", String quotemark:"\"", bool hasHeader:false})
  {
    this.separator = separator;
    this.quotemark = quotemark;

    if(sheet != null)
    {
      int row_cursor = 0;
      for(var row in sheet.trim().split('\n'))
      {
        data.add(new List<String>());
        var lineParser = new CsvLineParser(row, separator: separator, quotemark: quotemark);
        for(var col in lineParser)
        {
          data[row_cursor].add(col);
        }
        row_cursor++;
      }

    }

    if(hasHeader && data.isNotEmpty)
    {
      header = data.removeAt(0);
    }
  }

}


class CsvLineParser extends Object with IterableMixin
{
  List<String> cols = [];
  String separator;
  String quotemark;
  String current;

  Iterator get iterator => cols.iterator;

  CsvLineParser(String line, {String separator:",", String quotemark:"\""})
  {
    this.separator = separator;
    this.quotemark = quotemark;

    var data = line.trim().split(separator);
    for(int i=0; i < data.length; i++)
    {
      String tt = data[i];

      while (tt.startsWith(quotemark) && !tt.endsWith(quotemark))
      {
        tt = tt + separator + data[++i];
        tt.trim();
      }
      if(tt.length >= quotemark.length && tt.startsWith(quotemark) && tt.indexOf(quotemark, tt.length-(quotemark.length+1)) > -1)
      {
        tt = tt.substring(quotemark.length, tt.length-(quotemark.length));
      }
      cols.add(tt);
    }
  }



  toString()
  {
    return cols.toString();
  }

}
