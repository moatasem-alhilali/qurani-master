import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedule_form_fields.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/weekdays_picker_widget.dart';

// استخدم نفس enum والحقول اللي عرفناها
Future<void> showImprovedScheduleDialog(
  BuildContext context,
  NotificationScheduleCustomModel model,
  void Function(NotificationScheduleCustomModel result) onSave,
) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => _ScheduleDialog(
      model: model,
      onSave: onSave,
    ),
  );
}

class _ScheduleDialog extends StatefulWidget {
  const _ScheduleDialog({
    required this.model,
    required this.onSave,
  });

  final NotificationScheduleCustomModel model;
  final void Function(NotificationScheduleCustomModel result) onSave;

  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final PageController _pageController;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  // Form fields
  late ScheduleType _scheduleType;
  int? _hour;
  int? _minute;
  int? _intervalMinutes;
  List<int> _weekdays = [];
  List<DateTime> _customDates = [];
  String? _label;

  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _pageController = PageController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  void _initializeValues() {
    _scheduleType = widget.model.scheduleType;
    _hour = widget.model.hour;
    _minute = widget.model.minute;
    _intervalMinutes = widget.model.intervalMinutes;
    _weekdays = List<int>.from(widget.model.weekdays ?? []);
    _customDates = List<DateTime>.from(widget.model.customDates ?? []);
    _label = widget.model.label;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.w),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: 500.w,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildProgressIndicator(),
              Expanded(child: _buildPageView()),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryScheme,
            context.primaryScheme.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              widget.model.id == null ? Icons.add_alarm : Icons.edit,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model.id == null ? 'إضافة موعد جديد' : 'تعديل موعد',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'قم بتخصيص موعد الإشعار',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: List.generate(_totalPages, (index) {
          final isActive = index <= _currentPage;
          final isCurrent = index == _currentPage;

          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(
                right: index < _totalPages - 1 ? 8.w : 0,
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
    return Form(
      key: _formKey,
      child: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildScheduleTypePage(),
          _buildScheduleDetailsPage(),
          _buildSummaryPage(),
        ],
      ),
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
          ScheduleTypeDropdown(
            value: _scheduleType,
            onChanged: (type) {
              setState(() {
                _scheduleType = type;
                // Reset related fields when type changes
                _resetFieldsForType(type);
              });
            },
          ),
          SizedBox(height: 20.h),
          _buildScheduleTypeDescription(),
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

            // Conditional fields based on schedule type
            if (_scheduleType == ScheduleType.daily ||
                _scheduleType == ScheduleType.weekly)
              TimePickerFields(
                hour: _hour,
                minute: _minute,
                onHourChanged: (hour) => _hour = hour,
                onMinuteChanged: (minute) => _minute = minute,
              ),

            if (_scheduleType == ScheduleType.weekly) ...[
              SizedBox(height: 20.h),
              WeekdaysPickerWidget(
                initialSelection: _weekdays,
                onChanged: (weekdays) => setState(() => _weekdays = weekdays),
              ),
            ],

            if (_scheduleType == ScheduleType.everyNMinutes)
              IntervalMinutesField(
                value: _intervalMinutes,
                onChanged: (interval) => _intervalMinutes = interval,
              ),

            if (_scheduleType == ScheduleType.customDates)
              _buildCustomDatesPicker(),

            SizedBox(height: 20.h),
            LabelField(
              value: _label,
              onChanged: (label) => _label = label,
            ),
          ],
        ),
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
            'ملخص الموعد',
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
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'السابق',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          if (_currentPage > 0) SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed:
                  _currentPage == _totalPages - 1 ? _saveSchedule : _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryScheme,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                _currentPage == _totalPages - 1 ? 'حفظ' : 'التالي',
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

  // Helper methods for building components
  Widget _buildScheduleTypeDescription() {
    final descriptions = {
      ScheduleType.daily: 'يتم إرسال الإشعار يومياً في نفس الوقت',
      ScheduleType.weekly: 'يتم إرسال الإشعار في أيام محددة من الأسبوع',
      ScheduleType.everyNMinutes: 'يتم إرسال الإشعار كل فترة زمنية محددة',
      ScheduleType.customDates: 'يتم إرسال الإشعار في تواريخ وأوقات مخصصة',
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.primaryScheme.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.primaryScheme.withOpacity(0.3)),
      ),
      child: Text(
        descriptions[_scheduleType] ?? '',
        style: TextStyle(
          fontSize: 14.sp,
          color: context.primaryScheme,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildCustomDatesPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التواريخ المخصصة',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        // Add custom dates picker implementation
        // This is simplified - you can expand it based on your needs
        ElevatedButton.icon(
          onPressed: _addCustomDate,
          icon: const Icon(Icons.add),
          label: const Text('إضافة تاريخ'),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'سيتم إنشاء الموعد التالي:',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.green[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _generateSummaryText(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  void _resetFieldsForType(ScheduleType type) {
    switch (type) {
      case ScheduleType.daily:
        _weekdays.clear();
        _intervalMinutes = null;
        _customDates.clear();
      case ScheduleType.weekly:
        _intervalMinutes = null;
        _customDates.clear();
      case ScheduleType.everyNMinutes:
        _hour = null;
        _minute = null;
        _weekdays.clear();
        _customDates.clear();
      case ScheduleType.customDates:
        _hour = null;
        _minute = null;
        _weekdays.clear();
        _intervalMinutes = null;
      case ScheduleType.hourly:
        _hour = null;
        _minute = null;
        _weekdays.clear();
        _customDates.clear();
    }
  }

  void _nextPage() {
    if (_validateCurrentPage()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        return true; // Schedule type is always valid
      case 1:
        return _validateScheduleDetails();
      case 2:
        return true; // Summary page
      default:
        return false;
    }
  }

  bool _validateScheduleDetails() {
    switch (_scheduleType) {
      case ScheduleType.daily:
        return _hour != null && _minute != null;
      case ScheduleType.weekly:
        return _hour != null && _minute != null && _weekdays.isNotEmpty;
      case ScheduleType.everyNMinutes:
        return _intervalMinutes != null && _intervalMinutes! > 0;
      case ScheduleType.customDates:
        return _customDates.isNotEmpty;
      case ScheduleType.hourly:
        return _hour != null && _minute != null;
    }
  }

  String _generateSummaryText() {
    switch (_scheduleType) {
      case ScheduleType.daily:
        return 'إشعار يومي في الساعة ${_hour?.toString().padLeft(2, '0')}:${_minute?.toString().padLeft(2, '0')}';
      case ScheduleType.weekly:
        final days = _weekdays.map(_getArabicDayName).join('، ');
        return 'إشعار أسبوعي أيام $days في الساعة ${_hour?.toString().padLeft(2, '0')}:${_minute?.toString().padLeft(2, '0')}';
      case ScheduleType.everyNMinutes:
        return 'إشعار كل $_intervalMinutes دقيقة';
      case ScheduleType.customDates:
        return 'إشعار في ${_customDates.length} موعد مخصص';
      default:
        return '';
    }
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

  void _addCustomDate() {
    // Implement custom date picker
    // This is a placeholder - implement based on your needs
  }

  void _saveSchedule() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى التأكد من صحة جميع البيانات'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    final result = widget.model.copyWith(
      scheduleType: _scheduleType,
      hour: _hour,
      minute: _minute,
      intervalMinutes: _intervalMinutes,
      weekdays: _weekdays.isNotEmpty ? _weekdays : null,
      customDates: _customDates.isNotEmpty ? _customDates : null,
      label: _label,
    );

    Navigator.pop(context);
    widget.onSave(result);
  }
}
