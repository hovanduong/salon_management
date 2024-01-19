// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/note_language.dart';
import '../base/base.dart';
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
          _viewModel!.onSearchNotes(value);
        },
      ),
    );
  }

  Widget buildHeader(){
    return Container(
      color: AppColors.PRIMARY_GREEN,
      child: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 30 : 40,
          left: SizeToPadding.sizeMedium, 
          right: SizeToPadding.sizeMedium,
          bottom: SizeToPadding.sizeVerySmall,
        ),
        child: CustomerAppBar(
          onTap: () => Navigator.pop(context),
          title: NoteLanguage.note,
          color: AppColors.COLOR_WHITE,
          style: STYLE_LARGE.copyWith(
            color: AppColors.COLOR_WHITE,
            fontWeight: FontWeight.w700,
          ),
        ),
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
  
  Widget buildListNote(){
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: _viewModel!.listNote.isEmpty && !_viewModel!.isLoading
      ? buildIconEmpty()
      : SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height-170,
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:  SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          axisDirection: AxisDirection.down,
          children: [
            for (int i = 0; i < _viewModel!.listNote.length; i++)
              StaggeredGridTile.count(
                crossAxisCellCount: _viewModel!.tileCounts[i % 7][0],
                mainAxisCellCount: _viewModel!.tileCounts[i % 7][1],
                child: NoteTitleWidget(
                  index: i,
                  note: _viewModel!.listNote[i],
                  // tileType: _tileTypes[i % 7],
                ),),
          ],),
        ),
      ),),
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
