

import 'package:flutter/material.dart';

class MyBomb extends StatelessWidget {
  bool isBombShow;
  final fnction;

  MyBomb({required this.isBombShow, this.fnction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fnction,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: isBombShow ? Colors.grey[800] : Colors.grey[400],
        ),
      ),
    );
  }
}
