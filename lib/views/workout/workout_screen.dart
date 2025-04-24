import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/providers/payment_provider.dart';
import 'package:fynxfituser/viewmodels/fitness_goal_view_model.dart';
import 'package:fynxfituser/views/workout/workout_details_screen.dart';
import '../../models/workout_model.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/customs/custom_text.dart';

class WorkoutListPage extends ConsumerWidget {
  const WorkoutListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutProvider);
    final paymentNotifier = ref.watch(paymentProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workouts"),
        actions: [
          IconButton(
              onPressed: () {
                showSheet(context, ref);
              },
              icon: Icon(Icons.sort))
        ],
      ),
      body: workouts.isEmpty
          ? const Center(child: CustomText(text: "Not found"))
          : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final WorkoutModel workout = workouts[index];
                return WorkoutCard(
                  workout: workout,
                  paymentNotifier: paymentNotifier,
                ); //  FIXED
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(workoutProvider.notifier).fetchWorkouts(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void showSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final fitnessGoals = ref.watch(fitnessGoalViewModelProvider);

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: fitnessGoals.when(
            data: (goals) => ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return ListTile(
                  onTap: () {
                    ref.read(workoutProvider.notifier).sort(goal.title);
                    Navigator.pop(context);
                  },
                  title: Text(goal.title ?? "No Name"),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text("Error: $error")),
          ),
        );
      },
    );
  }
}

class WorkoutCard extends StatefulWidget {
  final WorkoutModel workout;
  final PaymentNotifier paymentNotifier;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.paymentNotifier,
  });

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isWorkoutPaid(),
      builder: (context, snapshot) {
        final paid = snapshot.data ?? false;

        return GestureDetector(
          onTap: () async{
            if (widget.workout.workoutOption == "Free" ||
                widget.workout.workoutOption == "") {
              navigateToDetails(context);
            } else if (paid) {
              navigateToDetails(context);
            } else {
              showPaymentBottomSheet(context);

            }
          },
          child: Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4,
            child: ListTile(
              title: CustomText(text: widget.workout.title ?? ""),
              trailing: const Icon(Icons.play_circle_fill, color: Colors.blue),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _isWorkoutPaid() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final paids = List<String>.from(doc.data()?['paids'] ?? []);
    return paids.contains(widget.workout.documentId);
  }

  void navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailPage(
          title: widget.workout.title ?? "",
          videoUrl: widget.workout.videoUrl ?? "",
          videoDescription: widget.workout.description ?? "",
          workoutId: widget.workout.documentId ?? "",
          userId: widget.workout.userId ?? "",
          advantages: widget.workout.advantages ?? "",
          intensity: widget.workout.intensity ?? "",
          muscle: widget.workout.muscle ?? "",
          sets: widget.workout.sets ?? "",
          repetitions: widget.workout.repetitions ?? "",
        ),
      ),
    );
  }
  void showPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.workout.title ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Price: ₹${widget.workout.workoutPrice ?? "0"}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async{

                    Navigator.pop(context);
                  widget.paymentNotifier.startPayment(
                      widget.workout.workoutPrice ?? "0",
                      "Anuja",
                      "6235713455",
                      "anujajs2002@gmail.com",
                    );
                 await   onPaymentSuccess(widget.workout.documentId);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
                    return  WorkoutListPage();
                    }));
                  },
                  child: const Text("Pay Now"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> onPaymentSuccess(String workoutId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userDocRef.update({
      'paids': FieldValue.arrayUnion([workoutId])
    });
  }

}
