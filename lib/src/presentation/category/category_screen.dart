// ignore_for_file: use_late_for_private_fields_and_variables

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
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: buildListCategories(),
        );
      },
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
      margin: EdgeInsets.only(bottom: SpaceBox.sizeSmall),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeToPadding.sizeSmall),
        child: CustomerAppBar(
          onTap: () {
            Navigator.pop(context);
          },
          title: CategoryLanguage.category,
        ),
      ),
    );
  }

  Widget buildCardService(int index, int serviceIndex) {
    final idService =
        _viewModel!.foundCategory[index].myServices?[serviceIndex].id;
    final idCategory = _viewModel!.foundCategory[index].id;
    final money =
        _viewModel!.foundCategory[index].myServices?[serviceIndex].money;
    final name = 
      _viewModel!.foundCategory[index].myServices?[serviceIndex].name;
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
        itemCount: _viewModel!.foundCategory[index].myServices?.length,
        itemBuilder: (context, serviceIndex) =>
            buildCardService(index, serviceIndex),
      ),
    );
  }

  Widget buildItemCategory(int index) {
    print(index);
    if(_viewModel!.listCategory.isNotEmpty){
      return _viewModel!.listCategory[index].myServices!.isNotEmpty? Icon(
        _viewModel!.listIconCategory[index] == true
            ? Icons.arrow_drop_down_circle
            : Icons.remove_circle,
        color: AppColors.PRIMARY_GREEN,
        size: 27,
      ): Container();
    }else {
      return Container();
    }
  }

  Widget buildTitleCategory(int index) {
    final id = _viewModel!.foundCategory[index].id;
    final name = _viewModel!.foundCategory[index].name;
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeVeryVerySmall),
      child: InkWell(
        onTap: () {
          _viewModel!.setIcon(index);
        },
        child: SlidableActionWidget(
          isCheckCategory: true,
          onTapButtonFirst: (context) => _viewModel!.showWaningDiaglog(
            onTapRight: () {
              _viewModel!.deleteCategory(id!);
            },title: CategoryLanguage.waningDeleteCategory,),
          onTapButtonSecond: (context) => _viewModel!.goToAddCategory(
            context: context, 
            categoryModel: CategoryModel(id: id, name: name),),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                    right: SizeToPadding.sizeSmall,
                    bottom: SizeToPadding.sizeMedium,
                    top: SizeToPadding.sizeMedium,),
                child: Paragraph(
                  content: _viewModel!.foundCategory[index].name,
                  style: STYLE_LARGE_BOLD,
                ),
              ),
              buildItemCategory(index),
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
        if (_viewModel!.listIconCategory[index] == false)
          buildListService(index)
        else
          Container(),
      ],
    );
  }

  Widget buildSearch(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeMedium),
      child: AppFormField(
        iconButton: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: AppColors.BLACK_300,
        ),
        hintText: CategoryLanguage.search,
        onChanged: (value) {
          _viewModel!.onSearchCategory(value.trim());
        },
      ),
    );
  }

  Widget showListCategory(){
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(
              left: SizeToPadding.sizeSmall,
              right: SizeToPadding.sizeVerySmall,),
          height: MediaQuery.of(context).size.height-200,
          child: ListView.builder(
            controller: _viewModel!.scrollController,
            itemCount: _viewModel!.loadingMore
              ? _viewModel!.foundCategory.length+1
              : _viewModel!.foundCategory.length,
            itemBuilder: (context, index) {
              if(index<_viewModel!.foundCategory.length){
                return buildContentCategoryWidget(index);
              }else{
                return const CupertinoActivityIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          boxShadow: [
            BoxShadow(
              color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig,),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSearch(),
              showListCategory(),
            ],
          ),
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
            ),
          ],
        ),
      ),
    );
  }
}
