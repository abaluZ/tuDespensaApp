import 'package:flutter/material.dart';

class AppBarDespensa extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final VoidCallback onBack;
  final VoidCallback onAvatarTap;
  final String logoPath;
  final String avatarPath;
  final String? titleText; // ✅ Título opcional

  const AppBarDespensa({
    Key? key,
    required this.backgroundColor,
    required this.onBack,
    required this.onAvatarTap,
    required this.logoPath,
    required this.avatarPath,
    this.titleText, // ✅ Lo añadimos al constructor
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
      title: titleText != null
          ? Text(
              titleText!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  logoPath,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Despensa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Stack(
              children: [
                Image.asset(
                  avatarPath,
                  width: 45,
                  height: 45,
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.yellow.shade100,
                      onTap: onAvatarTap,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
