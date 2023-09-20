import 'package:flutter/material.dart';

import '../../../resource/model/radio_model.dart';
import '../../configs.dart';
import '../../constants/app_space.dart';

class BottomSheetMultipleRadio extends StatefulWidget {
  const BottomSheetMultipleRadio({
    required this.listItems,
    Key? key,
    this.titleContent = '',
    this.titleButton = 'Hoàn thành',
    this.onTapSubmit,
    this.initValues,
    this.isSecondText = true,
    // this.onSearch,
  }) : super(key: key);

  final String? titleContent;
  final String? titleButton;
  final Map<dynamic, dynamic> listItems;
  // final List<CategoryModel> listItems;
  final List<int>? initValues;
  final ValueChanged<dynamic>? onTapSubmit;
  final bool isSecondText;
  // final Function(String)? onSearch;

  @override
  _BottomSheetMultipleRadioState createState() =>
      _BottomSheetMultipleRadioState();
}

class _BottomSheetMultipleRadioState extends State<BottomSheetMultipleRadio> {
  List<RadioModel> listRadioData = [];
  List<RadioModel> selectValue = [];
  bool enableButton = false;
  List<RadioModel> foundCategory = [];

  @override
  void initState() {
    super.initState();
    print('value selected: ${widget.initValues}');
    if (widget.initValues != null) {
      widget.listItems.entries.forEach((e) {
        if (widget.initValues!.contains(e.key)) {
          listRadioData.add(
            RadioModel(
              isSelected: true,
              id: e.key,
              name: e.value,
            ),
          );
        } else {
          listRadioData.add(
            RadioModel(
              isSelected: false,
              id: e.key,
              name: e.value,
            ),
          );
        }
      });
    } else {
      widget.listItems.entries.forEach((e) {
        listRadioData.add(
          RadioModel(
            isSelected: false,
            id: e.key,
            name: e.value,
          ),
        );
      });
    }
    setEnableButton();
    foundCategory = listRadioData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 2 / 3,
      margin: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeVerySmall),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5),
              color: AppColors.BLACK_100,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: SizeToPadding.sizeMedium,
              horizontal: SizeToPadding.sizeMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Paragraph(
                  content: widget.titleContent,
                  style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeToPadding.sizeVerySmall),
            child: AppFormField(
              iconButton: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
                color: AppColors.BLACK_300,
                // widget.changeColor!
                //     ? AppColors.PRIMARY_PINK
                // : AppColors.BLACK_300,
              ),
              hintText: 'Tìm kiếm',
              onChanged: (value) {
                // widget.onSearch!(value);
                onSearchCategory(value);
                setState(() {});
              },
            ),
          ),
          const Divider(
            height: 0,
            color: AppColors.BLACK_200,
            thickness: 1,
          ),
          Expanded(
            child: foundCategory.isEmpty
                ? const Center(
                    child: Paragraph(content: 'Không tìm thấy dữ liệu'))
                : ListView.builder(
                    itemCount: foundCategory.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        // splashColor: theme.getColor(ThemeColor.gainsboro),
                        onTap: () {
                          setState(() {
                            foundCategory[i].isSelected =
                                !foundCategory[i].isSelected;
                            // selectValue.forEach((element) {
                            //   if(element.id == listRadioData[i].id){
                            //     return;
                            //   }else{
                            //     selectValue.add(listRadioData[i]);
                            //   }
                            // });
                          });
                          setEnableButton();
                        },
                        child: RadioItem(
                          item: foundCategory[i],
                          isSecond: widget.isSecondText,
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(SizeToPadding.sizeMedium),
            child: AppButton(
              content: widget.titleButton,
              enableButton: enableButton,
              onTap: () {
                listRadioData.forEach((i) {
                  if (i.isSelected == true) {
                    selectValue.add(i);
                  }
                });
                Navigator.pop(context);
                widget.onTapSubmit!(selectValue);
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  void setEnableButton() {
    for (var i = 0; i < listRadioData.length; i++) {
      if (listRadioData[i].isSelected == true) {
        enableButton = true;
        break;
      } else {
        enableButton = false;
      }
    }
  }

  Future<void> filterCategory(String searchCategory) async {
    var listSearchCategory = <RadioModel>[];
    listSearchCategory = listRadioData
        .where(
          (element) => element.name!.toLowerCase().contains(searchCategory),
        )
        .toList();
    setState(() {
      foundCategory = listSearchCategory;
    });
  }

  Future<void> onSearchCategory(String value) async {
    if (value.isEmpty) {
      setState(() {
        foundCategory = listRadioData;
      });
    } else {
      final searchCategory = value.toLowerCase();
      // _timer = Timer(const Duration(milliseconds: 100), () async {});
      await filterCategory(searchCategory);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RadioItem extends StatelessWidget {
  const RadioItem({
    required this.item,
    required this.isSecond,
    Key? key,
  }) : super(key: key);
  final bool isSecond;
  final RadioModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.BLACK_100,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: item.isSelected
                  ? AppColors.PRIMARY_PINK
                  : AppColors.COLOR_WHITE,
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: item.isSelected
                    ? AppColors.PRIMARY_PINK
                    : AppColors.BLACK_200,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                color: AppColors.COLOR_WHITE,
              ),
            ),
          ),
          Flexible(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Paragraph(
                      content: item.name!.split('/')[0],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Paragraph(
                      content: item.name!.split('/')[1],
                    ),
                  ],
                )),
          ),
          // SizedBox(
          //   width: layout.sizeToPadding(LayoutSize.tiny),
          // ),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 1),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(item.text!,
          //             style: const TextStyle(
          //                 fontWeight: FontWeight.w500, fontSize: 10)),
          //         isSecond
          //             ? Padding(
          //                 padding: const EdgeInsets.all(2),
          //                 child: Text(
          //                   item.secondTitle!,
          //                   style: const TextStyle(
          //                     color: AppColors.BLACK_100,
          //                     // fontSize: layout
          //                     //     .sizeToFontSize(LayoutSize.medium)
          //                   ),
          //                 ),
          //               )
          //             : const SizedBox(),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
