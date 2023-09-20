// ignore_for_file: unnecessary_statements

import 'package:flutter/cupertino.dart';

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
    this.onChangedPage, 
    required this.model, 
  });

  final List<dynamic>? list;
  final Widget? widget;
  final Function()? onChanged;
  final Function(int page)? onChangedPage;
  final Function(dynamic) model;
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
    if(widget.list!.isNotEmpty && widget.list != null){
      listData = widget.list!;
      widget.list!=[];
    }
    pageLoadMore= widget.page!;
    scrollController.addListener(scrollListener);
  }

  Future<void> loadMoreData() async {
    pageLoadMore += 1;

    widget.onChangedPage!(pageLoadMore);
    listData = [...listData, ...widget.list!];
 
    setState(() {});
  }

   dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      Future.delayed(const Duration(seconds: 1), loadMoreData);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 200),
      child: ListView.builder(
        controller: scrollController,
        itemCount: listData.length +1,
        itemBuilder: (context, index) {

          if(index==listData.length && listData.length>4){
            return const CupertinoActivityIndicator();
          }
          widget.model(listData[index]);
          return widget.widget;
        },
      ),
    );
  }
}