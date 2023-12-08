import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GhostScaffold extends StatelessWidget {
  const GhostScaffold(
      {super.key,
      required this.appBar,
      required this.body,
      this.floatingActionButtonAnimator,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.backgroundColor});
  final AppBar appBar;
  final Widget body;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: Consumer<DashboardProvider>(
        builder: (context, ghost, b) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Container(
                decoration: ghost.checkGhostMode
                    ? BoxDecoration(
                        border: Border.all(
                          width: 2.5,
                          color: colorPrimaryA05,
                        ),
                      )
                    : null,
                child: body),
          );
        },
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
