import 'dart:async';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../utils/utils.dart';
import '../routers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  Timer _startDelay() => _timer = Timer(const Duration(seconds: 2), _init);

  Future<void> _goToSignIn(BuildContext context) =>
      Navigator.pushReplacementNamed(context, Routers.signIn);

  Future<void> _goToHome(BuildContext context) =>
      Navigator.pushReplacementNamed(context, Routers.navigation);

  Future<void> _init() async {
    // await AppPref.logout();
    // await HttpRemote.init();
    final token = await AppPref.getToken();
    if (token == null || token.isEmpty) {
      await _goToSignIn(context);
    } else {
      await _goToHome(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget buildDecoratedContainer() {
    return DecoratedContainer(
      widget: Center(
        child:
         Paragraph(
          content: AppValues.appName,
          style: STYLE_BIG.copyWith(
            color: AppColors.COLOR_WHITE,
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildDecoratedContainer());
  }
}
