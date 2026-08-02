import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Ota-onalar paneli rejimi uchun freym vidjeti
class ParentModeScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const ParentModeScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181824),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222232),
        elevation: 0,
        centerTitle: false,
        title: Text(
          title,
          style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
        ),
        actions: actions,
      ),
      body: Container(
        color: const Color(0xFF181824),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: body,
          ),
        ),
      ),
    );
  }
}
