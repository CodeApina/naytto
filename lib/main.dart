import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Firestore Testi')),
        ),
        body: Center(
          child: FutureBuilder(
            future: fetchFirestoreData(),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final data = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var item in data!) Text(item),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchFirestoreData() async {
    List<String> dataList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('testi').get();

      print('Dokumentteja haettu: ${querySnapshot.docs.length}');

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data.forEach((key, value) {
          dataList.add(value.toString());
        });
      });
    } catch (e) {
      print('Virhe tietojen hakemisessa: $e');
    }

    return dataList;
  }
}
