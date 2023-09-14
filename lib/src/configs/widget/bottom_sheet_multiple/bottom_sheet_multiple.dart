import 'package:flutter/material.dart';

import '../../configs.dart';
import '../../constants/app_space.dart';

class BottomSheetSingle extends StatefulWidget {
  const BottomSheetSingle({
    required this.listItems,
    Key? key,
    this.titleContent = '',
    this.onTapSubmit,
    this.initValues,
    this.isAll = false,
    this.onSearch,
    this.changeColor = false,
  }) : super(key: key);

  final String? titleContent;
  final Map<int, String> listItems;
  final dynamic initValues;
  final ValueChanged<MapEntry>? onTapSubmit;
  final bool isAll;
  final Function(String)? onSearch;
  final bool? changeColor;

  @override
  _BottomSheetSingleState createState() => _BottomSheetSingleState();
}

class _BottomSheetSingleState extends State<BottomSheetSingle> {
  late int? selectValue;
  late Map<int, String> listItems;
  @override
  void initState() {
    // if (widget.isAll) {
    //   listItems.addAll(widget.listItems);
    // } else {
    //   listItems = widget.listItems;
    // }
    listItems = widget.listItems;
    selectValue = widget.initValues;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 2 / 3,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5),
              color: AppColors.BLACK_200,
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
                color: widget.changeColor!
                    ? AppColors.PRIMARY_PINK
                    : AppColors.BLACK_300,
              ),
              hintText: 'Tìm kiếm',
              onChanged: (value) {
                widget.onSearch!(value);
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
            child: listItems.isEmpty
                ? const Center(child: Paragraph(content: 'Rỗng'))
                : ListView.builder(
                    itemCount: listItems.length,
                    itemBuilder: (context, i) {
                      final name = listItems.entries.toList()[i].value;
                      final key = listItems.entries.toList()[i].key;
                      return InkWell(
                        // splashColor: AppColors.BLACK_200,
                        onTap: () {
                          selectValue = key;
                          widget.onTapSubmit!(MapEntry(key, name));
                          setState(() {});
                        },
                        child: Container(
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
                                  color: selectValue == key
                                      ? AppColors.PRIMARY_PINK
                                      : AppColors.COLOR_WHITE,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2,
                                    color: selectValue == key
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
                                  child: Paragraph(
                                    content: name,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}