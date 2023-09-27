import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:flutter/material.dart';

import '../../widgets/primary_Appbar.dart';

class ForumsScreen extends StatelessWidget {
  const ForumsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GhostScaffold(
      appBar: primaryAppbar(
        title: 'Forums',
        elevation: 0.1,
        leading: const GhostModeBtn(),
      ),
      body: const Center(
        child: Text('Forum Screen'),
      ),
    );
  }
}
