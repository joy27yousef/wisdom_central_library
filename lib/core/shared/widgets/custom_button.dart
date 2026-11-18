import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

class CustomButton extends StatefulWidget {
  final Color color;
  final void Function() ontapfun;
  final String text;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.color,
    required this.ontapfun,
    required this.text,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _BoxtextState();
}

class _BoxtextState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isLoading ? null : widget.ontapfun,
      borderRadius: AppConsts.raduisMain,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: 45,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: AppConsts.raduisMain,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    widget.text,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,

                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),

                if (widget.isLoading)
                  Positioned.fill(
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment(-1.0 + 2 * _controller.value, 0),
                          end: Alignment(1.0 + 2 * _controller.value, 0),
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.3),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          stops: const [0.35, 0.5, 0.65],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
