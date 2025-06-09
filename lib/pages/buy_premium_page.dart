import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/icon_personalizado.dart';
import 'package:http/http.dart' as http;
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompraPage extends StatefulWidget {
  const CompraPage({super.key});

  @override
  State<CompraPage> createState() => _CompraPageState();
}

class _CompraPageState extends State<CompraPage> {
  int selectedPlan = 0; // 0: ninguno, 1: mensual, 2: anual

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double mensual = 20.0;
    final double anual = (mensual * 12 * 0.9).roundToDouble(); // 10% de descuento
    final double anualMensual = (anual / 12);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Image.asset(
                'assets/images/premium.png',
                width: double.infinity,
                height: screenHeight * 0.28,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tu Despensa",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "PREMIUM",
                      style: TextStyle(
                        color: Colors.amber[800],
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  _buildPlanCard(
                    title: 'Plan Mensual',
                    price: 'Bs ${mensual.toStringAsFixed(2)}',
                    subtitle: 'Pago mensual',
                    selected: selectedPlan == 1,
                    icon: Icons.emoji_events_rounded,
                    onTap: () => setState(() => selectedPlan = 1),
                  ),
                  SizedBox(height: 18),
                  _buildPlanCard(
                    title: 'Plan Anual',
                    price: 'Bs ${anual.toStringAsFixed(2)}',
                    subtitle: 'Equivale a Bs ${anualMensual.toStringAsFixed(2)}/mes',
                    selected: selectedPlan == 2,
                    icon: Icons.workspace_premium_rounded,
                    onTap: () => setState(() => selectedPlan = 2),
                    badge: 'Ahorra 10%',
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPlan == 0 ? Colors.grey[400] : Colors.amber[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 2,
                  ),
                  onPressed: selectedPlan == 0 ? null : () {
                    double monto = selectedPlan == 1 ? mensual : anual;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MetodoPagoPage(monto: monto, plan: selectedPlan == 1 ? 'Mensual' : 'Anual'),
                      ),
                    );
                  },
                  child: Text('Continuar'),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String subtitle,
    required bool selected,
    required IconData icon,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            decoration: BoxDecoration(
              color: selected ? Colors.amber[50] : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? Colors.amber[800]! : Colors.grey[300]!,
                width: selected ? 2.5 : 1.2,
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.15),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: selected ? Colors.amber[800] : Colors.black54, size: 38),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                      SizedBox(height: 6),
                      Text(price, style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(badge, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetodoPagoPage extends StatefulWidget {
  final double monto;
  final String plan;
  const MetodoPagoPage({super.key, required this.monto, required this.plan});

  @override
  State<MetodoPagoPage> createState() => _MetodoPagoPageState();
}

class _MetodoPagoPageState extends State<MetodoPagoPage> {
  int selectedMethod = 0; // 0: ninguno, 1: tarjeta, 2: qr
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Método de Pago'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Total a pagar: Bs ${widget.monto.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Row(
              children: [
                _buildMethodButton('Tarjeta', Icons.credit_card, 1),
                SizedBox(width: 16),
                _buildMethodButton('QR', Icons.qr_code_2_rounded, 2),
              ],
            ),
            SizedBox(height: 28),
            if (selectedMethod == 1) _buildCardForm(),
            if (selectedMethod == 2) _buildQRSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodButton(String label, IconData icon, int value) {
    final isSelected = selectedMethod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedMethod = value),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber[50] : Colors.white,
            border: Border.all(color: isSelected ? Colors.amber[800]! : Colors.grey[300]!, width: isSelected ? 2.2 : 1.2),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.amber.withOpacity(0.10),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.amber[800] : Colors.black54, size: 36),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.amber[800] : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Número de tarjeta',
              border: OutlineInputBorder(),
            ),
            maxLength: 16,
            validator: (value) {
              if (value == null || value.length != 16) return 'Debe tener 16 dígitos';
              return null;
            },
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'MM/AA',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 5,
                  validator: (value) {
                    if (value == null || !RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})').hasMatch(value)) return 'Formato inválido';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 3,
                  validator: (value) {
                    if (value == null || value.length != 3) return 'Debe tener 3 dígitos';
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nombre en la tarjeta',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Campo requerido';
              return null;
            },
          ),
          SizedBox(height: 22),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _upgradeToPremium(context);
              }
            },
            child: Text('Pagar'),
          ),
        ],
      ),
    );
  }

  Widget _buildQRSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Escanea el código QR para realizar el pago', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 18),
        Center(
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Image.asset('assets/images/qr_placeholder.png', fit: BoxFit.contain),
          ),
        ),
        SizedBox(height: 18),
        Text('Monto: Bs ${widget.monto.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 18),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            await _upgradeToPremium(context);
          },
          icon: Icon(Icons.qr_code_2_rounded),
          label: Text('Ya pagué'),
        ),
      ],
    );
  }

  Future<void> _upgradeToPremium(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No autenticado'), backgroundColor: Colors.red),
      );
      return;
    }
    final url = 'http://192.168.1.5:4000/api/users/upgrade-plan';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // Actualizo el provider de perfil
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.fetchUserProfile();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Ahora eres usuario Premium!'), backgroundColor: Colors.green),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar a Premium: ${response.body}'), backgroundColor: Colors.red),
      );
    }
  }
}
