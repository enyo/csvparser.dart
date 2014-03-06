library csvparser;

import 'dart:collection';

class CsvParserIterator extends Iterator<CsvLineParser> {
  CsvParser data;
  CsvParserIterator(this.data);
  CsvLineParser current = null;

  bool moveNext() {
    if (data.naive.isEmpty) {
      current = null;
      return false;
    }
    Queue<String> nn = data.removeNaiveQueue();
    while (nn.last.startsWith(data.QUOTEMARK) && !nn.last.endsWith(data.QUOTEMARK)) {
      String l = nn.removeLast();
      Queue<String> nn2 = data.removeNaiveQueue();
      String ln = l + data.LINEEND + nn2.removeFirst();
      nn
          ..add(ln)
          ..addAll(nn2);
    }
    current = new CsvLineParser(nn.join(data.SEPERATOR), seperator: data.SEPERATOR,
        quotemark: data.QUOTEMARK);
    return true;
  }
}

class CsvParser extends Object with IterableMixin<CsvLineParser> {
  String _file;
  Queue<String> naive;
  String SEPERATOR;
  String QUOTEMARK;
  String LINEEND;

  CsvParser(String file, {String seperator: ",", String quotemark: "\"", String
      lineend: null}) {
    this._file = file.trim();
    this.SEPERATOR = seperator;
    this.QUOTEMARK = quotemark;
    this.LINEEND = lineend;
    if (this.LINEEND == null) {
      if (_file.contains("\r\n")) {
        this.LINEEND = "\r\n";
      } else {
        this.LINEEND = "\n";
      }
    }
    naive = new Queue.from(_file.split(LINEEND));
  }

  Iterator<CsvLineParser> get iterator => new CsvParserIterator(this);

  Queue<String> removeNaiveQueue() => new Queue.from(naive.removeFirst().trim(
      ).split(SEPERATOR));



}

class CsvLineParserIterator extends Iterator<String> {
  CsvLineParser data;
  CsvLineParserIterator(this.data);
  String current = null;

  bool moveNext() {
    if (data.naive.isEmpty) {
      current = null;
      return false;
    }
    String tt = data.naive.removeFirst();
    while (tt.startsWith(data.QUOTEMARK) && !tt.endsWith(data.QUOTEMARK)) {
      tt = tt + data.SEPERATOR + data.naive.removeFirst();
    }
    current = tt;
    return true;
  }
}

class CsvLineParser extends Object with IterableMixin<String> {
  String _line;
  Queue<String> naive;
  String SEPERATOR;
  String QUOTEMARK;

  Iterator<String> get iterator => new CsvLineParserIterator(this);

  CsvLineParser(this._line, {String seperator: ",", String quotemark: "\""}) {
    this.SEPERATOR = seperator;
    this.QUOTEMARK = quotemark;
    this.naive = new Queue.from(_line.trim().split(SEPERATOR));
  }



}
