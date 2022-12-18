import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Github Search"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 8,
            ),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Search..."),
              ),
            ),
          ),
          Expanded(child: ListView.builder(
            itemBuilder: (_, index) {
              return const ListTile();
            },
          ))
        ],
      ),
    );
  }
}
