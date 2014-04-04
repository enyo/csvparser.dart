library csvparser;

import 'dart:collection';


class CsvParser implements Iterator<Iterator<String>> {
  String _file;
  Queue<String> _naive;
  String _SEPERATOR;
  String _QUOTEMARK;
  String _LINEEND;
  CsvLineParser current=null;
  List<String> _HEADERS;
  int _linenumber=0;
  
  int get linenumber=>_linenumber;
  
  CsvParser(String file, {String seperator:",", String quotemark:"\"", String lineend:null, bool setHeaders:false}) {
    this._file=file.trim();
    this._SEPERATOR=seperator;
    this._QUOTEMARK=quotemark;
    this._LINEEND=lineend;
    if(this._LINEEND==null) {
      if(_file.contains("\r\n"))
        this._LINEEND="\r\n";
      else
        this._LINEEND="\n";
    }
    if(_file.endsWith(this._LINEEND))
      _file = _file.substring(0, _file.length - this._LINEEND.length);
    if(_file.isEmpty) throw "file empty";
    
    _naive=new Queue.from(_file.split(_LINEEND));
    if(setHeaders) {
      this.moveNext();
      headers = this.current.toList();
    }
  }
  
  List<String> getLineAsList() {
    return current.toList();
  }
  
  List<String> get headers=>_HEADERS;
  
  void set headers(List<String> h) {
    _HEADERS=h;
  }
  
  Map<String, String> getLineAsMap({headers:null}) {
    if(headers==null) headers=this._HEADERS;
    return current.toMap(headers);
  }
    
  Queue<String> _removeNaiveQueue() {
    String naiveNextLine = _naive.removeFirst().trim();
    if (naiveNextLine.isEmpty) throw "unexpected empty line";
    return new Queue.from(naiveNextLine.split(_SEPERATOR));
  }

  bool _queueLineComplete(Queue<String> queue) {
    int numQuoteMark=0;
    queue.forEach((elem) {
      // only count QUOTEMARK which starts or ends an elem (next to a seperator)
      if (elem.startsWith(_QUOTEMARK))
        numQuoteMark++;
      if (elem.endsWith(_QUOTEMARK))
        numQuoteMark++;
    });
    return numQuoteMark.isEven;
  }

  bool moveNext() {
    if(_naive.isEmpty) {
      current=null;
      return false;
    }
    Queue<String> nn = _removeNaiveQueue();
    _linenumber++;
    while (!_queueLineComplete(nn)) {
      String l = nn.removeLast();
      Queue<String> nn2 = _removeNaiveQueue();
      String ln = l + _LINEEND + nn2.removeFirst();
      nn..add(ln)..addAll(nn2);
    }
    current = new CsvLineParser(nn.join(_SEPERATOR), seperator:_SEPERATOR, quotemark:_QUOTEMARK);
    return true;
  }
  
}

class CsvFieldType {
  static CsvFieldType NUMBER = new CsvFieldType._intern();
  static CsvFieldType STRING = new CsvFieldType._intern();
  
  CsvFieldType._intern();
}


class CsvLineParser implements Iterator<String> {
  String _line;
  Queue<String> _naive;
  String _SEPERATOR;
  String _QUOTEMARK;
  String current=null;
  CsvFieldType type;
  List<String> list;
  
  
  CsvLineParser(this._line, {String seperator:",", String quotemark:"\""}) {
    this._SEPERATOR=seperator;
    this._QUOTEMARK=quotemark;
    this._naive=new Queue.from(_line.trim().split(_SEPERATOR));
  }
  
  List<String> toList() {
    if(list==null) {
      list = new List<String>();
      while(this.moveNext()) {
        list.add(current);
      }
    }
    return list;
  }
  
  Map<String, String> toMap(List<String> headers) {
    /*Map<String, String> ret = new Map<String, String>();
    headers.forEach((String header) {
      if(!moveNext()) throw "css fault: ${this._line}";
      ret[header]=current;
    });
    if(headers.length!=ret.length) throw "wrong number of fields: ${headers}, ${ret}"; */
    return new Map.fromIterables(headers, this.toList());
  }
  
  bool moveNext() {
    if(_naive.isEmpty) {
      current=null;
      return false;
    }
    String tt = _naive.removeFirst();
    while(tt.startsWith(_QUOTEMARK) && !tt.endsWith(_QUOTEMARK)) {
      tt=tt + _SEPERATOR + _naive.removeFirst();
    }
    current=tt;
    if (current.startsWith(_QUOTEMARK)) {
      this.type = CsvFieldType.STRING;
      current = current.substring(_QUOTEMARK.length, current.length - _QUOTEMARK.length);
    }
    return true;
  }
  
}
