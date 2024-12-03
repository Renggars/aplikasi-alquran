import 'package:aplikasi_alquran/app/constant/color.dart';
import 'package:aplikasi_alquran/app/data/models/detail_surah.dart' as detail;
import 'package:aplikasi_alquran/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final Surah surah = Get.arguments;

  DetailSurahView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Surah ${surah.name?.transliteration?.id}"),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
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
            SizedBox(height: 20),
            FutureBuilder<detail.DetailSurah>(
                future: controller.getDetailSurah(surah.number.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("Ada data yang tidak ada"),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.verses?.length ?? 0,
                      itemBuilder: (context, index) {
                        if (snapshot.data!.verses!.isEmpty) {
                          return Center(
                            child: Text("Tidak ada data"),
                          );
                        }
                        detail.Verse ayat = snapshot.data!.verses![index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
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
                                          "${index + 1}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => Row(children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons
                                              .collections_bookmark_outlined),
                                        ),
                                        (controller.kondisiAudio.value ==
                                                "stop")
                                            ? IconButton(
                                                onPressed: () {
                                                  controller.playAudio(
                                                      ayat.audio?.primary);
                                                },
                                                icon: Icon(Icons.play_arrow),
                                              )
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  (controller.kondisiAudio
                                                              .value ==
                                                          "playing")
                                                      ? IconButton(
                                                          onPressed: () {
                                                            controller
                                                                .pauseAudio();
                                                          },
                                                          icon:
                                                              Icon(Icons.pause),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            controller
                                                                .resumeAudio();
                                                          },
                                                          icon: Icon(
                                                              Icons.play_arrow),
                                                        ),
                                                  IconButton(
                                                    onPressed: () {
                                                      controller.stopAudio();
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
                                "${ayat.text?.arab}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${ayat.text?.transliteration?.en}",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "${ayat.translation?.id}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      });
                })
          ],
        ));
  }
}
