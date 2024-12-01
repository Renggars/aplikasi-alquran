import 'package:aplikasi_alquran/app/constant/color.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:aplikasi_alquran/app/data/models/detail_surah.dart' as detail;
import '../controllers/detail_juz_controller.dart';

// ignore: use_key_in_widget_constructors
class DetailJuzView extends GetView<DetailJuzController> {
  final Map<String, dynamic> dataMapPerJuz = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUZ ${dataMapPerJuz["juz"]}'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: (dataMapPerJuz["verses"] as List).length,
        itemBuilder: (context, index) {
          if ((dataMapPerJuz["verses"] as List).isEmpty) {
            return Center(
              child: Text('Tidak ada data'),
            );
          }

          Map<String, dynamic> ayat = dataMapPerJuz["verses"][index];

          detail.DetailSurah surah = ayat["surah"];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if ((ayat["ayat"] as detail.Verse).number?.inSurah == 1)
                GestureDetector(
                  onTap: () => Get.defaultDialog(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    title: "Tafsir ${surah.name?.transliteration?.id}",
                    content: Text("${surah.tafsir?.id}"),
                  ),
                  child: Container(
                    width: Get.width,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [
                        appLightPurple1,
                        appDarkPurple,
                      ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            "${surah.name?.transliteration?.id?.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: appWhite,
                            ),
                          ),
                          Text(
                            "( ${surah.name?.translation?.id?.toUpperCase()} )",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: appWhite,
                            ),
                          ),
                          Text(
                            "${surah.numberOfVerses.toString()} Ayat | ${surah.revelation?.id}",
                            style: TextStyle(
                              fontSize: 16,
                              color: appWhite,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/list.png",
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${(ayat["ayat"] as detail.Verse).number?.inSurah}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          Text(
                            surah.name?.transliteration?.id ?? "",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Row(children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.collections_bookmark_outlined),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.play_arrow),
                        ),
                      ])
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "${(ayat["ayat"] as detail.Verse).text?.arab}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "${(ayat["ayat"] as detail.Verse).text?.transliteration?.en}",
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 15),
              Text(
                "${(ayat["ayat"] as detail.Verse).translation?.id}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
