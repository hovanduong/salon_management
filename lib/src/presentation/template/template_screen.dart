// import 'package:flutter/material.dart';

// import '../../configs/widget/button/app_button.dart';
// import '../base/base.dart';
// import 'template_viewmodel.dart';

// class TemplateScreen extends StatefulWidget {
//   const TemplateScreen({super.key});

//   @override
//   State<TemplateScreen> createState() => _TemplateScreenState();
// }

// class _TemplateScreenState extends State<TemplateScreen> {
//   TemplateViewModel? _viewModel;
//   final TextEditingController _passController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return BaseWidget<TemplateViewModel>(
//       viewModel: TemplateViewModel(),
//       onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
//       builder: (context, viewModel, child) {
//         return buildTemplate();
//       },
//     );
//   }

//   Widget buildTemplate() {
//     return SafeArea(
//       top: true,
//       child: Column(
//         children: [
//           // Paragraph(
//           //   content: SplashLanguage.stay,
//           // ),
//           AppButton(
//             isEnable: true,
//             verticalPadding: 10,
//             content: 'Xac nhan',
//             onTap: () {
//               // _viewModel!.checkPassword(_passController.text);
//             },
//           ),
//           AppButton(
//             verticalPadding: 10,
//             content: 'Xac nhan',
//             onTap: () {
//               _viewModel!.checkFullName(_passController.text);
//               _viewModel!.checkEmail(_emailController.text);
//               // _viewModel!.checkLogin();
//               // ScaffoldMessenger.of(context).showSnackBar(
//               //   const SnackBar(content: Text('Processing Data')),
//               // );
//             },
//           ),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(
//                 hintText: "Email Address",
//                 icon: const Icon(
//                   Icons.mail,
//                   color: Colors.blue,
//                 ),
//                 border: const OutlineInputBorder(),
//                 errorText: _viewModel!.isEmail ? null : _viewModel!.errorMail),
//           ),

//           const SizedBox(
//             height: 20,
//           ),

//           TextFormField(
//             controller: _passController,
//             decoration: InputDecoration(
//                 hintText: 'Password',
//                 border: const OutlineInputBorder(),
//                 errorText:
//                     _viewModel!.isFullName ? null : _viewModel!.errorFullName),
//           )
//         ],
//       ),
//     );
//   }
// }
