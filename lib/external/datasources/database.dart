import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pub_puzzler/domain/entities/game.dart';
import 'package:pub_puzzler/domain/entities/question.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final _logger = getLogger();
final _client = Client()
    .setEndpoint(GlobalConfiguration().getValue('baseAppwriteApiUrl'))
    .setProject(dotenv.env['APPWRITE_PROJECT_ID']);
final Databases _databases = Databases(_client);

Future<void> addGame(String userId, int score, List<bool> questions) async {
  logger.d("Adding new game document...");
  final game = {"userId": userId, "score": score, "questions": questions};
  await _createDoc(game);
}

Future<List<Game>> getGame(String userId) async {
  _logger.d("Getting game documents...");
  DocumentList docs = await _getDoc([Query.equal("userId", userId)]);
  List<Game> games = <Game>[];
  for (final doc in docs.documents) {
    Game game = Game.fromDoc(doc);
    games.add(game);
  }
  return games;
}

Future<void> _createDoc(Map<dynamic, dynamic> data) async {
  try {
    final document = await _databases.createDocument(
        databaseId: dotenv.env['APPWRITE_DB_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: ID.unique(),
        data: data);
    _logger.i("Created document: $document");
  } on AppwriteException catch (e) {
    _logger.e("Could not create document - Error occurred: ${e.message}");
  }
}

Future<DocumentList> _getDoc(List<String> queries) async {
  try {
    final documents = await _databases.listDocuments(
        databaseId: dotenv.env['APPWRITE_DB_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        queries: [
          ...queries,
        ]);
    _logger.i("Document list: $documents");
    return documents;
  } on AppwriteException catch (e) {
    _logger.e("Could not list documents - Error occurred: ${e.message}");
    return Future.error('Failed to fetch documents');
  }
}
