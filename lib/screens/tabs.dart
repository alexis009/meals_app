import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/provider/favorites_provider.dart';
import 'package:meals_app/provider/filters_provider.dart';

import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';

import '../widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FilterScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filterMealsProvider);
    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitile = 'Categories';
    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoritesMealProvider);
      activePageTitile = 'Your Favorites';
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitile),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          _selectPage(index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites')
        ],
      ),
    );
  }
}
