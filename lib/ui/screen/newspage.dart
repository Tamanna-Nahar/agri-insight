import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project1/models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'RootPage.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  TextEditingController searchController = TextEditingController();
  List<NewsQueryModel> newsModelList = [];
  List<NewsQueryModel> newsModelListCarousel = [];
  List<NewsQueryModel> moreNewsModelList = [];
  List<String> navBarItems = ["Crops", "Crop Management", "Weather Forecasts", "Market Prices", "Pest Control"];
  String selectedCategory = "Crops";

  bool isLoading = true;

  Future<void> _fetchNews(String url, List<NewsQueryModel> list) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          list.clear();
          list.addAll(
            (data["articles"] as List)
                .map((item) => NewsQueryModel.fromMap(item))
                .toList(),
          );
          isLoading = false;
        });
      } else {
        print('Failed to load news: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  void _fetchNewsForCategory(String category) {
    setState(() {
      isLoading = true;
    });
    String query;
    switch (category) {
      case "Crops":
        query = "agriculture";
        break;
      case "Crop Management":
        query = "Crop Management";
        break;
      case "Weather Forecasts":
        query = "Weather Forecasts";
        break;
      case "Market Prices":
        query = "Market Prices";
        break;
      case "Pest Control":
        query = "Pest Control";
        break;
      default:
        query = "agriculture";
    }
    final apiKey = "927a4244a6af4b3abc1c71b38568d169";
    final url = "https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey";

    _fetchNews(url, newsModelList);
    _fetchNews(url, newsModelListCarousel);
    _fetchNews(url, moreNewsModelList);
  }

  @override
  void initState() {
    super.initState();
    _fetchNewsForCategory(selectedCategory);
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => RootPage()),
          ),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: const Text(
          'News',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[400],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildNavBar(),
            _buildCarousel(),
            _buildNewsSection(newsModelList, 'Latest News'),
            _buildNewsSection(moreNewsModelList, 'More News'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.blueAccent,
          ),
          Expanded(
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                final query = Uri.encodeQueryComponent(value.trim());
                if (query.isNotEmpty) {
                  _fetchNews(
                    "https://newsapi.org/v2/everything?q=$query&apiKey=927a4244a6af4b3abc1c71b38568d169",
                    newsModelList,
                  );
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search Agriculture News',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: navBarItems.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedCategory = navBarItems[index];
              });
              _fetchNewsForCategory(navBarItems[index]);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  navBarItems[index],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarousel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16/9,
          viewportFraction: 0.8,
        ),
        items: newsModelListCarousel.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => _launchURL(item.newsUrl),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4.0,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.newsImg,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.black.withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.newsHead,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNewsSection(List<NewsQueryModel> newsList, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _launchURL(newsList[index].newsUrl);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2.0,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            newsList[index].newsImg,
                            fit: BoxFit.cover,
                            height: 180,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  newsList[index].newsHead,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  newsList[index].newsDes.length > 50
                                      ? "${newsList[index].newsDes.substring(0, 55)}...."
                                      : newsList[index].newsDes,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
