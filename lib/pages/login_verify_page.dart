import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Responsividad
import 'package:provider/provider.dart'; // Estado con Provider
import 'package:tudespensa/Utils/validators.dart';
import 'package:tudespensa/pages/home_page.dart'; // pagina a la que se navega
import 'package:tudespensa/provider/auth_provider.dart'; // Nuestro Provider personalizado
import 'package:tudespensa/constants.dart'; // Colores
import 'package:tudespensa/provider/profile_provider.dart'; // Provider para el perfil
import 'package:tudespensa/widgets/auth/auth_banner.dart';
import 'package:tudespensa/widgets/auth/auth_botton.dart';
import 'package:tudespensa/widgets/auth/auth_input.dart';
import 'package:tudespensa/widgets/logo_empresa.dart'; // Banner widget

class LoginVerifyPage extends StatelessWidget {
  final String email;
  LoginVerifyPage({super.key, required this.email});

  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
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
                    Container(
                      color: Colors.white,
                      width: 350.w,
                      height: 50.h,
                      child: AuthInput(
                        controller: passwordController,
                        keyboardType: TextInputType.number,
                        label: "Contraseña",
                        validator: passwordValidator,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AuthButton(
                      text: "Verificar y Entrar",
                      isLoading: authProvider.isLoading,
                      onPressed: () async {
                        final success = await authProvider.verifyLoginCode(
                          email: email,
                          codigo: codeController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        print("Verificación de código completada: $success");
                        if (success) {
                          print("Intentando obtener perfil de usuario...");
                          final response = await profileProvider.fetchUserProfile();
                          print("Respuesta del perfil: $response");
                          if (response != null) {
                            print("Navegando a HomePage...");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomePage()),
                            );
                          } else {
                            print("Error al cargar perfil: ${profileProvider.errorMessage}");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(profileProvider.errorMessage ?? "Error al cargar el perfil"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          print("Error en la verificación del código");
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
