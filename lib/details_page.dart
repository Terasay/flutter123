import 'package:flutter/material.dart';

class FoodDetailsArgs {
  const FoodDetailsArgs({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.rating,
  });

  final String title;
  final String description;
  final String imagePath;
  final double rating;
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.food});

  final FoodDetailsArgs food;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(food.title)),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(
              food.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const ColoredBox(
                  color: Color(0xFFE5E5E5),
                  child: Icon(Icons.fastfood, size: 58),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFF0CA18),
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      food.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  food.description,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.3,
                    color: Color(0xFF5E5E5E),
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
