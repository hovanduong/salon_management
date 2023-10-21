// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/category_language.dart';
import '../../resource/model/model.dart';
import '../base/base.dart';
import 'category_view_model.dart';
import 'components/components.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

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
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: AppColors.PRIMARY_GREEN,
            systemNavigationBarColor: Colors.white,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: buildCategoryScreen(),
        );
      },
    );
  }

  Widget buildCategoryScreen() {
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
                buildItemCategory(),
                if (_viewModel!.isLoading)
                  const Positioned(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: ThreeBounceLoading(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
        color: AppColors.PRIMARY_GREEN,
        child: Padding(
          padding:
              EdgeInsets.only(top: Platform.isAndroid ? 40 : 60, bottom: 10,
                left: SizeToPadding.sizeMedium,),
          child: CustomerAppBar(
            color: AppColors.COLOR_WHITE,
            style: STYLE_LARGE.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.COLOR_WHITE,
            ),
            onTap: () {
              Navigator.pop(context);
            },
            title: CategoryLanguage.category,
          ),
        ));
  }

  Widget buildCardService(int index, int serviceIndex) {
    final idService =
        _viewModel!.listCategory[index].myServices?[serviceIndex].id;
    final idCategory = _viewModel!.listCategory[index].id;
    final money =
        _viewModel!.listCategory[index].myServices?[serviceIndex].money;
    final name = _viewModel!.listCategory[index].myServices?[serviceIndex].name;
    return CardServiceWidget(
      money: money,
      name: name,
      onTap: (context) => _viewModel!.showWaningDiaglog(
        onTapRight: () {
          _viewModel!.deleteService(idCategory!, idService!);
        },
        title: CategoryLanguage.waningDeleteService,
      ),
    );
  }

  Widget buildListService(int index) {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeVeryVerySmall),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: _viewModel!.listCategory[index].myServices?.length,
        itemBuilder: (context, serviceIndex) =>
            buildCardService(index, serviceIndex),
      ),
    );
  }

  Widget buildIconCategory(int index) {
    if (_viewModel!.listCategory.isNotEmpty) {
      return _viewModel!.listCategory[index].myServices!.isNotEmpty
          ? Icon(
              _viewModel!.listCategory[index].isIconCategory == true
                  ? Icons.arrow_drop_down_circle
                  : Icons.remove_circle,
              color: AppColors.PRIMARY_GREEN,
              size: 27,
            )
          : Container();
    } else {
      return Container();
    }
  }

  Widget buildNameCategory(int index) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      padding: EdgeInsets.only(
        right: SizeToPadding.sizeSmall,
        bottom: SizeToPadding.sizeMedium,
        top: SizeToPadding.sizeMedium,
      ),
      child: Paragraph(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        content: _viewModel!.listCategory[index].name,
        style: STYLE_LARGE_BOLD,
      ),
    );
  }

  Widget buildTitleCategory(int index) {
    final id = _viewModel?.listCategory[index].id;
    final name = _viewModel?.listCategory[index].name;
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeVeryVerySmall),
      child: InkWell(
        onTap: () {
          if (_viewModel!.listCategory[index].myServices!.isNotEmpty){
            _viewModel!.setIcon(index);
          }
        },
        child: SlidableActionWidget(
          isCheckCategory: true,
          onTapButtonFirst: (context) => _viewModel!.showWaningDiaglog(
            onTapRight: () {
              _viewModel!.deleteCategory(id!);
            },
            title: CategoryLanguage.waningDeleteCategory,
          ),
          onTapButtonSecond: (context) => _viewModel!.goToAddCategory(
            context: context,
            categoryModel: CategoryModel(id: id, name: name),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildNameCategory(index),
              buildIconCategory(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContentCategoryWidget(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitleCategory(index),
        if (_viewModel!.listCategory[index].isIconCategory == false)
          buildListService(index),
      ],
    );
  }

  Widget buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeMedium),
      child: AppFormField(
        iconButton: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: AppColors.BLACK_300,
        ),
        hintText: CategoryLanguage.searchCategory,
        onChanged: (value) async {
          await _viewModel!.onSearchCategory(value.trim());
        },
      ),
    );
  }

  Widget buildCategory() {
    return Container(
      margin: EdgeInsets.only(
        left: SizeToPadding.sizeSmall,
        right: SizeToPadding.sizeVerySmall,
      ),
      height: MediaQuery.of(context).size.height - 200,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _viewModel!.scrollController,
        itemCount: _viewModel!.loadingMore
            ? _viewModel!.listCategory.length + 1
            : _viewModel!.listCategory.length,
        itemBuilder: (context, index) {
          if (index < _viewModel!.listCategory.length) {
            return buildContentCategoryWidget(index);
          } else {
            return const CupertinoActivityIndicator();
          }
        },
      ),
    );
  }

  Widget showListCategory() {
    return _viewModel!.listCategory.isEmpty
      ? Padding(
        padding: EdgeInsets.only(top: SizeToPadding.sizeBig * 7),
        child: EmptyDataWidget(
          title: CategoryLanguage.emptyCategory,
          content: CategoryLanguage.notificationEmptyCategory,
        ),
      )
      : RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: buildCategory(),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildSearch(),
            showListCategory(),
          ],
        ),
      ),
    );
  }

  Widget buildItemFloating() {
    return Column(
      children: [
        FloatingButtonWidget(
          heroTag: 'btnOne',
          content: CategoryLanguage.serviceAdd,
          iconData: Icons.add,
          onPressed: () {
            _viewModel!.goToAddServiceCategory(context);
          },
        ),
        FloatingButtonWidget(
          heroTag: 'btnTwo',
          content: CategoryLanguage.addCategory,
          iconData: Icons.add,
          onPressed: () {
            _viewModel!.goToAddCategory(context: context);
          },
        ),
      ],
    );
  }

  Widget buildItemCategory() {
    return Scaffold(
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
          ),
        ],
      ),
    );
  }
}
