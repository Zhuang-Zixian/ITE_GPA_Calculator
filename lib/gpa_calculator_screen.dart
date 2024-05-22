import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'shared_preference_helper.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// external classes imports
import 'module.dart';
import 'cgpa_provider.dart';
import 'home_page.dart'; // Import the Home page

class CumulativeGpaCircularBar extends StatelessWidget {
  final double cumulativeGpa;
  final Color color;

  CumulativeGpaCircularBar({required this.cumulativeGpa, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: 130.0,
        lineWidth: 12.0,
        percent: cumulativeGpa / 4.0,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CGPA',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              cumulativeGpa.toStringAsFixed(2),
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: color,
        backgroundColor: Colors.grey,
      ),
    );
  }
}

class GpaCalculatorScreen extends StatefulWidget {
  @override
  _GpaCalculatorScreenState createState() => _GpaCalculatorScreenState();
}

class _GpaCalculatorScreenState extends State<GpaCalculatorScreen> {
  List<Module> modules = [];
  List<Module> filteredModules = []; // Added this line
  double gpa = 0.0;

  Map<String, int> gradeScales = {
    'A': 4,
    'B': 3,
    'C': 2,
    'D': 1,
    'E': 1,
    'F': 0,
  };

  Map<String, Color> moduleColors = {};
  TextEditingController titleController = TextEditingController();
  TextEditingController creditUnitsController = TextEditingController();
  String selectedGrade = 'A';

  static const String modulesKey = 'modules';

  @override
  void initState() {
    super.initState();
    loadModules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GPA Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFC5092C),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          ),
          PopupMenuButton(
            onSelected: (result) {
              sortModules(result);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'ascending',
                child: Text('Sort Ascending'),
              ),
              PopupMenuItem(
                value: 'descending',
                child: Text('Sort Descending'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Consumer<CGPAProvider?>(
              builder: (context, cgpaProvider, _) {
                final cumulativeGpa = cgpaProvider?.cgpa ?? 0.0;
                return CumulativeGpaCircularBar(
                  cumulativeGpa: cumulativeGpa,
                  color: Color(0xFFC5092C),
                );
              },
            ),
            SizedBox(height: 15),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Module Title *',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: creditUnitsController,
              decoration: InputDecoration(
                labelText: 'Module Credit Units *',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedGrade,
              items: gradeScales.keys.map((grade) {
                return DropdownMenuItem<String>(
                  value: grade,
                  child: Text(grade),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGrade = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addModule();
                    saveModules();
                  },
                  child: Text(
                    'Add Module',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC5092C),
                    minimumSize: Size(120, 36),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Clear all modules
                    clearAllModules();
                  },
                  child: Text('Clear All', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC5092C),
                    minimumSize: Size(120, 36),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            buildModuleList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books, color: Color(0xFFC5092C)),
            label: 'Modules',
          ),
        ],
        selectedLabelStyle: TextStyle(color: Color(0xFFC5092C)),
      ),
    );
  }

  Widget buildModuleList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredModules.length, // Changed from modules to filteredModules
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(index),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    editModule(index);
                  },
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (context) {
                    Module originalModule = filteredModules[index];
                    deleteModule(index);
                    saveModules();
                    showUndoSnackBar(context, index, originalModule);
                  },
                  backgroundColor: Color(0xFFC5092C),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              title: Text(filteredModules[index].title), // Changed from modules to filteredModules
              subtitle: Text('${filteredModules[index].creditUnits} credit units'), // Changed from modules to filteredModules
              tileColor: moduleColors[filteredModules[index].title] ?? Colors.white,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Grade: ${filteredModules[index].grade}'), // Changed from modules to filteredModules
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      showColorPicker(filteredModules[index].title); // Changed from modules to filteredModules
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: moduleColors[filteredModules[index].title] ?? Colors.blue, // Changed from modules to filteredModules
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void loadModules() async {
    List<dynamic> modulesList =
    await SharedPreferencesHelper.getList(modulesKey);

    setState(() {
      modules = modulesList.map((moduleData) {
        Map<String, dynamic> moduleMap = moduleData;
        String title = moduleMap['title'];
        int creditUnits = moduleMap['creditUnits'];
        String grade = moduleMap['grade'];

        // Load module color from SharedPreferences
        Color color = moduleMap['color'] != null
            ? Color(moduleMap['color'])
            : Colors.white; // Set default color to white

        // Save module color to the map
        moduleColors[title] = color;

        return Module(title, creditUnits, grade);
      }).toList();

      filteredModules = List.from(modules); // Added this line

      calculateGPA();
    });
  }

  void saveModules() {
    List<Map<String, dynamic>> modulesData = modules.map((module) {
      return {
        'title': module.title,
        'creditUnits': module.creditUnits,
        'grade': module.grade,
        // Save module color to SharedPreferences
        'color': moduleColors[module.title]?.value ?? Colors.blue.value,
      };
    }).toList();
    SharedPreferencesHelper.saveList(modulesKey, modulesData);
  }

  void addModule() {
    String title = titleController.text;
    int creditUnits = int.tryParse(creditUnitsController.text) ?? 0;
    String grade = selectedGrade;

    if (title.isNotEmpty && creditUnits > 0) {
      bool moduleExists = modules.any((module) => module.title == title);

      if (moduleExists) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('A module with the same title already exists.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        Module module = Module(title, creditUnits, grade);

        // Set the color for the new module (you can use any default color you prefer).
        moduleColors[module.title] = Colors.white;

        setState(() {
          modules.add(module);
          filteredModules.add(module); // Added this line
          calculateGPA();
          titleController.clear();
          creditUnitsController.clear();
        });

        saveModules();
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Module Title and Module Credit Units are required.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void calculateGPA() {
    double totalGradePoints = 0;
    int totalCreditUnits = 0;

    for (var module in modules) {
      totalGradePoints += module.creditUnits * gradeScales[module.grade]!;
      totalCreditUnits += module.creditUnits;
    }

    gpa = totalCreditUnits != 0 ? totalGradePoints / totalCreditUnits : 0.0;

    Provider.of<CGPAProvider?>(context, listen: false)?.updateCGPA(gpa);
  }

  void editModule(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
      String editedTitle = filteredModules[index].title; // Changed from modules to filteredModules
      int editedCreditUnits = filteredModules[index].creditUnits; // Changed from modules to filteredModules
      String editedGrade = filteredModules[index].grade; // Changed from modules to filteredModules

      return AlertDialog(
        title: Text('Edit Module'),
        content: Column(
            children: [
        TextField(
        controller: TextEditingController(text: filteredModules[index].title), // Changed from modules to filteredModules
        decoration: InputDecoration(labelText: 'Edited Module Title'),
        onChanged: (value) {
          editedTitle = value;
        },
      ),
    TextField(
    controller: TextEditingController(
    text: filteredModules[index].creditUnits.toString()), // Changed from modules to filteredModules
    decoration:
    InputDecoration(labelText: 'Edited Module Credit Units'),
    keyboardType: TextInputType.number,
      onChanged: (value) {
        editedCreditUnits = int.tryParse(value) ?? 0;
      },
    ),
              DropdownButtonFormField<String>(
                value: editedGrade,
                items: gradeScales.keys.map((grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (value) {
                  editedGrade = value!;
                },
              ),
            ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                filteredModules[index].title = editedTitle; // Changed from modules to filteredModules
                filteredModules[index].creditUnits = editedCreditUnits; // Changed from modules to filteredModules
                filteredModules[index].grade = editedGrade; // Changed from modules to filteredModules
                calculateGPA();
              });

              saveModules();
              loadModules();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      );
        },
    );
  }

  void deleteModule(int index) {
    setState(() {
      modules.removeAt(index);
      filteredModules.removeAt(index); // Changed from modules to filteredModules
      calculateGPA();
    });

    saveModules();
  }

  void showUndoSnackBar(BuildContext context, int index, Module originalModule) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Module deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              modules.insert(index, originalModule);
              filteredModules.insert(index, originalModule); // Changed from modules to filteredModules
              calculateGPA();
            });

            saveModules();
          },
        ),
      ),
    );
  }

  void clearAllModules() {
    setState(() {
      modules.clear();
      filteredModules.clear(); // Changed from modules to filteredModules
      calculateGPA();
    });

    saveModules();
  }

  void sortModules(String order) {
    setState(() {
      if (order == 'ascending') {
        filteredModules.sort((a, b) => a.title.compareTo(b.title)); // Changed from modules to filteredModules
      } else if (order == 'descending') {
        filteredModules.sort((a, b) => b.title.compareTo(a.title)); // Changed from modules to filteredModules
      }
      calculateGPA();
    });

    saveModules();
  }

  void showColorPicker(String title) {
    Color currentColor = moduleColors.containsKey(title)
        ? moduleColors[title]!
        : Colors.white; // Use white if color is not set

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                setState(() {
                  moduleColors[title] = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                saveModules(); // Save module colors when color is picked
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Added search functionality
  void showSearchDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Modules'),
          content: TextField(
            onChanged: (value) {
              filterModules(value);
            },
            decoration: InputDecoration(
              hintText: 'Enter module name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  // Added search functionality
  void filterModules(String query) {
    setState(() {
      filteredModules = modules
          .where((module) =>
          module.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
