import 'package:aplikasi_alquran/app/data/models/juz.dart' as juz;
import 'package:aplikasi_alquran/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_juz_controller.dart';

// ignore: use_key_in_widget_constructors
class DetailJuzView extends GetView<DetailJuzController> {
  final juz.Juz detailJuz = Get.arguments['juz'];
  final List<Surah> allSurahInThisJuz = Get.arguments['surah'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUZ ${detailJuz.juz}'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: detailJuz.verses!.length,
        itemBuilder: (context, index) {
          // ignore: prefer_is_empty
          if (detailJuz.verses == null || detailJuz.verses?.length == 0) {
            return Center(
              child: Text('Tidak ada data'),
            );
          }
          juz.Verses ayat = detailJuz.verses![index];
          if (index != 0) {
            if (ayat.number?.inSurah == 1) {
              controller.index++;
            }
          }

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
                                "${ayat.number?.inSurah}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          Text(
                            // ignore: unnecessary_string_interpolations
                            "${allSurahInThisJuz[controller.index].name?.transliteration?.id ?? ""}",
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
                  "${ayat.text?.arab}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "{${ayat.text?.transliteration?.en}}",
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 15),
              Text(
                "{${ayat.translation?.id}}",
                textAlign: TextAlign.justify,
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
