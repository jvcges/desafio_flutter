import 'package:desafio_flutter/core/Theme/app_colors.dart';
import 'package:desafio_flutter/shared/constants/app_icons.dart';
import 'package:desafio_flutter/shared/extensions/e_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onTapIndex;
  final int currentIndex;
  const CustomBottomNavigationBar({
    super.key,
    required this.onTapIndex,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                onTapIndex(0);
              },
              child: CBottomNavigationItem(
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
                child: CBottomNavigationItem(
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
    );
  }
}

class CBottomNavigationItem extends StatelessWidget {
  final bool isSelected;
  final String svgPath;
  final String title;
  const CBottomNavigationItem({
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
