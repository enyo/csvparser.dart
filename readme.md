This is a copy of http://pub.dartlang.org/packages/csvparser because I couldn't find where the code is hosted
and need to do some changes.

Naive csvparser. This code may work, or it may not. I just got bored by writing it repeatedly, so I thought I'd publish it.

## Sample usage:

```
String data="\"hello\",\"world\"\n\"wie\ngeht's\",\"dir\"";

CsvParser cp = new CsvParser(data, seperator:",", quotemark:"\""); while(cp.moveNext()) { while(cp.current.moveNext()) print(cp.current.current); }
```