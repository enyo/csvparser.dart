library csvparser;

import 'dart:collection';

class CsvParser extends Iterator with IterableMixin<CsvLineParser>
{
  String _file;
  Queue<String> _naive;
  String _SEPERATOR;
  String _QUOTEMARK;
  String _LINEEND;
  CsvLineParser current = null;

  CsvParser(String file, {String seperator:",", String quotemark:"\"", String lineend:null})
  {
    this._file = file.trim();
    this._SEPERATOR = seperator;
    this._QUOTEMARK = quotemark;
    this._LINEEND = lineend;
    if (this._LINEEND == null)
    {
      if (_file.contains("\r\n"))this._LINEEND = "\r\n";
      else this._LINEEND = "\n";
    }
    _naive = new Queue.from(_file.split(_LINEEND));
  }

  Iterator<CsvLineParser> get iterator
  => this;

  Queue<String> _removeNaiveQueue()
  => new Queue.from(_naive.removeFirst().trim().split(_SEPERATOR));

  bool moveNext()
  {
    if (_naive.isEmpty)
    {
      current = null;
      return false;
    }
    Queue<String> nn = _removeNaiveQueue();
    while (nn.last.startsWith(_QUOTEMARK) && !nn.last.endsWith(_QUOTEMARK))
    {
      String l = nn.removeLast();
      Queue<String> nn2 = _removeNaiveQueue();
      String ln = l + _LINEEND + nn2.removeFirst();
      nn
        ..add(ln)
        ..addAll(nn2);
    }
    current = new CsvLineParser(nn.join(_SEPERATOR), seperator:_SEPERATOR, quotemark:_QUOTEMARK);
    return true;
  }

}

class CsvLineParser extends Iterator with IterableMixin<String>
{
  String _line;
  Queue<String> _naive;
  String _SEPERATOR;
  String _QUOTEMARK;
  String current = null;

  Iterator<String> get iterator
  => this;

  CsvLineParser(this._line, {String seperator:",", String quotemark:"\""})
  {
    this._SEPERATOR = seperator;
    this._QUOTEMARK = quotemark;
    this._naive = new Queue.from(_line.trim().split(_SEPERATOR));
  }

  bool moveNext()
  {
    if (_naive.isEmpty)
    {
      current = null;
      return false;
    }
    String tt = _naive.removeFirst();
    while (tt.startsWith(_QUOTEMARK) && !tt.endsWith(_QUOTEMARK))
    {
      tt = tt + _SEPERATOR + _naive.removeFirst();
    }
    current = tt;
    return true;
  }

}
