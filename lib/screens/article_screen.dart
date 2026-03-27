import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'Semua',
    '🐶 Anjing',
    '🐱 Kucing',
    '🍎 Nutrisi',
    '💉 Vaksin',
  ];

  // Mock Data Artikel (Pure Fabrication)
  final List<Article> _articles = [
    Article(
      title: 'Bahaya Kutu pada Kucing Indoor dan Cara Pencegahannya',
      category: 'Kucing',
      readTime: '4 mnt baca',
      date: '24 Okt 2023',
    ),
    Article(
      title: 'Panduan Transisi Makanan Baru untuk Anjing Sensitif',
      category: 'Nutrisi',
      readTime: '6 mnt baca',
      date: '21 Okt 2023',
    ),
    Article(
      title: 'Jadwal Vaksinasi Wajib Anak Anjing (Puppy) Tahun 2023',
      category: 'Vaksin',
      readTime: '5 mnt baca',
      date: '18 Okt 2023',
    ),
    Article(
      title: 'Mengenal Tanda-tanda Dehidrasi pada Hewan Peliharaan',
      category: 'Semua',
      readTime: '3 mnt baca',
      date: '15 Okt 2023',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: velyTheme.backgroundLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: velyTheme.surfaceWhite.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: velyTheme.textDark,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Artikel Sehat vely',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: velyTheme.textDark,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  color: velyTheme.textDark,
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                },
              ),
            ],
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. HERO SECTION (Featured Article)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: _buildHeroArticle(),
              ),
            ),

            // 2. KATEGORI (Horizontal Scroll)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryChip(index);
                  },
                ),
              ),
            ),

            // 3. DAFTAR ARTIKEL (List View)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildArticleItem(_articles[index]);
                }, childCount: _articles.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Komponen Artikel Unggulan (Hero)
  Widget _buildHeroArticle() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
          image: const DecorationImage(
            image: AssetImage(
              'lib/public/images/golden-retriever.jpg',
            ), // Menggunakan aset yang sudah ada
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.8),
              ],
              stops: const [0.3, 0.6, 1.0],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: velyTheme.primaryTeal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'FEATURED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Mengapa Golden Retriever Sangat Rentan Terhadap Heatstroke?',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '8 mnt baca',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Drh. Amanda',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Komponen Chip Kategori
  Widget _buildCategoryChip(int index) {
    final isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? velyTheme.primaryTeal : velyTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _categories[index],
          style: TextStyle(
            color: isSelected ? Colors.white : velyTheme.textGrey,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // Komponen List Item Artikel
  Widget _buildArticleItem(Article article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigasi ke detail artikel (akan dibuat di fase berikutnya)
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail Kotak
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage(
                      'lib/public/images/chat_bg_portrait.png',
                    ), // Placeholder estetis
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Teks Detail
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: velyTheme.primaryTeal,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: velyTheme.textDark,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          article.date,
                          style: const TextStyle(
                            fontSize: 11,
                            color: velyTheme.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          article.readTime,
                          style: const TextStyle(
                            fontSize: 11,
                            color: velyTheme.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model Data Internal
class Article {
  final String title;
  final String category;
  final String readTime;
  final String date;

  Article({
    required this.title,
    required this.category,
    required this.readTime,
    required this.date,
  });
}
