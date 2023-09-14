import 'package:flutter/material.dart';

import '../resource/model/user_model.dart';
import 'app/splash.dart';
import 'bottom_navigation_bar/navigation_screen.dart';
import 'create_password/create_password.dart';
import 'service_add/add_service.dart';
import 'service_add/add_service_screen.dart';
import 'service_details/service_details_screen.dart';
import 'service_edit/edit_service_screen.dart';
import 'service_list/service_list_screen.dart';
import 'sign_in/sign_in.dart';
import 'sign_up/sign_up_screen.dart';
import 'update_profile/update_profile.dart';
import 'verification_code/verification_code_screen.dart';

class TemplateArguments {
  TemplateArguments(this.data, this.created);
  final dynamic data;
  final String created;
}

class RegisterArguments {
  RegisterArguments({
    this.pass,
    this.verificationId,
    this.userModel,
  });
  final String? pass;
  final String? verificationId;
  final UserModel? userModel;
}

class Routers {
  static const String getStarted = '/getStarted';
  static const String home = '/home';
  static const String homeDetails = '/homeDetails';
  static const String verification = '/verification';
  static const String updateProfile = '/updateProfile';
  static const String createPassword = '/createPassword';
  static const String signIn = '/signIn';
  static const String addService = '/addService';
  static const String serviceList = '/serviceList';
  static const String serviceDetails = '/serviceDetails';
  static const String editService = '/editService';
  static const String signUp = '/signUp';
  static const String navigation = '/navigation';
  

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case getStarted:
        return animRoute(
          const SplashScreen(),
          beginOffset: right,
          name: getStarted,
          arguments: arguments,
        );

      case navigation:
        return animRoute(
          const NavigateScreen(),
          beginOffset: right,
          name: verification,
          arguments: arguments,
        );

      case verification:
        return animRoute(
          const VerificationScreen(),
          beginOffset: right,
          name: verification,
          arguments: arguments,
        );

      // case home:
      //   return animRoute(
      //     const HomeScreen(),
      //     beginOffset: right,
      //     name: home,
      //     arguments: arguments,
      //   );

      // case homeDetails:
      //   return animRoute(
      //     const HomeDetailScreen(),
      //     beginOffset: right,
      //     name: homeDetails,
      //     arguments: arguments,
      //   );

      case updateProfile:
        return animRoute(
          const UpdateProfileSreen(),
          beginOffset: right,
          name: updateProfile,
          arguments: arguments,
        );

      case createPassword:
        return animRoute(
          const CreatePasswordScreen(),
          beginOffset: right,
          name: createPassword,
          arguments: arguments,
        );

      case signIn:
        return animRoute(
          const SignInScreen(),
          beginOffset: right,
          name: signIn,
          arguments: arguments,
        );

      case addService:
        return animRoute(
          const ServiceAddScreen(),
          beginOffset: right,
          name: addService,
          arguments: arguments,
        );

      case editService:
        return animRoute(
          const EditServiceScreen(),
          beginOffset: right,
          name: editService,
          arguments: arguments,
        );
      case serviceList:
        return animRoute(
          const ServiceListScreen(),
          beginOffset: right,
          name: serviceList,
          arguments: arguments,
        );
      case serviceDetails:
        return animRoute(
          const ServiceDetailsScreen(),
          beginOffset: right,
          name: serviceDetails,
          arguments: arguments,
        );

      case signUp:
        return animRoute(
          const SignUpScreen(),
          beginOffset: right,
          name: signUp,
          arguments: arguments,
        );

      // case profileMember:
      //   return animRoute(const ProfileMemberScreen(),
      //       beginOffset: right, name: profileMember, arguments: arguments);

      default:
        return animRoute(
          Center(
            child: Text('No route defined for ${settings.name}'),
          ),
          name: '/error',
        );
    }
  }

  static Route animRoute(
    Widget page, {
    required String name,
    Offset? beginOffset,
    Object? arguments,
  }) {
    return PageRouteBuilder(
      settings: RouteSettings(name: name, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = beginOffset ?? const Offset(0, 0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Offset center = const Offset(0, 0);
  static Offset top = const Offset(0, 1);
  static Offset bottom = const Offset(0, -1);
  static Offset left = const Offset(-1, 0);
  static Offset right = const Offset(1, 0);
}
