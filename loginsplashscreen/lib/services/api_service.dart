// import 'package:dio/dio.dart';
// import 'package:loginsplashscreen/model/Category.dart';
//
// class ApiService {
//   final Dio dio = Dio();
//
//   Future<List<Category>> fetchCategories() async {
//     try {
//       final response = await dio.get('http://172.20.10.4:8000/faculty/categories/',  options: Options(
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       ),);
//       if (response.statusCode == 200) {
//         List<Category> categories = (response.data as List)
//             .map((json) => Category.fromJson(json))
//             .toList();
//         return categories;
//       } else {
//         throw Exception('Failed to load categories');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }
