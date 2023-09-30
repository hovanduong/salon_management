import '../../configs/app_result/app_result.dart';
import '../../configs/widget/dialog/warnig_network_dialog.dart';
import '../../resource/model/invoice_model.dart';
import '../../resource/service/invoice.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class InvoiceViewModel extends BaseViewModel {

  InvoiceApi invoiceApi= InvoiceApi();

  List<InvoiceModel> listInvoice=[];

  int page =1;

  bool isLoading=true;
   
  Future<void> init() async{
    await getInvoice(page);
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
      showDialogNetwork(context);
    } else if (value is Exception) {
      // showErrorDialog(context);
    } else {
      isLoading=false;
      listInvoice = value as List<InvoiceModel>;
    }
    notifyListeners();
  }
}
