main(){
  test02();
}

void test01() {
  int base = 50;
  for (int i = 0; i < 500; i += base) {
    print('$i ~/ $base : ${(i ~/ base)% 5}');
  }
}

void test02() {
  int base = 50;
  for (int i = 0; i < 1000; i += 50) {
    print(i % 550);
  }
}