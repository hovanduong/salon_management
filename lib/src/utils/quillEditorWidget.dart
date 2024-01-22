
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillEditorWidget extends StatefulWidget {
  final QuillController controller;
  const QuillEditorWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<QuillEditorWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<QuillEditorWidget> {
  // final paragraphStyle = DefaultTextBlockStyle(
  //   TextStyle(color: appStore.isDarkMode ? white : black),
  //   Tuple2(0, 0),
  //   Tuple2(0, 0),
  //   null,
  // );
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: QuillEditor(
              customStyleBuilder: (attribute) => const TextStyle(),
              customStyles: DefaultStyles(
                paragraph: paragraphStyle,
                h1: paragraphStyle,
                h2: paragraphStyle,
                h3: paragraphStyle,
                inlineCode:
                    InlineCodeStyle(style: const TextStyle(color: Colors.white)),
                quote: paragraphStyle,
                lists: DefaultListBlockStyle(
                  TextStyle(color: appStore.isDarkMode ? white : black),
                  Tuple2(0, 0),
                  Tuple2(0, 0),
                  const BoxDecoration(),
                  null,
                ),
              ),
              placeholder: 'Write Notes here',
              autoFocus: true,
              padding: EdgeInsets.zero,
              scrollController: ScrollController(),
              scrollable: true,
              expands: false,
              focusNode: focusNode,
              controller: widget.controller,
              readOnly: false, configurations: null,
            ),
          ),
        ),
        QuillToolbar.basic(
          toolbarIconCrossAlignment: WrapCrossAlignment.end,
          toolbarIconAlignment: WrapAlignment.start,
          controller: widget.controller,
          axis: Axis.horizontal,
          multiRowsDisplay: false,
          showCenterAlignment: true,
          showRedo: false,
          showUndo: false,
          showBackgroundColorButton: false,
          showFontFamily: false,
          showStrikeThrough: true,
          showColorButton: false,
          showListCheck: false,
          iconTheme: const QuillIconTheme(),
        ),
      ],
    );
  }
}
