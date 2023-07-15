import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/dashboard/provider/ghost_porvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class GhostModeBtn extends StatefulWidget {
  const GhostModeBtn({Key? key}) : super(key: key);

  @override
  State<GhostModeBtn> createState() => _GhostModeBtnState();
}

class _GhostModeBtnState extends State<GhostModeBtn> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GhostProvider>(
      builder: (context, ghostMode, b) {
        return IconButton(
          onPressed: () => ghostMode.toggleGhostMode(),
          icon: SvgPicture.asset(
            icGhostMode,
            color: ghostMode.checkGhostMode ? Colors.red : Colors.black,
          ),
        );
      },
    );
  }
}