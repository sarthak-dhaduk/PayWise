import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:paywise/widgets/line_titles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color.fromARGB(158, 126, 61, 255),
    const Color.fromARGB(255, 126, 61, 255),
  ];

  Future<List<FlSpot>> fetchMonthlyExpenses() async {
    // Get the email from Shared Preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email == null) return [];

    // Get the current year
    int currentYear = DateTime.now().year;

    // Initialize Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query Firestore for expense transactions by the user
    QuerySnapshot querySnapshot = await firestore
        .collection('transactions')
        .where('email', isEqualTo: email)
        .where('transaction_type', isEqualTo: 'Expense')
        .get();

    // Initialize a map to hold total expense per month (indexed by month: 0 for Jan, 11 for Dec)
    Map<int, double> monthlyExpenses = {
      for (int i = 0; i < 12; i++) i: 0.0,
    };

    // Sum up expenses per month for the current year
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      Timestamp timestamp = data['timestamp'];
      double amount =
          (data['amount'] ?? 0).toDouble(); // Handle nullable 'amount'

      DateTime date = timestamp.toDate();

      // Check if the transaction is from the current year
      if (date.year == currentYear) {
        int month = date.month - 1; // Month index for array (0 to 11)

        // Add the transaction amount to the respective month total
        monthlyExpenses[month] = (monthlyExpenses[month] ?? 0.0) + amount;
      }
    }

    // Create a list of FlSpot points for the chart, converting amounts to thousands for display
    List<FlSpot> spots = monthlyExpenses.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value / 1000))
        .toList();

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: fetchMonthlyExpenses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        return LineChart(
          LineChartData(
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 12,
            titlesData: LineTitles.getTitleData(),
            gridData: FlGridData(
              show: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  strokeWidth: 1,
                );
              },
              drawVerticalLine: false,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
              border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255), width: 1),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  final monthNames = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec'
                  ];

                  return touchedSpots.map((lineBarSpot) {
                    String month = monthNames[lineBarSpot.x.toInt()];
                    String amount = (lineBarSpot.y * 1000)
                        .toStringAsFixed(0); // Format amount in thousands

                    return LineTooltipItem(
                      "$amount ($month)",
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
                getTooltipColor: (spot) =>
                    const Color.fromARGB(89, 126, 61, 255).withOpacity(0.75),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isStrokeCapRound: true,
                spots: snapshot.data!,
                isCurved: true,
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
                barWidth: 5,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: gradientColors
                        .map((color) => color.withOpacity(0.15))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
