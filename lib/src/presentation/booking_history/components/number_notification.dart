// ignore_for_file: avoid_dynamic_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class NumberNotification extends StatelessWidget {
  const NumberNotification({
    super.key, 
    this.id,
  });

  final String? id;

  @override
  Widget build(BuildContext context) {
    final users = FirebaseFirestore.instance.collection('Notification').doc(id);
    return StreamBuilder<DocumentSnapshot>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
         if (snapshot.hasError) {
          return const SizedBox();
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox();
        } else {
          final data = (snapshot.data!.data()??{}) as Map<String, dynamic>;
          return data['count']!=0? CircleAvatar(
            maxRadius: 8,
            backgroundColor: AppColors.Red_Money,
            child: Paragraph(
              content: data['count']>99? '99+':
               data['count'].toString(),
              color: AppColors.COLOR_WHITE,
            ),
          ): const SizedBox();
        }
      },
    );
  }
}
