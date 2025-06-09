import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/icon_personalizado.dart';
import 'package:tudespensa/pages/buy_premium_page.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final benefits = [
      {
        'icon': Icons.stars_rounded,
        'color': Colors.amber[700],
        'text': 'Acceso ilimitado a recetas generadas por IA.'
      },
      {
        'icon': Icons.history_edu_rounded,
        'color': Colors.deepPurple,
        'text': 'Historial completo de tus recetas y compras.'
      },
      {
        'icon': Icons.picture_as_pdf_rounded,
        'color': Colors.redAccent,
        'text': 'Descarga reportes PDF personalizados.'
      },
      {
        'icon': Icons.lock_open_rounded,
        'color': Colors.green[700],
        'text': 'Desbloquea todas las funciones avanzadas.'
      },
      {
        'icon': Icons.support_agent_rounded,
        'color': Colors.blue[700],
        'text': 'Soporte prioritario y novedades exclusivas.'
      },
    ];

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
            // Encabezado visual
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
            SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Text(
                    '¡Lleva tu experiencia al siguiente nivel!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Hazte premium y accede a funciones exclusivas que te ayudarán a organizar tu despensa, planificar tus comidas y aprovechar al máximo la inteligencia artificial. ¡No te pierdas de todo lo que tenemos para ti!',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Beneficios de ser Premium:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 12),
                  ...benefits.map((b) => Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.07),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(b['icon'] as IconData, color: b['color'] as Color?, size: 32),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                b['text'] as String,
                                style: TextStyle(fontSize: 15, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompraPage(),
                      ),
                    );
                  },
                  child: Text('Ver nuestros planes'),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
