import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Responsividad
import 'package:provider/provider.dart'; // Estado con Provider
import 'package:tudespensa/Utils/validators.dart';
import 'package:tudespensa/provider/auth_provider.dart'; // Nuestro Provider personalizado
import 'package:tudespensa/constants.dart'; // Colores
import 'package:tudespensa/pages/goal_page.dart'; // pagina a la que se navega
import 'package:tudespensa/widgets/auth/auth_banner.dart'; // Widget del banner
import 'package:tudespensa/widgets/auth/auth_botton.dart'; // Widget del boton
import 'package:tudespensa/widgets/auth/auth_input.dart'; // Widget del input
import 'package:tudespensa/widgets/logo_empresa.dart'; // pagina a la que se navega

class RegisterVerifyPage extends StatelessWidget {
  final String email;
  RegisterVerifyPage({super.key, required this.email});

  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final screenHeight = MediaQuery.of(context).size.height;
    final iskeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true, // Hace scroll hacia abajo si el teclado aparece
          child: Column(
            children: [
              if (!iskeyboard)
                AuthBanner(
                  height: screenHeight * 0.35, // 35% de la pantalla
                  backgroundImagePath:
                      'assets/images/login.png', // Imagen de fondo
                ),
              SizedBox(height: 20.h),
              // Formulario
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Código enviado a: $email",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Input para el código
                    Container(
                      color: Colors.white,
                      width: 350.w,
                      height: 50.h,
                      child: AuthInput(
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        label: "Codigo",
                        validator: codeValidator,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Input para el nombre de usuario
                    Container(
                      color: Colors.white,
                      width: 350.w,
                      height: 50.h,
                      child: AuthInput(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        label: "Nombre de usuario",
                        validator: userNameValidator,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Input para la contraseña
                    Container(
                      color: Colors.white,
                      width: 350.w,
                      height: 50.h,
                      child: AuthInput(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        label: "Contraseña",
                        validator: passwordValidator,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botón para registrarse
                    AuthButton(
                      text: "Registrarse",
                      isLoading: authProvider
                          .isLoading, // Cambia el texto a "Cargando..." si está cargando
                      onPressed: () async {
                        final success = await authProvider.verifyRegisterCode(
                          email: email,
                          codigo: codeController.text.trim(),
                          username: nameController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => GoalPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Error al verificar código"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 30.h),
                    LogoEmpresa(),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
