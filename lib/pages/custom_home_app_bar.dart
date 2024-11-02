import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:observer/analytics_page.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + kTextTabBarHeight);  // تعيين ارتفاع AppBar مع TabBar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Align(
        alignment: Alignment.center,
        child: Text('الجدول الأسبوعي'),
      ),
      bottom: TabBar(
        tabs: [
          Tab(text: 'الفرائض'),
          Tab(text: 'السنن'),
        ],
        indicatorColor: const Color.fromARGB(255, 7, 28, 148),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        unselectedLabelColor: const Color.fromARGB(179, 6, 46, 14),
        labelColor: const Color.fromARGB(255, 7, 28, 148),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.analytics),
          onPressed: () {
            Get.to(() => AnalyticsPage());
          },
        ),
      ],
    );
  }
}
