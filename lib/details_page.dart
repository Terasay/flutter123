import 'package:flutter/material.dart';

class FoodDetailsArgs {
  const FoodDetailsArgs({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.rating,
    this.prepTime = '10 Min',
    this.totalTime = '30 Min',
    this.servings = '2',
    this.recommendedText = 'Recommended !',
    this.steps = const <String>[],
  });

  final String title;
  final String description;
  final String imagePath;
  final double rating;
  final String prepTime;
  final String totalTime;
  final String servings;
  final String recommendedText;
  final List<String> steps;
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.food});

  final FoodDetailsArgs food;

  @override
  Widget build(BuildContext context) {
    final recipe = _resolveRecipe(food);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F1F1),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        titleSpacing: 0,
        title: const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DishHeaderCard(food: food, recipe: recipe),
              const SizedBox(height: 10),
              _SectionCard(
                title: 'Description',
                child: Text(
                  recipe.description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.28,
                    color: Color(0xFF5D5D5D),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _SectionCard(
                title: 'Steps',
                child: Column(
                  children: List.generate(recipe.steps.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == recipe.steps.length - 1 ? 0 : 10,
                      ),
                      child: _StepTile(
                        number: index + 1,
                        text: recipe.steps[index],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ResolvedRecipe _resolveRecipe(FoodDetailsArgs food) {
    final normalized = food.title.toLowerCase();

    if (normalized.contains('matsutake')) {
      return _ResolvedRecipe(
        description:
            'Matsutake goose liver is a delicate dish combining fragrant '
            'matsutake mushroom and rich goose liver. The mushroom brings an '
            'earthy aroma, while the liver is soft, buttery, and smooth.',
        prepTime: food.prepTime,
        totalTime: food.totalTime,
        servings: food.servings,
        recommendedText: food.recommendedText,
        steps: food.steps.isNotEmpty
            ? food.steps
            : const [
                'Prepare matsutake sauce: chop fresh matsutake and gently saute '
                    'with butter. Add stock and reduce into a smooth sauce.',
                'Pan-fry foie gras slices over medium heat for about 2-3 minutes '
                    'per side until lightly golden and soft inside.',
                'Plate and finish: place foie gras on a warm plate, spoon over '
                    'the matsutake sauce, and garnish with seasonal herbs.',
              ],
      );
    }

    final genericSteps = food.steps.isNotEmpty
        ? food.steps
        : [
            'Prepare all ingredients for ${food.title.toLowerCase()} and season '
                'them gently with salt and pepper.',
            'Cook over medium heat until the main ingredients are tender and the '
                'flavors are fully blended.',
            'Plate carefully, adjust seasoning, and serve while warm.',
          ];

    return _ResolvedRecipe(
      description: food.description,
      prepTime: food.prepTime,
      totalTime: food.totalTime,
      servings: food.servings,
      recommendedText: food.recommendedText,
      steps: genericSteps,
    );
  }
}

class _DishHeaderCard extends StatelessWidget {
  const _DishHeaderCard({required this.food, required this.recipe});

  final FoodDetailsArgs food;
  final _ResolvedRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageWidth = (constraints.maxWidth * 0.44).clamp(120.0, 176.0);
          final imageHeight = imageWidth * 0.78;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1,
                            color: Color(0xFFF0C112),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recipe.recommendedText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4E6EDC),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _MetaStat(
                                label: 'Prep',
                                value: recipe.prepTime,
                              ),
                            ),
                            Expanded(
                              child: _MetaStat(
                                label: 'Total',
                                value: recipe.totalTime,
                              ),
                            ),
                            Expanded(
                              child: _MetaStat(
                                label: 'Servings',
                                value: recipe.servings,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: imageWidth,
                      height: imageHeight,
                      child: Image.asset(
                        food.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return const ColoredBox(
                            color: Color(0xFFE6E6E6),
                            child: Center(
                              child: Icon(Icons.fastfood_rounded, size: 42),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      food.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _RatingStars(rating: food.rating),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetaStat extends StatelessWidget {
  const _MetaStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFFC88D44),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF454545),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF373737),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE35050), width: 2),
            color: const Color(0xFFFFF7F7),
          ),
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE35050),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.25,
              color: Color(0xFF555555),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starPosition = index + 1;
        if (rating >= starPosition) {
          return const Icon(
            Icons.star_rounded,
            size: 17,
            color: Color(0xFFF0CA18),
          );
        }
        if (rating >= starPosition - 0.5) {
          return const Icon(
            Icons.star_half_rounded,
            size: 17,
            color: Color(0xFFF0CA18),
          );
        }
        return const Icon(
          Icons.star_border_rounded,
          size: 17,
          color: Color(0xFFF0CA18),
        );
      }),
    );
  }
}

class _ResolvedRecipe {
  const _ResolvedRecipe({
    required this.description,
    required this.prepTime,
    required this.totalTime,
    required this.servings,
    required this.recommendedText,
    required this.steps,
  });

  final String description;
  final String prepTime;
  final String totalTime;
  final String servings;
  final String recommendedText;
  final List<String> steps;
}
