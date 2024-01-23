// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/note_language.dart';
import '../../utils/app_handel_color.dart';
import '../../utils/date_format_utils.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'components/note_title.dart';
import 'note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  NoteViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: NoteViewModel(),
      onViewModelReady: (viewModel) => _viewModel=viewModel!..init(), 
      builder: (context, viewModel, child) => buildLoading(),
    );
  }

  Widget buildLoading(){
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
                buildNoteScreen(),
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

 Widget buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeMedium),
      child: AppFormField(
        iconButton: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: AppColors.BLACK_300,
        ),
        hintText: NoteLanguage.search,
        onChanged: (value) {
          _viewModel!.onSearchNotes(value: value);
        },
      ),
    );
  }

  Widget buildButtonOptionView(){
    return MenuAnchor(
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: const CircleAvatar(
            radius: 13,
            backgroundColor: AppColors.BLACK_500,
            child: Icon(Icons.more_horiz, size: 17, 
              color: AppColors.COLOR_WHITE,),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () => _viewModel!.onChangeViewScreen(NoteLanguage.gridView),
          child: Paragraph(
            content: NoteLanguage.gridView,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        MenuItemButton(
          onPressed: () => _viewModel!.onChangeViewScreen(NoteLanguage.listView),
          child: Paragraph(
            content: NoteLanguage.listView,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future noteColorPicker() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Paragraph(
                content: NoteLanguage.searchColor,
                style: STYLE_MEDIUM,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
                child: SelectNoteColor(
                  onTap: (color) {
                    _viewModel!.onSearchNotes(color: color);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildButtonHeader(){
    return Padding(
      padding: EdgeInsets.only(right: SizeToPadding.sizeMedium),
      child: Row(
        children: [
          InkWell(
            onTap: noteColorPicker,
            child: Icon(
              Icons.color_lens_outlined,
              color: _viewModel!.selectColor!=AppColors.COLOR_WHITE?
                _viewModel!.selectColor : AppColors.BLACK_500 ,
            ),
          ),
          SizedBox(width: SizeToPadding.sizeSmall,),
          buildButtonOptionView(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: Platform.isAndroid ? 30 : 40,
        left: SizeToPadding.sizeMedium,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _viewModel!.onSearchNotes(),
            child: Paragraph(
              content: NoteLanguage.note,
              style: STYLE_VERY_BIG.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildButtonHeader(),
        ],
      ),
    );
  }


  Widget buildIconEmpty(){
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: SizeToPadding.sizeBig * 7),
        child: EmptyDataWidget(
          title: NoteLanguage.note,
          content: NoteLanguage.currentNoteEmpty,
        ),
      ),
    );
  }

  Widget buildGridViewScreen(){
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      axisDirection: AxisDirection.down,
      children: [
        for (int i = 0; i < (_viewModel!.isLoadMore?
          _viewModel!.listCurrent.length+1
          : _viewModel!.listCurrent.length); i++)
          if (i < _viewModel!.listCurrent.length) 
            StaggeredGridTile.count(
              crossAxisCellCount: _viewModel!.tileCounts[i % 7][0],
              mainAxisCellCount: _viewModel!.tileCounts[i % 7][1],
              child: NoteTitleWidget(
                note: _viewModel!.listCurrent[i],
                onTap: () => _viewModel!.gotoDetailNote(
                  _viewModel!.listCurrent[i],),
              ),
            )
          else const Center(child: CupertinoActivityIndicator()),
      ],
    );
  }

  Widget buildTitleContentListView(int index){
    return Paragraph(
      content: _viewModel!.listCurrent[index].title??'',
      maxLines: 1,
      style: STYLE_MEDIUM.copyWith(
        fontWeight: FontWeight.w600,
        color: (_viewModel!.listCurrent[index].color!=null)?
          AppHandleColor.getColorFromHex(_viewModel!.listCurrent[index].color!)
          !=AppColors.COLOR_WHITE?
          AppColors.COLOR_WHITE: AppColors.BLACK_500: null,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildNoteContentListView(int index){
    return Paragraph(
      content: Document.fromJson(jsonDecode(
        _viewModel!.listCurrent[index].note??'',),).toPlainText(),
      maxLines: 1,
      style: STYLE_SMALL.copyWith(
        fontWeight: FontWeight.w600,
        color: (_viewModel!.listCurrent[index].color!=null)?
          AppHandleColor.getColorFromHex(_viewModel!.listCurrent[index].color!)
          !=AppColors.COLOR_WHITE?
          AppColors.COLOR_WHITE: AppColors.BLACK_500: null,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildDateContentListView(int index){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Paragraph(
          content: _viewModel!.listCurrent[index].updatedAt!= null
            ? AppDateUtils.splitHourDate(
                AppDateUtils.formatDateLocal(
                  _viewModel!.listCurrent[index].updatedAt!,
                ),
              )
            : '',
          style:STYLE_SMALL.copyWith(
            color: (_viewModel!.listCurrent[index].color!=null)?
              AppHandleColor.getColorFromHex(_viewModel!.listCurrent[index].color!)
              !=AppColors.COLOR_WHITE?
              AppColors.COLOR_WHITE: AppColors.BLACK_500: null,)
        ),
      ],
    );
  }

  Widget buildContentListView(int index){
    return InkWell(
      onTap: ()=> _viewModel!.gotoDetailNote(
        _viewModel!.listCurrent[index],),
      child: Container(
        margin: EdgeInsets.only(top: SizeToPadding.sizeMedium),
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall,
          horizontal: SizeToPadding.sizeMedium,),
        height: 100,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: (_viewModel!.listCurrent[index].color!=null)?
            AppHandleColor.getColorFromHex(
              _viewModel!.listCurrent[index].color!,
            ): null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.BLACK_200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleContentListView(index),
            buildNoteContentListView(index),
            const Spacer(),
            buildDateContentListView(index),
          ],
        ),
      ),
    );
  }

  Widget buildListViewScreen(){
    return Column(
      children: [
        ...List.generate(
          _viewModel!.isLoadMore?
          _viewModel!.listCurrent.length+1
          : _viewModel!.listCurrent.length, (index){
            if (index < _viewModel!.listCurrent.length) {
              return buildContentListView(index);
            } else {
              return const CupertinoActivityIndicator();
            }
          },
        ),
      ],
    );
  }
  
  Widget buildListNote(){
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: _viewModel!.listCurrent.isEmpty && !_viewModel!.isLoading
      ? buildIconEmpty()
      : SizedBox(
          width: double.maxFinite,
          height: MediaQuery.sizeOf(context).height-240,
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, ),
          child:  SingleChildScrollView(
            controller: _viewModel!.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child:_viewModel!.isGridView? buildGridViewScreen()
              : buildListViewScreen(),
          ),
        ),
      ),
    );
  }

  Widget buildNoteScreen(){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildSearch(),
            buildListNote(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
        child: FloatingActionButton(
          backgroundColor: AppColors.PRIMARY_GREEN,
          onPressed: () => _viewModel!.gotoAddNote(),
          child: const Icon(Icons.add, color: AppColors.COLOR_WHITE,),
        ),
      ),
    );
  }
}
