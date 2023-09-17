import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../resource/model/model.dart';
import '../../utils/app_currency.dart';
import '../base/base.dart';
import 'category_view_model.dart';
import 'components/floating_button_widget.dart';
import 'components/slidable_action_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<CategoryViewModel>(
      viewModel: CategoryViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) {
        return buildListCategories();
      },
    );
  }

  Widget buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: SpaceBox.sizeSmall),
      decoration: BoxDecoration(color: AppColors.COLOR_WHITE, boxShadow: [
        BoxShadow(color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
      ],),
      child: Padding(
        padding: EdgeInsets.all(SizeToPadding.sizeSmall),
        child: CustomerAppBar(
          onTap: () {
            Navigator.pop(context);
          },
          title: 'Category',
        ),
      ),
    );
  }

  Widget buildCardService(int index, int serviceIndex) {
    final idService= _viewModel!.listCategory[index].myServices?[serviceIndex].id;
    final idCategory= _viewModel!.listCategory[index].id;
    final money= _viewModel!.listCategory[index].myServices?[serviceIndex].money;
    return Padding(
      padding:EdgeInsets.only(
            bottom: SpaceBox.sizeSmall, right: SpaceBox.sizeMedium,),
      child: SlidableActionWidget(
        onTapButtonFirst: (context) 
          => _viewModel!.deleteService(idCategory!, idService!),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: AppColors.COLOR_WHITE,
              borderRadius: BorderRadius.circular(SpaceBox.sizeSmall),
              boxShadow: [
                BoxShadow(
                    color: AppColors.BLACK_300, blurRadius: SpaceBox.sizeVerySmall,)
              ],),
          child: ListTile(
            title: Paragraph(
              content:
                  _viewModel!.listCategory[index].myServices?[serviceIndex].name,
              style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
            ),
            subtitle: Paragraph(
              content:
                  AppCurrencyFormat.formatMoneyVND(
                    money ?? 0),
              style: STYLE_SMALL_BOLD.copyWith(color: AppColors.BLACK_400,),
            ),
          ),
        ),
      )
    );
  }

  Widget buildListService(int index) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _viewModel!.listCategory[index].myServices?.length,
        itemBuilder: (context, serviceIndex) =>
            buildCardService(index, serviceIndex),);
  }

  Widget buildItemCategory(int index) {
    return Icon(
      _viewModel!.listIconCategory[index] == true
          ? Icons.arrow_drop_down_circle
          : Icons.remove_circle, 
      color: AppColors.PRIMARY_GREEN, size: 27,
    );
  }

  Widget buildTitleCategory(int index) {
    final id= _viewModel!.listCategory[index].id;
    final name= _viewModel!.listCategory[index].name;
    return InkWell(
      onTap: () {
        _viewModel!.setIcon(index);
      },
      child: SlidableActionWidget(
        isCheckCategory: true,
        onTapButtonFirst: (context) => _viewModel!.deleteCategory(id!),
        onTapButtonSecond: (context) => _viewModel!.goToAddCategory(
          context: context, categoryModel: CategoryModel(
            id: id,
            name: name
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding:  EdgeInsets.only(
                right: SizeToPadding.sizeSmall, bottom: SizeToPadding.sizeMedium,
                top: SizeToPadding.sizeMedium
              ),
              child: Paragraph(
                content: _viewModel!.listCategory[index].name,
                style: STYLE_LARGE_BOLD,
              ),
            ),
            buildItemCategory(index),
          ],
        ),
      ),
    );
  }

  Widget buildContentCategoryWidget(int index) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      buildTitleCategory(index),
      if (_viewModel!.listIconCategory[index] == false)
        buildListService(index)
      else
        Container(),
    ],);
  }

  Widget buildBody() {
    return Expanded(
      child: RefreshIndicator(
        color: AppColors.PRIMARY_GREEN,
        onRefresh: ()async {
          await _viewModel!.pullRefresh();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(color: AppColors.COLOR_WHITE, boxShadow: [
            BoxShadow(color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
          ],),
          child: Padding(
            padding: EdgeInsets.only(top: SizeToPadding.sizeMedium,
              left: SizeToPadding.sizeSmall, right: SizeToPadding.sizeVerySmall),
            child: ListView.builder(
              itemCount: _viewModel!.listCategory.length,
              itemBuilder: (context, index) => buildContentCategoryWidget(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemFloating() {
    return Column(
      children: [
        FloatingButtonWidget(
          heroTag: 'btn1',
          content: 'Add Service',
          iconData: Icons.add,
          onPressed: (){_viewModel!.goToAddServiceCategory(context);},
        ),
        FloatingButtonWidget(
          heroTag: 'btn2',
          content: 'Add Category',
          iconData: Icons.add,
          onPressed: (){_viewModel!.goToAddCategory(context: context);},
        ),
      ],
    );
  }

  Widget buildListCategories() {
    return Scaffold(
      body: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.online,
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          offlineChild: const ThreeBounceLoading(),
          onlineChild: Container(
            color: AppColors.COLOR_WHITE,
            child: Stack(
              children: [
                buildCategory(),
                if (_viewModel!.isLoading)
                  const Positioned(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: ThreeBounceLoading(),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategory() {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            buildHeader(),
            buildBody(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!_viewModel!.isIconFloatingButton)
              buildItemFloating()
            else
              Container(),
            FloatingButtonWidget(
              heroTag: 'btn',
              iconData:
                  _viewModel!.isIconFloatingButton ? Icons.menu : Icons.close,
              onPressed: () {
                _viewModel!.setIconFloating();
              },
            )
          ],
        ),
      ),
    );
  }
}
