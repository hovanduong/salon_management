// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

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
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildLoading(),
    );
  }

  Widget buildLoading() {
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

  Widget buildButtonOptionView() {
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
          child: CircleAvatar(
            radius: 13,
            backgroundColor: AppColors.COLOR_WHITE.withOpacity(0.2),
            child: const Icon(
              Icons.more_horiz,
              size: 17,
              color: AppColors.COLOR_WHITE,
            ),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () =>
              _viewModel!.onChangeViewScreen(NoteLanguage.gridView),
          child: Paragraph(
            content: NoteLanguage.gridView,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        MenuItemButton(
          onPressed: () =>
              _viewModel!.onChangeViewScreen(NoteLanguage.listView),
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
      backgroundColor: AppColors.BLACK_500,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Paragraph(
                content: NoteLanguage.searchColor,
                style: STYLE_MEDIUM.copyWith(
                  color: AppColors.COLOR_WHITE,
                ),
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

  Widget buildButtonHeader() {
    return Padding(
      padding: EdgeInsets.only(
        right: SizeToPadding.sizeMedium,
        bottom: 15,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: noteColorPicker,
            child: Showcase(
              key: _viewModel!.selectColorKey,
              description: NoteLanguage.searchColor,
              child: Icon(
                Icons.color_lens_outlined,
                color: AppColors.COLOR_WHITE.withOpacity(0.7),
                // color: _viewModel!.selectColor != AppColors.COLOR_WHITE
                //     ? _viewModel!.selectColor
                //     : AppColors.COLOR_WHITE,
              ),
            ),
          ),
          SizedBox(
            width: SizeToPadding.sizeSmall,
          ),
          Showcase(
              key: _viewModel!.selectViewKey,
              description: NoteLanguage.selectViewDescription,
              child: buildButtonOptionView()),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      color: AppColors.PRIMARY_GREEN,
      padding: EdgeInsets.only(
        top: Platform.isAndroid ? 30 : 60,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Paragraph(
                  textAlign: TextAlign.center,
                  content: NoteLanguage.note,
                  style: STYLE_LARGE.copyWith(
                    color: AppColors.COLOR_WHITE,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          const Spacer(),
          buildButtonHeader(),
        ],
      ),
    );
  }

  // Widget buildHeader() {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //       top: Platform.isAndroid ? 30 : 40,
  //       left: SizeToPadding.sizeMedium,
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 7,
  //           child: InkWell(
  //             onTap: () => _viewModel!.onSearchNotes(),
  //             child: Paragraph(
  //               textAlign: TextAlign.center,
  //               content: NoteLanguage.note,
  //               style: STYLE_VERY_BIG.copyWith(
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ),
  //         buildButtonHeader(),
  //       ],
  //     ),
  //   );
  // }

  Widget buildIconEmpty() {
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

  Widget buildGridViewScreen() {
    final gridChildren =
        List<Widget>.generate(_viewModel!.listCurrent.length, (index) {
      return StaggeredGridTile.count(
        crossAxisCellCount: _viewModel!.tileCounts[index % 7][0],
        mainAxisCellCount: _viewModel!.tileCounts[index % 7][1],
        child: Padding(
          padding: EdgeInsets.only(
            top: ((index == 0 || index == 1) ? SizeToPadding.sizeSmall : 0),
          ),
          child: NoteTitleWidget(
            onTapFavorite: () => _viewModel!.pinNote(
              _viewModel!.listCurrent[index].id ?? 0,
            ),
            note: _viewModel!.listCurrent[index],
            onTap: () => _viewModel!.gotoDetailNote(
              _viewModel!.listCurrent[index],
            ),
          ),
        ),
      );
    });

    return Column(
      children: [
        StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 8,
          axisDirection: AxisDirection.down,
          children: gridChildren,
        ),
        if (_viewModel!.isLoadMore)
          const Center(child: CupertinoActivityIndicator()),
      ],
    );
  }

  Widget buildTitleContentListView(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.5,
          child: Paragraph(
            content: _viewModel!.listCurrent[index].title ?? '',
            maxLines: 1,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: (_viewModel!.listCurrent[index].color != null)
                  ? AppHandleColor.getColorFromHex(
                            _viewModel!.listCurrent[index].color!,
                          ) !=
                          AppColors.COLOR_WHITE
                      ? AppColors.BLACK_500
                      : AppColors.BLACK_500
                  : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        buildButtonFavoriteNote(index),
      ],
    );
  }

  Widget buildButtonFavoriteNote(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryVerySmall),
      child: InkWell(
        onTap: () => _viewModel!.pinNote(
          _viewModel!.listCurrent[index].id ?? 0,
        ),
        child: CircleAvatar(
          radius: 17,
          backgroundColor: (_viewModel!.listCurrent[index].color != null)
              ? _viewModel!.listCurrent[index].color != '#FFFFFF'
                  ? AppColors.COLOR_WHITE
                  : AppColors.PRIMARY_GREEN
              : null,
          child: Center(
            child: Icon(
              (_viewModel!.listCurrent[index].pined ?? false)
                  ? Icons.favorite
                  : Icons.favorite_border,
              size: 20,
              color: (_viewModel!.listCurrent[index].pined ?? false)
                  ? AppColors.Red_Money
                  : (_viewModel!.listCurrent[index].color != '#FFFFFF'
                      ? AppColors.BLACK_500
                      : AppColors.COLOR_WHITE),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNoteContentListView(int index) {
    return Paragraph(
      content: Document.fromJson(
        jsonDecode(
          _viewModel!.listCurrent[index].note ?? '',
        ),
      ).toPlainText(),
      maxLines: 4,
      style: STYLE_SMALL.copyWith(
        fontWeight: FontWeight.w300,
        color: (_viewModel!.listCurrent[index].color != null)
            ? AppHandleColor.getColorFromHex(
                      _viewModel!.listCurrent[index].color!,
                    ) !=
                    AppColors.COLOR_WHITE
                ? AppColors.BLACK_500
                : AppColors.BLACK_500
            : null,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildDateContentListView(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: _viewModel!.listCurrent[index].color == '#FFFFFF'
            ? AppColors.PRIMARY_GREEN
            : AppColors.COLOR_WHITE,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppImages.icClock,
            height: 20,
            color: _viewModel!.listCurrent[index].color == '#FFFFFF'
                ? AppColors.COLOR_WHITE
                : null,
          ),
          const SizedBox(width: 7),
          Paragraph(
            content: _viewModel!.listCurrent[index].updatedAt != null
                ? AppDateUtils.splitHourDate(
                    AppDateUtils.formatDateLocal(
                      _viewModel!.listCurrent[index].updatedAt!,
                    ),
                  )
                : '',
            style: STYLE_SMALL.copyWith(
              fontWeight: FontWeight.w500,
              color: (_viewModel!.listCurrent[index].color != null)
                  ? AppHandleColor.getColorFromHex(
                            _viewModel!.listCurrent[index].color!,
                          ) !=
                          AppColors.COLOR_WHITE
                      ? AppColors.BLACK_500
                      : AppColors.COLOR_WHITE
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardNote(int index) {
    return InkWell(
      onTap: () => _viewModel!.gotoDetailNote(
        _viewModel!.listCurrent[index],
      ),
      child: Container(
        margin: EdgeInsets.only(top: SizeToPadding.sizeMedium),
        padding: EdgeInsets.only(
          left: SizeToPadding.sizeSmall,
          right: SizeToPadding.sizeMedium,
          bottom: SizeToPadding.sizeSmall,
          top: SizeToPadding.sizeVerySmall,
        ),
        height: 200,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: (_viewModel!.listCurrent[index].color != null)
              ? AppHandleColor.getColorFromHex(
                  _viewModel!.listCurrent[index].color!,
                )
              : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.BLACK_200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleContentListView(index),
            const SizedBox(height: 10),
            buildNoteContentListView(index),
            const Spacer(),
            buildDateContentListView(index),
          ],
        ),
      ),
    );
  }

  Widget buildButtonCardNote(int index) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: InkWell(
        onTap: () => _viewModel!.gotoDetailNote(
          _viewModel!.listCurrent[index],
        ),
        child: Container(
          width: 65,
          height: 65,
          decoration: const BoxDecoration(
            color: AppColors.PRIMARY_GREEN,
            borderRadius: BorderRadius.all(
              Radius.circular(65),
            ),
          ),
          child: const Icon(
            Icons.arrow_outward_outlined,
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
    );
  }

  Widget buildListViewScreen() {
    return Column(
      children: [
        ...List.generate(
          _viewModel!.isLoadMore
              ? _viewModel!.listCurrent.length + 1
              : _viewModel!.listCurrent.length,
          (index) {
            if (index < _viewModel!.listCurrent.length) {
              return buildCardNote(index);
            } else {
              return const CupertinoActivityIndicator();
            }
          },
        ),
      ],
    );
  }

  Widget buildListNote() {
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: _viewModel!.listCurrent.isEmpty && !_viewModel!.isLoading
          ? buildIconEmpty()
          : SizedBox(
              width: double.maxFinite,
              height: MediaQuery.sizeOf(context).height - 265,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: SingleChildScrollView(
                  controller: _viewModel!.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _viewModel!.isGridView
                      ? buildGridViewScreen()
                      : buildListViewScreen(),
                ),
              ),
            ),
    );
  }

  Widget buildListSelectItem() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: _viewModel!.listSelectItem.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () => _viewModel!.onChangeSelectItem(index),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeToPadding.sizeVeryVerySmall,
            ),
            padding: EdgeInsets.symmetric(
              vertical: SizeToPadding.sizeVeryVerySmall,
              horizontal: SizeToPadding.sizeSmall,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(BorderRadiusSize.sizeSmall),
              ),
              color: _viewModel!.selectItem == index
                  ? AppColors.PRIMARY_GREEN
                  : AppColors.COLOR_WHITE,
              border: Border.all(color: AppColors.BLACK_200),
            ),
            child: Paragraph(
              content: _viewModel!.listSelectItem[index],
              style: STYLE_SMALL.copyWith(
                fontWeight: FontWeight.w600,
                color: _viewModel!.selectItem == index
                    ? AppColors.COLOR_WHITE
                    : AppColors.BLACK_500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNoteScreen() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildSearch(),
            buildListSelectItem(),
            buildListNote(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
        child: Showcase(
          description: NoteLanguage.addNote,
          key: _viewModel!.addKey,
          child: FloatingActionButton(
            backgroundColor: AppColors.PRIMARY_GREEN,
            onPressed: () => _viewModel!.gotoAddNote(),
            child: const Icon(
              Icons.add,
              color: AppColors.COLOR_WHITE,
            ),
          ),
        ),
      ),
    );
  }
}
