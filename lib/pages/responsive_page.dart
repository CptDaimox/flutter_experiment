import 'package:flutter/material.dart';
import 'package:flutter_experiment/responsive/desktop_scaffold.dart';
import 'package:flutter_experiment/responsive/mobile_scaffold.dart';
import 'package:flutter_experiment/responsive/responsive_layout.dart';
import 'package:flutter_experiment/responsive/tablet_scaffold.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: DesktopScaffold());
  }
}
