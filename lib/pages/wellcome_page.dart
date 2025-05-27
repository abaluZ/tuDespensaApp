import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Para que sea "responsivo" y se adapte a diferentes pantallas
import 'package:tudespensa/constants.dart'; // Para los colores
// Pages
import 'package:tudespensa/pages/login_request_page.dart';
import 'package:tudespensa/pages/register_request_page.dart';
// Widgets
import 'package:tudespensa/widgets/banners/wellcome_banner.dart';
import 'package:tudespensa/widgets/buttons/wellcome_button.dart';
import 'package:tudespensa/widgets/logo_empresa.dart';

class WellcomePage extends StatelessWidget {
  const WellcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen con el nombre y el logo de la empresa
            WellcomeBanner(),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(38.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15.h),
                  // Texto de bienvenida
                  Text(
                    "Cocina fácil, come inteligente",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25.h),
                  // BOTONES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // BOTON DE REGISTRO
                      // utilizando el widget WellcomeButton
                      WellcomeButton(
                        title: "Registrarse",
                        textColor: Colors.black,
                        color: Naranja,
                        destination: RegisterRequestPage(),
                      ),
                      SizedBox(width: 10.w),
                      // BOTON DE LOGEO
                      WellcomeButton(
                        title: "Iniciar sesión",
                        textColor: Colors.white,
                        color: Verde,
                        destination: LoginRequestPage(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  LogoEmpresa()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
