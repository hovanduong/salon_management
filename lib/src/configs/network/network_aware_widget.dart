// ignore_for_file: always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'netword_service.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget({
    Key? key,
    required this.onlineChild,
    required this.offlineChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final networkStatus = Provider.of<NetworkStatus>(context);
    if (networkStatus == NetworkStatus.online) {
      return onlineChild;
    } else {
      // _showToastMessage("Offline");
      return offlineChild;
    }
  }

  // void _showToastMessage(String message){
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1
  //   );
  // }
}
