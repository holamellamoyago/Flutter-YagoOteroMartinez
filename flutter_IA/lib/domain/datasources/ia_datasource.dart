import 'package:flutter_ia/data/entities/contents.dart';
import 'package:flutter_ia/data/entities/response.dart';

abstract class IaDatasource {
  Future<String> sendMessage(Contents contents);
}
