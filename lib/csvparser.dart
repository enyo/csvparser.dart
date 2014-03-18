library csvparser;

import 'dart:collection';

class CsvParserIterator extends Iterator {
  CsvLineParser current;
  List<CsvLineParser> rows;
  String separator;
  String quotemark;
  int cursor = 0;

  CsvParserIterator(this.rows, this.separator, this.quotemark);

  bool moveNext()
  {
    if (rows == null || cursor >= rows.length)
    {
      current = null;
      return false;
    }

    current = rows[cursor];
    cursor++;
    return true;
  }
}

class CsvParser extends Object with IterableMixin
{
  List<CsvLineParser> rows = [];
  String separator;
  String quotemark;

  CsvLineParser header;

  Iterator get iterator => new CsvParserIterator(rows, separator, quotemark);

  CsvParser(String sheet, {String separator:",", String quotemark:"\"", bool hasHeader:false})
  {
    this.separator = separator;
    this.quotemark = quotemark;

    if(sheet != null)
    {
      for(var row in sheet.trim().split('\n'))
      {
        rows.add(new CsvLineParser(row, separator: separator, quotemark: quotemark));
      }

    }

    if(hasHeader && rows != null && rows.length > 0)
    {
      header = rows.removeAt(0);
    }
  }

}

class CsvLineParserIterator extends Iterator
{
  List<String> cols;
  String separator;
  String quotemark;
  String current;
  int cursor = 0;

  CsvLineParserIterator(this.cols, this.separator, this.quotemark);

  bool moveNext()
    {
      if (cols == null || cursor >= cols.length)
      {
        current = null;
        return false;
      }
      current = cols[cursor++];
      return true;
    }
}


class CsvLineParser extends Object with IterableMixin
{
  List<String> cols = [];
  String separator;
  String quotemark;
  String current;

  Iterator get iterator => new CsvLineParserIterator(cols, separator, quotemark);

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
