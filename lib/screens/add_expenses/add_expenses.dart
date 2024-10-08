import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_tracker_app/screens/add_expenses/category_creation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectDate = DateTime.now();
  late Expense expense;
  bool isLoading = false;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          Navigator.pop(context, expense);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // To un-focus when tap outside of text field, wrap the Entire Scaffold with GestureDetector
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
              builder: (context, state) {
            if (state is GetCategoriesSuccess) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Add Expenses",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      // Wrap the TextFormField with SizedBox with a width to take the size of SizedBox
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: expenseController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.dollarSign,
                            size: 18,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    TextFormField(
                      readOnly: true,
                      onTap: () {},
                      controller: categoryController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: expense.category == Category.empty
                            ? Colors.white
                            : Color(expense.category.color),
                        prefixIcon: expense.category == Category.empty
                            ? const Icon(
                                FontAwesomeIcons.list,
                                size: 18,
                                color: Colors.grey,
                              )
                            : Image.asset(
                                'assets/${expense.category.icon}.png',
                                scale: 1.6,
                              ),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              var newCategory = await categoryCreation(context);
                              setState(() {
                                state.categories.insert(0, newCategory);
                              });
                            },
                            icon: Icon(
                              FontAwesomeIcons.plus,
                              size: 18,
                              color: Colors.grey,
                            )),
                        // label: Text("Category"), this label goes up when input clicks
                        hintText: "Category",
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: state.categories.length,
                          itemBuilder: (context, int i) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    expense.category = state.categories[i];
                                    categoryController.text =
                                        expense.category.name;
                                  });
                                },
                                leading: Image.asset(
                                  'assets/${state.categories[i].icon}.png',
                                  scale: 1.5,
                                ),
                                title: Text(state.categories[i].name),
                                tileColor: Color(state.categories[i].color),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: selectDate,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 365)),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );

                        if (newDate != null) {
                          setState(() {
                            dateController.text =
                                DateFormat('dd/MM/yyyy').format(newDate);
                            selectDate = newDate;
                            expense.date = newDate;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.clock,
                          size: 18,
                          color: Colors.grey,
                        ),
                        // label: Text("Category"), this label goes up when input clicks
                        hintText: "Date",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    SizedBox(
                      width: double.infinity,
                      height: kToolbarHeight,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  expense.amount =
                                      int.parse(expenseController.text);
                                  expense.expenseId = const Uuid().v1();
                                });
                                context
                                    .read<CreateExpenseBloc>()
                                    .add(CreateExpense(expense));
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ),
    );
  }
}
