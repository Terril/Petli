import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_dialog.dart';
import 'apirequest/service.dart';
import 'baseviewmodel.dart';
import 'model/image_model.dart';
import 'package:like_button/like_button.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Petli'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseViewModel<MyHomePage> {
  Widget buildProducts(ImageModel items) {
    return InkWell(
      splashColor: Colors.purple,
      onTap: () {
        showDialog(context: context, builder: (_) => ImageDialog(items.url));
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CachedNetworkImage(
                imageUrl: items.thumbnailUrl,
                height: 72.0,
                width: double.infinity),
            Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(items.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12))),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () {
                isImageLiked(items).then((value) => {
                      onLikeButtonTapped(value, items),
                      setState(() {
                        // index = 0;
                      })
                    });
              },
              child: getButtonText(items),
            ),
          ],
        ),
      ),
    );
  }

  Widget getButtonText(ImageModel items) {
    return FutureBuilder<bool>(
        future: isImageLiked(items),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return new Text(
            (snapshot.hasData && snapshot.data!) ? 'Liked' : 'Not Liked',
              );
        });
  }

  Widget _productsGridView(List<ImageModel> items) {
    // items = items.getRange(present, present + perPage);
    present = present + 10;
    return items.isEmpty
        ? showNoDataImage()
        : GridView.builder(
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, position) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: buildProducts(items[position]),
              );
            },
            itemCount: items.length, // Can be null
          );
  }

  Widget showNoDataImage() {
    return const Image(
        image: AssetImage('no_data_found.png'),
        height: double.infinity,
        width: double.infinity);
  }

  Widget apiRequest() {
    return FutureBuilder<List<ImageModel>>(
        future: getData(present),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (isLoading) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                if (scrollController != null) {
                  if (scrollController!.hasClients) {
                    scrollController!.jumpTo(
                        scrollController!.position.maxScrollExtent -
                            ((snapshot.data!.length - 11) * 100));
                  }
                }
              });
            }
            if (snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                scrollController = null;
                return _productsGridView(loadMoreItems);
              } else if (snapshot.data!.isEmpty) {
                return showNoDataImage();
              } else {
                loadMoreItems.addAll(snapshot.data!);
                return _productsGridView(snapshot.data!);
              }
            } else {
              return showNoDataImage();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(child: apiRequest()),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void addItemIntoLisT(skipCount) {
    FutureBuilder<List<ImageModel>>(
        future: getData(present),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                scrollController = null;
              } else {
                loadMoreItems.addAll(snapshot.data!);
                //  scrollController.jumpTo(scrollController.position.maxScrollExtent);
              }
            }
          }
          return const SizedBox();
        });
  }
}
