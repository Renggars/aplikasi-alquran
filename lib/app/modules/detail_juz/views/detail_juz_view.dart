import 'package:aplikasi_alquran/app/constant/color.dart';
import 'package:aplikasi_alquran/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:aplikasi_alquran/app/data/models/detail_surah.dart' as detail;
import 'package:scroll_to_index/scroll_to_index.dart';
import '../controllers/detail_juz_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class DetailJuzView extends GetView<DetailJuzController> {
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;

  final Map<String, dynamic>? dataMapPerJuz = Get.arguments["juz"];

  @override
  Widget build(BuildContext context) {
    if (dataMapPerJuz == null || dataMapPerJuz!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Detail Juz")),
        body: Center(child: Text("Data tidak ditemukan.")),
      );
    }

    if (Get.arguments["bookmark"] != null) {
      bookmark = Get.arguments["bookmark"];
      if (bookmark!["index_ayat"] > 0) {
        controller.scrollC.scrollToIndex(
          bookmark!["index_ayat"],
          preferPosition: AutoScrollPosition.begin,
        );
      }
    }

    List<Widget> allAyat =
        List.generate((dataMapPerJuz?["verses"] as List).length, (index) {
      Map<String, dynamic> ayat = dataMapPerJuz?["verses"][index];

      detail.DetailSurah surah = ayat["surah"];
      detail.Verse verse = ayat["ayat"] as detail.Verse;

      return AutoScrollTag(
        key: ValueKey(index),
        index: index,
        controller: controller.scrollC,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (verse.number?.inSurah == 1)
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
                                "${verse.number?.inSurah}",
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
                      GetBuilder<DetailJuzController>(
                        builder: (c) => Row(children: [
                          IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  title: "Bookmark",
                                  middleText: "Pilih jenis Bookmark",
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await c.addBookmark(
                                          true,
                                          surah,
                                          verse,
                                          index,
                                        );
                                        homeC.update();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: appPurple),
                                      child: Text("LAST READ"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        c.addBookmark(
                                          true,
                                          surah,
                                          verse,
                                          index,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: appPurple),
                                      child: Text("BOOKMARK"),
                                    ),
                                  ]);
                            },
                            icon: Icon(Icons.collections_bookmark_outlined),
                          ),
                          (verse.kondisiAudio == "stop")
                              ? IconButton(
                                  onPressed: () {
                                    c.playAudio(verse);
                                  },
                                  icon: Icon(Icons.play_arrow),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    (verse.kondisiAudio == "playing")
                                        ? IconButton(
                                            onPressed: () {
                                              c.pauseAudio(verse);
                                            },
                                            icon: Icon(Icons.pause),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              c.resumeAudio(verse);
                                            },
                                            icon: Icon(Icons.play_arrow),
                                          ),
                                    IconButton(
                                      onPressed: () {
                                        c.stopAudio(verse);
                                      },
                                      icon: Icon(Icons.stop),
                                    )
                                  ],
                                )
                        ]),
                      )
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
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('JUZ ${dataMapPerJuz?["juz"]}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        controller: controller.scrollC,
        children: [...allAyat],
      ),
    );
  }
}
