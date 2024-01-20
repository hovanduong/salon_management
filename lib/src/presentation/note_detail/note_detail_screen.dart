import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/note_language.dart';
import '../../resource/model/model.dart';
import '../../utils/app_handel_color.dart';
import '../../utils/date_format_utils.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'note_detail.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen>{

  NoteDetailViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final noteModel= ModalRoute.of(context)?.settings.arguments;
    return BaseWidget(
      viewModel: NoteDetailViewModel(), 
      onViewModelReady: (viewModel) => _viewModel=viewModel!..init(
        noteModel as NoteModel?,),
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
                buildNoteDetailScreen(),
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

  Widget buildHeader(){
    return Container(
      margin: EdgeInsets.only(top: SizeToPadding.sizeBig*2),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_outlined, size: 35,) ,
          ),
          IconButton(
            onPressed: () => _viewModel!.deleteNote(), 
            icon: const Icon(Icons.delete, 
              size: 35, color: AppColors.Red_Money,) ,
          ),
        ],
      ),
    );
  }

  Widget buildTitle(){
    return Padding(
      padding: EdgeInsets.only(right: SizeToPadding.sizeMedium,
        left: SizeToPadding.sizeMedium, 
        top: SizeToPadding.sizeSmall,
      ),
      child: Paragraph(
        content: _viewModel!.noteModel?.title??'',
        style: STYLE_LARGE_BIG.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }  

  Widget buildDate(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall,
        horizontal: SizeToPadding.sizeMedium,),
      child: Paragraph(
        content: _viewModel!.noteModel?.updatedAt!= null
          ? AppDateUtils.splitHourDate(
              AppDateUtils.formatDateLocal(
                _viewModel!.noteModel!.updatedAt!,
              ),
            )
          : '',
        style:STYLE_SMALL.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildNote(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall,
        horizontal: SizeToPadding.sizeMedium,),
      width: double.maxFinite,
      height: MediaQuery.sizeOf(context).height-170,
      child: SingleChildScrollView(
        child: Paragraph(
          content: _viewModel!.noteModel?.note??'',
          style: STYLE_MEDIUM.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildNoteDetailScreen(){
    return Scaffold(
      backgroundColor: (_viewModel!.noteModel?.color!='' &&
       _viewModel!.noteModel?.color!=null)
       ? AppHandleColor.getColorFromHex(
        _viewModel!.noteModel?.color??'',
      ): AppColors.COLOR_WHITE,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            buildTitle(),
            buildDate(),
            buildNote(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
        child: FloatingActionButton(
          backgroundColor: AppColors.PRIMARY_GREEN,
          onPressed: () =>_viewModel!.gotoUpdateNote(),
          child: const Icon(Icons.edit, color: AppColors.COLOR_WHITE,),
        ),
      ),
    );
  }
}
