import 'package:flutter/material.dart';

class JellyButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  const JellyButton({
    super.key,
    required this.title,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  State<JellyButton> createState() => _JellyButtonState();
}

class _JellyButtonState extends State<JellyButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) {
        setState(() => pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(pressed ? 0.93 : 1.0),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          gradient: LinearGradient(
            colors: pressed
                ? widget.colors.reversed.toList()
                : widget.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: pressed ? 5 : 12,
              offset: Offset(0, pressed ? 3 : 8),
            ),
          ],
        ),

        child: Stack(
          children: [

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 18,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}