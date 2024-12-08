import 'dart:convert';

import 'package:aplikasi_alquran/app/data/db/bookmark.dart';
import 'package:aplikasi_alquran/app/data/models/detail_surah.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:aplikasi_alquran/app/data/models/surah.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  List<Map<String, dynamic>> allJuz = [];

  RxBool isDarkMode = false.obs;
  RxBool adaDataAllJuz = false.obs;

  DatabaseManager database = DatabaseManager.instance;

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead =
        await db.query("bookmark", where: "last_read = 1");
    if (dataLastRead.isEmpty) {
      // tidak ada data last read
      return null;
    } else {
      // ada data => ambil index ke 0 (karena cuma ada 1 data di dalam list)
      return dataLastRead.first;
    }
  }

  void deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");

    update();
    Get.back(); // tutup dialog
    Get.snackbar("Berhasil", "Telah berhasil meghapus bookmark");
  }

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmark = await db.query(
      "bookmark",
      where: "last_read = 0",
      orderBy: "juz, via, surah, ayat",
    );
    return allBookmark;
  }

  void changeTheme() async {
    Get.isDarkMode
        ? Get.changeTheme(ThemeData.light())
        : Get.changeTheme(ThemeData.dark());
    isDarkMode.toggle();

    final box = GetStorage();

    if (Get.isDarkMode) {
      // dark -> light
      box.remove("themeDark");
    } else {
      // light -> dark
      box.write('themeDark', true);
    }
  }

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

    for (var i = 1; i <= 114; i++) {
      var res =
          await http.get(Uri.parse('https://api.quran.gading.dev/surah/$i'));
      if (res.statusCode != 200) {
        print("Error: Failed to fetch surah $i");
        continue;
      }

      Map<String, dynamic>? rawData = json.decode(res.body)['data'];
      if (rawData == null) {
        print("Error: Data for surah $i is null");
        continue;
      }

      DetailSurah data = DetailSurah.fromJson(rawData);

      if (data.verses == null || data.verses!.isEmpty) {
        print("Error: No verses found for surah $i");
        continue;
      }

      for (var ayat in data.verses!) {
        if (ayat.meta?.juz == null) {
          print("Error: Juz is null for ayat ${ayat.number?.inSurah}");
          continue;
        }

        if (ayat.meta!.juz == juz) {
          penampungAyat.add({
            "surah": data,
            "ayat": ayat,
          });
        } else {
          if (penampungAyat.isNotEmpty) {
            allJuz.add({
              "juz": juz,
              "start": penampungAyat[0],
              "end": penampungAyat[penampungAyat.length - 1],
              "verse": penampungAyat,
            });
          }
          juz++;
          penampungAyat = [];
          penampungAyat.add({
            "surah": data,
            "ayat": ayat,
          });
        }
      }
    }

    if (penampungAyat.isNotEmpty) {
      allJuz.add({
        "juz": juz,
        "start": penampungAyat[0],
        "end": penampungAyat[penampungAyat.length - 1],
        "verse": penampungAyat,
      });
    }

    print("Data successfully processed: ${allJuz.length} juz found");
    return allJuz;
  }
}
