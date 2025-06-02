import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar Provider
import 'package:tudespensa/Utils/validators.dart'; // Los validadores de los inputs
import 'package:tudespensa/constants.dart'; // Colores
import 'package:tudespensa/pages/home_page.dart'; // Página a la que se navegará
import 'package:tudespensa/provider/gender_provider.dart';
import 'package:tudespensa/provider/information_provider.dart'; // Importar el provider de información
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/widgets/buttons/gender_button.dart';
import 'package:tudespensa/widgets/buttons/information_button.dart'; // Widget del botón de información
import 'package:tudespensa/widgets/information/date_input.dart'; // Widget del campo de fecha
import 'package:tudespensa/widgets/information/information_banner.dart'; // Widget del banner
import 'package:tudespensa/widgets/information/information_input.dart'; // Widget de los inputs de información
import 'package:tudespensa/widgets/logo_empresa.dart'; // Widget del logo de la empresa

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  DateTime? selectedDate;

  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final estaturaController = TextEditingController();
  final pesoController = TextEditingController();
  final edadController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nombreController.dispose();
    apellidosController.dispose();
    estaturaController.dispose();
    pesoController.dispose();
    edadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final genderProvider = Provider.of<GenderProvider>(context);
    final profileProvider = context.watch<ProfileProvider>();
    final provider = Provider.of<InformationProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isKeyboard)
              // Widget para el banner
              InformationBanner(),
            SizedBox(height: 30),
            Text("Información",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 25),
            if (!isKeyboard)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Ingresa tus datos para poder ayudarte en tu objetivo.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    InformationInput(
                      controller: nombreController,
                      keyboardType: TextInputType.text,
                      label: "Nombre",
                      hintText: "Ej: Jose Pedro",
                      validator: nameValidator,
                    ),
                    SizedBox(height: 20),
                    InformationInput(
                      controller: apellidosController,
                      keyboardType: TextInputType.text,
                      label: "Apellidos",
                      hintText: "Ej: Balmaceda Pascal",
                      validator: lastnameValidator,
                    ),
                    SizedBox(height: 20),
                    InformationInput(
                      controller: estaturaController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      label: "Estatura (m)",
                      hintText: "Ej: 1.67",
                      validator: statureValidator,
                    ),
                    SizedBox(height: 20),
                    InformationInput(
                      controller: pesoController,
                      keyboardType: TextInputType.number,
                      label: "Peso",
                      hintText: "Ej: 70.5 kg",
                      validator: weightValidator,
                    ),
                    SizedBox(height: 20),
                    BirthdayField(
                      controller: edadController,
                      validator: birthdayValidator,
                      onDateChanged: (pickedDate) {
                        selectedDate = pickedDate;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GenderButton(
                          title: "Masculino",
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          icon: Icons.man_2_rounded,
                          value: true,
                          onTap: () {
                            genderProvider.changeGender(true);
                          },
                        ),
                        SizedBox(width: 10),
                        GenderButton(
                          title: "Femenino",
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          icon: Icons.woman_2_rounded,
                          value: false,
                          onTap: () {
                            genderProvider.changeGender(false);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            provider.isLoading
                ? CircularProgressIndicator()
                : InformationButton(
                    onSave: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await provider.saveInformation(
                          nombreController.text,
                          apellidosController.text,
                          estaturaController.text,
                          pesoController.text,
                          selectedDate?.toIso8601String() ?? '',
                          genderProvider.genderAsText!,
                        );
                        if (success) {
                          final profileSuccess =
                              await profileProvider.fetchUserProfile();
                          print(profileProvider.userModel);
                          if (profileSuccess != null && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()),
                            );
                            return true;
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Error al cargar el perfil"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            return false;
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Error al guardar la información"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          return false;
                        }
                      }
                      return false;
                    },
                    buttonText: "Siguiente",
                    isLoading: provider.isLoading,
                    formKey: _formKey,
                    backgroundColor: Naranja,
                  ),
            SizedBox(height: 30),
            // Widget para el logo de la empresa
            LogoEmpresa(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
