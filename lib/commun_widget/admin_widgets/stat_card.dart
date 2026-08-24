import 'package:flutter/material.dart';
import '../../cor/app_colors.dart'; 

class StatCard extends StatelessWidget {
  final String title;          
  final String value;          
  final IconData icon;         
  final bool isHighlighted;    

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.isHighlighted,
    super.key,
  }) ;

  
  @override
Widget build(BuildContext context) {
  return Container(
    width: 110, 
    height: 110, 
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isHighlighted ? Colors.white : AppColors.greenPrimary.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isHighlighted ? AppColors.orangeSecondary.withValues(alpha: 0.3) : Colors.transparent,
        width: 1.5,),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, color: isHighlighted ? AppColors.orangeSecondary : AppColors.greenPrimary, size: 35),
        // textDirection ou maxLines pour éviter les retours à la ligne brusques
       Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

         Center(
            child: Text(
              value, 
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
         ),
      ],
    ),
  );
}

}
