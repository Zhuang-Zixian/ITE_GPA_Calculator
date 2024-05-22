import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'cgpa_provider.dart';
import 'gpa_calculator_screen.dart';
import 'shared_preference_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  double targetCGPA = 3.50;

  @override
  void initState() {
    super.initState();
    loadTargetCGPA();
  }

  @override
  Widget build(BuildContext context) {
    double cgpa = Provider.of<CGPAProvider>(context).cgpa;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFC5092C),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC5092C),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 30.0,),
          CircularPercentIndicator(
            radius: 200.0,
            lineWidth: 16.0,
            percent: cgpa / 4.0,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your CGPA',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  cgpa.toStringAsFixed(2),
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Target: ${targetCGPA.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            progressColor: Color(0xFFC5092C),
            backgroundColor: Colors.grey,
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEditButton(),
              _buildRectangleContainer('To Target', (targetCGPA - cgpa).toStringAsFixed(2)),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            } else if (_currentIndex == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GpaCalculatorScreen(),
                ),
              );
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xFFC5092C),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Modules',
          ),
        ],
        selectedLabelStyle: TextStyle(color: Color(0xFFC5092C)),
      ),
    );
  }

  Widget _buildRectangleContainer(String label, String value) {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFC5092C), // Use the same red color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFC5092C), // Use the same red color
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () => _editTarget(context),
        child: Text(
          'Edit GPA Target',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void _editTarget(BuildContext context) async {
    TextEditingController targetController = TextEditingController(text: targetCGPA.toString());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Target CGPA'),
          content: TextField(
            controller: targetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter Target CGPA'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double newTargetCGPA = double.tryParse(targetController.text) ?? targetCGPA;
                setState(() {
                  targetCGPA = newTargetCGPA;
                });
                saveTargetCGPA(newTargetCGPA);
                Navigator.pop(context);
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );
  }

  void loadTargetCGPA() async {
    double storedTargetCGPA = await SharedPreferencesHelper.getDouble('targetCGPA') ?? targetCGPA;
    setState(() {
      targetCGPA = storedTargetCGPA;
    });
  }

  void saveTargetCGPA(double newTargetCGPA) {
    SharedPreferencesHelper.setDouble('targetCGPA', newTargetCGPA);
  }
}
