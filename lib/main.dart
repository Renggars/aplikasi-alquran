import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:aplikasi_alquran/app/constant/color.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: box.read('themeDark') == null ? appLight : appDark,
      title: "Application",
      // initialRoute: Routes.INTRODUCTION,
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    ),
  );
}
