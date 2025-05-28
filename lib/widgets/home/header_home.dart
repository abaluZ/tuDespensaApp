import 'package:flutter/material.dart';
import 'package:tudespensa/pages/user_page.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset('assets/images/logo.png', width: 65, height: 65),
              const SizedBox(width: 10),
              const Text(
                "Tu\nDespensa",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Stack(
              children: [
                Image.asset('assets/images/icon.png', width: 68, height: 68),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.yellow.shade100,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
