import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../resource/model/user_model.dart';
import 'app/splash.dart';
import 'booking/booking_screen.dart';
import 'booking_details/booking_details.dart';
import 'bottom_navigation_bar/navigation_screen.dart';
import 'calendar/calendar.dart';
import 'category/category_screen.dart';
import 'category_add/category_add.dart';
import 'change_password/change_password.dart';
import 'debit/debit_screen.dart';
import 'debt/debt.dart';
import 'debt_add/debt__add_screen.dart';
import 'debt_detail/debt_detail.dart';
import 'debtor/debtor.dart';
import 'home/home.dart';
import 'invoice/invoice_screen.dart';
import 'my_customer/my_customer.dart';
import 'my_customer_add/my_customer_add_screen.dart';
import 'my_customer_edit/my_customer_edit_screen.dart';
import 'note/note_screen.dart';
import 'note_add/note_add.dart';
import 'note_detail/note_detail.dart';
import 'notification/notification.dart';
import 'payment/payment.dart';
import 'payment_bill/bill_payment_screen.dart';
import 'profile_account/profile_account.dart';
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
  static const String changePassword = '/changePassword';
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
  static const String debit = '/debit';
  static const String debt = '/debt';
  static const String notification = '/notification';
  static const String debtAdd = '/debtAdd';
  static const String payment = '/payment';
  static const String bill = '/bill';
  static const String profileAccount = '/profileAccount';
  static const String calendar = '/calendar';
  static const String debtDetail = '/debtDetail';
  static const String debtor = '/debtor';
  static const String noteScreen = '/noteScreen';
  static const String noteAddScreen = '/noteAddScreen';
  static const String noteDetailScreen = '/noteDetailScreen';
  static const String homeScreen = '/homeScreen';


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
      
      case homeScreen:
        return animRoute(
          const HomeScreen(),
          beginOffset: right,
          name: homeScreen,
          arguments: arguments,
        );

      case noteDetailScreen:
        return animRoute(
          const NoteDetailScreen(),
          beginOffset: right,
          name: noteDetailScreen,
          arguments: arguments,
        );

      case noteAddScreen:
        return animRoute(
          const NoteAddScreen(),
          beginOffset: right,
          name: noteAddScreen,
          arguments: arguments,
        );

      case noteScreen:
        return animRoute(
          const NoteScreen(),
          beginOffset: right,
          name: noteScreen,
          arguments: arguments,
        );

      case debtor:
        return animRoute(
          const DebtorScreen(),
          beginOffset: right,
          name: debtor,
          arguments: arguments,
        );
      
      case debtDetail:
        return animRoute(
          const DebtDetailsScreen(),
          beginOffset: right,
          name: debtDetail,
          arguments: arguments,
        );

      case calendar:
        return animRoute(
          const CalendarScreen(),
          beginOffset: right,
          name: calendar,
          arguments: arguments,
        );

      case profileAccount:
        return animRoute(
          const ProfileAccountScreen(),
          beginOffset: right,
          name: profileAccount,
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

      case debt:
        return animRoute(
          const DebtScreen(),
          beginOffset: right,
          name: debt,
          arguments: arguments,
        );

      case debtAdd:
        return animRoute(
          const DebtAddScreen(),
          beginOffset: right,
          name: debtAdd,
          arguments: arguments,
        );
      
      case notification:
        return animRoute(
          const NotificationScreen(),
          beginOffset: right,
          name: notification,
          arguments: arguments,
        );
      
      case debit:
        return animRoute(
          const DebitScreen(),
          beginOffset: right,
          name: debit,
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

      case changePassword:
        return animRoute(
          const ChangePasswordScreen(),
          beginOffset: right,
          name: changePassword,
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
      pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
        builder: Builder(builder: (context) => page,),),
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
