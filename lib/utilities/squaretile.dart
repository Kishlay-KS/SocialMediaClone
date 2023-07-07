import 'package:flutter/material.dart';
import 'package:instagram_clone/utilities/colors.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16),
        color: mobileBackgroundColor,
      ),
      child: Image.asset(
        imagePath,
        height: 70,
      ),
    );
  }
}
