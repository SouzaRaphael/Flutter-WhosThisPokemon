import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackClick;
  final List<Widget>? actions;

  const Header({
    super.key,
    this.showBackButton = false,
    this.onBackClick,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        spacing: 10,
        children: [
          SizedBox(
            height: 35, 
            child: Image.asset("assets/images/pokeball_selected.png")
          ),
          Text("Quem é esse pokemon?", style: Theme.of(context).textTheme.bodyLarge,)
        ],
      ),
      leading: showBackButton
          ? IconButton(
              onPressed: onBackClick ?? () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              tooltip: "Voltar",
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}