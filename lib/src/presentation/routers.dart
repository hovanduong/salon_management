import 'package:flutter/material.dart';

import '../resource/model/user_model.dart';
import 'app/splash.dart';
import 'bill_payment/bill_payment_screen.dart';
import 'booking/booking_screen.dart';
import 'booking_details/booking_details.dart';
import 'bottom_navigation_bar/navigation_screen.dart';
import 'category/category_screen.dart';
import 'category_add/category_add.dart';
import 'create_password/create_password.dart';
import 'invoice/invoice_screen.dart';
import 'myCustomer_edit/my_customer_edit_screen.dart';
import 'my_customer/my_customer.dart';
import 'my_customer_add/my_customer_add_screen.dart';
import 'payment/payment.dart';
import 'service_add/service_add.dart';
import 'sign_in/sign_in.dart';
import 'sign_up/sign_up_screen.dart';
import 'update_profile/update_profile.dart';

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
  static const String updateService = '/updateService';
  static const String signUp = '/signUp';
  static const String navigation = '/navigation';
  static const String category = '/category';
  static const String addCategory = '/addCategory';
  static const String bookingDetails = '/bookingDetails';
  static const String myCustomer = '/myCustomer';
  static const String myCustomerAdd = '/myCustomerAdd';
  static const String myCustomerEdit = '/myCustomerEdit';
  static const String addBooking = '/addBooking';
  static const String invoice = '/invoice';
  static const String payment = '/payment';
  static const String bill = '/bill';


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
          name: navigation,
          arguments: arguments,
        );

      case bill:
        return animRoute(
          const BillPaymentScreen(),
          beginOffset: right,
          name: bill,
          arguments: arguments,
        );
        
      case payment:
        return animRoute(
          const PaymentScreen(),
          beginOffset: right,
          name: payment,
          arguments: arguments,
        );

      case invoice:
        return animRoute(
          const InvoiceScreen(),
          beginOffset: right,
          name: invoice,
          arguments: arguments,
        );
      
      case addBooking:
        return animRoute(
          const BookingScreen(),
          beginOffset: right,
          name: addBooking,
          arguments: arguments,
        );

      case home:
        return animRoute(
          const NavigateScreen(),
          beginOffset: right,
          name: home,
          arguments: arguments,
        );

      // case homeDetails:
      //   return animRoute(
      //     const HomeDetailScreen(),
      //     beginOffset: right,
      //     name: homeDetails,
      //     arguments: arguments,
      //   );

      case myCustomerEdit:
        return animRoute(
          const MyCustomerEditScreen(),
          beginOffset: right,
          name: myCustomerEdit,
          arguments: arguments,
        );

      case myCustomerAdd:
        return animRoute(
          const MyCustomerAddScreen(),
          beginOffset: right,
          name: myCustomerAdd,
          arguments: arguments,
        );

      case myCustomer:
        return animRoute(
          const MyCustomerScreen(),
          beginOffset: right,
          name: myCustomer,
          arguments: arguments,
        );

      case bookingDetails:
        return animRoute(
          const BookingDetailsScreen(),
          beginOffset: right,
          name: bookingDetails,
          arguments: arguments,
        );

      case addService:
        return animRoute(
          const ServiceAddScreen(),
          beginOffset: right,
          name: addService,
          arguments: arguments,
        );

      case category:
        return animRoute(
          const CategoryScreen(),
          beginOffset: right,
          name: category,
          arguments: arguments,
        );

      case addCategory:
        return animRoute(
          const CategoryAddScreen(),
          beginOffset: right,
          name: addCategory,
          arguments: arguments,
        );

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
