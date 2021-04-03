import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/widget/widget.dart';
import 'package:http/http.dart' as http;
class Search extends StatefulWidget {
  final String searchQuery;
  Search({this.searchQuery});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchCtrl = new TextEditingController();

  getSearchWallpaper(String Query) async {
    var response = await http.get(
        "https://api.pexels.com/v1/search?query=$Query&per_page=40",
        headers: {"Authorization": APIKey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpaper(widget.searchQuery);
    super.initState();
    searchCtrl.text = widget.searchQuery;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BrandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                margin: EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchCtrl,
                        decoration: InputDecoration(
                            hintText: "Search wallpaper",
                            border: InputBorder.none),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          getSearchWallpaper(searchCtrl.text);
                        },
                        child: Container(child: Icon(Icons.search))),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              wallPaperList(wallpapers: wallpapers, context: context),
            ],
          )
        ),
      ),
    );
  }
}
