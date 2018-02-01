[args library doc](https://www.dartdocs.org/documentation/args/1.0.2/index.html)

Lorsque le code main est appelé avec des arguments : 
```
dart prog.dart -n text.txt
```

alors, arguments.length == 2
```dart
void main(List<String> arguments)
```