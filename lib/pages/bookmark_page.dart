import 'package:agriplant/pages/Bookmark_product_ListPage.dart';
import 'package:agriplant/pages/bookmark_DiseaseListPage.dart';
import 'package:agriplant/pages/bookmark_process_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Bookmarks",
        ),
        
      ),
      body: ListView(
        children: [
          const SizedBox(height: 25),
          ListTile(
            title: const Text("Products"),
            leading: const Icon(IconlyLight.infoSquare),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookmarkListPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Cultivation process"),
            leading: const Icon(IconlyLight.buy),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProcessListPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Identified diseases"),
            leading: const Icon(IconlyLight.bookmark),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DiseaseListPage(),
                ),
              );
            },
          ),
          
        ],
      ),
    );
  }



}
