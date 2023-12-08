import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class GhostModeBtn extends StatefulWidget {
  const GhostModeBtn({super.key});

  @override
  State<GhostModeBtn> createState() => _GhostModeBtnState();
}

class _GhostModeBtnState extends State<GhostModeBtn> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, ghostMode, b) {
        return IconButton(
          onPressed: () => ghostMode.toggleGhostMode(),
          icon: SvgPicture.asset(
            icGhostMode,
            color: ghostMode.checkGhostMode ? colorPrimaryA05 : Colors.black,
          ),
        );
      },
    );
  }
}
