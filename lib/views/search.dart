import 'dart:convert';

import 'package:FreeWallpaper/data/data.dart';
import 'package:FreeWallpaper/model/wallpaper_model.dart';
import 'package:FreeWallpaper/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class Search extends StatefulWidget {

  final String searchQuery;
  
   Search({this.searchQuery});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchController = new TextEditingController();
   List<WallpaperModel> wallpapers = new List();
  
  getSearchWallpapers(String query ) async {
    var response = await http.get(
        "https://api.pexels.com/v1/search?query=$query &per_page=15&page=1",
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
    getSearchWallpapers(widget.searchQuery);
    
    super.initState();
    searchController.text = widget.searchQuery;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      
      body:  SingleChildScrollView(
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
                       getSearchWallpapers(searchController.text);
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
              wallpaperList(wallpapers: wallpapers, context: context),
          ],
          ),
        ),
      )
    );
  }
} 