import 'package:flutter/material.dart';

class FlyingBookAnimation {
  static void run({
    required BuildContext context,
    required GlobalKey startKey,
    required GlobalKey targetKey,
    required String coverUrl,
    required VoidCallback onComplete,
  }) {
    final RenderBox? startBox =
        startKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? targetBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;

    if (startBox == null || targetBox == null) {
      onComplete();
      return;
    }

    final startOffset = startBox.localToGlobal(Offset.zero);
    final targetOffset = targetBox.localToGlobal(Offset.zero);

    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _FlyingBookWidget(
          startOffset: startOffset,
          targetOffset: targetOffset,
          coverUrl: coverUrl,
          onEnd: () {
            overlayEntry?.remove();
            onComplete();
          },
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);
  }
}

class _FlyingBookWidget extends StatefulWidget {
  final Offset startOffset;
  final Offset targetOffset;
  final String coverUrl;
  final VoidCallback onEnd;

  const _FlyingBookWidget({
    required this.startOffset,
    required this.targetOffset,
    required this.coverUrl,
    required this.onEnd,
  });

  @override
  State<_FlyingBookWidget> createState() => _FlyingBookWidgetState();
}

class _FlyingBookWidgetState extends State<_FlyingBookWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _positionAnimation =
        Tween<Offset>(
          begin: widget.startOffset,
          end: widget.targetOffset,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.25), weight: 70),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _controller.forward().then((_) => widget.onEnd());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        // حركة قوسية للأعلى (Parabolic Arc) أثناء الطيران
        final arcY = -70 * (1 - (2 * progress - 1) * (2 * progress - 1));
        final currentPos = _positionAnimation.value;

        return Positioned(
          left: currentPos.dx,
          top: currentPos.dy + arcY,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 55,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.coverUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
