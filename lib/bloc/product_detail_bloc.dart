import '../database/sqlite_repo.dart';
import '../model/image_model.dart';

import 'dart:async';

class ProductDetailBloc {
  //Get instance of the Repository
  final _sqliteRepository = SqliteRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _sqliteController = StreamController<List<ImageModel>>.broadcast();
  final _sqliteProductDeletedController = StreamController<bool>.broadcast();

  get productDetails => _sqliteController.stream;
  StreamSink<bool> get _inDeleted => _sqliteProductDeletedController.sink;
  Stream<bool> get deleted => _sqliteProductDeletedController.stream;

  ProductDetailBloc() {
    getAllProducts();
  }

  getAllProducts() async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _sqliteController.sink.add(await _sqliteRepository.getAllProducts());
  }

  addProduct(ImageModel products) async {
    await _sqliteRepository.insertProducts(products);
  }

  updateProduct(ImageModel products) async {
    await _sqliteRepository.updateProducts(products);
  }

  Future<bool> isProductAvailable(ImageModel products) async {
    bool productAvailable =
        await _sqliteRepository.isProductAvailable(products);
    return productAvailable;
  }

  deleteProduct(int id) async {
    _sqliteRepository.deleteProductDetailById(id);
    _inDeleted.add(true);
    getAllProducts();
  }

  deleteAllProduct() async {
    _sqliteRepository.deleteAllProductDetail();
    _inDeleted.add(true);
    getAllProducts();
  }

  dispose() {
    _sqliteController.close();
    _sqliteProductDeletedController.close();
  }
}
