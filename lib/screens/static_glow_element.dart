import 'package:flutter/material.dart';

class StaticGlowElement extends StatelessWidget {
  const StaticGlowElement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.6),
                blurRadius: 20,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Text("hello world", style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
