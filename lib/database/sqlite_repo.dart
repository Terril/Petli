import '../model/image_model.dart';
import './sqlite_helper.dart';

class SqliteRepository {
 
  Future getAllProducts() => SqlitHelper.db.getAllProducts();

  Future insertProducts(ImageModel detail) => SqlitHelper.db.insertProductIntoDatabase(detail);

  Future updateProducts(ImageModel detail) => SqlitHelper.db.updateProducts(detail);

  Future<bool> isProductAvailable(ImageModel detail) => SqlitHelper.db.isProductAvailable(detail);

  Future deleteProductDetailById(int id) => SqlitHelper.db.deleteProduct(id);

  //We are not going to use this in the demo
  Future deleteAllProductDetail() => SqlitHelper.db.deleteAll();
}