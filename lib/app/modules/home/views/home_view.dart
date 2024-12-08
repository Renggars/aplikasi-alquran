// import 'package:aplikasi_alquran/app/data/models/surah.dart';
import 'package:aplikasi_alquran/app/constant/color.dart';
import 'package:aplikasi_alquran/app/data/models/surah.dart';
import 'package:aplikasi_alquran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:aplikasi_alquran/app/data/models/detail_surah.dart' as detail;

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDarkMode.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al Quran App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.SEARCHING),
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamualaiikum",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GetBuilder<HomeController>(builder: (c) {
                return FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [
                            appLightPurple1,
                            appDarkPurple,
                          ]),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: -50,
                              right: 0,
                              child: Opacity(
                                opacity: 0.8,
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image.asset(
                                    "assets/images/alquran.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.menu_book_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Terakhir dibaca",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Loading...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    Map<String, dynamic>? lastRead = snapshot.data;

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(colors: [
                          appLightPurple1,
                          appDarkPurple,
                        ]),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        child: InkWell(
                          onLongPress: () => {
                            if (lastRead != null)
                              {
                                Get.defaultDialog(
                                  title: "Delete Last Read",
                                  middleText:
                                      "Yakin ingin menghapus last read bookmark?",
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () => Get.back(),
                                      child: Text("CANCEL"),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          c.deleteBookmark(lastRead["id"]);
                                        },
                                        child: Text("DELETE"))
                                  ],
                                )
                              }
                          },
                          onTap: () {
                            if (lastRead != null) {
                              // bisa di arahkan ke page detail surah / juz
                              switch (lastRead["via"]) {
                                case "juz":
                                  Map<String, dynamic> dataMapPerJuz =
                                      controller.allJuz[lastRead["juz"] - 1];
                                  Get.toNamed(
                                    Routes.DETAIL_JUZ,
                                    arguments: {
                                      "juz": dataMapPerJuz,
                                      "bookmark": lastRead,
                                    },
                                  );
                                  break;
                                default:
                                  Get.toNamed(
                                    Routes.DETAIL_SURAH,
                                    arguments: {
                                      "name": lastRead["surah"]
                                          .toString()
                                          .replaceAll("+", "'"),
                                      "number": lastRead["number_surah"],
                                      "bookmark": lastRead,
                                    },
                                  );
                                  break;
                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -50,
                                right: 0,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Image.asset(
                                      "assets/images/alquran.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book_rounded,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Terakhir dibaca",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      lastRead == null
                                          ? ""
                                          : lastRead["surah"]
                                              .toString()
                                              .replaceAll("+", "'"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      lastRead == null
                                          ? "Belum ada data"
                                          : "Juz ${lastRead["juz"]} | Ayat ${lastRead["ayat"]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
              TabBar(
                indicatorColor: appPurple,
                labelColor: appPurple,
                tabs: [
                  Tab(
                    text: "Surah",
                  ),
                  Tab(
                    text: "Juz",
                  ),
                  Tab(
                    text: "Bookmark",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Surah
                    FutureBuilder<List<Surah>>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Tidak ada data"),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Surah surah = snapshot.data![index];
                              return ListTile(
                                onTap: () => Get.toNamed(
                                  Routes.DETAIL_JUZ,
                                  arguments: {
                                    "name": surah.name!.transliteration!.id,
                                    "number": surah.number!,
                                  },
                                ),
                                leading: Container(
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
                                      "${surah.number}",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${surah.name?.transliteration?.id}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Text(
                                  "${surah.numberOfVerses} Ayat | ${surah.revelation?.id}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: Text(
                                  "${surah.name?.short}",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    // Juz
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: controller.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          controller.adaDataAllJuz.value = false;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.isEmpty ||
                            snapshot.data == null) {
                          return const Center(
                            child: Text("Tidak ada data"),
                          );
                        }

                        controller.adaDataAllJuz.value = true;
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> dataMapPerJuz =
                                snapshot.data![index];
                            return ListTile(
                              onTap: () => Get.toNamed(
                                Routes.DETAIL_JUZ,
                                arguments: {"juz": dataMapPerJuz},
                              ),
                              leading: Container(
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
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                              title: Text(
                                "Juz ${index + 1}",
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                children: [
                                  Text(
                                    "Mulai dari ${(dataMapPerJuz["start"]["surah"] as detail.DetailSurah).name?.transliteration?.id} ayat ${(dataMapPerJuz["start"]["ayat"] as detail.Verse).number?.inSurah}",
                                  ),
                                  Text(
                                    "Mulai dari ${(dataMapPerJuz["end"]["surah"] as detail.DetailSurah).name?.transliteration?.id} ayat ${(dataMapPerJuz["start"]["ayat"] as detail.Verse).number?.inSurah}",
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // Bookmark
                    GetBuilder<HomeController>(builder: (c) {
                      if (c.adaDataAllJuz.isFalse) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text("Sedang memuat data juz..."),
                            ],
                          ),
                        );
                      }

                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: c.getBookmark(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.data!.isEmpty) {
                            return Center(
                              child: Text("Belum ada bookmark"),
                            );
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> dataBookmark =
                                  snapshot.data![index];
                              return ListTile(
                                onTap: () {
                                  switch (dataBookmark["via"]) {
                                    case "juz":
                                      Map<String, dynamic> dataMapPerJuz =
                                          controller
                                              .allJuz[dataBookmark["juz"] - 1];
                                      Get.toNamed(
                                        Routes.DETAIL_JUZ,
                                        arguments: {
                                          "juz": dataMapPerJuz,
                                          "bookmark": dataBookmark,
                                        },
                                      );
                                      break;
                                    default:
                                      Get.toNamed(
                                        Routes.DETAIL_SURAH,
                                        arguments: {
                                          "name": dataBookmark["surah"]
                                              .toString()
                                              .replaceAll("+", "'"),
                                          "number":
                                              dataBookmark["number_surah"],
                                          "bookmark": dataBookmark,
                                        },
                                      );
                                      break;
                                  }
                                },
                                leading: Container(
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  dataBookmark["surah"]
                                      .toString()
                                      .replaceAll("+", "'"),
                                ),
                                subtitle: Text(
                                    "Ayat ${dataBookmark["ayat"]} via ${dataBookmark["via"]}"),
                                trailing: IconButton(
                                  onPressed: () {
                                    c.deleteBookmark(dataBookmark["id"]);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.changeTheme(),
        child: Obx(
          () => Icon(
            Icons.add,
            color: controller.isDarkMode.isTrue ? appWhite : appPurple,
          ),
        ),
      ),
    );
  }
}
