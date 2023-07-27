import 'package:flutter/material.dart';

import '../../widgets/primary_Appbar.dart';

class ForumsScreen extends StatelessWidget {
  const ForumsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: 'Forums', elevation: 0.1),
      body: Column(
        children: const [],
      ),
    );
  }
}
