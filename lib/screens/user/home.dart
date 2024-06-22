import 'package:flutter/material.dart';
import 'package:synctours/widgets/custom_app_bar.dart';
import 'package:synctours/widgets/custom_drawer.dart';
import 'package:synctours/widgets/destination_card.dart';
import 'package:synctours/widgets/trending_card.dart';
import 'package:synctours/widgets/recent_search_item.dart';
import 'package:synctours/widgets/section_title.dart';
import 'package:synctours/utils/image_utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Container(
        color: Colors.grey[100],
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Where to in Kenya?',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SectionTitle(title: 'Featured Destinations in Kenya'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final destinations = [
                      'Nairobi',
                      'Maasai Mara',
                      'Mombasa',
                      'Mount Kenya'
                    ];
                    return DestinationCard(
                        title: destinations[index],
                        subtitle: 'Explore the beauty of Kenya',
                        imageUrl: getDestinationImage(index));
                  },
                  childCount: 4,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SectionTitle(title: 'Trending in Kenya'),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 150.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final trendingPlaces = [
                      'Nairobi National Park',
                      'Diani Beach',
                      'Amboseli National Park',
                      'Tsavo National Park',
                      'Lake Nakuru'
                    ];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TrendingCard(
                        title: trendingPlaces[index],
                        imageUrl: getTrendingImage(index),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SectionTitle(title: 'Recent Searches'),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    RecentSearchItem(query: 'Nairobi'),
                    RecentSearchItem(query: 'Mombasa'),
                    RecentSearchItem(query: 'Maasai Mara'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
