import 'package:flutter/cupertino.dart';
import 'package:petli/apirequest/service.dart';
import 'package:petli/model/image_model.dart';
import 'package:petli/bloc/product_detail_bloc.dart';

abstract class BaseViewModel<T extends StatefulWidget> extends State<T> {
  ScrollController? scrollController;
  List<ImageModel> loadMoreItems = List.empty(growable: true);
  int present = 10;
  bool isLoading = false;
  int skipCount = 0;

  final ProductDetailBloc block = ProductDetailBloc();

  BaseViewModel() {
    scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  _scrollListener() {
    if(scrollController != null) {
      if (scrollController!.offset >=
          scrollController!.position.maxScrollExtent &&
          !scrollController!.position.outOfRange) {
       // if (loadMoreItems.length >= present) {
          setState(() {
            isLoading = true;
            if (isLoading) {
              skipCount = skipCount + 30;
              addItemIntoLisT(skipCount);
            }
          });
      //  }
      }
    }
  }

  void addItemIntoLisT(var skipCount);

  void onLikeButtonTapped(bool isLiked, ImageModel model) async {
    if(!isLiked) {
      block.addProduct(model);
    } else {
      block.deleteProduct(model.id);
    }
  }

  Future<bool> isImageLiked(ImageModel items) {
    return block.isProductAvailable(items);
  }
}