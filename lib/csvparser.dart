library csvparser;

import 'dart:collection';

class CsvParserIterator extends Iterator {
  CsvLineParser current;
  List<String> rows;
  String separator;
  String quotemark;
  int cursor = 0;

  CsvParserIterator(this.rows, this.separator, this.quotemark);

  bool moveNext()
  {
    print('CsvParser.cursor: ${cursor}');
    if (rows == null || cursor >= rows.length)
    {
      current = null;
      // reset the cursor?
//      cursor = 0;
      return false;
    }

    current = new CsvLineParser(rows[cursor], separator:separator, quotemark:quotemark);
    cursor++;
    return true;
  }
}

class CsvParser extends Object with IterableMixin
{
  List<String> rows;
  String separator;
  String quotemark;

  CsvLineParser header;

  Iterator get iterator => new CsvParserIterator(rows, separator, quotemark);

  CsvParser(String sheet, {String seperator:",", String quotemark:"\"", bool hasHeader:false})
  {
    this.separator = seperator;
    this.quotemark = quotemark;

    this.rows = sheet.trim().split('\n');
    if(hasHeader && rows != null && rows.length > 0)
    {
      header = new CsvLineParser(rows.removeAt(0));
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
      print('CsvLineParser.cursor: ${cursor}');
      if (cols == null || cursor >= cols.length)
      {
        current = null;
        // reset the cursor?
//        cursor = 0;
        return false;
      }
      String tt = cols[cursor++];

      while (tt.startsWith(quotemark) && !tt.endsWith(quotemark))
      {
        tt = tt + separator + cols[cursor++];
        tt.trim();
      }
      if(tt.startsWith(quotemark) && tt.indexOf(quotemark, tt.length-1))
      {
        tt = tt.substring(1, tt.length-1);
      }
      current = tt;
      return true;
    }
}


class CsvLineParser extends Object with IterableMixin
{
  List<String> cols;
  String separator;
  String quotemark;
  String current;

  Iterator get iterator => new CsvLineParserIterator(cols, separator, quotemark);

  CsvLineParser(String line, {String separator:",", String quotemark:"\""})
  {
    this.separator = separator;
    this.quotemark = quotemark;

    this.cols = line.trim().split(separator);
  }



  toString()
  {
    return cols.toString();
  }

}
