import 'package:flutter/material.dart';

/// Bolalar rejimi uchun maxsus mo'ljallangan fon va freym vidjeti
class ChildModeScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  const ChildModeScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF0F4FF),
              Color(0xFFE8F5E9),
              Color(0xFFFFF8E1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
