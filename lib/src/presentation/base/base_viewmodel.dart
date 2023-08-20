
import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {

  BuildContext? _context;
  BuildContext get context => _context!;

  dynamic setContext(BuildContext value) => _context = value;
}
