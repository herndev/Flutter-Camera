import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MyGallery extends StatelessWidget {
  final List images;

  MyGallery({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getExternalStorageDirectory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 2.0,
                  children: List.generate(images.length, (index) {
                    return Center(
                      child: Image.file(
                        File(images[index]),
                      ),
                    );
                  }));
            } else {
              print('');
            }
            return Center(child: CircularProgressIndicator());
          }),
      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.cyan[700],
                  borderRadius: BorderRadius.circular(50),
                ),
                // borderRadius: BorderRadius.circular(100)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.logout, color: Colors.amber[300]),
                    Text("Camera",
                        style:
                            TextStyle(color: Colors.amber[300], fontSize: 12))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
