import 'package:flutter/material.dart';

class HomeTypesPage extends StatelessWidget {
  const HomeTypesPage({
    super.key,
    required this.categoryTitle,
    required this.heroImagePath,
  });

  final String categoryTitle;
  final String heroImagePath;

  @override
  Widget build(BuildContext context) {
    final dishes = _dishesForCategory(
      categoryTitle: categoryTitle,
      heroImagePath: heroImagePath,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F0F0),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leadingWidth: 42,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        title: Text(
          categoryTitle,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFD8D8D8)),
        ),
      ),
      body: SafeArea(top: false, child: _WaterfallFoodGrid(dishes: dishes)),
    );
  }

  List<_FoodTileData> _dishesForCategory({
    required String categoryTitle,
    required String heroImagePath,
  }) {
    final lowerCaseCategory = categoryTitle.toLowerCase();

    if (lowerCaseCategory == 'pastries') {
      return [
        _FoodTileData(
          title: 'Croissant',
          imagePath: heroImagePath,
          imageHeight: 176,
        ),
        const _FoodTileData(
          title: 'Brioche',
          imagePath: 'assets/images/brioche.jpg',
          imageHeight: 164,
        ),
        const _FoodTileData(
          title: 'Baguette',
          imagePath: 'assets/images/Baguette.png',
          imageHeight: 196,
        ),
        const _FoodTileData(
          title: 'Quiche Lorraine',
          imagePath: 'assets/images/Quiche Lorraine.jpg',
          imageHeight: 160,
        ),
        const _FoodTileData(
          title: 'Pain Brie',
          imagePath: 'assets/images/Pain Brie.jpg',
          imageHeight: 182,
        ),
        const _FoodTileData(
          title: 'La Galette',
          imagePath: 'assets/images/La Galette.jpg',
          imageHeight: 170,
        ),
      ];
    }

    if (lowerCaseCategory == 'soups') {
      return [
        _FoodTileData(
          title: 'Pumpkin soup',
          imagePath: heroImagePath,
          imageHeight: 178,
        ),
        const _FoodTileData(
          title: 'French onion soup',
          imagePath: 'assets/images/French Onion Soup.jpg',
          imageHeight: 168,
        ),
        const _FoodTileData(
          title: 'Provence tomato soup',
          imagePath: 'assets/images/Provence tomato soup.jpg',
          imageHeight: 195,
        ),
        const _FoodTileData(
          title: 'French vegetable soup',
          imagePath: 'assets/images/French vegetable beef soup.jpg',
          imageHeight: 162,
        ),
        const _FoodTileData(
          title: 'Onion gratinee',
          imagePath: 'assets/images/French Onion Soup.jpg',
          imageHeight: 184,
        ),
      ];
    }

    return [
      const _FoodTileData(
        title: 'Basque chicken stew',
        imagePath: 'assets/images/Basque chicken stew.jpg',
        imageHeight: 160,
      ),
      _FoodTileData(
        title: 'Burgundy beef',
        imagePath: heroImagePath,
        imageHeight: 188,
      ),
      const _FoodTileData(
        title: 'French snail',
        imagePath: 'assets/images/FrenchSnail.jpg',
        imageHeight: 206,
      ),
      const _FoodTileData(
        title: 'Cassoulet',
        imagePath: 'assets/images/Cassoulet.jpg',
        imageHeight: 150,
      ),
      const _FoodTileData(
        title: 'Duck confit',
        imagePath: 'assets/images/Duck confit.jpg',
        imageHeight: 172,
      ),
      const _FoodTileData(
        title: 'Beef tartare',
        imagePath: 'assets/images/Beef tartare.jpg',
        imageHeight: 170,
      ),
    ];
  }
}

class _WaterfallFoodGrid extends StatelessWidget {
  const _WaterfallFoodGrid({required this.dishes});

  final List<_FoodTileData> dishes;

  @override
  Widget build(BuildContext context) {
    final splitColumns = _splitInColumns(dishes);
    final leftColumn = splitColumns[0];
    final rightColumn = splitColumns[1];

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftColumn
                  .map((dish) => _FoodCardItem(dish: dish))
                  .toList(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: rightColumn
                  .map((dish) => _FoodCardItem(dish: dish))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<List<_FoodTileData>> _splitInColumns(List<_FoodTileData> dishes) {
    final left = <_FoodTileData>[];
    final right = <_FoodTileData>[];
    var leftHeight = 0.0;
    var rightHeight = 0.0;

    for (final dish in dishes) {
      final estimatedCardHeight = dish.imageHeight + 56;
      if (leftHeight <= rightHeight) {
        left.add(dish);
        leftHeight += estimatedCardHeight;
      } else {
        right.add(dish);
        rightHeight += estimatedCardHeight;
      }
    }

    return [left, right];
  }
}

class _FoodCardItem extends StatelessWidget {
  const _FoodCardItem({required this.dish});

  final _FoodTileData dish;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDADADA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: dish.imageHeight,
              child: Image.asset(
                dish.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const ColoredBox(
                    color: Color(0xFFE3E3E3),
                    child: Center(
                      child: Icon(
                        Icons.fastfood_rounded,
                        size: 34,
                        color: Color(0xFF7D7D7D),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
              child: Text(
                dish.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 28, color: Color(0xFF525252)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodTileData {
  const _FoodTileData({
    required this.title,
    required this.imagePath,
    required this.imageHeight,
  });

  final String title;
  final String imagePath;
  final double imageHeight;
}
