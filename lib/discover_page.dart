import 'package:flutter/material.dart';

import 'auth/local_auth_db.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final PageController _controller = PageController(viewportFraction: 0.84);
  final Set<String> _favoriteChefs = <String>{};

  final List<_ChefData> _chefs = const [
    _ChefData(
      name: 'Alain Ducasse',
      rating: 4.0,
      specialty: 'Classic Reinvented',
      city: 'Paris',
      intro:
          'His grasp of detail is outstanding, and every dish he cooks is like '
          'a meticulously crafted work of art. Guests often say his plates feel '
          'both luxurious and deeply comforting at the same time.',
      dishImagePath: 'assets/images/CHOUCROUTE.jpg',
      avatarImagePath: 'assets/images/image_1.jpg',
    ),
    _ChefData(
      name: 'Anne-Sophie Pic',
      rating: 4.7,
      specialty: 'Elegant Balance',
      city: 'Valence',
      intro:
          'She combines precision and emotion, creating elegant plates where '
          'textures and aromas stay in perfect balance. Her menu flows like a '
          'story, from delicate openings to rich and memorable finishes.',
      dishImagePath: 'assets/images/Coquilles St Jacques.jpg',
      avatarImagePath: 'assets/images/image_2.jpg',
    ),
    _ChefData(
      name: 'Guy Savoy',
      rating: 4.5,
      specialty: 'Modern Heritage',
      city: 'Lyon',
      intro:
          'Every course tells a story of French tradition with a modern twist, '
          'built on pure ingredients and deep flavor. His signature approach '
          'is warm, expressive, and instantly recognizable.',
      dishImagePath: 'assets/images/Burgundy beef_2.jpg',
      avatarImagePath: 'assets/images/image_3.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadChefFavorites();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadChefFavorites() async {
    final favorites = await LocalAuthDb.instance
        .getChefFavoritesForCurrentAccount();
    if (!mounted) {
      return;
    }
    setState(() {
      _favoriteChefs
        ..clear()
        ..addAll(favorites);
    });
  }

  void _toggleFavorite(String chefName) async {
    final isCurrentlyFavorite = _favoriteChefs.contains(chefName);
    setState(() {
      if (isCurrentlyFavorite) {
        _favoriteChefs.remove(chefName);
      } else {
        _favoriteChefs.add(chefName);
      }
    });

    await LocalAuthDb.instance.setChefFavoriteForCurrentAccount(
      chefName: chefName,
      isFavorite: !isCurrentlyFavorite,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'Chef',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD8A913),
            ),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Featured culinary masters',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF8D8D8D),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        const Divider(height: 1, thickness: 1, color: Color(0xFFDADADA)),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardHeight = (constraints.maxHeight * 0.80).clamp(
                360.0,
                500.0,
              );

              return PageView.builder(
                controller: _controller,
                physics: const ClampingScrollPhysics(),
                itemCount: _chefs.length,
                itemBuilder: (context, index) {
                  final chef = _chefs[index];
                  final verticalInset =
                      ((constraints.maxHeight - cardHeight) / 2).clamp(
                        6.0,
                        56.0,
                      );
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      8,
                      verticalInset,
                      8,
                      verticalInset,
                    ),
                    child: _ChefPresentationCard(
                      chef: chef,
                      height: cardHeight,
                      isFavorite: _favoriteChefs.contains(chef.name),
                      onFavoriteTap: () => _toggleFavorite(chef.name),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChefPresentationCard extends StatelessWidget {
  const _ChefPresentationCard({
    required this.chef,
    required this.height,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final _ChefData chef;
  final double height;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final dishHeight = height * 0.38;
    final headerHeight = dishHeight + 38;

    return Center(
      child: SizedBox(
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE9E1D0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: headerHeight,
                      width: double.infinity,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: dishHeight,
                            child: Image.asset(
                              chef.dishImagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return const ColoredBox(
                                  color: Color(0xFFE7E7E7),
                                  child: Center(
                                    child: Icon(
                                      Icons.restaurant_menu_rounded,
                                      size: 40,
                                      color: Color(0xFF7A7A7A),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.30),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: dishHeight - 38,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 76,
                                height: 76,
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    chef.avatarImagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return const ColoredBox(
                                        color: Color(0xFFE4E4E4),
                                        child: Icon(
                                          Icons.person_rounded,
                                          size: 42,
                                          color: Color(0xFF828282),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: dishHeight - 4,
                            right: 12,
                            child: Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              child: IconButton(
                                onPressed: onFavoriteTap,
                                splashRadius: 20,
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints.tightFor(
                                  width: 38,
                                  height: 38,
                                ),
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: isFavorite
                                      ? const Color(0xFFE24A4A)
                                      : const Color(0xFFB0B0B0),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    chef.name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC97A2A),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(child: _ChefRatingRow(rating: chef.rating)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _ChefMetaChip(label: chef.specialty),
                      _ChefMetaChip(label: chef.city),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    chef.intro,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.28,
                      color: Color(0xFF606060),
                    ),
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChefRatingRow extends StatelessWidget {
  const _ChefRatingRow({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final filledStars = rating.floor().clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Padding(
            padding: const EdgeInsets.only(right: 1),
            child: Icon(
              i < filledStars ? Icons.star_rounded : Icons.star_border_rounded,
              size: 19,
              color: const Color(0xFFE2CD12),
            ),
          ),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7480D5),
          ),
        ),
      ],
    );
  }
}

class _ChefMetaChip extends StatelessWidget {
  const _ChefMetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4ECD3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF87631F),
        ),
      ),
    );
  }
}

class _ChefData {
  const _ChefData({
    required this.name,
    required this.rating,
    required this.specialty,
    required this.city,
    required this.intro,
    required this.dishImagePath,
    required this.avatarImagePath,
  });

  final String name;
  final double rating;
  final String specialty;
  final String city;
  final String intro;
  final String dishImagePath;
  final String avatarImagePath;
}
