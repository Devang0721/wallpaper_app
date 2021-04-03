import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({@required this.imgUrl});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  var filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.imgUrl,
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _save();
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xff1C1B1B).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30)),
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white60, width: 1),
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFF)
                            ])),
                        child: Column(
                          children: [
                            Text(
                              'Set Wallpaper',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Image will be saved in gallery',
                              style:
                                  TextStyle(color: Colors.white70, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    if(Platform.isAndroid){
      await _askPermission();
    }
    var response = await Dio().get(
      widget.imgUrl,
      options: Options(responseType: ResponseType.bytes)
    );
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if(Platform.isIOS){
      await PermissionHandler().requestPermissions([PermissionGroup.photos]);
    }else{
      await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    }
  }
}
