import 'package:flutter/material.dart';

class AdminStatsCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final int delay;

  const AdminStatsCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.delay,
  }) : super(key: key);

  @override
  State<AdminStatsCard> createState() => _AdminStatsCardState();
}

class _AdminStatsCardState extends State<AdminStatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_isHovered ? 0.05 : 0)
              ..rotateY(_isHovered ? -0.05 : 0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(
                      ((_isHovered ? 0.9 : 0.6) * 255).round(),
                      0x1A,
                      0x23,
                      0x32,
                    ),
                    Color.fromARGB(
                      ((_isHovered ? 0.8 : 0.5) * 255).round(),
                      0x0F,
                      0x14,
                      0x19,
                    ),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.color.withAlpha(
                    ((_isHovered ? 0.6 : 0.3) * 255).round(),
                  ),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withAlpha(
                      ((_isHovered ? 0.4 : 0.1) * 255).round(),
                    ),
                    blurRadius: _isHovered ? 30 : 15,
                    spreadRadius: _isHovered ? 5 : 0,
                    offset: Offset(0, _isHovered ? 10 : 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.color.withAlpha(
                                ((_isHovered ? 0.3 : 0.2) * 255).round(),
                              ),
                              widget.color.withAlpha(
                                ((_isHovered ? 0.2 : 0.1) * 255).round(),
                              ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.color.withAlpha((0.4 * 255).round()),
                          ),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.color,
                          size: _isHovered ? 28 : 24,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _isHovered ? 1 : 0,
                        child: Icon(
                          Icons.arrow_outward,
                          color: widget.color.withAlpha((0.6 * 255).round()),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: widget.color.withAlpha(
                                (0.3 * 255).round(),
                              ),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: widget.color.withAlpha((0.8 * 255).round()),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
