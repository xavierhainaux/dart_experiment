import 'dart:math';

main(){
  reduceWithLambda();
  reduceWithMinMax();
}

/// reduce with a lambda expression
void reduceWithLambda() {
  print('reduceWithLambda');
  List<int> dataList = [1,2,3,4,5,6,7,8,9,10];

  int reducedData = dataList.reduce((a, b) => a + b);
  print(reducedData);
  print(dataList);
}

/// reduce with min / max function
void reduceWithMinMax() {
  print('reduceWithMinMax');
  List<int> dataList = [1,2,3,4,5,6,7,8,9,10];

  ///keep only min data
  int minData = dataList.reduce(min);
  print(minData);

  ///keep only max data
  int maxData = dataList.reduce(max);
  print(maxData);
  print(dataList);
}

