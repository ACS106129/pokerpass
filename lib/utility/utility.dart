import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:pokerpass/setting/setting.dart';

class Utility {
  /// [mainScale] must greater than 0, less than 1
  static void loading(final Duration duration, final BuildContext context,
      {final double mainScale = 0.6}) {
    if (mainScale > 1 || mainScale < 0)
      throw ArgumentError('mainScale:$mainScale error!');
    final subScaleDuration = Duration(
        milliseconds: (duration.inMilliseconds * (1 - mainScale) / 2).round());
    BotToast.showLoading(
      crossPage: false,
      animationDuration: subScaleDuration,
      animationReverseDuration: subScaleDuration,
      backButtonBehavior: BackButtonBehavior.none,
      backgroundColor:
          CupertinoDynamicColor.resolve(Setting.loadingColor, context),
      duration:
          Duration(milliseconds: (duration.inMilliseconds * mainScale).round()),
    );
  }

  static String base64Encode(final String str) {
    return base64.encode(utf8.encode(str));
  }

  static String base64Decode(final String str) {
    return utf8.decode(base64.decode(str));
  }
}
