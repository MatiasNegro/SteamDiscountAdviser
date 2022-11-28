import 'package:flutter/widgets.dart';

///Custom icon class to insert it in the Dialogs where there is the option to delete something.

class TrashBinIcon {
  TrashBinIcon._();

  static const _kFontFam = 'TrashBinIcon';
  static const String? _kFontPkg = null;

  static const IconData trash =
      IconData(0xf1f8, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
