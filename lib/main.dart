import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/Utils/preferences.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/wellcome_page.dart';
import 'package:tudespensa/provider/auth_provider.dart';
import 'package:tudespensa/provider/gender_provider.dart';
import 'package:tudespensa/provider/goal_provider.dart';
import 'package:tudespensa/provider/information_provider.dart';
import 'package:tudespensa/provider/ingredient_provider.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/provider/shopping_list_provider.dart';
import 'package:tudespensa/provider/type_diet_provider.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(create: (_) => InformationProvider()),
        ChangeNotifierProvider(create: (_) => GenderProvider()),
        ChangeNotifierProvider(create: (_) => TypeDietProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (context) => IngredientProvider()),
      ],
      child: ScreenUtilInit(
        designSize: Size(390, 844), // Tamaño base (como iPhone 13)
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          title: 'Tu Despensa',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: BackgroundColor,
            scaffoldBackgroundColor: BackgroundColor,
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('es', ''), // Español
            Locale('en', ''), // Inglés
          ],
          home: WellcomePage(),
        ),
      ),
    );
  }
}
