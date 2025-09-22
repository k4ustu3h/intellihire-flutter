import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:mongo_dart/mongo_dart.dart";

class MongoDatabase {
  static late Db _db;
  static late DbCollection _jobsCollection;

  static final String? _connectionUri = dotenv.env["MONGODB_URI"];
  static const String _jobsCollectionName = "jobs";

  static Future<void> connect() async {
    _db = await Db.create(_connectionUri!);
    await _db.open();
    _jobsCollection = _db.collection(_jobsCollectionName);
  }

  static Future<List<Map<String, dynamic>>> getJobs() async {
    return await _jobsCollection.find().toList();
  }

  static Future<void> close() async {
    await _db.close();
  }
}
