import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';

class MyDhikrCardWidget extends StatefulWidget {
  const MyDhikrCardWidget({
    required this.subih,
    required this.count,
    required this.onTap,
    required this.onReset,
    super.key,
    this.onEdit,
    this.onDelete,
    this.useAnimatedTasbih = false,
  });
  final SubihModel subih;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onReset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool useAnimatedTasbih;

  @override
  State<MyDhikrCardWidget> createState() => _MyDhikrCardWidgetState();
}

class _MyDhikrCardWidgetState extends State<MyDhikrCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showActionMenu(BuildContext context) {
    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      color: context.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      items: [
        if (widget.onEdit != null)
          PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: context.primaryScheme,
                ),
                SizedBox(width: 12.w),
                Text(
                  'تعديل',
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        PopupMenuItem<String>(
          value: 'reset',
          child: Row(
            children: [
              const Icon(
                Icons.refresh_rounded,
                size: 20,
                color: Colors.orange,
              ),
              SizedBox(width: 12.w),
              Text(
                'إعادة تعيين',
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (widget.onDelete != null)
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                const Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: Colors.red,
                ),
                SizedBox(width: 12.w),
                Text(
                  'حذف',
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
      ],
    ).then((value) {
      switch (value) {
        case 'edit':
          widget.onEdit?.call();
        case 'reset':
          widget.onReset();
        case 'delete':
          widget.onDelete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: CardWidget(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                child: Column(
                  children: [
                    // Header with action menu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title with enhanced styling
                              Text(
                                widget.subih.title,
                                style: context.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                  color: context.primaryScheme,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 4.h),
                              // Content preview
                              Text(
                                widget.subih.content,
                                style: context.bodyMedium?.copyWith(
                                  color: FxColors.gray1,
                                  fontSize: 14.sp,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Action menu button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () => _showActionMenu(context),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: context.primaryScheme.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                Icons.more_vert_rounded,
                                color: context.primaryScheme,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
