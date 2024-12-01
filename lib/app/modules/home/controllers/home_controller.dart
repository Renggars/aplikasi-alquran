import 'dart:convert';

import 'package:aplikasi_alquran/app/data/models/detail_surah.dart';
import 'package:get/get.dart';

import 'package:aplikasi_alquran/app/data/models/surah.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  RxBool isDarkMode = false.obs;
  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah');
    var res = await http.get(url);

    List data = (json.decode(res.body) as Map<String, dynamic>)['data'];

    if (data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Map<String, dynamic>>> getAllJuz() async {
    int juz = 1;

    List<Map<String, dynamic>> penampungAyat = [];
    List<Map<String, dynamic>> allJuz = [];

    for (var i = 1; i <= 114; i++) {
      var res =
          await http.get(Uri.parse('https://api.quran.gading.dev/surah/$i'));
      Map<String, dynamic> rawData = json.decode(res.body)['data'];
      DetailSurah data = DetailSurah.fromJson(rawData);

      if (data.verses != null) {
        // ex: surah albaqoroh => ratusan ayat
        // juz 1 => ayat 1 - 141
        // juz 2 => ayat 142 - ...

        for (var ayat in data.verses!) {
          if (ayat.meta?.juz == juz) {
            penampungAyat.add({
              "surah": data,
              "ayat": ayat,
            });
          } else {
            allJuz.add({
              "juz": juz,
              "start": penampungAyat[0],
              "end": penampungAyat[penampungAyat.length - 1],
              "verse": penampungAyat,
            });
            juz++;
            penampungAyat = [];
            penampungAyat.add({
              "surah": data,
              "ayat": ayat,
            });
          }
        }
      }
    }
    allJuz.add({
      "juz": juz,
      "start": penampungAyat[0],
      "end": penampungAyat[penampungAyat.length - 1],
      "verse": penampungAyat,
    });

    return allJuz;
  }
}
