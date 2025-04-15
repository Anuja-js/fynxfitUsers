import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/viewmodels/bmi_view_model.dart';

import '../../core/utils/constants.dart';
import '../../widgets/customs/custom_text.dart';

class BMICalculatorPage extends ConsumerWidget {
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  BMICalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bmiState = ref.watch(bmiProvider);
    final bmiNotifier = ref.read(bmiProvider.notifier);

    return Scaffold(backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(title: CustomText(text:"BMI Calculator",fontWeight: FontWeight.bold,fontSize: 15.sp,),
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Height Unit:"),
                ToggleButtons(
                  isSelected: [!bmiState.isHeightInInches, bmiState.isHeightInInches],
                  onPressed: (_) => bmiNotifier.toggleHeightUnit(),
                  children: const [
                    Padding(padding: EdgeInsets.all(8.0), child: Text("cm")),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("in")),
                  ],
                ),
              ],
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: bmiState.isHeightInInches ? "Height (in)" : "Height (cm)",
                border: const OutlineInputBorder(),
              ),
            ),
            sh20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Weight Unit:"),
                ToggleButtons(
                  isSelected: [!bmiState.isWeightInLbs, bmiState.isWeightInLbs],
                  onPressed: (_) => bmiNotifier.toggleWeightUnit(),
                  children: const [
                    Padding(padding: EdgeInsets.all(8.0), child: Text("kg")),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("lb")),
                  ],
                ),
              ],
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: bmiState.isWeightInLbs ? "Weight (lb)" : "Weight (kg)",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                double height = double.tryParse(heightController.text) ?? 0;
                double weight = double.tryParse(weightController.text) ?? 0;

                if (height > 0 && weight > 0) {
                  bmiNotifier.calculateBMI(height, weight);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter valid values")),
                  );
                }
              },
              child: const Text("Calculate BMI"),
            ),
           sh20,
            if (bmiState.bmi > 0)
              Column(
                children: [
                  if(heightController.text.isNotEmpty&& weightController.text.isNotEmpty)     Text(
                    "Your BMI: ${bmiState.bmi.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
               if(heightController.text.isNotEmpty&& weightController.text.isNotEmpty)   Text(
                    "Category: ${bmiState.getCategory()}",
                    style: TextStyle(
                      fontSize: 18,
                      color: bmiState.getCategory() == "Underweight"
                          ? Colors.blue
                          : bmiState.getCategory() == "Normal Weight"
                          ? Colors.green
                          : bmiState.getCategory() == "Overweight"
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
