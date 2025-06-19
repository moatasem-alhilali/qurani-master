import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';

class WeekdaysPickerWidget extends StatefulWidget {
  const WeekdaysPickerWidget({
    required this.initialSelection,
    required this.onChanged,
    super.key,
  });

  final List<int> initialSelection;
  final ValueChanged<List<int>> onChanged;

  @override
  State<WeekdaysPickerWidget> createState() => _WeekdaysPickerWidgetState();
}

class _WeekdaysPickerWidgetState extends State<WeekdaysPickerWidget>
    with TickerProviderStateMixin {
  late List<int> selected;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final weekDays = [7, 1, 2, 3, 4, 5, 6]; // الأحد...السبت
  final weekLabels = [
    'أحد',
    'اثنين',
    'ثلاثاء',
    'أربعاء',
    'خميس',
    'جمعة',
    'سبت'
  ];

  @override
  void initState() {
    super.initState();
    selected = List<int>.from(widget.initialSelection);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.date_range,
                size: 20.sp,
                color: Colors.green[700],
              ),
              SizedBox(width: 8.w),
              Text(
                'اختر أيام الأسبوع',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Weekdays Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 2.5,
            ),
            itemCount: 7,
            itemBuilder: (context, index) {
              final day = weekDays[index];
              final isSelected = selected.contains(day);
              final isFriday = day == 5; // الجمعة

              return AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isSelected ? _scaleAnimation.value : 1.0,
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () => _toggleDay(day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isFriday ? Colors.green : context.primaryScheme)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? (isFriday ? Colors.green : context.primaryScheme)
                            : Colors.grey.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: (isFriday
                                        ? Colors.green
                                        : context.primaryScheme)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weekLabels[index],
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                            ),
                          ),
                          if (isFriday && isSelected) ...[
                            SizedBox(height: 2.h),
                            Icon(
                              Icons.mosque,
                              size: 12.sp,
                              color: Colors.white,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          if (selected.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Text(
                'المحدد: ${selected.map(_getArabicDayName).join('، ')}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          // Quick Selection Buttons
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickButton(
                'كل يوم',
                Icons.select_all,
                _selectAll,
              ),
              _buildQuickButton(
                'أيام العمل',
                Icons.work,
                _selectWorkdays,
              ),
              _buildQuickButton(
                'عطلة',
                Icons.weekend,
                _selectWeekend,
              ),
              _buildQuickButton(
                'مسح',
                Icons.clear,
                _clearAll,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: Colors.grey[600],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDay(int day) {
    setState(() {
      if (selected.contains(day)) {
        selected.remove(day);
      } else {
        selected.add(day);
      }
      widget.onChanged(selected);
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _selectAll() {
    setState(() {
      selected = List<int>.from(weekDays);
      widget.onChanged(selected);
    });
  }

  void _selectWorkdays() {
    setState(() {
      selected = [1, 2, 3, 4, 7]; // اثنين إلى خميس + أحد
      widget.onChanged(selected);
    });
  }

  void _selectWeekend() {
    setState(() {
      selected = [5, 6]; // الجمعة والسبت
      widget.onChanged(selected);
    });
  }

  void _clearAll() {
    setState(() {
      selected.clear();
      widget.onChanged(selected);
    });
  }

  String _getArabicDayName(int day) {
    switch (day) {
      case 1:
        return 'الاثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      default:
        return '؟';
    }
  }
}
