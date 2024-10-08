import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_app/screens/add_expenses/add_expenses.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_tracker_app/screens/home/views/main_screen.dart';
import 'package:expense_tracker_app/screens/stats/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  Color selectedColor = const Color(0xFF00B2E7);
  Color unselectedColor = Colors.black38;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: index == 0 ? MainScreen() : StaticScreen(),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              index = value;
              // Because on pressing bottom navigation it give value as 0,1
            });
          },
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.home,
                  color: index == 0 ? selectedColor : unselectedColor,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.graph_square_fill,
                  color: index == 1 ? selectedColor : unselectedColor,
                ),
                label: "Stats")
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => CreateCategoryBloc(
                      FirabaseExpenseRepo(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => GetCategoriesBloc(
                      FirabaseExpenseRepo(),
                    )..add(GetCategories()),
                  )
                ],
                child: const AddExpenses(),
              ),
            ),
          );
        },
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
              transform: const GradientRotation(pi / 4),
            ),
          ),
          child: const Icon(
            CupertinoIcons.add,
          ),
        ),
        shape: CircleBorder(),
      ),
    );
  }
}
