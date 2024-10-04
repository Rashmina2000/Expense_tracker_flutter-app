import 'package:expense_tracker_app/screens/add_expenses/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:expense_repository/expense_repository.dart';
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

  List<String> myCategoryIcons = [
    'entertainment',
    'food',
    'grocery',
    'home',
    'payment',
    'pet',
    'shopping',
    'tax',
    'tech',
    'travel',
    'service'
  ];

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // To un-focus when tap outside of text field, wrap the Entire Scaffold with GestureDetector
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: Padding(
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
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    FontAwesomeIcons.list,
                    size: 18,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (alert) {
                            bool isExpanded = false;
                            String iconSelected = "";
                            Color colorSelected = Colors.white;
                            TextEditingController categoryNameController =
                                TextEditingController();
                            TextEditingController categoryIconController =
                                TextEditingController();
                            TextEditingController categoryColorController =
                                TextEditingController();
                            bool isLoading = false;
                            return BlocProvider.value(
                              value: context.read<CreateCategoryBloc>(),
                              child: BlocListener<CreateCategoryBloc,
                                  CreateCategoryState>(
                                listener: (context, state) {
                                  if (state is CreateCategorySuccess) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.pop(alert);
                                  } else if (state is CreateCategoryLoading) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                  }
                                },
                                child: StatefulBuilder(
                                  builder: (alert, setState) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey.shade100,
                                      title: Text("Create a category"),
                                      content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  categoryNameController,
                                              //readOnly: true,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: "Name",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              onTap: () {
                                                setState(() {
                                                  isExpanded = !isExpanded;
                                                });
                                              },
                                              controller:
                                                  categoryIconController,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: "Icon",
                                                suffixIcon: Icon(CupertinoIcons
                                                    .chevron_down),
                                                border: OutlineInputBorder(
                                                  borderRadius: isExpanded
                                                      ? BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              10),
                                                        )
                                                      : BorderRadius.circular(
                                                          10),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                            isExpanded
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 200,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        bottom:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: GridView.builder(
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            mainAxisSpacing: 5,
                                                            crossAxisSpacing: 5,
                                                            crossAxisCount: 3,
                                                          ),
                                                          itemCount:
                                                              myCategoryIcons
                                                                  .length,
                                                          itemBuilder:
                                                              (context, int i) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  iconSelected =
                                                                      myCategoryIcons[
                                                                          i];
                                                                });
                                                              },
                                                              child: Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    width: iconSelected ==
                                                                            myCategoryIcons[i]
                                                                        ? 5
                                                                        : 2,
                                                                    color: iconSelected ==
                                                                            myCategoryIcons[
                                                                                i]
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .grey,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/${myCategoryIcons[i]}.png'),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  )
                                                : Container(),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              controller:
                                                  categoryColorController,
                                              readOnly: true,
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return AlertDialog(
                                                        backgroundColor: Colors
                                                            .grey.shade100,
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            ColorPicker(
                                                              pickerColor:
                                                                  colorSelected,
                                                              onColorChanged:
                                                                  (Color
                                                                      value) {
                                                                setState(() {
                                                                  colorSelected =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height:
                                                                  kToolbarHeight,
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      ctx);
                                                                },
                                                                child: Text(
                                                                  "Save",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              },
                                              decoration: InputDecoration(
                                                isDense: true,
                                                filled: true,
                                                fillColor: colorSelected,
                                                hintText: "Color",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              height: kToolbarHeight,
                                              child: isLoading == true
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : TextButton(
                                                      onPressed: () {
                                                        Category category =
                                                            Category.empty;
                                                        category.categoryId =
                                                            const Uuid().v1();
                                                        category.name =
                                                            categoryNameController
                                                                .text;
                                                        category.icon =
                                                            iconSelected;
                                                        category.color =
                                                            colorSelected
                                                                .toString();
                                                        context
                                                            .read<
                                                                CreateCategoryBloc>()
                                                            .add(CreateCategory(
                                                                category));
                                                        //Navigator.pop(alert);
                                                        //create category
                                                      },
                                                      child: Text(
                                                        "Save",
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        FontAwesomeIcons.plus,
                        size: 18,
                        color: Colors.grey,
                      )),
                  // label: Text("Category"), this label goes up when input clicks
                  hintText: "Category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
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
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );

                  if (newDate != null) {
                    setState(() {
                      dateController.text =
                          DateFormat('dd/MM/yyyy').format(newDate);
                      selectDate = newDate;
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
                child: TextButton(
                  onPressed: () {},
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
        ),
      ),
    );
  }
}
