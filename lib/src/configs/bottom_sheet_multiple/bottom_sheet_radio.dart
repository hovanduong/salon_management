import 'package:flutter/material.dart';

import '../../resource/model/radio_model.dart';
import '../configs.dart';

class BottomSheetSingleRadio extends StatefulWidget {
  const BottomSheetSingleRadio({
    Key? key,
    this.titleContent = '',
    this.titleButton = 'Hoàn thành',
    required this.listItems,
    this.onTapSubmit,
    this.initValues,
    this.isSecondText = true,
  }) : super(key: key);

  final String? titleContent;
  final String? titleButton;
  final Map<dynamic, dynamic> listItems;
  final List<int>? initValues;
  final ValueChanged<dynamic>? onTapSubmit;
  final bool isSecondText;

  @override
  _BottomSheetSingleRadioState createState() => _BottomSheetSingleRadioState();
}

class _BottomSheetSingleRadioState extends State<BottomSheetSingleRadio> {
  List<RadioModel> listRadioData = [];
  List<RadioModel> selectValue = [];

  @override
  void initState() {
    super.initState();
    print(widget.initValues);
    if (widget.initValues != null) {
      widget.listItems.entries.forEach((e) {
        if (widget.initValues == e.key || widget.initValues!.contains(e.key)) {
          listRadioData.add(RadioModel(
            isSelected: true,
            id: e.key,
            secondTitle: "${e.value[1]}",
            text: e.value,
          ));
          // selectValue = widget.initValues;
        } else {
          listRadioData.add(RadioModel(
            isSelected: false,
            id: e.key,
            secondTitle: "${e.value[1]}",
            text: e.value,
          ));
        }
      });
    } else {
      widget.listItems.entries.forEach((e) {
        listRadioData.add(RadioModel(
          isSelected: false,
          id: e.key,
          secondTitle: "${e.value[1]}",
          text: e.value,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 2 / 3,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5),
              color: AppColors.BLACK_100,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Paragraph(
              content: widget.titleContent,
            ),
          ),
          Expanded(
              child: listRadioData.length == 0
                  ? Container(child: Text('data'))
                  : ListView.builder(
                      itemCount: listRadioData.length,
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          // splashColor: theme.getColor(ThemeColor.gainsboro),
                          onTap: () {
                            setState(() {
                              listRadioData[i].isSelected =
                                  !listRadioData[i].isSelected;
                              // selectValue.forEach((element) {
                              //   if(element.id == listRadioData[i].id){
                              //     return;
                              //   }else{
                              //     selectValue.add(listRadioData[i]);
                              //   }
                              // });
                            });
                          },
                          child: RadioItem(
                            item: listRadioData[i],
                            isSecond: widget.isSecondText,
                          ),
                        );
                      },
                    )),
          Container(
            margin: EdgeInsets.only(
              bottom: 20,
            ),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: InkWell(
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
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  decoration: new BoxDecoration(
                    color: AppColors.PRIMARY_PINK,
                    // borderRadius: 10,
                    border:
                        new Border.all(width: 1.0, color: AppColors.BLACK_300),
                  ),
                  child: Paragraph(
                    // isCenter: true,
                    content: widget.titleButton,
                    // size: LayoutSize.medium,
                    // color: ThemeColor.lightest,
                    // linePadding: LayoutSize.none,
                    // weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RadioItem extends StatelessWidget {
  const RadioItem({
    Key? key,
    required this.item,
    required this.isSecond,
  }) : super(key: key);
  final bool isSecond;
  final RadioModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 16,
            bottom: 61,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                decoration: BoxDecoration(
                    color: AppColors.COLOR_WHITE,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: item.isSelected
                          ? AppColors.PRIMARY_PINK
                          : AppColors.COLOR_GREY,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: item.isSelected
                          ? AppColors.PRIMARY_PINK
                          : AppColors.COLOR_GREY,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: layout.sizeToPadding(LayoutSize.tiny),
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.text!,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 10)),
                      isSecond
                          ? Padding(
                              padding: EdgeInsets.all(2),
                              child: Text(
                                item.secondTitle!,
                                style: TextStyle(
                                  color: AppColors.BLACK_100,
                                  // fontSize: layout
                                  //     .sizeToFontSize(LayoutSize.medium)
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 0.5, height: 0),
      ],
    );
  }
}
