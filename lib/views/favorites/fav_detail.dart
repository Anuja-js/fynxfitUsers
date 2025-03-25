// import 'package:flutter/material.dart';
//
// class DetailsPageFav extends StatelessWidget {
//   final Map<String, dynamic> item;
//   final String type; // "article" or "workout"
//
//   const DetailsPageFav({super.key, required this.item, required this.type});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(type == "article" ? "Article Details" : "Workout Details")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (item['imageUrl'] != null)
//               Image.network(item['imageUrl'], height: 200, fit: BoxFit.cover),
//             const SizedBox(height: 10),
//             Text(item['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Text(item['description'] ?? "No description available"),
//           ],
//         ),
//       ),
//     );
//   }
// }
