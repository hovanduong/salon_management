// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/debt_language.dart';
import '../../../resource/model/model.dart';
import '../../../utils/app_currency.dart';
import '../../../utils/date_format_utils.dart';

class ContentInvoicePaid extends StatelessWidget {
  const ContentInvoicePaid({
    super.key, 
    this.index,
    this.owesPaidModel,
    this.colorMoneyTitle, 
    this.onShowInvoice,
    this.isShowListInvoice=true, 
    this.onGotoDetailInvoice,
  });

  final int? index;
  final OwesPaidModel? owesPaidModel;
  final Color? colorMoneyTitle;
  final Function()? onShowInvoice;
  final Function(OwesModel owesModel)? onGotoDetailInvoice;
  final bool isShowListInvoice;

  @override
  Widget build(BuildContext context) {
    final listCurrent=owesPaidModel?.invoices?.reversed.toList();
    return Visibility(
      visible: owesPaidModel!=null?true: false,
      child: Column(
        children: [
          InkWell(
            onTap: () => onShowInvoice!(),
            child: Column( 
              children: [
                buildTitle(context),
                buildTransactionOf(listCurrent),
              ],
            ),
          ),
          buildListInvoicePaid(listCurrent),
        ],
      ),
    );
  }

  Widget buildTransactionOf(List<OwesModel>? listCurrent){
    final name= listCurrent?[0].myCustomerOwes
    ?.fullName?.split(' ').last;
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVeryVerySmall,
        horizontal: SizeToPadding.sizeLarge,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Paragraph(
            content: '${DebtLanguage.transactionOf}: ',
            style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500),
          ),
          Paragraph(
            content: owesPaidModel?.isMe??false? DebtLanguage.me:
              name ?? '',
            style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500,),
          ),
        ],
      ),
    );
  }

  Widget buildListInvoicePaid(List<OwesModel>? listCurrent){
    return Visibility(
      visible: isShowListInvoice,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: listCurrent?.length??0,
        itemBuilder: (context, index) => buildContentInvoicePaid(index, listCurrent),
      ),
    );
  }

  Widget buildContentInvoicePaid(int index, List<OwesModel>? listCurrent){
    return InkWell(
      onTap: ()=> onGotoDetailInvoice!(owesPaidModel!.invoices![index]),
      child: Column(
        children: [
          const Divider( color: AppColors.BLACK_200,),
          buildTitleInvoice(index, listCurrent),
          SizedBox(height: SpaceBox.sizeSmall,),
          buildDateInvoice(index, listCurrent),
        ],
      ),
    );
  }

  Widget buildTitleInvoice(int index, List<OwesModel>? listCurrent){
    final code= listCurrent?[index].code;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: code!=null? '#$code':'',
          style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
        ),
        Paragraph(
          content: AppCurrencyFormat.formatMoneyD(
            listCurrent?[index].money??0,),
          style: STYLE_MEDIUM.copyWith(
            fontWeight: FontWeight.w500,
            color: (listCurrent?[index].isDebit??false)
            ? AppColors.Red_Money: AppColors.Green_Money,
          ),
        ),
      ],
    );
  }

  Widget buildDateInvoice(int index, List<OwesModel>? listCurrent){
    final date= listCurrent?[index].date;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: DebtLanguage.date,
          style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500),
        ),
        Paragraph(
          content: date != null
            ? AppDateUtils.splitHourDate(
                AppDateUtils.formatDateLocal(
                  date,
                ),
              )
            : '',
          style: STYLE_SMALL.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildTitle(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: 'GD${1000+(owesPaidModel?.debitId??0)}',
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width-170,
          alignment: Alignment.centerRight,
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: STYLE_SMALL.copyWith(
                fontWeight: FontWeight.w500, 
                color: AppColors.BLACK_500,
              ),
              children: [
                TextSpan(
                  text: '${DebtLanguage.debtPaid}: ',
                ),
                TextSpan(
                  text: AppCurrencyFormat.formatMoneyD(
                  owesPaidModel?.totalMoneyIsDebitTrue??0,),
                  style: STYLE_MEDIUM.copyWith(
                    fontWeight: FontWeight.w500,
                  color: colorMoneyTitle?? AppColors.Green_Money,
                  ),
                ), 
              ],
            ),
          ),
        ),
        Icon(isShowListInvoice? Icons.arrow_drop_up_outlined : 
          Icons.arrow_drop_down,),
      ],
    );
  }
}