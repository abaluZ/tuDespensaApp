import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Responsividad
import 'package:provider/provider.dart'; // Estado con Provider
import 'package:tudespensa/Utils/validators.dart'; // el validator que usamos en el input
import 'package:tudespensa/provider/auth_provider.dart'; // Nuestro Provider personalizado
import 'package:tudespensa/pages/register_verify_page.dart'; // pagina a la que se navega
import 'package:tudespensa/constants.dart'; // Colores
import 'package:tudespensa/widgets/auth/auth_banner.dart'; // Widget del banner
import 'package:tudespensa/widgets/auth/auth_botton.dart'; // Widget del boton
import 'package:tudespensa/widgets/auth/auth_input.dart'; // Widget del input
import 'package:tudespensa/widgets/logo_empresa.dart'; // Logo de la empresa

class RegisterRequestPage extends StatelessWidget {
  RegisterRequestPage({super.key});

  // Controlador para manejar el texto del input de correo
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Obtenemos el estado del AuthProvider con Provider
    final authProvider = context.watch<AuthProvider>();
    // Altura de la pantalla (para distribuir elementos)
    final screenHeight = MediaQuery.of(context).size.height;
    // Detecta si el teclado está activo
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true, // Hace scroll hacia abajo si el teclado aparece
          child: Column(
            children: [
              // Imagen de bienvenida si el teclado NO está activo
              if (!isKeyboard)
                AuthBanner(
                  height: screenHeight * 0.35, // 35% de la pantalla
                  backgroundImagePath:
                      'assets/images/login.png', // Imagen de fondo
                ),

              // Zona del formulario
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Registrate",
                        style: TextStyle(
                          fontSize: 24.sp, // se adapta al tamaño de pantalla
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Ingresa tu correo para recibir un código de verificación",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.sp, // se adapta al tamaño de pantalla
                        ),
                      ),
                      SizedBox(height: 25.h),
                      // Campo de correo electrónico
                      Container(
                        color: Colors.white,
                        width: 350.w,
                        height: 50.h,
                        child: AuthInput(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          label: "Correo Electronico",
                          validator: emailValidator,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      // Botón para enviar código
                      AuthButton(
                        text: "Enviar código",
                        isLoading: authProvider.isLoading,
                        onPressed: () async {
                          final success = await authProvider
                              .requestRegisterCode(emailController.text.trim());
                          if (success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterVerifyPage(
                                  email: emailController.text.trim(),
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No se pudo enviar el código"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 40.h),
                      // Pie de página
                      LogoEmpresa(),
                      SizedBox(
                        height: 20.h,
                      ), // Extra espacio por si el teclado está activo
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
