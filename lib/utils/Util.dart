import 'dart:math';

String generateCachedId() => "${generate(20)}_${generate(13)}";

String generate(int count) {
  var id = "";
  var r = Random(DateTime.now().microsecondsSinceEpoch);
  var letters = [
    "q","w","e","r","t","y","u","i","o","p",
    "a","s","d","f","g","h","j","k","l",
    "z","x","c","v","b","n","m"
  ];
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
  for(var c = 0; c < 20; c++) {
    bool isLetter = r.nextBool();
    if(isLetter) {
      bool isUpperCase = r.nextBool();
      if(isUpperCase)
        id += letters[r.nextInt(letters.length)].toUpperCase();
      else id += letters[r.nextInt(letters.length)];
    } else {
      id += numbers[r.nextInt(numbers.length)].toString();
    }
  }
  return id;
}

bool isCacheId(String id) => id.length > 30 && id.contains("_");
String toFirebaseId(String id) => id.split("_")[0];