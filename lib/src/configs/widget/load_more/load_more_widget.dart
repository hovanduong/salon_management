import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../resource/service/auth.dart';
import '../../../resource/service/my_booking.dart';
import '../../configs.dart';

class LoadMoreWidget extends StatefulWidget {
  const LoadMoreWidget({
    super.key, 
    this.list, 
    this.widget, 
    this.onChanged, 
    this.page, 
  });

  final List<dynamic>? list;
  final Widget? widget;
  final Function()? onChanged;
  final int? page;

  @override
  State<LoadMoreWidget> createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {
  ScrollController scrollController = ScrollController();
  MyBookingApi myBookingApi = MyBookingApi();

  List<dynamic> listData=[];
  late int pageLoadMore;

  @override
  void initState() {
    super.initState();
    if(widget.list!.isNotEmpty){
      listData = widget.list!;
    }
    pageLoadMore= widget.page!;
    scrollController.addListener(scrollListener);
  }

  Future<void> loadMoreData() async {
    pageLoadMore += 1;
 
    final result = await myBookingApi.getMyBooking(
      AuthParams(
        page: pageLoadMore,
        pageSize: 10
      )
    );

    final value = switch (result) {
      Success(value: final listMyBooking) => listMyBooking,
      Failure(exception: final exception) => exception,
    };

    if(value is List) {
      if (listData.isNotEmpty) {
        listData = [...listData, ...value];
      }
    }
    setState(() {});
  }

   dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      Future.delayed(const Duration(seconds: 2), loadMoreData);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 200),
      child: ListView.builder(
        controller: scrollController,
        itemCount: listData.length +1 ,
        itemBuilder: (context, index) {
          if(index==listData.length && listData.length>4){
            return const CupertinoActivityIndicator();
          }
          return widget.widget;
        },
      ),
    );
  }
}