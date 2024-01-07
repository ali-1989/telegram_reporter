import 'package:telegram_reporter/reporter.dart';

void main() {
  sendReport();
}


void sendReport() {
  TelegramReporter(
    botToken: '195211143...',
    targetChat: '14888... or @user_name',
    reportHeader: 'Report sent from ${TelItalics('Demo App')}.',
    reportSubHeader:
        '${TelSpoiler('${TelUnderline('Flutter-Demo')}')}', // optional
    reportMessage: '${TelCode('Custom.message')}',
    extraInfo: 'Footer...', // optional
    onSuccess: () {
      print('tele ==== done!!!!');
    },
    onFailure: (msg) {
      print('tele ==== $msg');
    },
  ).report();
}
