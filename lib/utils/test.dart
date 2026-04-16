// ignore_for_file: avoid_print

class Cat {
  String name;
  int age;

  Cat(this.name, this.age);

  void meow() {
    print("$name: meow");
  }

  void bigMeow() {
    print("$name: MEOWWWWWW!");
  }
}

void main(List<String> args) {
  var shino = Cat("shino", 12);
  shino.meow();
  shino.bigMeow();
}
