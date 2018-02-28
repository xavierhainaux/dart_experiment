main(){
  List<String> basePossibleValues = <String>['a', 'b', 'c', 'd', 'e'];

  for (int i = 0; i < 10; ++i) {
    ///Génère une liste random de x elements à partir d'un liste de base
    List<String> finalList = new List<String>.generate(3, (int index) => (basePossibleValues..shuffle()).first);
    print(finalList);
  }
}