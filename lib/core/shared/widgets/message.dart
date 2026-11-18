import 'dart:async';
import 'package:flutter/material.dart';

OverlayEntry? _currentOverlayEntry;
Timer? _overlayTimer;

void showMessage(
  BuildContext context, {
  required String message,
  bool isSuccess = true,
  bool isInfo = false,
  Duration duration = const Duration(seconds: 3),
}) {
  if (!context.mounted) return;

  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;

  // إغلاق أي رسالة سابقة فوراً قبل عرض الجديدة
  _overlayTimer?.cancel();
  _currentOverlayEntry?.remove();
  _currentOverlayEntry = null;

  final Color accentColor;
  final Color backgroundColor;
  final IconData icon;

  if (isInfo) {
    accentColor = const Color(0xFF2F80ED);
    backgroundColor = const Color(0xFFF0F6FF);
    icon = Icons.info_rounded;
  } else if (isSuccess) {
    accentColor = const Color(0xFF27AE60);
    backgroundColor = const Color(0xFFEEF9F1);
    icon = Icons.check_circle_rounded;
  } else {
    accentColor = const Color(0xFFEB5757);
    backgroundColor = const Color(0xFFFFF2F2);
    icon = Icons.error_rounded;
  }

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (ctx) => _TopToastWidget(
      message: message,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      icon: icon,
      onDismiss: () {
        _overlayTimer?.cancel();
        if (_currentOverlayEntry == entry) {
          entry.remove();
          _currentOverlayEntry = null;
        }
      },
    ),
  );

  _currentOverlayEntry = entry;
  overlay.insert(entry);

  _overlayTimer = Timer(duration, () {
    if (_currentOverlayEntry == entry) {
      entry.remove();
      _currentOverlayEntry = null;
    }
  });
}

class _TopToastWidget extends StatefulWidget {
  final String message;
  final Color accentColor;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onDismiss;

  const _TopToastWidget({
    required this.message,
    required this.accentColor,
    required this.backgroundColor,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) < 0) {
                  widget.onDismiss();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: widget.accentColor.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.accentColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF2D3748),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
