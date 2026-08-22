import 'package:dio/dio.dart';

import '../../../core/config/app_environment.dart';
import '../../learning/data/seed_learning_repository.dart';

class AiPandaRepository {
  AiPandaRepository({
    required SeedLearningRepository learningRepository,
    Dio? dio,
  })  : _learningRepository = learningRepository,
        _dio = dio ?? Dio(BaseOptions(baseUrl: AppEnvironment.apiBaseUrl));

  final SeedLearningRepository _learningRepository;
  final Dio _dio;

  Future<String> ask(String question) async {
    if (AppEnvironment.apiBaseUrl.startsWith('http://localhost')) {
      return _localAnswer(question);
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/ai/conversations/demo/messages',
        data: {'message': question},
      );

      return response.data?['answer'] as String? ?? _localAnswer(question);
    } on DioException {
      return _localAnswer(question);
    }
  }

  String _localAnswer(String question) {
    final snippets = _learningRepository.knowledgeSnippets(question);
    final context = snippets.map((snippet) => '- $snippet').join('\n');

    return '''
Here is a simple explanation based on your StudyBuddy notes:

$context

Exam tip: write the key terms first, then explain the steps in your own words. Try one practice question: "Can I explain this in three short points?"
''';
  }
}
