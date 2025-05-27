import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoEmpresa extends StatelessWidget {
  const LogoEmpresa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Los Kollingas",
          style: TextStyle(fontSize: 14.sp), // ✅ Responsivo
        ),
        SizedBox(width: 15.w),
        Image.asset(
          "assets/images/logo_empresa.png",
          height: 45.h,
          width: 45.w,
        )
      ],
    );
  }
}
