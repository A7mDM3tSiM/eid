import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

import 'emirate_id_model.dart';

class EIDScanner {
  static Future<EmirateIdModel?> scanEmirateID({
    required File image,
  }) async {
    List<String> eIdDates = [];
    final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textDetector.processImage(InputImage.fromFilePath(image.path));
    if (!recognizedText.text
            .toString()
            .toLowerCase()
            .contains("resident identity card".toLowerCase()) &&
        !recognizedText.text
            .toString()
            .toLowerCase()
            .contains("UNITED ARAB EMIRATES".toLowerCase())) {
      return null;
    }
    final listText = recognizedText.text.split('\n');

    // attributes
    String? name;
    String? number;
    String? nationality;
    String? sex;

    for (var element in listText) {
      if (_isDate(text: element.trim())) {
        eIdDates.add(element.trim());
      } else if (_isName(text: element.trim()) != null) {
        name = _isName(text: element.trim());
      } else if (_isNationality(text: element.trim()) != null) {
        nationality = _isNationality(text: element.trim());
      } else if (_isSex(text: element.trim()) != null) {
        sex = _isSex(text: element.trim());
      } else if (_isNumberID(text: element.trim())) {
        number = element.trim();
      }
    }
    eIdDates = _sortDateList(dates: eIdDates);

    textDetector.close();

    return EmirateIdModel(
      name: name!,
      number: number!,
      nationality: nationality,
      sex: sex,
      dateOfBirth: eIdDates.length == 3 ? eIdDates[0] : null,
      issueDate: eIdDates.length == 3 ? eIdDates[1] : null,
      expiryDate: eIdDates.length == 3 ? eIdDates[2] : null,
    );
  }

  static Future<bool> validatedEidBackFace({required File image}) async {
    final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textDetector.processImage(InputImage.fromFilePath(image.path));

    String textContent = recognizedText.text.toLowerCase();
    bool containsIssuingPlace = textContent.contains("issuing place");
    bool containsCardNumber = textContent.contains("card number");

    if (!containsIssuingPlace && !containsCardNumber) {
      return false;
    }

    RegExp sevenDigitsOrMore = RegExp(r'(\d{7,})');
    bool containsSevenDigitsOrMore = sevenDigitsOrMore.hasMatch(textContent);
    return containsSevenDigitsOrMore;
  }

  static List<String> _sortDateList({required List<String> dates}) {
    List<DateTime> tempList = [];
    DateFormat format = DateFormat("dd/MM/yyyy");
    for (int i = 0; i < dates.length; i++) {
      tempList.add(format.parse(dates[i]));
    }
    tempList.sort((a, b) => a.compareTo(b));
    dates.clear();
    for (int i = 0; i < tempList.length; i++) {
      dates.add(format.format(tempList[i]));
    }
    return dates;
  }

  /// it will sort the dates
  static bool _isDate({required String text}) {
    RegExp pattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    return pattern.hasMatch(text);
  }

  /// it will get the value of sex
  static String? _isSex({required String text}) {
    // Check if the text starts with 'Sex:'
    if (text.startsWith("Sex:")) {
      // Get the text after 'Sex:' and trim whitespace
      String sex = text.split(":").last.trim();
      // Return 'Male' if the text is 'M', 'Female' if the text is 'F', or null otherwise
      return (sex == 'M' || sex == 'm')
          ? 'Male'
          : (sex == 'F' || sex == 'f')
              ? 'Female'
              : null;
    }
    return null;
  }

  /// it will get the value of name
  static String? _isName({required String text}) {
    // This pattern matches 'Name:' or possible incomplete variations like 'ame:' or 'me:'.
    // It then captures everything after the colon.
    RegExp pattern = RegExp(r'(?:N?ame:)\s*(.*)');
    RegExpMatch? match = pattern.firstMatch(text);
    return match != null ? match.group(1)?.trim() : null;
  }

  /// it will get the value of Nationality
  static String? _isNationality({required String text}) {
    // This pattern looks for 'Nationality' followed by any combination of the characters " ", ":", ".", or ","
    // and then captures the rest of the line.
    RegExp pattern = RegExp(r'Nationality[ :.,]*(.*)');
    RegExpMatch? match = pattern.firstMatch(text);
    return match != null ? match.group(1)?.trim() : null;
  }

  /// it will get the value of Number ID
  static bool _isNumberID({required String text}) {
    RegExp pattern = RegExp(r'^\d{3}-\d{4}-\d{7}-\d{1}$');
    return pattern.hasMatch(text);
  }
}
