import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskController extends GetxController {
  var fardTaskCompletionStatus = List.generate(7, (index) => List<bool>.filled(5, false)).obs;
  var sunnahTaskCompletionStatus = List.generate(7, (index) => List<bool>.filled(5, false)).obs;
  var isLoading = true.obs; // مؤشر التحميل

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  bool isTaskCompleted(bool isFard, int dayIndex, int taskIndex) {
    return isFard
        ? fardTaskCompletionStatus[dayIndex][taskIndex]
        : sunnahTaskCompletionStatus[dayIndex][taskIndex];
  }

  void toggleTaskCompletion(bool isFard, int dayIndex, int taskIndex, bool isCompleted) {
    if (isFard) {
      fardTaskCompletionStatus[dayIndex][taskIndex] = isCompleted;
      fardTaskCompletionStatus.refresh(); // تحديث الواجهة بشكل صحيح
    } else {
      sunnahTaskCompletionStatus[dayIndex][taskIndex] = isCompleted;
      sunnahTaskCompletionStatus.refresh(); // تحديث الواجهة بشكل صحيح
    }
    saveTasks(isFard);
  }

  bool isDateInFuture(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime comparedDate = DateTime(date.year, date.month, date.day); // تجاهل التوقيت والتعامل مع التواريخ فقط
    return comparedDate.isAfter(today);
  }

  void saveTasks(bool isFard) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      isFard ? 'fardTaskCompletionStatus' : 'sunnahTaskCompletionStatus',
      jsonEncode(isFard ? fardTaskCompletionStatus : sunnahTaskCompletionStatus),
    );
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final fardStatus = prefs.getString('fardTaskCompletionStatus');
    if (fardStatus != null) {
      fardTaskCompletionStatus.value = List<List<bool>>.from(
        jsonDecode(fardStatus).map((item) => List<bool>.from(item))
      );
    }

    final sunnahStatus = prefs.getString('sunnahTaskCompletionStatus');
    if (sunnahStatus != null) {
      sunnahTaskCompletionStatus.value = List<List<bool>>.from(
        jsonDecode(sunnahStatus).map((item) => List<bool>.from(item))
      );
    }

    isLoading.value = false; // إخفاء مؤشر التحميل بعد تحميل البيانات
  }
}
