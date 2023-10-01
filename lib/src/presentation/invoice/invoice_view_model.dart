import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/invoice_model.dart';
import '../../resource/service/invoice.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class InvoiceViewModel extends BaseViewModel {
  InvoiceApi invoiceApi = InvoiceApi();

  List colors = [
    AppColors.COLOR_TEAL,
    AppColors.COLOR_OLIVE,
    AppColors.COLOR_MAROON,
    AppColors.COLOR_GREEN_LIST,
    AppColors.COLOR_PURPLE,
    AppColors.PRIMARY_PINK,
  ];

  List<InvoiceModel> listInvoice=[];
  List<InvoiceModel> listFoundInvoice=[];
  List<InvoiceModel> listCurrent=[];


  ScrollController scrollController = ScrollController();

  bool isLoading = true;
  bool loadingMore=false;

  int page=1;
   
  Future<void> init() async{
    page=1;
    await getInvoice(page);
    scrollController.addListener(scrollListener);
    listCurrent=listInvoice;
    listFoundInvoice=listInvoice;
  }

  Future<void> pullRefresh() async {
    await init();
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    page+=1;
    await getInvoice(page);
    listCurrent = [...listCurrent, ...listInvoice];
    listFoundInvoice=listCurrent;
    loadingMore = false;
    notifyListeners();
  }

  dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      loadingMore = true;
      Future.delayed(const Duration(seconds: 2), loadMoreData);
 
      notifyListeners();
    }
  }

  Future<void> filterCategory(String searchCategory) async {
    var listSearchCategory = <InvoiceModel>[];
    listSearchCategory = listInvoice.where(
      (element) => element.code!.toLowerCase().contains(searchCategory) 
      || element.myBooking!.myCustomer!.fullName!.toLowerCase()
        .contains(searchCategory),)
    .toList();
    listFoundInvoice=listSearchCategory;
    notifyListeners();
  }

  Future<void> onSearchCategory(String value) async{
    if(value.isEmpty){
      listFoundInvoice = listInvoice;  
    }else{
      final searchCategory = value.toLowerCase();
      await filterCategory(searchCategory);
    }
    notifyListeners();
  }

  Future<void> getInvoice(int page) async {
    final result = await invoiceApi.getInvoice(
      InvoiceParams(
        page: page,
      ),
    );

    final value = switch (result) {
      Success(value: final isBool) => isBool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      listInvoice = value as List<InvoiceModel>;
    }
    isLoading = false;
    notifyListeners();
  }
}
