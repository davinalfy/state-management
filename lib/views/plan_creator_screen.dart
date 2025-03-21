import 'package:flutter/material.dart';
import '../views/plan_screen.dart';
import '../models/data_layer.dart';
import '../provider/plan_provider.dart';

class PlanCreatorScreen extends StatefulWidget {
  const PlanCreatorScreen({super.key});

  @override
  State<PlanCreatorScreen> createState() => _PlanCreatorScreenState();
}

class _PlanCreatorScreenState extends State<PlanCreatorScreen> {

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ganti 'Namaku' dengan nama panggilan Anda
      appBar: AppBar(title: const Text('Master Plans Davina')),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildListCreator(),
            const SizedBox(height: 20),
            Expanded(child: _buildMasterPlans())
          ],
        ),
      ),
    );
  }

  Widget _buildListCreator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        color: Theme.of(context).cardColor,
        elevation: 10,
        child: TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Add a plan',
              contentPadding: EdgeInsets.all(20)),
            onEditingComplete: addPlan),
      )
    );
  }

  Widget _buildMasterPlans() {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
      List<Plan> plans = planNotifier.value;

      if (plans.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.note, size: 80, color: Colors.grey),
            Text(
              'Anda belum memiliki rencana apapun.',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center, // Center text
            )
          ]
        );
      }
      return ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return ListTile(
                title: Text(plan.name),
                subtitle: Text(plan.completenessMessage),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PlanScreen(plan: plan,)));
                }
              );
            }
          );
  }

  void addPlan() {
    final text = textController.text;
      if (text.isEmpty) {
        return;
      }
      final plan = Plan(name: text, tasks: []);
      ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
      planNotifier.value = List<Plan>.from(planNotifier.value)..add(plan);
      textController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {});
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}