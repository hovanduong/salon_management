import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/service_details_language.dart';

import '../base/base.dart';

import 'components/money_highlight_widget.dart';
import 'service_details.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  ServiceDetailsViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ServiceDetailsViewModel>(
      viewModel: ServiceDetailsViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildServiceDetails(),
    );
  }

  //NOTE: MAIN WIDGET
  Widget buildServiceDetails() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildAppbar(),
            Padding(
              padding: EdgeInsets.only(
                left: SizeToPadding.sizeMedium,
                right: SizeToPadding.sizeMedium,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTopicText(),
                      buildMoneyText(),
                    ],
                  ),
                  buildDescriptionText(),
                  Image.asset(AppImages.serviceDetails),
                  buildDeleteServiceButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppbar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeMedium,
        vertical: SizeToPadding.sizeSmall * 2,
      ),
      child: CustomerAppBar(
        onTap: () => Navigator.pop(context),
        title: ServiceDetailsLanguage.serviceDetails,
        gestureDetector: GestureDetector(
          onTap: () => _viewModel!.onEditService(context),
          child: SvgPicture.asset(AppImages.editService),
        ),
      ),
    );
  }

  Widget buildTopicText() {
    return const Paragraph(
      content: 'Dinner',
      style: STYLE_LARGE_BIG,
    );
  }

  Widget buildDescriptionText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium * 2),
      child: const Paragraph(
        content: 'Dinner at my house',
        style: STYLE_LARGE,
      ),
    );
  }

  Widget buildMoneyText() {
    return const MoneyHighlightWidget();
  }

  Widget buildDeleteServiceButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium * 2),
      child: AppButton(
        content: ServiceDetailsLanguage.deleteService,
        enableButton: true,
        onTap: () {
          popupDialog(context);
        },
      ),
    );
  }

  dynamic popupDialog(_) {
    showDialog(
      context: context,
      builder: (ctx) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: ServiceDetailsLanguage.deleteService,
          content: ServiceDetailsLanguage.deleteServiceContent,
          leftButtonName: ServiceDetailsLanguage.cancel,
          onTapLeft: () => Navigator.pop(context),
          rightButtonName: ServiceDetailsLanguage.confirm,
          onTapRight: () => Navigator.pop(context),
        );
        // WarningDialogWidget(
        //   image: AppImages.icPlus,
        //   title: ServiceDetailsLanguage.serviceDetailDialogTitle,
        //   content: ServiceDetailsLanguage.serviceDetailDialogContent,
        //   onTapLeft: () => Navigator.pop(ctx),
        //   cancelButtonName: ServiceDetailsLanguage.serviceDetailCancelButton,
        //   onTapRight: () => Navigator.pop(ctx),
        //   confirmButtonName: ServiceDetailsLanguage.serviceDetailConfirmButton,
        // );
      },
    );
  }
}
