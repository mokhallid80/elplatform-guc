import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guc_swiss_knife/services/route_observer_service.dart';
import '../models/category.dart';
import '../models/post.dart';
import '../managers/lost_and_founds_manager.dart';
import '../components/posts/posts.dart';
import '../components/categories/category_icon.dart';
import '../components/categories/categories.dart';

import '../services/posts_service.dart';
import '../components/toast/toast.dart';

import '../components/utils/no_content.dart';

class LostAndFoundsPage extends StatefulWidget {
  const LostAndFoundsPage({super.key});

  @override
  State<LostAndFoundsPage> createState() => _LostAndFoundsPageState();
}

class _LostAndFoundsPageState extends State<LostAndFoundsPage> {
  final PostsService _postsService = PostsService();

  late List<Category> categories;
  List<Category> selectedCategories = [];

  late List<Category> categoriesChoices;
  List<Category> selectedCategoriesChoices = [];

  var categoriesMap = LostAndFoundsManager().categoriesMap;

  DateTime? latestPostTimestamp;
  bool hasNewPosts = false;

  bool answeredOnly = false;

  @override
  void initState() {
    RouteObserverService().logUserActivity('/lost_and_founds');
    super.initState();
    categories = categoriesMap.entries.map((entry) {
      return Category(
        name: entry.value.name,
        icon: CategoryIcon(icon: entry.value.icon),
        addCategory: addCategory,
        removeCategory: removeCategory,
      );
    }).toList();

    categoriesChoices = categoriesMap.entries.map((entry) {
      return Category(
        name: entry.value.name,
        icon: CategoryIcon(icon: entry.value.icon),
        addCategory: addCategory,
        removeCategory: removeCategory,
      );
    }).toList();

    setState(() {
      categories[0].selected = true;
      categoriesChoices[0].selected = true;
    });
  }

  void addCategory(Category c, bool asFilter) {
    setState(() {
      if (asFilter) {
        selectedCategories.clear();
        if (c.name.toLowerCase() != "all") {
          selectedCategories.add(c);
        }
        categories.forEach((element) {
          element.selected = false;
        });
        c.selected = true;
      }
    });

    // categories.forEach((element) {
    //   print(element.name + " " + element.selected.toString());
    // });
    // selectedCategories.forEach((element) {
    //   print("SS " + element.name + " " + element.selected.toString());
    // });
  }

  void removeCategory(Category c, bool asFilter) {
    setState(() {
      if (asFilter) {
        selectedCategories.remove(c);
        if (selectedCategories.isEmpty) {
          categories[0].selected = true;
          addCategory(categories[0], asFilter);
        }
      }
    });
  }

  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _postsService.getPosts('lost_and_founds'),
      builder: (context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            DateTime? newestPostTimestamp = snapshot.data?.first.dateCreated;
            if (latestPostTimestamp == null) {
              latestPostTimestamp = newestPostTimestamp;
            } else if (newestPostTimestamp != null &&
                newestPostTimestamp.isAfter(latestPostTimestamp!)) {
              // New post received - Show toast
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Toast.show(context, "New posts available", "info", onTap: () {
                  // Any additional action on tap
                  scrollToTop();
                }, icon: FontAwesomeIcons.arrowUp);
              });
              latestPostTimestamp = newestPostTimestamp;
            }
          }
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Retrieve posts and filter them based on selected categories
        List<Post> allPosts = snapshot.data ?? [];
        List<Post> filteredPosts = selectedCategories.isEmpty
            ? allPosts
            : allPosts.where((post) {
                return selectedCategories.any((category) =>
                    post.category.toLowerCase() == category.name.toLowerCase());
              }).toList();
        if (answeredOnly) {
          filteredPosts = filteredPosts.where((post) {
            return post.resolved == false;
          }).toList();
        }

        if (snapshot.data!.isNotEmpty) {
          return Column(
            children: [
              Categories(
                  key: UniqueKey(), categories: categories, asFilter: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Losts Only",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Switch(
                    value: answeredOnly,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (bool value) {
                      setState(() {
                        answeredOnly = value;
                      });
                    },
                  ),
                ],
              ),
              if (filteredPosts.isNotEmpty)
                Expanded(
                  child: Posts(
                    posts: filteredPosts,
                    selectedCategories: selectedCategories,
                    controller: _scrollController,
                    collection: "lost_and_founds",
                  ),
                ),
              if (!filteredPosts.isNotEmpty)
                const NoContent(text: "No Posts Available")
            ],
          );
        } else {
          return const NoContent(text: "No Posts Available");
        }
      },
    );
  }
}
