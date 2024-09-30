import 'package:desafio_flutter/core/Theme/app_colors.dart';
import 'package:desafio_flutter/shared/constants/app_icons.dart';
import 'package:desafio_flutter/shared/extensions/e_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final Function(int) onTapIndex;
  final int currentIndex;
  const AppBottomNavigationBar({
    super.key,
    required this.onTapIndex,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB4B4B4).withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  onTapIndex(0);
                },
                child: AppBottomNavigationItem(
                  isSelected: currentIndex == 0,
                  svgPath: AppIcons.mapPageIcon,
                  title: "Mapa",
                ),
              )),
              Expanded(
                child: InkWell(
                  onTap: () {
                    onTapIndex(1);
                  },
                  child: AppBottomNavigationItem(
                    isSelected: currentIndex == 1,
                    svgPath: AppIcons.savedLocationsPageIcon,
                    title: "Caderneta",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          ),
        ],
      ),
    );
  }
}

class AppBottomNavigationItem extends StatelessWidget {
  final bool isSelected;
  final String svgPath;
  final String title;
  const AppBottomNavigationItem({
    super.key,
    required this.isSelected,
    required this.svgPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SvgPicture.asset(
              fit: BoxFit.none,
              svgPath,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primaryColor : AppColors.secondaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.5,
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
            ),
          ),
        ].addSpacing(
          8,
          direction: Axis.vertical,
        ),
      ),
    );
  }
}
