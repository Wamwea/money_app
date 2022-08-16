import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/core/styling/styling.dart';
import 'package:money_app/features/authentication/view_models/auth_view_model.dart';
import 'package:money_app/features/authentication/views/login_page.dart';
import 'package:money_app/features/authentication/views/signup_page.dart';
import 'package:money_app/features/expenses/models/spend.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeName = 'home';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Map<String, List<Spending>> spendingMap = {
    'Incomes': [
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.income,
        amount: 100,
        description: 'Groceries',
      ),
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.income,
        amount: 151,
        description: 'Groceries',
      ),
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.income,
        amount: 131,
        description: 'Groceries',
      ),
    ],
    'Expenses': [
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.expense,
        amount: 100,
        description: 'Groceries',
      ),
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.expense,
        amount: 151,
        description: 'Groceries',
      ),
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.expense,
        amount: 131,
        description: 'Groceries',
      ),
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.expense,
        amount: 234,
        description: 'Groceries',
      ),
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.expense,
        amount: 624,
        description: 'Groceries',
      )
    ],
    'Loans': [
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.loan,
        amount: 234,
        description: 'Groceries',
      ),
      Spending(
        time: DateTime.now(),
        spendingID: 'ab123',
        type: SpendingType.loan,
        amount: 624,
        description: 'Groceries',
      )
    ],
    'Repayments': [],
  };

  Map<String, double> getDataMap(Map<String, List<Spending>> spendingMap) {
    Map<String, double> dataMap = {};
    spendingMap.forEach((key, value) {
      dataMap[key] = value.fold(0, (sum, spending) => sum + spending.amount);
    });
    return dataMap;
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () async {
                      await ref.read(authStateProvider.notifier).signOut().then(
                          (value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage())));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Log out',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.face)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'OVERVIEW',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (!mounted) return;
                  scaffoldKey.currentState!.openEndDrawer();
                },
                icon: Icon(Icons.settings))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                ...spendingMap.keys
                    .map((key) => TotalSpendingCard({key: spendingMap[key]!})),
                SizedBox(height: 8),
                PieChart(
                    dataMap: getDataMap(spendingMap),
                    legendOptions:
                        LegendOptions(legendPosition: LegendPosition.left),
                    chartValuesOptions: ChartValuesOptions(
                        decimalPlaces: 0,
                        showChartValuesInPercentage: true,
                        showChartValueBackground: false))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TotalSpendingCard extends StatelessWidget {
  const TotalSpendingCard(this.spendings, {Key? key}) : super(key: key);
  final Map<String, List<Spending>> spendings;
  @override
  Widget build(BuildContext context) {
    final totalSpending = spendings.values.first
        .fold<double>(0, (total, spending) => total + spending.amount);
    final spendType = spendings.keys.first;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff02c38e)),
          borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KES ${totalSpending.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Balance: KES 00',
            style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            spendType,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          Divider(thickness: 1),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!spendings.containsKey('Repayments'))
                Icon(Icons.add, color: Color(0xff02c38e)),
              SizedBox(width: 8),
              GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SpendingPage(spendings.values.first))),
                  child: Icon(Icons.list_sharp, color: Color(0xff02c38e))),
            ],
          )
        ],
      ),
    );
  }
}

class SpendCard extends StatelessWidget {
  const SpendCard(this.spending, {Key? key}) : super(key: key);
  final Spending spending;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff02c38e)),
          borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KES ${spending.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${spending.amount}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                spending.type.name,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
          Text(
            spending.description,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingPage extends StatefulWidget {
  const SpendingPage(this.spendings, {Key? key}) : super(key: key);
  final List<Spending> spendings;
  @override
  State<SpendingPage> createState() => _SpendingPageState();
}

class _SpendingPageState extends State<SpendingPage> {
  @override
  Widget build(BuildContext context) => SafeArea(
          child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {},
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            '${widget.spendings.first.type.name} spendings',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
                fontSize: 14),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
              itemCount: widget.spendings.length,
              itemBuilder: (context, index) {
                return SpendCard(widget.spendings[index]);
              }),
        ),
      ));
}
