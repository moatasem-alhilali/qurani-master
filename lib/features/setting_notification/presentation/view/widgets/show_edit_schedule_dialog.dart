import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting_notification/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/main.dart';

class ShowEditScheduleDialog extends StatefulWidget {
  const ShowEditScheduleDialog({
    required this.model,
    required this.onSave,
    super.key,
  });
  final NotificationSettingModel model;
  final void Function(NotificationSettingModel updated) onSave;

  @override
  State<ShowEditScheduleDialog> createState() => _ShowEditScheduleDialogState();
}

class _ShowEditScheduleDialogState extends State<ShowEditScheduleDialog>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;

  ScheduleType selectedType = ScheduleType.daily;
  int? hour;
  int? minute;
  int? interval;
  List<int> weekdays = [];
  List<DateTime> customDates = [];
  String? validationError;
  int currentPage = 0;
  final int totalPages = 3;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }

  void _initializeValues() {
    selectedType = widget.model.scheduleType;
    hour = widget.model.hour;
    minute = widget.model.minute;
    interval = widget.model.intervalMinutes;
    weekdays = List<int>.of(widget.model.weekdays ?? []);
    customDates = List<DateTime>.of(widget.model.customDates ?? []);
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _pageController = PageController();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimations() {
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      validationError = null;
      if (selectedType == ScheduleType.daily ||
          selectedType == ScheduleType.weekly) {
        if (hour == null || minute == null) {
          validationError = 'حدد الساعة والدقيقة';
        }
      }
      if (selectedType == ScheduleType.weekly) {
        if (weekdays.isEmpty) {
          validationError = 'حدد يوم واحد على الأقل من الأسبوع';
        }
      }
      if (selectedType == ScheduleType.everyNMinutes) {
        if (interval == null || interval! < 1) {
          validationError = 'أدخل عدد الدقائق (يجب أن يكون أكبر من صفر)';
        }
      }
      if (selectedType == ScheduleType.customDates) {
        if (customDates.isEmpty) {
          validationError = 'أضف تاريخ/وقت واحد على الأقل';
        }
      }
    });
  }

  String formatDate(DateTime dt) => DateFormat('yyyy-MM-dd – HH:mm').format(dt);

  Future<void> onAddCustomDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: context.primaryScheme,
                ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: context.primaryScheme,
                  ),
            ),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        final full = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          customDates.add(full);
        });
      }
    }
  }

  void _nextPage() {
    _validate();
    if (validationError == null && currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveSchedule(BuildContext ctx) {
    _validate();
    if (validationError == null) {
      final updated = widget.model.copyWith(
        scheduleType: selectedType,
        hour: (selectedType == ScheduleType.daily ||
                selectedType == ScheduleType.weekly)
            ? hour
            : null,
        minute: (selectedType == ScheduleType.daily ||
                selectedType == ScheduleType.weekly)
            ? minute
            : null,
        intervalMinutes:
            selectedType == ScheduleType.everyNMinutes ? interval : null,
        weekdays: selectedType == ScheduleType.weekly ? weekdays : null,
        customDates:
            selectedType == ScheduleType.customDates ? customDates : null,
      );

      // Check if widget is still mounted before adding event
      // If BLoC event fails, still call onSave and close dialog manually
      widget.onSave.call(updated);
      if (ctx.mounted) {
        Navigator.of(ctx).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideAnimation, _fadeAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: 500.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildProgressIndicator(),
                  Expanded(child: _buildPageView()),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: List.generate(totalPages, (index) {
          final isActive = index <= currentPage;
          final isCurrent = index == currentPage;

          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(
                right: index < totalPages - 1 ? 8.w : 0,
                left: index > 0 ? 8.w : 0,
              ),
              height: 4.h,
              decoration: BoxDecoration(
                color: isActive
                    ? (isCurrent
                        ? context.primaryScheme
                        : context.primaryScheme.withOpacity(0.5))
                    : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (page) {
        setState(() {
          currentPage = page;
        });
      },
      children: [
        _buildScheduleTypePage(),
        _buildScheduleDetailsPage(),
        _buildSummaryPage(),
      ],
    );
  }

  Widget _buildScheduleTypePage() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر نوع الجدولة',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
          _buildScheduleTypeCard(),
          SizedBox(height: 20.h),
          _buildScheduleTypeDescription(),
        ],
      ),
    );
  }

  Widget _buildScheduleTypeCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: context.primaryScheme.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButton<ScheduleType>(
        value: selectedType,
        isExpanded: true,
        underline: const SizedBox(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: context.primaryScheme,
        ),
        items: ScheduleType.values.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Row(
              children: [
                Icon(
                  _getScheduleTypeIcon(e),
                  color: context.primaryScheme,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  _typeToStr(e),
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (val) => setState(() {
          selectedType = val!;
          if (selectedType == ScheduleType.weekly && weekdays.isEmpty) {
            weekdays = [1];
          }
        }),
      ),
    );
  }

  Widget _buildScheduleTypeDescription() {
    final descriptions = {
      ScheduleType.daily: 'يتم إرسال الإشعار يومياً في نفس الوقت',
      ScheduleType.weekly: 'يتم إرسال الإشعار في أيام محددة من الأسبوع',
      ScheduleType.everyNMinutes: 'يتم إرسال الإشعار كل فترة زمنية محددة',
      ScheduleType.customDates: 'يتم إرسال الإشعار في تواريخ وأوقات مخصصة',
      ScheduleType.hourly: 'يتم إرسال الإشعار كل ساعة',
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.primaryScheme.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.primaryScheme.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.primaryScheme,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              descriptions[selectedType] ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                color: context.primaryScheme,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleDetailsPage() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل الموعد',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            if (selectedType == ScheduleType.daily ||
                selectedType == ScheduleType.weekly)
              _buildTimeSelector(),
            if (selectedType == ScheduleType.everyNMinutes)
              _buildIntervalSelector(),
            if (selectedType == ScheduleType.weekly) ...[
              SizedBox(height: 20.h),
              _buildWeekdaySelector(),
            ],
            if (selectedType == ScheduleType.customDates) ...[
              _buildCustomDatesSection(),
            ],
            if (validationError != null) ...[
              SizedBox(height: 16.h),
              _buildErrorMessage(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وقت الإشعار',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildTimeDropdown(
                  label: 'الساعة',
                  value: hour ?? 0,
                  max: 24,
                  onChanged: (val) => setState(() => hour = val),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildTimeDropdown(
                  label: 'الدقيقة',
                  value: minute ?? 0,
                  max: 60,
                  onChanged: (val) => setState(() => minute = val),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDropdown({
    required String label,
    required int value,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: context.primaryScheme.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButton<int>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: List.generate(max, (i) => i).map((i) {
              return DropdownMenuItem(
                value: i,
                child: Text(
                  i.toString().padLeft(2, '0'),
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
            }).toList(),
            onChanged: (val) => onChanged(val ?? 0),
          ),
        ),
      ],
    );
  }

  Widget _buildIntervalSelector() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(
            'كل',
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 80.w,
            child: TextFormField(
              initialValue: interval?.toString() ?? '5',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
              ),
              onChanged: (v) => setState(() => interval = int.tryParse(v) ?? 5),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'دقيقة',
            style: TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdaySelector() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أيام الأسبوع',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(7, (idx) {
              final day = idx + 1;
              final selected = weekdays.contains(day);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: FilterChip(
                  label: Text(_arabicDayOfWeek(day)),
                  selected: selected,
                  selectedColor: context.primaryScheme.withOpacity(0.2),
                  checkmarkColor: context.primaryScheme,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        weekdays.add(day);
                      } else {
                        weekdays.remove(day);
                      }
                    });
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDatesSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التواريخ المخصصة',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onAddCustomDate,
                icon: Icon(Icons.add, size: 18.sp),
                label: Text('إضافة', style: TextStyle(fontSize: 14.sp)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryScheme,
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (customDates.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Text(
                'لم تقم بإضافة أي تاريخ بعد',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...customDates.asMap().entries.map((entry) {
              final index = entry.key;
              final date = entry.value;
              return AnimatedContainer(
                duration: Duration(milliseconds: 300 + (index * 100)),
                margin: EdgeInsets.only(bottom: 8.h),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: context.primaryScheme,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          formatDate(date),
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            setState(() => customDates.removeAt(index)),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              validationError!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPage() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الإعداد',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
          _buildSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green[700],
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'سيتم تطبيق الإعداد التالي:',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            _generateSummaryText(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: [
          if (currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  side: BorderSide(color: context.primaryScheme),
                ),
                child: Text(
                  'السابق',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: context.primaryScheme,
                  ),
                ),
              ),
            ),
          if (currentPage > 0) SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                currentPage == totalPages - 1
                    ? _saveSchedule(context)
                    : _nextPage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryScheme,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: Text(
                currentPage == totalPages - 1 ? 'حفظ الإعدادات' : 'التالي',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _generateSummaryText() {
    switch (selectedType) {
      case ScheduleType.daily:
        return 'إشعار يومي في الساعة ${hour?.toString().padLeft(2, '0')}:${minute?.toString().padLeft(2, '0')}';
      case ScheduleType.weekly:
        final days = weekdays.map(_arabicDayOfWeek).join('، ');
        return 'إشعار أسبوعي أيام $days في الساعة ${hour?.toString().padLeft(2, '0')}:${minute?.toString().padLeft(2, '0')}';
      case ScheduleType.everyNMinutes:
        return 'إشعار كل $interval دقيقة';
      case ScheduleType.customDates:
        return 'إشعار في ${customDates.length} موعد مخصص';
      case ScheduleType.hourly:
        return 'إشعار كل ساعة عند الدقيقة ${minute ?? 0}';
    }
  }

  IconData _getScheduleTypeIcon(ScheduleType type) {
    switch (type) {
      case ScheduleType.daily:
        return Icons.today;
      case ScheduleType.weekly:
        return Icons.date_range;
      case ScheduleType.everyNMinutes:
        return Icons.timer;
      case ScheduleType.customDates:
        return Icons.event;
      case ScheduleType.hourly:
        return Icons.access_time;
    }
  }
}

String _typeToStr(ScheduleType t) {
  switch (t) {
    case ScheduleType.daily:
      return 'يومي';
    case ScheduleType.hourly:
      return 'كل ساعة';
    case ScheduleType.everyNMinutes:
      return 'كل عدة دقائق';
    case ScheduleType.weekly:
      return 'أسبوعي';
    case ScheduleType.customDates:
      return 'تواريخ مخصصة';
  }
}

String _arabicDayOfWeek(int d) {
  switch (d) {
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
