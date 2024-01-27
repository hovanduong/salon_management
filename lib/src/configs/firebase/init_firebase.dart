import 'package:firebase_core/firebase_core.dart';

import '../environment/environment.dart';
import 'firebase_options_product.dart';
import 'firebase_options_staging.dart';

class InitFirebase {
  static bool isCheckProd() {
    const appName = EnvironmentConfig.appName;
    const result = appName == 'ApCare';
    return result;
  }

  static Future<void> initializeApp() async { 
    final isProd = isCheckProd();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptionsStaging.currentPlatform,
        // options: isProd
        //     ? DefaultFirebaseOptionsProduct.currentPlatform
        //     : DefaultFirebaseOptionsStaging.currentPlatform,
        );
  }
}
