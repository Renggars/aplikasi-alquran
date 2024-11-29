// [
//   [...], juz 1 => index 0
//   [...], juz 2 => index 1
//   [...], juz 30 => index 29
// ]

// List<List<Ayat>>

// [
//   {
//     "juz": 1,
//     "start": Ayat,
//     "end": Ayat,
//     "verses": [...]
//   },
//   {
//     "juz": 1,
//     "start": Ayat,
//     "end": Ayat,
//     "verses": [...]
//   }
// ]

// List<Map<String, dynamic>>

import 'dart:convert';

import 'package:aplikasi_alquran/app/data/models/detail_surah.dart';
import 'package:http/http.dart' as http;

void main() async {
  int juz = 1;

  List<Map<String, dynamic>> penampungAyat = [];
  List<Map<String, dynamic>> allJuz = [];

  for (var i = 1; i <= 114; i++) {
    var res =
        await http.get(Uri.parse('https://api.quran.gading.dev/surah/$i'));
    Map<String, dynamic> raData =
        (json.decode(res.body) as Map<String, dynamic>)['data'];
    DetailSurah data = DetailSurah.fromJson(raData);

    if (data.verses != null) {
      // ex: surah albaqoroh => ratusan ayat
      // juz 1 => ayat 1 - 141
      // juz 2 => ayat 142 - ...

      data.verses!.forEach((ayat) {
        if (ayat.meta?.juz == juz) {
          penampungAyat.add({
            "surah": data.name?.transliteration?.id ?? "",
            "ayat": ayat,
          });
        } else {
          print("=====================");
          print("BERHASIL MEMASUKKAN JUZ");
          print("START JUZ");
          print(
              "Ayat : ${(penampungAyat[0]["ayat"] as Verse).number?.inSurah}");
          print((penampungAyat[0]["ayat"] as Verse).text?.arab);
          print("END JUZ");
          print(
              "Ayat : ${(penampungAyat[penampungAyat.length - 1]["ayat"] as Verse).number?.inSurah}");
          print((penampungAyat[penampungAyat.length - 1]["ayat"] as Verse)
              .text
              ?.arab);
          allJuz.add({
            "juz": juz,
            "start": penampungAyat[0],
            "end": penampungAyat[penampungAyat.length - 1],
            "verse": penampungAyat,
          });
          juz++;
          penampungAyat.clear();
          penampungAyat.add({
            "surah": data.name?.transliteration?.id ?? "",
            "ayat": ayat,
          });
        }
      });
    }
  }
  print("=====================");
  print("BERHASIL MEMASUKKAN JUZ");
  print("START JUZ");
  print("Ayat : ${(penampungAyat[0]["ayat"] as Verse).number?.inSurah}");
  print((penampungAyat[0]["ayat"] as Verse).text?.arab);
  print("END JUZ");
  print(
      "Ayat : ${(penampungAyat[penampungAyat.length - 1]["ayat"] as Verse).number?.inSurah}");
  print((penampungAyat[penampungAyat.length - 1]["ayat"] as Verse).text?.arab);
  allJuz.add({
    "juz": juz,
    "start": penampungAyat[0],
    "end": penampungAyat[penampungAyat.length - 1],
    "verse": penampungAyat,
  });
}
