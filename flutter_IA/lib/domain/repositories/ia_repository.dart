
import 'package:flutter_ia/data/entities/contents.dart';
import 'package:flutter_ia/data/entities/response.dart';

abstract class IARepository {
  Future<String> sendMessage(Contents contents);
}
