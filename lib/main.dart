import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'components/tab_controller.dart';
import 'components/pages/extra_pages/about_us.dart';
import 'components/pages/extra_pages/contacts.dart';
import 'components/pages/extra_pages/courses.dart';
import 'components/pages/extra_pages/instructors.dart';
import 'components/pages/extra_pages/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.system,
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (dummyCtx) => const TabsControllerScreen(),
        '/contacts': (dummyCtx) => const Contacts(),
        '/navigation': (dummyCtx) => const Navigation(),
        '/courses': (dummyCtx) => const Courses(),
        '/instructors': (dummyCtx) => const Instructors(),
        '/aboutUs': (dummyCtx) => const AboutUs(),
      },
    );
  }
}
