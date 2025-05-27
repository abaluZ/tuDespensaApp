import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar Provider
import 'package:tudespensa/Utils/validators.dart'; // Los validadores de los inputs
import 'package:tudespensa/constants.dart'; // Colores
import 'package:tudespensa/pages/home_page.dart'; // Página a la que se navegará
import 'package:tudespensa/provider/information_provider.dart'; // Importar el provider de información
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
  final generoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nombreController.dispose();
    apellidosController.dispose();
    estaturaController.dispose();
    pesoController.dispose();
    edadController.dispose();
    generoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
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
                    InformationInput(
                      controller: generoController,
                      keyboardType: TextInputType.text,
                      label: "Género",
                      hintText: "Masculino/Femenino",
                      validator: genderValidator,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            provider.isLoading
                ? CircularProgressIndicator()
                : InformationButton(
                    onSave: () => provider.saveInformation(
                      nombreController.text,
                      apellidosController.text,
                      estaturaController.text,
                      pesoController.text,
                      edadController.text,
                      generoController.text,
                    ),
                    nextPage: const HomePage(),
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
