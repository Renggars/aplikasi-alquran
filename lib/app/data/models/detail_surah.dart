// To parse this JSON data, do
//
//     final detailSurah = detailSurahFromJson(jsonString);

import 'dart:convert';

DetailSurah detailSurahFromJson(String str) =>
    DetailSurah.fromJson(json.decode(str));

String detailSurahToJson(DetailSurah data) => json.encode(data.toJson());

class DetailSurah {
  int? number;
  int? sequence;
  int? numberOfVerses;
  Name? name;
  Revelation? revelation;
  DetailSurahTafsir? tafsir;
  PreBismillah? preBismillah;
  List<Verse>? verses;

  DetailSurah({
    this.number,
    this.sequence,
    this.numberOfVerses,
    this.name,
    this.revelation,
    this.tafsir,
    this.preBismillah,
    this.verses,
  });

  factory DetailSurah.fromJson(Map<String, dynamic>? json) => DetailSurah(
        number: json?["number"],
        sequence: json?["sequence"],
        numberOfVerses: json?["numberOfVerses"],
        name: Name.fromJson(json?["name"]),
        revelation: Revelation.fromJson(json?["revelation"]),
        tafsir: DetailSurahTafsir.fromJson(json?["tafsir"]),
        preBismillah: PreBismillah.fromJson(json?["preBismillah"]),
        verses: json?["verses"] == null
            ? null
            : List<Verse>.from(json!["verses"].map((x) => Verse.fromJson(x))),
      );

  Map<String, dynamic>? toJson() => {
        "number": number,
        "sequence": sequence,
        "numberOfVerses": numberOfVerses,
        "name": name?.toJson(),
        "revelation": revelation?.toJson(),
        "tafsir": tafsir?.toJson(),
        "preBismillah": preBismillah?.toJson(),
        "verses": verses == null
            ? null
            : List<dynamic>.from(verses!.map((x) => x.toJson())),
      };
}

class Name {
  String? short;
  String? long;
  Translation? transliteration;
  Translation? translation;

  Name({
    this.short,
    this.long,
    this.transliteration,
    this.translation,
  });

  factory Name.fromJson(Map<String, dynamic>? json) => Name(
        short: json?["short"],
        long: json?["long"],
        transliteration: Translation.fromJson(json?["transliteration"]),
        translation: Translation.fromJson(json?["translation"]),
      );

  Map<String, dynamic>? toJson() => {
        "short": short,
        "long": long,
        "transliteration": transliteration?.toJson(),
        "translation": translation?.toJson(),
      };
}

class Translation {
  String? en;
  String? id;

  Translation({
    this.en,
    this.id,
  });

  factory Translation.fromJson(Map<String, dynamic>? json) => Translation(
        en: json?["en"],
        id: json?["id"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "id": id,
      };
}

class PreBismillah {
  Text? text;
  Translation? translation;
  Audio? audio;

  PreBismillah({
    this.text,
    this.translation,
    this.audio,
  });

  factory PreBismillah.fromJson(Map<String, dynamic>? json) => PreBismillah(
        text: Text.fromJson(json?["text"]),
        translation: Translation.fromJson(json?["translation"]),
        audio: Audio.fromJson(json?["audio"]),
      );

  Map<String, dynamic>? toJson() => {
        "text": text?.toJson(),
        "translation": translation?.toJson(),
        "audio": audio?.toJson(),
      };
}

class Audio {
  String? primary;
  List<String>? secondary;

  Audio({
    this.primary,
    this.secondary,
  });

  factory Audio.fromJson(Map<String, dynamic>? json) => Audio(
        primary: json?["primary"],
        secondary: json?["secondary"] == null
            ? null
            : List<String>.from(json!["secondary"].map((x) => x)),
      );

  Map<String, dynamic>? toJson() => {
        "primary": primary,
        "secondary": secondary == null
            ? null
            : List<dynamic>.from(secondary!.map((x) => x)),
      };
}

class Text {
  String? arab;
  Transliteration? transliteration;

  Text({
    this.arab,
    this.transliteration,
  });

  factory Text.fromJson(Map<String, dynamic>? json) => Text(
        arab: json?["arab"],
        transliteration: Transliteration.fromJson(json?["transliteration"]),
      );

  Map<String, dynamic>? toJson() => {
        "arab": arab,
        "transliteration": transliteration?.toJson(),
      };
}

class Transliteration {
  String? en;

  Transliteration({
    this.en,
  });

  factory Transliteration.fromJson(Map<String, dynamic>? json) =>
      Transliteration(
        en: json?["en"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
      };
}

class Revelation {
  String? arab;
  String? en;
  String? id;

  Revelation({
    this.arab,
    this.en,
    this.id,
  });

  factory Revelation.fromJson(Map<String, dynamic>? json) => Revelation(
        arab: json?["arab"],
        en: json?["en"],
        id: json?["id"],
      );

  Map<String, dynamic> toJson() => {
        "arab": arab,
        "en": en,
        "id": id,
      };
}

class DetailSurahTafsir {
  String? id;

  DetailSurahTafsir({
    this.id,
  });

  factory DetailSurahTafsir.fromJson(Map<String, dynamic>? json) =>
      DetailSurahTafsir(
        id: json?["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class Verse {
  Number? number;
  Meta? meta;
  Text? text;
  Translation? translation;
  Audio? audio;
  VerseTafsir? tafsir;
  String kondisiAudio;

  Verse({
    this.number,
    this.meta,
    this.text,
    this.translation,
    this.audio,
    this.tafsir,
    this.kondisiAudio = "stop",
  });

  factory Verse.fromJson(Map<String, dynamic>? json) => Verse(
        number: Number.fromJson(json?["number"]),
        meta: Meta.fromJson(json?["meta"]),
        text: Text.fromJson(json?["text"]),
        translation: Translation.fromJson(json?["translation"]),
        audio: Audio.fromJson(json?["audio"]),
        tafsir: VerseTafsir.fromJson(json?["tafsir"]),
      );

  Map<String, dynamic>? toJson() => {
        "number": number?.toJson(),
        "meta": meta?.toJson(),
        "text": text?.toJson(),
        "translation": translation?.toJson(),
        "audio": audio?.toJson(),
        "tafsir": tafsir?.toJson(),
        "kondisiAudio": kondisiAudio
      };
}

class Meta {
  int? juz;
  int? page;
  int? manzil;
  int? ruku;
  int? hizbQuarter;
  Sajda? sajda;

  Meta({
    this.juz,
    this.page,
    this.manzil,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });

  factory Meta.fromJson(Map<String, dynamic>? json) => Meta(
        juz: json?["juz"],
        page: json?["page"],
        manzil: json?["manzil"],
        ruku: json?["ruku"],
        hizbQuarter: json?["hizbQuarter"],
        sajda: Sajda.fromJson(json?["sajda"]),
      );

  Map<String, dynamic>? toJson() => {
        "juz": juz,
        "page": page,
        "manzil": manzil,
        "ruku": ruku,
        "hizbQuarter": hizbQuarter,
        "sajda": sajda?.toJson(),
      };
}

class Sajda {
  bool? recommended;
  bool? obligatory;

  Sajda({
    this.recommended,
    this.obligatory,
  });

  factory Sajda.fromJson(Map<String, dynamic>? json) => Sajda(
        recommended: json?["recommended"],
        obligatory: json?["obligatory"],
      );

  Map<String, dynamic> toJson() => {
        "recommended": recommended,
        "obligatory": obligatory,
      };
}

class Number {
  int? inQuran;
  int? inSurah;

  Number({
    this.inQuran,
    this.inSurah,
  });

  factory Number.fromJson(Map<String, dynamic>? json) => Number(
        inQuran: json?["inQuran"],
        inSurah: json?["inSurah"],
      );

  Map<String, dynamic> toJson() => {
        "inQuran": inQuran,
        "inSurah": inSurah,
      };
}

class VerseTafsir {
  Id? id;

  VerseTafsir({
    this.id,
  });

  factory VerseTafsir.fromJson(Map<String, dynamic>? json) => VerseTafsir(
        id: Id.fromJson(json?["id"]),
      );

  Map<String, dynamic>? toJson() => {
        "id": id?.toJson(),
      };
}

class Id {
  String? short;
  String? long;

  Id({
    this.short,
    this.long,
  });

  factory Id.fromJson(Map<String, dynamic>? json) => Id(
        short: json?["short"],
        long: json?["long"],
      );

  Map<String, dynamic> toJson() => {
        "short": short,
        "long": long,
      };
}
