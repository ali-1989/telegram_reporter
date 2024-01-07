import 'dart:convert';
import 'package:http/http.dart';
import 'package:telegram_reporter/src/tools.dart';

typedef VoidFunction = void Function();
typedef FailFunction = void Function(String failMsg);
///=============================================================================
class TelegramReporter {
  final VoidFunction? _onSuccess;
  final FailFunction? _onFailure;
  final int _targetTopic;
  final bool _disableWebPagePreview;

  final String _botToken,
      _chatId,
      _reportMessage,
      _reportHeader,
      _reportSubHeader;

  String? _reportExtraInfo;

  final String _noTokenMsg = 'NO BOT TOKEN PROVIDED!',
      _noChatIdMsg = 'NO TARGET CHAT USERNAME/ID PROVIDED!',
      _malformedUrl = 'MALFORMED URL! CHECK URL AGAIN.',
      _noInternet = 'NO INTERNET CONNECTION!';


  /// used of https://t.me/BotFather to find id for [botToken]
  /// used of https://t.me/raw_data_bot to find yourId for [targetChat]

  TelegramReporter({
    required String botToken,
    required String targetChat,
    int targetTopic = 0,
    required String reportHeader,
    String reportSubHeader = '',
    required String reportMessage,
    String? extraInfo,
    bool disableWebPagePreview = true,
    VoidFunction? onSuccess,
    FailFunction? onFailure,
  })  : _botToken = botToken,
        _chatId = targetChat,
        _targetTopic = targetTopic,
        _reportHeader = reportHeader,
        _reportSubHeader = reportSubHeader,
        _reportMessage = reportMessage,
        _reportExtraInfo = extraInfo,
        _disableWebPagePreview = disableWebPagePreview,
        _onSuccess = onSuccess,
        _onFailure = onFailure;

  void report() async {
    /*bool internet = await isInternetConnected();

    if (!internet) {
      _onFailure(_noInternet);
      return;
    }*/

    if (_chatId.isEmpty) {
      _onFailure?.call(_noChatIdMsg);
      return;
    }

    if (_botToken.isEmpty) {
      _onFailure?.call(_noTokenMsg);
      return;
    }

    try {
      final response = await get(Uri.parse(_prepareUrl()));

      if (response.statusCode == 200) {
        _onSuccess?.call();
      }
      else {
        final res = jsonDecode(response.body);
        _onFailure?.call(
            'FAILED TO SEND! ErrorCode: ${res['error_code']}, ErrorMessage: "${res['description']}".');
      }
    }
    catch (e) {
      _onFailure?.call(_malformedUrl);
    }
  }

  String _prepareUrl() {
    String finalUrl = "https://api.telegram.org/bot$_botToken"
        "/sendMessage?chat_id=$_chatId"
        "&text=${Uri.encodeFull(_prepareReport())}";

    if (_targetTopic > 0) {
      finalUrl += "&message_thread_id=$_targetTopic";
    }

    finalUrl += "&parse_mode=HTML&disable_web_page_preview=$_disableWebPagePreview";

    return finalUrl;
  }

  String _prepareReport() {
    String buffer = '${TelBold(_reportHeader)}\n';

    if (_reportSubHeader.isNotEmpty){
      buffer += '$_reportSubHeader\n';
    }

    buffer += '\n${TelBold('Message:')}\n';
    buffer += '$_reportMessage\n';

    if (_reportExtraInfo != null){
      buffer += "\n${TelBold('Extra Info:')}\n";
      buffer += _reportExtraInfo!;
    }

    return buffer;
  }
}
