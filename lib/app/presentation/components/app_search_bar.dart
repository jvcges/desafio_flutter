import 'package:desafio_flutter/core/Theme/app_colors.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final Function(String value) searchFunction;
  final TextEditingController textController;
  const AppSearchBar({
    super.key,
    required this.searchFunction,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF707079).withOpacity(0.32),
            offset: const Offset(1, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        keyboardType: TextInputType.number,
        cursorColor: AppColors.primaryColor,
        inputFormatters: [TextInputMask(mask: "99999-999")],
        decoration: const InputDecoration(
          hintText: 'Buscar',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15.0),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          searchFunction(value);
        },
        onTap: () {
          if (textController.text.isEmpty) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          }
        },
      ),
    );
  }
}
