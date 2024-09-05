import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:technical_task/src/data/models/android_version.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final String input1 = '''
  [{"0":{"id":1,"title":"Gingerbread"},
  "1":{"id":2,"title":"Jellybean"},
  "3":{"id":3,"title":"KitKat"}},
  [{"id":4,"title":"Lollipop"},
  {"id":5,"title":"Pie"},
  {"id":6,"title":"Oreo"},
  {"id":7,"title":"Nougat"}]]
  ''';

  final String input2 = '''
  [{"0":{"id":1,"title":"Gingerbread"},
  "1":{"id":2,"title":"Jellybean"},
  "3":{"id":3,"title":"KitKat"}},
  {"0":{"id":8,"title":"Froyo"},
  "2":{"id":9,"title":"Éclair"},
  "3":{"id":10,"title":"Donut"}},
  [{"id":4,"title":"Lollipop"},
  {"id":5,"title":"Pie"},
  {"id":6,"title":"Oreo"},
  {"id":7,"title":"Nougat"}]]
  ''';
  List<AndroidVersion> parseJson(String input) {
    final jsonList = json.decode(input) as List;
    List<AndroidVersion> androidVersions = [];

    for (var element in jsonList) {
      if (element is Map) {
        int i = 0;
        while (element.containsKey(i.toString()) || element.containsKey((i + 1).toString())) {
          if (element.containsKey(i.toString())) {
            final value = element[i.toString()];
            androidVersions.add(AndroidVersion(id: value['id'], title: value['title']));
          } else {
            androidVersions.add(AndroidVersion(id: null, title: ""));
          }
          i++;
        }
      } else if (element is List) {
        for (var item in element) {
          androidVersions.add(AndroidVersion(id: item['id'], title: item['title']));
        }
      }
    }

    return androidVersions;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter JSON Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final versions = parseJson(input1);
                  _showOutputInBottomSheet(context, versions);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Output 1'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final versions = parseJson(input2);
                  _showOutputInBottomSheet(context, versions);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Output 2'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showOutputInBottomSheet(BuildContext context, List<AndroidVersion> versions){
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: Colors.green[100],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Parsed Data",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              GridView.builder(
                shrinkWrap: true, // Ensure GridView wraps its content
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: versions.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Text(
                      versions[index].title?.isEmpty == true ? ' ' : versions[index].title!,
                      style: const TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
