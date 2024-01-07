import 'package:http/http.dart';

Future<bool> canConnectToTelegram() async {
  try {
    Response response = await get(Uri.parse('https://telegram.org/'));
    return response.statusCode == 200;
  }
  catch (e) {
    return false;
  }
}
///=============================================================================
class TelBold {
  final String text;

  TelBold(this.text);

  @override
  String toString() {
    return '<b>$text</b>';
  }
}
///=============================================================================
class TelItalics {
  final String text;

  TelItalics(this.text);

  @override
  String toString() {
    return '<i>$text</i>';
  }
}
///=============================================================================
class TelStrikeThrough {
  final String text;

  TelStrikeThrough(this.text);

  @override
  String toString() {
    return '<s>$text</s>';
  }
}
///=============================================================================
class TelSpoiler {
  final String text;

  TelSpoiler(this.text);

  @override
  String toString() {
    return '<tg-spoiler>$text</tg-spoiler>';
  }
}
///=============================================================================
class TelUnderline {
  final String text;

  TelUnderline(this.text);

  @override
  String toString() {
    return '<u>$text</u>';
  }
}
///=============================================================================
class TelCode {
  final String text;
  final String lang;

  TelCode(this.text, {this.lang = ''});

  @override
  String toString() {
    return lang.isNotEmpty
        ? '<pre language="$lang">$text</pre>'
        : '<code>$text</code>';
  }
}
