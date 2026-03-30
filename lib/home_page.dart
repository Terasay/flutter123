import 'dart:async';

import 'package:flutter/material.dart';

import 'auth/local_auth_db.dart';
import 'details_page.dart';
import 'discover_page.dart';
import 'home_types_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _heroController = PageController(viewportFraction: 0.92);
  Timer? _heroTimer;
  int _heroIndex = 0;
  int _selectedTab = 1;
  final Set<String> _favoriteDishTitles = <String>{};

  final List<_HeroBanner> _heroBanners = const [
    _HeroBanner(imagePath: 'assets/images/Basque chicken stew.jpg'),
    _HeroBanner(imagePath: 'assets/images/Coquilles St Jacques.jpg'),
    _HeroBanner(imagePath: 'assets/images/French Onion Soup.jpg'),
    _HeroBanner(imagePath: 'assets/images/123.jpg'),
  ];

  final List<_FoodCategory> _categories = const [
    _FoodCategory(
      title: 'Main dishes',
      iconPath: 'assets/icons/icon_91.png',
      heroImagePath: 'assets/images/Burgundy beef .jpg',
    ),
    _FoodCategory(
      title: 'Pastries',
      iconPath: 'assets/icons/icon_92.png',
      heroImagePath: 'assets/images/Croissant.jpg',
    ),
    _FoodCategory(
      title: 'Soups',
      iconPath: 'assets/icons/icon_90.png',
      heroImagePath: 'assets/images/Pumpkin Soup.jpg',
    ),
  ];

  final List<FoodDetailsArgs> _popularFood = const [
    FoodDetailsArgs(
      title: 'Matsutake foie gras',
      description:
          'Matsutake and foie gras are mainly made from Matsutake and foie gras, '
          'with a rich and soft taste.',
      imagePath: 'assets/images/Matsutake foie gras.jpg',
      rating: 5.0,
    ),
    FoodDetailsArgs(
      title: 'French onion soup',
      description:
          'A classic onion broth with toasted bread and melted cheese, warm and '
          'comforting for any season.',
      imagePath: 'assets/images/French Onion Soup.jpg',
      rating: 4.8,
    ),
    FoodDetailsArgs(
      title: 'Burgundy beef',
      description:
          'Slow-cooked beef braised in red wine with herbs, carrots and mushroom '
          'for a deep traditional flavor.',
      imagePath: 'assets/images/Burgundy beef_2.jpg',
      rating: 4.9,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startHeroAutoScroll();
    _loadDishFavorites();
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _heroController.dispose();
    super.dispose();
  }

  void _startHeroAutoScroll() {
    _heroTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_heroController.hasClients) {
        return;
      }

      final nextIndex = (_heroIndex + 1) % _heroBanners.length;
      _heroController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onTabPressed(int tabIndex) {
    if (tabIndex == _selectedTab) {
      return;
    }

    setState(() {
      _selectedTab = tabIndex;
    });
  }

  Future<void> _loadDishFavorites() async {
    final favorites = await LocalAuthDb.instance
        .getDishFavoritesForCurrentAccount();
    if (!mounted) {
      return;
    }
    setState(() {
      _favoriteDishTitles
        ..clear()
        ..addAll(favorites);
    });
  }

  void _onFavoriteTap(FoodDetailsArgs food) async {
    final isCurrentlyFavorite = _favoriteDishTitles.contains(food.title);
    setState(() {
      if (isCurrentlyFavorite) {
        _favoriteDishTitles.remove(food.title);
      } else {
        _favoriteDishTitles.add(food.title);
      }
    });

    await LocalAuthDb.instance.setDishFavoriteForCurrentAccount(
      dishTitle: food.title,
      isFavorite: !isCurrentlyFavorite,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            const DiscoverPage(),
            _HomeContent(
              heroController: _heroController,
              heroIndex: _heroIndex,
              heroBanners: _heroBanners,
              categories: _categories,
              popularFood: _popularFood,
              favoriteTitles: _favoriteDishTitles,
              onHeroPageChanged: (index) {
                setState(() {
                  _heroIndex = index;
                });
              },
              onCategoryTap: (category) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => HomeTypesPage(
                      categoryTitle: category.title,
                      heroImagePath: category.heroImagePath,
                    ),
                  ),
                );
              },
              onPopularFoodTap: (food) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DetailsPage(food: food),
                  ),
                );
              },
              onFavoriteTap: _onFavoriteTap,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _HomeBottomNavigation(
        selectedTab: _selectedTab,
        onTabPressed: _onTabPressed,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.heroController,
    required this.heroIndex,
    required this.heroBanners,
    required this.categories,
    required this.popularFood,
    required this.favoriteTitles,
    required this.onHeroPageChanged,
    required this.onCategoryTap,
    required this.onPopularFoodTap,
    required this.onFavoriteTap,
  });

  final PageController heroController;
  final int heroIndex;
  final List<_HeroBanner> heroBanners;
  final List<_FoodCategory> categories;
  final List<FoodDetailsArgs> popularFood;
  final Set<String> favoriteTitles;
  final ValueChanged<int> onHeroPageChanged;
  final ValueChanged<_FoodCategory> onCategoryTap;
  final ValueChanged<FoodDetailsArgs> onPopularFoodTap;
  final ValueChanged<FoodDetailsArgs> onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 190,
            child: PageView.builder(
              physics: const ClampingScrollPhysics(),
              controller: heroController,
              itemCount: heroBanners.length,
              onPageChanged: onHeroPageChanged,
              itemBuilder: (context, index) {
                final banner = heroBanners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      banner.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const ColoredBox(
                          color: Color(0xFFE3E3E3),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 34,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(heroBanners.length, (index) {
                final isActive = index == heroIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 9 : 7,
                  height: isActive ? 9 : 7,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFA7A7A7),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Main categories',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: categories
                  .map(
                    (category) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: InkWell(
                          onTap: () => onCategoryTap(category),
                          borderRadius: BorderRadius.circular(10),
                          child: Ink(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFF6DE8F),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              height: 105,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: Image.asset(
                                      category.iconPath,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) {
                                        return const Icon(
                                          Icons.restaurant_menu_rounded,
                                          size: 32,
                                          color: Color(0xFF676767),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    category.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Popular food',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 386,
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final dish = popularFood[index];
                return _PopularFoodCard(
                  food: dish,
                  isFavorite: favoriteTitles.contains(dish.title),
                  onTap: () => onPopularFoodTap(dish),
                  onFavoriteTap: () => onFavoriteTap(dish),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemCount: popularFood.length,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _PopularFoodCard extends StatelessWidget {
  const _PopularFoodCard({
    required this.food,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final FoodDetailsArgs food;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: SizedBox(
                      height: 228,
                      width: double.infinity,
                      child: Image.asset(
                        food.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return const ColoredBox(
                            color: Color(0xFFE8E8E8),
                            child: Center(
                              child: Icon(Icons.fastfood, size: 42),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            food.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF0CA18),
                              size: 18,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              food.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF595959),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Text(
                      food.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.2,
                        color: Color(0xFF717171),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Material(
              color: Colors.white.withValues(alpha: 0.92),
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: onFavoriteTap,
                splashRadius: 15,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 26,
                  height: 26,
                ),
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite
                      ? const Color(0xFFE24A4A)
                      : const Color(0xFFADADAD),
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBottomNavigation extends StatelessWidget {
  const _HomeBottomNavigation({
    required this.selectedTab,
    required this.onTabPressed,
  });

  final int selectedTab;
  final ValueChanged<int> onTabPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Container(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(maxHeight: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _BottomNavItem(
                icon: Icons.explore_outlined,
                label: 'Discover',
                isSelected: selectedTab == 0,
                onTap: () => onTabPressed(0),
              ),
            ),
            Expanded(
              child: _BottomNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: selectedTab == 1,
                onTap: () => onTabPressed(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        constraints: const BoxConstraints(minHeight: 36),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF6DE8F) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF2A2A2A)),
            if (isSelected) ...[
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2A2A2A),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroBanner {
  const _HeroBanner({required this.imagePath});

  final String imagePath;
}

class _FoodCategory {
  const _FoodCategory({
    required this.title,
    required this.iconPath,
    required this.heroImagePath,
  });

  final String title;
  final String iconPath;
  final String heroImagePath;
}
