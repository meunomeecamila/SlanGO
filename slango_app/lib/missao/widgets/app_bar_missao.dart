import 'package:flutter/material.dart';

class AppBarMissao extends StatelessWidget implements PreferredSizeWidget {
  final String? nomeMundo;
  final VoidCallback? onVoltar;

  const AppBarMissao({
    super.key,
    this.nomeMundo,
    this.onVoltar,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        ),
        onPressed: onVoltar ?? () => Navigator.pop(context),
      ),
      title: nomeMundo != null
          ? Text(
              nomeMundo!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          : null,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}