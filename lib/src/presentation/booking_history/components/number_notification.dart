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
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('No data found for the user');
        } else {
          final data = (snapshot.data!.data()??{}) as Map<String, dynamic>;
          return data['count']!=0? CircleAvatar(
            maxRadius: 8,
            backgroundColor: AppColors.Red_Money,
            child: Paragraph(
              content: data['count'].toString(),
              color: AppColors.COLOR_WHITE,
            ),
          ): const SizedBox();
        }
      },
    );
  }
}
