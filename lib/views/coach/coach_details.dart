import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/models/coach_model.dart';
import 'package:fynxfituser/models/message.dar.dart';
import 'package:fynxfituser/providers/follow_provider.dart';
import 'package:fynxfituser/providers/payment_provider.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/message/chat_screen.dart';
import 'package:fynxfituser/views/message/message.dart';
import 'package:fynxfituser/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/utils/constants.dart';

class CoachDetailsPage extends ConsumerWidget {
  final CoachModel coach;

  const CoachDetailsPage({Key? key, required this.coach}) : super(key: key);

  Future<bool> isUserSubscribed(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      bool isSubscribed = userDoc['subscribe'] ?? false;
      DateTime expireDate =
          DateTime.tryParse(userDoc['expire_date'] ?? "") ?? DateTime(2000);

      if (DateTime.now().isAfter(expireDate)) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'subscribe': false,
        });
        return false;
      }
      return isSubscribed;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentNotifier = ref.watch(paymentProvider);

    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        title: CustomText(
          text: coach.name,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundImage: NetworkImage(coach.profileImage),
                  onBackgroundImageError: (_, __) =>
                      const Icon(Icons.person, size: 80, color: Colors.grey),
                ),
              ),
            ),
            sh20,
            SizedBox(
              width: double.infinity,
              child: Card(
                color: AppThemes.darkTheme.cardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "📛 Name: ${coach.name}",
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      sh10,
                      CustomText(
                        text: "🛠️ Expertise: ${coach.expertise}",
                        fontSize: 15.sp,
                      ),
                      sh10,
                      CustomText(
                        text: "📅 Experience: ${coach.experience} years",
                        fontSize: 15.sp,
                      ),
                      sh10,
                      CustomText(
                        text: "📖 Bio: ${coach.bio}",
                        fontSize: 15.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            sh20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<int>(
                      future: ref.read(followProvider).getFollowersCount(coach.id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return CustomText(
                          text: '👥 Followers: ${snapshot.data}',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<int>(
                      future: ref.read(followProvider).getFollowingCount(FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return CustomText(
                          text: '➡️ Following: ${snapshot.data}',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            sh10,

            const Spacer(),
            FutureBuilder<bool>(
              future: ref
                  .read(followProvider)
                  .isFollowing(FirebaseAuth.instance.currentUser!.uid, coach.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                bool isFollowingCoach = snapshot.data!;
                return ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Colors.deepPurple, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: () async {
                        if (isFollowingCoach) {
                          await ref.read(followProvider).unfollowCoach(
                            FirebaseAuth.instance.currentUser!.uid,
                            coach.id,
                          );
                        } else {
                          await ref.read(followProvider).followCoach(
                            FirebaseAuth.instance.currentUser!.uid,
                            coach.id,
                          );
                        }
                      },
                      text: isFollowingCoach ? "❌ Unfollow" : "➕ Follow",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                    ),
                  ),
                );
              },
            ),

            FutureBuilder<bool>(
              future: isUserSubscribed(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                bool isSubscribed = snapshot.data ?? false;
                return isSubscribed
                    ? Column(
                        children: [

                          CustomText(
                            text: "✅ You are already subscribed!",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          sh10,
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Colors.deepPurple, Colors.blueAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: SizedBox(width: double.infinity,
                              child: CustomElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
                                   return ChatScreen(coach: coach, userId: FirebaseAuth.instance.currentUser!.uid);
                                  }));
                                },
                                text: "💬 Chat",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                textColor:
                                    AppThemes.darkTheme.scaffoldBackgroundColor,
                              ),
                            ),
                          )
                        ],
                      )
                    : ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [Colors.deepPurple, Colors.blueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: SizedBox(width: double.infinity,
                          child: CustomElevatedButton(
                            onPressed: () {
                              paymentNotifier.startPayment("199", "Anuja",
                                  "6235713455", "anujajs2002@gmail.com");
                            },
                            text: "💎 Subscribe for Chat - ₹199",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            textColor:
                                AppThemes.darkTheme.scaffoldBackgroundColor,
                          ),
                        ),
                      );
              },
            ),
            sh20,
          ],
        ),
      ),
    );
  }
}
