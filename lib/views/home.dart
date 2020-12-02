import 'dart:convert';

import 'package:FreeWallpaper/data/data.dart';
import 'package:FreeWallpaper/model/categories_model.dart';
import 'package:FreeWallpaper/model/wallpaper_model.dart';
import 'package:FreeWallpaper/views/category.dart';
import 'package:FreeWallpaper/views/search.dart';
import 'package:FreeWallpaper/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = new List();
  List<WallpaperModel> wallpapers = new List();

  TextEditingController searchController = new TextEditingController();

  int no_of_image = 20;

  getTrendingWallpapers() async {
    var response = await http.get(
        "https://api.pexels.com/v1/curated?per_page=$no_of_image&page=1",
        headers: {"Authorization": api_key});
    // print(response.body.toString());
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      // print(element);

      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {});
  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xfff5f8fd)),
              padding: EdgeInsets.symmetric(horizontal: 24),
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "search  wallpaper",
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Search(
                                    searchQuery: searchController.text,
                                  )));
                    },
                    child: Container(
                      child: Icon(Icons.search),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 16,
            ),

            Container(
              height: 80,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoriesTile(
                      imgUrl: categories[index].imgUrl,
                      title: categories[index].categorieName);
                },
              ),
            ),
            // CategoriesTile()

            wallpaperList(wallpapers: wallpapers, context: context),
          ]),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;

  CategoriesTile({@required this.imgUrl, @required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Categorie(
          categorieName: title.toLowerCase(),
        ))  );
      },
        child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: <Widget>[
            ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imgUrl,
                height: 50, width: 100, fit: BoxFit.cover),
                ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              height: 50,
              width: 100,
              child: Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
 