import 'package:flutter/material.dart';
import 'gallery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Flutter Camera",
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController _cameraController;
  Future<void> _initCameraFuture;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List holder = new List();

    return Scaffold(
      body: FutureBuilder(
          future: availableCameras(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Can\'t access camera');
            } else if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              CameraDescription camera =
                  (snapshot.data as List<CameraDescription>).first;
              return cameraView(camera);
            }

            return Center(child: CircularProgressIndicator());
          }),
      bottomNavigationBar: new BottomNavigationBar(
          backgroundColor: Colors.cyan[700],
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: new IconButton(
                  onPressed: () async {
                    try {
                      await _initCameraFuture;
                      final path = join(
                        (await getExternalStorageDirectory()).path,
                        '${DateTime.now()}.jpg',
                      );
                      await _cameraController.takePicture(path);
                      holder.add(path);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyGallery(images: holder)),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
                // ignore: deprecated_member_use
                title: new Text('Camera',
                    style: TextStyle(color: Colors.white, fontSize: 16))),
            BottomNavigationBarItem(
                icon: new IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyGallery(images: holder)),
                    );
                  },
                  icon: Icon(Icons.apps, color: Colors.amber[300]),
                ),
                // ignore: deprecated_member_use
                title: new Text('Gallery',
                    style: TextStyle(color: Colors.amber[300], fontSize: 16))),
          ]),
    );
  }

  FutureBuilder cameraView(CameraDescription camera) {
    _cameraController = CameraController(camera, ResolutionPreset.max);
    _initCameraFuture = _cameraController.initialize();
    return FutureBuilder<void>(
      future: _initCameraFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Camera error'));
        } else if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_cameraController);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
