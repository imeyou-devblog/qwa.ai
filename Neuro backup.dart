
/// УЛЬТРА-ОПТИМИЗИРОВАННЫЙ CosineLSH для сверхразреженных векторов
class CosineLSH {
  static const int _bitsPerByte = 8;
  
  final int _numHyperplanes;
  final int _numBands;
  final int _rowsPerBand;
  final int _dimensions;
  final List<Map<int, double>> _hyperplanes;
  final List<Map<String, Uint8List>> _buckets; // Квантованные сигнатуры
  final Map<String, int> _vectorToBucket; // Быстрый поиск векторов
    final List<Map<String, Set<String>>> _bucketToVectors; // band → bucketKey → Set<vectorId>
  final Map<String, Uint8List> _vectorSignatures; // vectorId → полная сигнатура
  
  CosineLSH({
    required int dimensions,
    int numHyperplanes = 100,
    int numBands = 20,
    double sparsity = 0.01,
  })  : _numHyperplanes = numHyperplanes,
        _numBands = numBands,
                _bucketToVectors = List.generate(numBands, (_) => {}),
        _vectorSignatures = {},
        _rowsPerBand = numHyperplanes ~/ numBands,
        _dimensions = dimensions,
        _hyperplanes = [],
        _buckets = List.filled(numBands, {}),
        _vectorToBucket = {} {
    _initializeUltraHyperplanes(dimensions, sparsity);
  }

  /// УЛЬТРА-ОПТИМИЗИРОВАННАЯ инициализация гиперплоскостей
  void _initializeUltraHyperplanes(int dimensions, double sparsity) {
    final random = Random();
    final nonZeroCount = (dimensions * sparsity).round().clamp(1, 1000);
    final usedIndices = <int>{};
    
    for (int i = 0; i < _numHyperplanes; i++) {
      final hyperplane = <int, double>{};
      usedIndices.clear();
      
      // Создаем уникальные индексы для максимальной эффективности
      while (hyperplane.length < nonZeroCount) {
        final index = random.nextInt(dimensions);
        if (usedIndices.add(index)) {
          hyperplane[index] = random.nextGaussian();
        }
      }
      
      _normalizeSparseVector(hyperplane);
      _hyperplanes.add(hyperplane);
    }
  }

  /// СУПЕР-БЫСТРАЯ нормализация на месте
  void _normalizeSparseVector(Map<int, double> vector) {
    double normSquared = 0.0;
    for (final value in vector.values) {
      normSquared += value * value;
    }
    
    if (normSquared > 0) {
      final invNorm = 1.0 / sqrt(normSquared);
      for (final key in vector.keys) {
        vector[key] = vector[key]! * invNorm;
      }
    }
  }

  /// УЛЬТРА-ОПТИМИЗИРОВАННОЕ вычисление сигнатуры
  Uint8List _computeUltraSignature(Map<int, double> sparseVector) {
    final signatureBytes = Uint8List((_numHyperplanes + _bitsPerByte - 1) ~/ _bitsPerByte);
    
    for (int i = 0; i < _numHyperplanes; i++) {
      final hyperplane = _hyperplanes[i];
      double dotProduct = 0.0;
      
      // МАКСИМАЛЬНО ОПТИМИЗИРОВАННЫЙ цикл
      if (sparseVector.length < hyperplane.length) {
        for (final entry in sparseVector.entries) {
          final value = hyperplane[entry.key];
          if (value != null) {
            dotProduct += entry.value * value;
          }
        }
      } else {
        for (final entry in hyperplane.entries) {
          final value = sparseVector[entry.key];
          if (value != null) {
            dotProduct += value * entry.value;
          }
        }
      }
      
      // Установка бита без ветвлений
      if (dotProduct >= 0) {
        final byteIndex = i ~/ _bitsPerByte;
        final bitIndex = i % _bitsPerByte;
        signatureBytes[byteIndex] |= (1 << bitIndex);
      }
    }
    
    return signatureBytes;
  }

  /// КВАНТОВАННОЕ вычисление нормы (8x сжатие)
  double _computeQuantizedNorm(Map<int, double> vector) {
    double sum = 0.0;
    for (final value in vector.values) {
      sum += value * value;
    }
    return sqrt(sum);
  }

  /// МЕГА-ОПТИМИЗИРОВАННОЕ добавление вектора с поддержкой int и double
void addVector(String vectorId, dynamic vector) {
  if (vector is Map<int, double>) {
    final signature = _computeUltraSignature(vector);
    _addQuantizedSignature(vectorId, signature);
  } else if (vector is Map<int, int>) {
    final normalizedVector = _normalizeIntVector(vector);
    final signature = _computeUltraSignature(normalizedVector);
    _addQuantizedSignature(vectorId, signature);
  } else {
    throw ArgumentError('Vector must be Map<int, double> or Map<int, int>');
  }
}

/// УЛЬТРА-БЫСТРАЯ нормализация int вектора в double
Map<int, double> _normalizeIntVector(Map<int, int> intVector) {
  if (intVector.isEmpty) return {};
  
  // Вычисляем сумму за один проход
  int sum = 0;
  for (final value in intVector.values) {
    sum += value;
  }
  
  // Если сумма 0, возвращаем нулевой вектор
  if (sum == 0) return {};
  
  // Конвертируем в double с нормализацией за один проход
  final invSum = 1.0 / sum;
  final normalized = <int, double>{};
  
  for (final entry in intVector.entries) {
    normalized[entry.key] = entry.value * invSum;
  }
  
  return normalized;
}

/// Добавление уже нормализованного вектора (ЕЩЕ БЫСТРЕЕ)
void addNormalizedVector(String vectorId, List<double> normalizedVector) {
  final sparseVector = <int, double>{};
  for (int i = 0; i < normalizedVector.length; i++) {
    final value = normalizedVector[i];
    if (value != 0.0) {
      sparseVector[i] = value;
    }
  }
  final signature = _computeUltraSignature(sparseVector);
  _addQuantizedSignature(vectorId, signature);
}

/// Добавление int вектора с предварительной нормализацией
void addIntVector(String vectorId, Map<int, int> intVector) {
  final normalizedVector = _normalizeIntVector(intVector);
  final signature = _computeUltraSignature(normalizedVector);
  _addQuantizedSignature(vectorId, signature);
}
  /// КВАНТОВАННОЕ хранение сигнатур

  /// СУПЕР-БЫСТРЫЙ поиск похожих векторов
  Set<String> findSimilarVectors(Map<int, double> queryVector, {double threshold = 0.7}) {
    final querySignature = _computeUltraSignature(queryVector);
    return _findByQuantizedSignature(querySignature);
  }

  Set<String> findSimilarNormalized(List<double> normalizedVector, {double threshold = 0.7}) {
    final sparseVector = <int, double>{};
    for (int i = 0; i < normalizedVector.length; i++) {
      final value = normalizedVector[i];
      if (value != 0.0) {
        sparseVector[i] = value;
      }
    }
    return findSimilarVectors(sparseVector, threshold: threshold);
  }

  /// УЛЬТРА-ОПТИМИЗИРОВАННЫЙ поиск по квантованной сигнатуре
   /// ИСПРАВЛЕННОЕ квантованное хранение сигнатур
  void _addQuantizedSignature(String vectorId, Uint8List signature) {
    _vectorSignatures[vectorId] = signature;
    
    for (int band = 0; band < _numBands; band++) {
      final startByte = band * _rowsPerBand ~/ _bitsPerByte;
      final endByte = ((band + 1) * _rowsPerBand + _bitsPerByte - 1) ~/ _bitsPerByte;
      final bandSignature = Uint8List.sublistView(signature, startByte, endByte);
      
      final bandKey = _bytesToKey(bandSignature);
      
      // Сохраняем связь bucket → vectorId
      _bucketToVectors[band][bandKey] ??= <String>{};
      _bucketToVectors[band][bandKey]!.add(vectorId);
      
      // Сохраняем сигнатуру для быстрого сравнения
      _buckets[band][bandKey] = bandSignature;
    }
  }

  /// ПОЛНОСТЬЮ ИСПРАВЛЕННЫЙ поиск
  Set<String> _findByQuantizedSignature(Uint8List signature) {
    final candidates = <String>{};
    
    for (int band = 0; band < _numBands; band++) {
      final startByte = band * _rowsPerBand ~/ _bitsPerByte;
      final endByte = ((band + 1) * _rowsPerBand + _bitsPerByte - 1) ~/ _bitsPerByte;
      final bandSignature = Uint8List.sublistView(signature, startByte, endByte);
      
      final bandKey = _bytesToKey(bandSignature);
      final bucketVectors = _bucketToVectors[band][bandKey];
      
      if (bucketVectors != null) {
        // Проверяем точное совпадение сигнатур для каждого вектора
        for (final vectorId in bucketVectors) {
          final storedSignature = _vectorSignatures[vectorId];
          if (storedSignature != null && 
              _bandSignaturesMatch(bandSignature, storedSignature, band)) {
            candidates.add(vectorId);
          }
        }
      }
    }
    
    return candidates;
  }

  /// Проверка совпадения только нужной полосы сигнатур
  bool _bandSignaturesMatch(Uint8List queryBand, Uint8List storedFullSignature, int band) {
    final startByte = band * _rowsPerBand ~/ _bitsPerByte;
    final endByte = ((band + 1) * _rowsPerBand + _bitsPerByte - 1) ~/ _bitsPerByte;
    
    final storedBand = Uint8List.sublistView(storedFullSignature, startByte, endByte);
    
    return _signaturesMatch(queryBand, storedBand);
  }
  /// СВЕРХБЫСТРОЕ сравнение сигнатур
  bool _signaturesMatch(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// ЭКСТРЕМАЛЬНО ОПТИМИЗИРОВАННОЕ косинусное сходство
  double exactCosineSimilarity(Map<int, double> vector1, Map<int, double> vector2) {
    // Быстрая проверка на пустые векторы
    if (vector1.isEmpty || vector2.isEmpty) return 0.0;
    
    double dotProduct = 0.0;
    double norm1Squared = 0.0;
    double norm2Squared = 0.0;
    
    // ОДИН проход для всех вычислений
    if (vector1.length < vector2.length) {
      for (final entry in vector1.entries) {
        final value1 = entry.value;
        final value2 = vector2[entry.key];
        norm1Squared += value1 * value1;
        if (value2 != null) {
          dotProduct += value1 * value2;
        }
      }
      for (final value2 in vector2.values) {
        norm2Squared += value2 * value2;
      }
    } else {
      for (final entry in vector2.entries) {
        final value2 = entry.value;
        final value1 = vector1[entry.key];
        norm2Squared += value2 * value2;
        if (value1 != null) {
          dotProduct += value1 * value2;
        }
      }
      for (final value1 in vector1.values) {
        norm1Squared += value1 * value1;
      }
    }
    
    if (norm1Squared == 0 || norm2Squared == 0) return 0.0;
    
    return dotProduct / (sqrt(norm1Squared) * sqrt(norm2Squared));
  }

  /// БЫСТРАЯ оценка через сигнатуры
  double estimateCosineSimilarity(Map<int, double> vector1, Map<int, double> vector2) {
    final signature1 = _computeUltraSignature(vector1);
    final signature2 = _computeUltraSignature(vector2);
    
    int matchingBits = 0;
    for (int i = 0; i < signature1.length; i++) {
      matchingBits += (signature1[i] & signature2[i]).bitCount;
    }
    
    return cos((1 - matchingBits / _numHyperplanes) * pi);
  }

  /// УЛЬТРА-ЭФФЕКТИВНЫЙ хэш для байтов
  String _bytesToKey(Uint8List bytes) {
    // Оптимизированный хэш для быстрого поиска
    final buffer = StringBuffer();
    for (int i = 0; i < min(bytes.length, 8); i++) {
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  /// Расширенная статистика с квантованием
  Map<String, dynamic> getStats() {
    int totalBuckets = 0;
    int totalVectors = _vectorToBucket.length;
    int totalHyperplaneElements = 0;
    int totalSignatureMemory = 0;
    
    for (final hyperplane in _hyperplanes) {
      totalHyperplaneElements += hyperplane.length;
    }
    
    for (final bucket in _buckets) {
      totalBuckets += bucket.length;
      for (final signature in bucket.values) {
        totalSignatureMemory += signature.length;
      }
    }
    
    final originalMemory = totalVectors * _numHyperplanes ~/ _bitsPerByte;
    final compressedMemory = totalSignatureMemory;
    final compressionRatio = originalMemory / compressedMemory;
    
    return {
      'dimensions': _dimensions,
      'numHyperplanes': _numHyperplanes,
      'numBands': _numBands,
      'totalVectors': totalVectors,
      'totalBuckets': totalBuckets,
      'hyperplaneSparsity': '${((1 - totalHyperplaneElements / (_hyperplanes.length * _dimensions)) * 100).toStringAsFixed(1)}%',
      'signatureMemory': '${compressedMemory / 1024} КБ',
      'compressionRatio': '${compressionRatio.toStringAsFixed(1)}x',
      'memoryPerVector': '${(compressedMemory / totalVectors).toStringAsFixed(2)} байт',
    };
  }

  /// Очистка с минимальными накладными расходами
  void clear() {
    for (final bucket in _buckets) {
      bucket.clear();
    }
    _vectorToBucket.clear();
  }
}

/// Расширение для быстрого подсчета битов
extension _BitCount on int {
  int get bitCount {
    var count = 0;
    var n = this;
    while (n > 0) {
      count += n & 1;
      n >>= 1;
    }
    return count;
  }
}
class SemanticSearchSystem {
  final CosineLSH _lsh;
  final int _maxDimensions;
  final Map<String, Map<int, double>> _vectorStorage;
  
  SemanticSearchSystem({
    required int maxDimensions,
    int numHyperplanes = 100,
    int numBands = 20,
  }) : _lsh = CosineLSH(
          dimensions: maxDimensions,
          numHyperplanes: numHyperplanes,
          numBands: numBands,
        ),
        _maxDimensions = maxDimensions,
        _vectorStorage = {};
  
  /// Добавление вектора с автоматической нормализацией и расширением
  void addVector(String vectorId, dynamic sparseVector) {
    // Нормализуем и расширяем вектор


    final normalizedVector = normalizeAndExpandVector(sparseVector);
    
    // Обрезаем до максимальной размерности если нужно
    final trimmedVector = normalizedVector.length > _maxDimensions 
        ? normalizedVector.sublist(0, _maxDimensions)
        : normalizedVector;
    
    // Конвертируем обратно в Map<int, double> для CosineLSH
    final preparedVector = _listToSparseMap(trimmedVector);
    
    // Сохраняем оригинальный вектор для точных вычислений
    _vectorStorage[vectorId] = preparedVector;
   
    // Добавляем в LSH индекс
    _lsh.addVector(vectorId, preparedVector);
  }

  
  List<double> normalizeAndExpandVector(dynamic inputVector) {
  if (inputVector is Map<int, double>) {
    return normalizeAndExpandVectorDouble(inputVector);
  } else if (inputVector is Map<int, int>) {
    return normalizeAndExpandVectorInt(inputVector);
  } else {
    throw ArgumentError('Input must be Map<int, double> or Map<int, int>');
  }
}

List<double> normalizeAndExpandVectorDouble(Map<int, double> inputVector) {
  if (inputVector.isEmpty) return [];
  final maxId = inputVector.keys.reduce((a, b) => a > b ? a : b);
  final sum = inputVector.values.reduce((a, b) => a + b);
  final result = List<double>.filled(maxId, 0.0);
  
  final sortedEntries = inputVector.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  
  for (final entry in sortedEntries) {
    final index = entry.key - 1;
    if (index < result.length) {
      result[index] = sum == 0 ? 0.0 : entry.value / sum;
    }
  }
  
  return result;
}

List<double> normalizeAndExpandVectorInt(Map<int, int> inputVector) {
  if (inputVector.isEmpty) return [];
  final maxId = inputVector.keys.reduce((a, b) => a > b ? a : b);
  final sum = inputVector.values.reduce((a, b) => a + b);
  final result = List<double>.filled(maxId, 0.0);
  
  final sortedEntries = inputVector.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  
  for (final entry in sortedEntries) {
    final index = entry.key - 1;
    if (index < result.length) {
      result[index] = sum == 0 ? 0.0 : entry.value / sum;
    }
  }
  
  return result;
}

  
  /// Добавление int-вектора
  void addVectorInt(String vectorId, Map<int, int> sparseVector) {
    final normalizedVector = normalizeAndExpandVectorInt(sparseVector);
    final trimmedVector = normalizedVector.length > _maxDimensions 
        ? normalizedVector.sublist(0, _maxDimensions)
        : normalizedVector;
    
    final preparedVector = _listToSparseMap(trimmedVector);
    _vectorStorage[vectorId] = preparedVector;
    _lsh.addVector(vectorId, preparedVector);
  }
  
  /// Поиск похожих векторов
  Set<String> findSimilarVectors(Map<int, double> queryVector, {double threshold = 0.7}) {
    final normalizedQuery = normalizeAndExpandVector(queryVector);
    final trimmedQuery = normalizedQuery.length > _maxDimensions 
        ? normalizedQuery.sublist(0, _maxDimensions)
        : normalizedQuery;
    
    final preparedQuery = _listToSparseMap(trimmedQuery);
    
    return _lsh.findSimilarVectors(preparedQuery, threshold: threshold);
  }
  
  /// Точное вычисление схожести
  double exactSimilarity(String vectorId1, String vectorId2) {
    final vector1 = _vectorStorage[vectorId1];
    final vector2 = _vectorStorage[vectorId2];
    
    if (vector1 == null || vector2 == null) return 0.0;
    
    return _lsh.exactCosineSimilarity(vector1, vector2);
  }
  
  /// Вспомогательный метод: List<double> → Map<int, double>
  Map<int, double> _listToSparseMap(List<double> list) {
    final map = <int, double>{};
    for (int i = 0; i < list.length; i++) {
      if (list[i] != 0.0) {
        map[i + 1] = list[i]; // +1 чтобы сохранить оригинальную индексацию
      }
    }
    return map;
  }
  
  /// Получение статистики
  Map<String, dynamic> getStats() {
    final lshStats = _lsh.getStats();
    return {
      ...lshStats,
      'storedVectors': _vectorStorage.length,
      'maxDimensions': _maxDimensions,
    };
  }
}
class RecommendationSystem {
  final CosineLSH _lsh;
  final Map<String, Map<int, double>> _userVectors;
  
  RecommendationSystem({required int dimensions})
      : _lsh = CosineLSH(dimensions: dimensions),
        _userVectors = {};
  
  void addUserPreferences(String userId, Map<int, double> preferences) {
    _userVectors[userId] = preferences;
    _lsh.addVector(userId, preferences);
  }
  
  Set<String> findSimilarUsers(String userId) {
    final userVector = _userVectors[userId];
    if (userVector == null) return {};
    
    return _lsh.findSimilarVectors(userVector);
  }
  
  double userSimilarity(String user1, String user2) {
    final vector1 = _userVectors[user1];
    final vector2 = _userVectors[user2];
    
    if (vector1 == null || vector2 == null) return 0.0;
    
    return _lsh.exactCosineSimilarity(vector1, vector2);
  }
}

// Использование
void example() {
  final recommender = RecommendationSystem(dimensions: 100);
  
  // Предпочтения пользователей (например, оценки товаров)
  recommender.addUserPreferences('user1', {0: 5.0, 1: 3.0, 2: 4.5});
  recommender.addUserPreferences('user2', {0: 4.8, 1: 3.2, 2: 4.6}); // Похож на user1
  recommender.addUserPreferences('user3', {10: 5.0, 11: 2.0}); // Другой профиль
  
  final similarUsers = recommender.findSimilarUsers('user1');
  print('Похожие на user1: $similarUsers'); // Найдет user2
}

class SemanticEmbedding {
  final List<double> vector;
  final DateTime createdAt;
  final String version;
  
  SemanticEmbedding({
    required this.vector,
    DateTime? createdAt,
    this.version = '1.0',
  }) : createdAt = createdAt ?? DateTime.now();
  
  // Сериализация для JSON
  Map<String, dynamic> toJson() => {
    'vector': vector,
    'createdAt': createdAt.toIso8601String(),
    'version': version,
  };
  
  factory SemanticEmbedding.fromJson(Map<String, dynamic> json) {
    return SemanticEmbedding(
      vector: List<double>.from(json['vector']),
      createdAt: DateTime.parse(json['createdAt']),
      version: json['version'] ?? '1.0',
    );
  }
  
  // Косинусная схожесть с другим эмбеддингом
  double similarityTo(SemanticEmbedding other) {
    double dot = 0.0, norm1 = 0.0, norm2 = 0.0;
    for (int i = 0; i < vector.length; i++) {
      dot += vector[i] * other.vector[i];
      norm1 += vector[i] * vector[i];
      norm2 += other.vector[i] * other.vector[i];
    }
    return dot / (sqrt(norm1) * sqrt(norm2));
  }
}
class EmbeddingService {
  final int embeddingDimensions;
  final bool useCompression;
  final Map<int, dynamic> _wordEmbeddings; // Может хранить оба типа
  final Map<int, dynamic> _neuronEmbeddings;
  final Map<int, dynamic> _fragmentEmbeddings;
  
  EmbeddingService({
    this.embeddingDimensions = 100,
    this.useCompression = true, // Включаем сжатие по умолчанию
  }) : _wordEmbeddings = {},
        _neuronEmbeddings = {},
        _fragmentEmbeddings = {};
  
  /// Генерация эмбеддинга (сжатого или обычного)
  dynamic _generateEmbeddingVector(List<double> vector) {
    if (useCompression) {
      return CompressedEmbedding(quantizedVector: CompressedEmbedding.quantize(vector));
    } else {
      return SemanticEmbedding(vector: vector);
    }
  }
   SemanticEmbedding generateWordEmbedding(Word word, Map<int, Word> allWords) {
    final vector = List<double>.filled(embeddingDimensions, 0.0);
    final random = Random(word.id);
    
    // Базовый вектор
    for (int i = 0; i < embeddingDimensions; i++) {
      vector[i] = (word.id * (i + 1)) % 1.0;
    }
    
    // Учитываем связи с другими словами
    double totalWeight = 0.0;
    word.ratings.forEach((otherWordId, rating) {
      final otherWord = allWords[otherWordId];
      if (otherWord != null && _wordEmbeddings.containsKey(otherWordId)) {
        final otherEmbedding = _wordEmbeddings[otherWordId]!;
        final weight = rating / word.allRating.toDouble();
        
        for (int i = 0; i < embeddingDimensions; i++) {
          vector[i] += otherEmbedding.vector[i] * weight;
        }
        totalWeight += weight;
      }
    });
    
    // Нормализация
    if (totalWeight > 0) {
      for (int i = 0; i < embeddingDimensions; i++) {
        vector[i] /= totalWeight;
      }
    }
    
    return SemanticEmbedding(vector: vector);
  }
  
  void _applySemanticTypeWeight(List<double> vector, String semanticType) {
    final weights = {
      'question': 1.2,
      'statement': 1.0,
      'command': 1.1,
      'exclamation': 1.15,
    };
    
    final weight = weights[semanticType] ?? 1.0;
    for (int i = 0; i < vector.length; i++) {
      vector[i] *= weight;
    }
  }
  
  void _applyNeuronRelations(Neuron neuron, List<double> vector, Map<int, Word> allWords) {
    // Учитываем рейтинги других нейронов
    neuron.neuronRatings.forEach((otherNeuronId, rating) {
      if (_neuronEmbeddings.containsKey(otherNeuronId)) {
        final otherEmbedding = _neuronEmbeddings[otherNeuronId]!;
        final influence = rating / 100.0; // Нормализация
        
        for (int i = 0; i < embeddingDimensions; i++) {
          vector[i] = vector[i] * (1 - influence) + otherEmbedding.vector[i] * influence;
        }
      }
    });
  }

  SemanticEmbedding updateNeuronEmbedding(
    Neuron neuron, 
    Map<int, Word> allWords,
    Map<int, Fragment> allFragments,
  ) {
    final embedding = generateNeuronEmbedding(neuron, allWords, allFragments);
    _neuronEmbeddings[neuron.id] = embedding;
    return embedding;
  }

    SemanticEmbedding updateFragmentEmbedding(Fragment fragment, Map<int, Word> allWords) {
    final embedding = generateFragmentEmbedding(fragment, allWords);
    _fragmentEmbeddings[fragment.id] = embedding;
    return embedding;
  }

  SemanticEmbedding generateFragmentEmbedding(Fragment fragment, Map<int, Word> allWords) {
    final vector = List<double>.filled(embeddingDimensions, 0.0);
    int validWords = 0;
    
    for (final wordId in fragment.wordIds) {
      if (_wordEmbeddings.containsKey(wordId)) {
        final wordEmbedding = _wordEmbeddings[wordId]!;
        for (int i = 0; i < embeddingDimensions; i++) {
          vector[i] += wordEmbedding.vector[i];
        }
        validWords++;
      }
    }
    
    if (validWords > 0) {
      for (int i = 0; i < embeddingDimensions; i++) {
        vector[i] /= validWords;
      }
    }
    
    _applySemanticTypeWeight(vector, fragment.semanticType);
    return SemanticEmbedding(vector: vector);
  }

  SemanticEmbedding generateNeuronEmbedding(
    Neuron neuron, 
    Map<int, Word> allWords,
    Map<int, Fragment> allFragments,
  ) {
    final vector = List<double>.filled(embeddingDimensions, 0.0);
    int validComponents = 0;
    
    // Ключевые слова
    for (final wordId in neuron.keywords) {
      if (_wordEmbeddings.containsKey(wordId)) {
        final wordEmbedding = _wordEmbeddings[wordId]!;
        for (int i = 0; i < embeddingDimensions; i++) {
          vector[i] += wordEmbedding.vector[i];
        }
        validComponents++;
      }
    }
    
    // Связанные фрагменты
    for (final fragmentId in neuron.fragmentLinks) {
      if (_fragmentEmbeddings.containsKey(fragmentId)) {
        final fragmentEmbedding = _fragmentEmbeddings[fragmentId]!;
        for (int i = 0; i < embeddingDimensions; i++) {
          vector[i] += fragmentEmbedding.vector[i];
        }
        validComponents++;
      }
    }
    
    if (validComponents > 0) {
      for (int i = 0; i < embeddingDimensions; i++) {
        vector[i] /= validComponents;
      }
    }
    
    _applyNeuronRelations(neuron, vector, allWords);
    return SemanticEmbedding(vector: vector);
  }
  /// Обновление эмбеддинга слова
  dynamic updateWordEmbedding(Word word, Map<int, Word> allWords) {
    final rawVector = _computeRawWordEmbedding(word, allWords);
    final embedding = _generateEmbeddingVector(rawVector);
    _wordEmbeddings[word.id] = embedding;
    return embedding;
  }
  
  /// Получение вектора (автоматически распаковывает если нужно)
  List<double> getVector(dynamic embedding) {
    if (embedding is CompressedEmbedding) {
      return embedding.dequantize();
    } else if (embedding is SemanticEmbedding) {
      return embedding.vector;
    }
    return List<double>.filled(embeddingDimensions, 0.0);
  }
  
  /// Схожесть между любыми типами эмбеддингов
  double computeSimilarity(dynamic emb1, dynamic emb2) {
    if (emb1 is CompressedEmbedding && emb2 is CompressedEmbedding) {
      return emb1.fastSimilarityTo(emb2); // Используем оптимизированный метод
    }
    
    // Для смешанных типов или обычных эмбеддингов
    final vec1 = getVector(emb1);
    final vec2 = getVector(emb2);
    
    double dot = 0.0, norm1 = 0.0, norm2 = 0.0;
    for (int i = 0; i < vec1.length; i++) {
      dot += vec1[i] * vec2[i];
      norm1 += vec1[i] * vec1[i];
      norm2 += vec2[i] * vec2[i];
    }
    return dot / (sqrt(norm1) * sqrt(norm2));
  }
  
  /// Поиск похожих нейронов (работает с любым типом эмбеддингов)
  List<SimilarityResult> findSimilarNeurons(int neuronId, int topK, double minSimilarity) {
    final sourceEmbedding = _neuronEmbeddings[neuronId];
    if (sourceEmbedding == null) return [];
    
    final results = <SimilarityResult>[];
    
    _neuronEmbeddings.forEach((id, embedding) {
      if (id != neuronId) {
        final similarity = computeSimilarity(sourceEmbedding, embedding);
        if (similarity >= minSimilarity) {
          results.add(SimilarityResult(id: id, similarity: similarity));
        }
      }
    });
    
    results.sort((a, b) => b.similarity.compareTo(a.similarity));
    return results.take(topK).toList();
  }

   /// ✅ ПОЛУЧИТЬ существующий эмбеддинг (без пересчета)
  SemanticEmbedding? getWordEmbedding(int wordId) => _wordEmbeddings[wordId];
  SemanticEmbedding? getFragmentEmbedding(int fragmentId) => _fragmentEmbeddings[fragmentId];
  SemanticEmbedding? getNeuronEmbedding(int neuronId) => _neuronEmbeddings[neuronId];
  
  // Приватный метод вычисления сырого вектора
  List<double> _computeRawWordEmbedding(Word word, Map<int, Word> allWords) {
    final vector = List<double>.filled(embeddingDimensions, 0.0);
    final random = Random(word.id);
    
    // Используем наше расширение для Gaussian
    for (int i = 0; i < embeddingDimensions; i++) {
      vector[i] = random.nextGaussian() * 0.1; // Меньший разброс
    }
    
    // Остальная логика остается такой же...
    double totalWeight = 0.0;
    word.ratings.forEach((otherWordId, rating) {
      final otherWord = allWords[otherWordId];
      if (otherWord != null && _wordEmbeddings.containsKey(otherWordId)) {
        final otherEmbedding = _wordEmbeddings[otherWordId];
        final otherVector = getVector(otherEmbedding);
        final weight = rating / word.allRating.toDouble();
        
        for (int i = 0; i < embeddingDimensions; i++) {
          vector[i] += otherVector[i] * weight;
        }
        totalWeight += weight;
      }
    });
    
    if (totalWeight > 0) {
      for (int i = 0; i < embeddingDimensions; i++) {
        vector[i] /= totalWeight;
      }
    }
    
    return vector;
  }
}

class SimilarityResult {
  final int id;
  final double similarity;
  
  SimilarityResult({required this.id, required this.similarity});
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'similarity': similarity,
  };
}

class CompressedEmbedding {
  final List<int> quantizedVector;
  final DateTime createdAt;
  final String version;
  
  CompressedEmbedding({
    required this.quantizedVector,
    DateTime? createdAt,
    this.version = '1.0',
  }) : createdAt = createdAt ?? DateTime.now();
  
  // Квантование из double в int8
  static List<int> quantize(List<double> vector) {
    // Находим максимальное абсолютное значение для нормализации
    double maxAbs = vector.map((v) => v.abs()).reduce((a, b) => a > b ? a : b);
    if (maxAbs == 0.0) maxAbs = 1.0; // избегаем деления на 0
    
    return vector.map((v) {
      // Нормализуем к диапазону [-127, 127]
      double normalized = v / maxAbs;
      return (normalized * 127).round().clamp(-127, 127);
    }).toList();
  }
  
  // Восстановление при использовании
  List<double> dequantize() {
    return quantizedVector.map((v) => v / 127.0).toList();
  }
  
  // Сериализация для JSON (еще более компактная!)
  Map<String, dynamic> toJson() => {
    'q': quantizedVector, // 'q' вместо 'vector' для экономии места
    'c': createdAt.millisecondsSinceEpoch,
    'v': version,
  };
  
  factory CompressedEmbedding.fromJson(Map<String, dynamic> json) {
    return CompressedEmbedding(
      quantizedVector: List<int>.from(json['q']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['c']),
      version: json['v'] ?? '1.0',
    );
  }
  
  // Косинусная схожесть между сжатыми эмбеддингами
  double similarityTo(CompressedEmbedding other) {
    final vec1 = dequantize();
    final vec2 = other.dequantize();
    
    double dot = 0.0, norm1 = 0.0, norm2 = 0.0;
    for (int i = 0; i < vec1.length; i++) {
      dot += vec1[i] * vec2[i];
      norm1 += vec1[i] * vec1[i];
      norm2 += vec2[i] * vec2[i];
    }
    return dot / (sqrt(norm1) * sqrt(norm2));
  }
  
  // Быстрая схожесть без деквантования (оптимизированная)
  double fastSimilarityTo(CompressedEmbedding other) {
    int dot = 0;
    int norm1 = 0;
    int norm2 = 0;
    
    for (int i = 0; i < quantizedVector.length; i++) {
      final v1 = quantizedVector[i];
      final v2 = other.quantizedVector[i];
      dot += v1 * v2;
      norm1 += v1 * v1;
      norm2 += v2 * v2;
    }
    
    return dot / (sqrt(norm1) * sqrt(norm2));
  }
}

extension NeuronEmbeddingExtension on Neuron {
  /// 🔄 Обновить эмбеддинг этого нейрона
  void updateEmbedding(EmbeddingService service, Map<int, Word> words, Map<int, Fragment> fragments) {
   // embedding = service.updateNeuronEmbedding(this, words, fragments);
  }
  
  /// ✅ Получить актуальный эмбеддинг (если есть)
  SemanticEmbedding? getEmbedding(EmbeddingService service) {
    //return embedding ?? service.getNeuronEmbedding(id);
  }
}

extension WordEmbeddingExtension on Word {
  /// 🔄 Обновить эмбеддинг этого слова
  void updateEmbedding(EmbeddingService service, Map<int, Word> allWords) {
    //embedding = service.updateWordEmbedding(this, allWords);
  }
  
  /// ✅ Получить актуальный эмбеддинг
  SemanticEmbedding? getEmbedding(EmbeddingService service) {
    //return embedding ?? service.getWordEmbedding(id);
  }
}

extension FragmentEmbeddingExtension on Fragment {
  /// 🔄 Обновить эмбеддинг этого фрагмента
  void updateEmbedding(EmbeddingService service, Map<int, Word> allWords) {
    //embedding = service.updateFragmentEmbedding(this, allWords);
  }
  
  /// ✅ Получить актуальный эмбеддинг
  SemanticEmbedding? getEmbedding(EmbeddingService service) {
    //return embedding ?? service.getFragmentEmbedding(id);
  }
}

// Добавляем в начало файла или в отдельный хелпер
extension GaussianRandom on Random {
  double nextGaussian() {
    // Box-Muller transform для генерации нормального распределения
    double u1 = 1.0 - nextDouble(); // (0,1] -> (0,1]
    double u2 = 1.0 - nextDouble();
    double radius = sqrt(-2.0 * log(u1));
    double theta = 2.0 * pi * u2;
    return radius * cos(theta);
  }
}

enum SemanticType {
  fact,           // Факт
  opinion,        // Мнение  
  instruction,    // Инструкция
  question,       // Вопрос
  hypothesis,     // Гипотеза
  definition,     // Определение
  comparison,     // Сравнение
  causal,         // Причинно-следственная связь
  temporal,       // Временное
  emotional,      // Эмоциональное
  unknown;        // Неопределенный тип

  /// Возвращает русское название типа
  String get displayName {
    return switch (this) {
      SemanticType.fact => 'факт',
      SemanticType.opinion => 'мнение', 
      SemanticType.instruction => 'инструкция',
      SemanticType.question => 'вопрос',
      SemanticType.hypothesis => 'гипотеза',
      SemanticType.definition => 'определение',
      SemanticType.comparison => 'сравнение',
      SemanticType.causal => 'причинно-следственная связь',
      SemanticType.temporal => 'временное утверждение',
      SemanticType.emotional => 'эмоциональное высказывание',
      SemanticType.unknown => 'неизвестный тип',
    };
  }

  /// Возвращает английское название (для JSON/API)
  String get name {
    return toString().split('.').last;
  }
}
class SemanticPatternDetector {
  /// Анализирует утверждение и определяет его семантический тип
  static SemanticType analyzeStatement(String text) {
    final cleanText = _preprocessText(text);
    
    // Проверяем паттерны в порядке приоритета
    if (_isQuestion(cleanText)) return SemanticType.question;
    if (_isFact(cleanText)) return SemanticType.fact;
    if (_isOpinion(cleanText)) return SemanticType.opinion;
    if (_isInstruction(cleanText)) return SemanticType.instruction;
    if (_isHypothesis(cleanText)) return SemanticType.hypothesis;
    if (_isDefinition(cleanText)) return SemanticType.definition;
    if (_isComparison(cleanText)) return SemanticType.comparison;
    if (_isCausal(cleanText)) return SemanticType.causal;
    if (_isTemporal(cleanText)) return SemanticType.temporal;
    if (_isEmotional(cleanText)) return SemanticType.emotional;
    
    return SemanticType.unknown;
  }
  
  /// Определяет ФАКТЫ
  static bool _isFact(String text) {
    final factPatterns = [
      // Паттерны утверждений фактов
      RegExp(r'^(является|это|составляет|равен|находится|содержит)'),
      RegExp(r'\d+(\s|\-)(лет|год|месяц|день|час|минут|секунд)'),
      RegExp(r'[0-9]+(%|градус|метр|километр|кг|г)'),
      RegExp(r'(по данным|согласно|исследования показывают|доказано)'),
      RegExp(r'(всегда|никогда|каждый|любой)'),
      // Утверждения в настоящем времени
      RegExp(r'\b(есть|существует|имеет|содержит)\b'),
    ];
    
    return factPatterns.any((pattern) => pattern.hasMatch(text));
  }
  
  /// Определяет МНЕНИЯ
  static bool _isOpinion(String text) {
    final opinionPatterns = [
      RegExp(r'\b(я думаю|по моему|на мой взгляд|считаю|полагаю)\b'),
      RegExp(r'\b(лучший|худший|красивый|уродливый|интересный|скучный)\b'),
      RegExp(r'\b(нравится|люблю|ненавижу|предпочитаю)\b'),
      RegExp(r'\b(возможно|вероятно|скорее всего|может быть)\b'),
      RegExp(r'\b(к сожалению|к счастью|жаль|рад)\b'),
    ];
    
    return opinionPatterns.any((pattern) => pattern.hasMatch(text));
  }
  
  /// Определяет ИНСТРУКЦИИ
  static bool _isInstruction(String text) {
    final instructionPatterns = [
      RegExp(r'^(нажми|введите|выберите|следуйте|используйте|установите)'),
      RegExp(r'\b(шаг|инструкция|руководство|как сделать)\b'),
      RegExp(r'\b(сначала|затем|потом|после этого|в конце)\b'),
      RegExp(r'[0-9]+\.\s'), // Нумерованные шаги
    ];
    
    return instructionPatterns.any((pattern) => pattern.hasMatch(text));
  }
  
  /// Определяет ВОПРОСЫ
  static bool _isQuestion(String text) {
    final questionPatterns = [
      RegExp(r'^\?|(\?)$'), // Заканчивается на ?
      RegExp(r'^(как|что|где|когда|почему|зачем|кто|чей|сколько)'),
      RegExp(r'\b(ли\??|не так ли\??|правильно\??|верно\??)\b'),
    ];
    
    return questionPatterns.any((pattern) => pattern.hasMatch(text));
  }
  
  /// Определяет ГИПОТЕЗЫ
  static bool _isHypothesis(String text) {
    final hypothesisPatterns = [
      RegExp(r'\b(если.*то|предположим|допустим|гипотетически)\b'),
      RegExp(r'\b(возможно|вероятно|может быть|скорее всего)\b'),
      RegExp(r'\b(предполагается|считается|полагают)\b'),
    ];
    
    return hypothesisPatterns.any((pattern) => pattern.hasMatch(text));
  }
  
  /// Определения
  static bool _isDefinition(String text) {
    return RegExp(r'^[А-Яа-я]+\s*—\s*|^[А-Яа-я]+\s*это\s*').hasMatch(text) ||
           text.contains('определение') ||
           text.contains('означает');
  }
  
  /// Сравнения
  static bool _isComparison(String text) {
    return text.contains('чем') || 
           text.contains('по сравнению') ||
           RegExp(r'\b(больше|меньше|лучше|хуже|сильнее|слабее)\b').hasMatch(text);
  }
  
  /// Причинно-следственные связи
  static bool _isCausal(String text) {
    return text.contains('потому что') ||
           text.contains('из-за') ||
           text.contains('в результате') ||
           text.contains('следовательно');
  }
  
  /// Временные утверждения
  static bool _isTemporal(String text) {
    return RegExp(r'\b(завтра|вчера|сегодня|потом|после|до|когда)\b').hasMatch(text);
  }
  
  /// Эмоциональные утверждения
  static bool _isEmotional(String text) {
    final emotionalWords = ['рад', 'грустно', 'злой', 'счастлив', 'отвратительно', 'прекрасно'];
    return emotionalWords.any((word) => text.contains(word));
  }
  
  static String _preprocessText(String text) {
    return text.toLowerCase().trim();
  }
}

class FactConfidenceAnalyzer {
  /// Оценивает уверенность в том, что утверждение - факт (0.0 - 1.0)
  static double analyzeFactConfidence(String text) {
    double confidence = 0.0;
    
    // Признаки высокофактических утверждений
    if (_containsNumbers(text)) confidence += 0.3;
    if (_containsScientificTerms(text)) confidence += 0.2;
    if (_hasFactualLanguage(text)) confidence += 0.3;
    if (_isVerifiable(text)) confidence += 0.2;
    
    // Штрафы за субъективные маркеры
    if (_containsOpinionMarkers(text)) confidence -= 0.3;
    if (_containsEmotionalLanguage(text)) confidence -= 0.2;
    
    return confidence.clamp(0.0, 1.0);
  }
  
  static bool _containsNumbers(String text) {
    return RegExp(r'\d+').hasMatch(text);
  }
  
  static bool _containsScientificTerms(String text) {
    final scientificWords = ['исследование', 'эксперимент', 'доказано', 'теория', 'закон'];
    return scientificWords.any((word) => text.toLowerCase().contains(word));
  }
  
  static bool _hasFactualLanguage(String text) {
    final factualMarkers = [
      'является', 'составляет', 'равен', 'соответствует', 
      'по данным', 'согласно', 'на основании'
    ];
    return factualMarkers.any((marker) => text.toLowerCase().contains(marker));
  }
  
  static bool _isVerifiable(String text) {
    // Утверждения, которые можно проверить
    return _containsNumbers(text) || 
           text.toLowerCase().contains('можно проверить') ||
           _containsSpecificReferences(text);
  }
  
  static bool _containsSpecificReferences(String text) {
    return RegExp(r'[А-Яа-я]+\s[0-9]+').hasMatch(text) || // "Глава 5"
           text.contains('исследование') ||
           text.contains('эксперимент');
  }
  
  static bool _containsOpinionMarkers(String text) {
    final opinionMarkers = ['я думаю', 'по моему', 'наверное', 'возможно'];
    return opinionMarkers.any((marker) => text.toLowerCase().contains(marker));
  }
  
  static bool _containsEmotionalLanguage(String text) {
    final emotionalWords = ['к сожалению', 'к счастью', 'ужасно', 'прекрасно'];
    return emotionalWords.any((word) => text.toLowerCase().contains(word));
  }
}

class SemanticAnalyzer1 {
  /// Полный анализ семантики утверждения
  static SemanticAnalysisResult analyze(String text) {
    final semanticType = SemanticPatternDetector.analyzeStatement(text);
    final factConfidence = FactConfidenceAnalyzer.analyzeFactConfidence(text);
    final entities = _extractEntities(text);
    final relations = _extractRelations(text);
    
    return SemanticAnalysisResult(
      text: text,
      semanticType: semanticType,
      factConfidence: factConfidence,
      entities: entities,
      relations: relations,
      isFactual: factConfidence > 0.7,
      isSubjective: semanticType == SemanticType.opinion || 
                   semanticType == SemanticType.emotional,
    );
  }
   static List<SemanticRelation> _extractRelations(String text) {
    return RelationExtractor.extractRelations(text);
  }
  /// Извлекает сущности из текста
  static List<SemanticEntity> _extractEntities(String text) {
    final entities = <SemanticEntity>[];
    
    // Простая реализация - можно улучшить с помощью вашей системы Word
    final words = text.split(RegExp(r'\s+'));
    
    for (final word in words) {
      if (_isPotentialEntity(word)) {
        entities.add(SemanticEntity(
          text: word,
          type: _classifyEntityType(word),
          position: text.indexOf(word),
        ));
      }
    }
    
    return entities;
  }
  
  static bool _isPotentialEntity(String word) {
    // Слова с заглавной буквы или длинные слова
    return word.length > 3 || 
           (word.isNotEmpty && word[0] == word[0].toUpperCase());
  }
  

  static final _temporalWords = {
    // Временные периоды
    'сегодня', 'завтра', 'вчера', 'сейчас', 'сразу', 'потом', 'позже',
    'скоро', 'недавно', 'давно', 'вскоре', 'сначала', 'после',
    
    // Дни недели
    'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота', 'воскресенье',
    
    // Месяцы
    'январь', 'февраль', 'март', 'апрель', 'май', 'июнь',
    'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь',
    
    // Времена года
    'весна', 'лето', 'осень', 'зима',
    
    // Части суток
    'утро', 'день', 'вечер', 'ночь', 'полдень', 'полночь',
    
    // Относительное время
    'прошлое', 'будущее', 'настоящее', 'следующий', 'предыдущий',
    'начало', 'конец', 'период', 'время', 'момент',
    
    // Частотные слова
    'всегда', 'никогда', 'иногда', 'часто', 'редко', 'обычно',
    'постоянно', 'регулярно', 'ежедневно', 'еженедельно',
    
    // Возрастные периоды
    'детство', 'юность', 'молодость', 'зрелость', 'старость',
  };

  static bool isTemporalWord(String word) {
    final cleanWord = word.toLowerCase().trim();
    return _temporalWords.contains(cleanWord) ||
           _matchesTemporalPattern(cleanWord);
  }

  static bool _matchesTemporalPattern(String word) {
    final temporalPatterns = [
      RegExp(r'^\d+:\d+$'), // 12:30
      RegExp(r'^\d+[чч]\.$'), // 12ч.
      RegExp(r'^\d+\s*(год|месяц|день|час|минут|секунд)$'), // 5 лет
      RegExp(r'^[0-9]+[-\–][0-9]+$'), // 2020-2023
      RegExp(r'^(в|на|до|после|через|во|с|по)$'), // временные предлоги
    ];

    return temporalPatterns.any((pattern) => pattern.hasMatch(word));
  }

  static final _locationWords = {
    // Общие локационные термины
    'город', 'деревня', 'село', 'поселок', 'столица', 'центр',
    'улица', 'площадь', 'проспект', 'бульвар', 'переулок',
    'дом', 'здание', 'сооружение', 'помещение', 'комната',
    
    // Географические объекты
    'страна', 'государство', 'республика', 'область', 'край',
    'район', 'округ', 'регион', 'территория', 'зона',
    'гора', 'река', 'озеро', 'море', 'океан', 'остров',
    'лес', 'поле', 'пустыня', 'долина', 'равнина',
    
    // Направления и положения
    'север', 'юг', 'запад', 'восток', 'северо-запад', 'юго-восток',
    'верх', 'низ', 'лево', 'право', 'центр', 'периферия',
    'внутри', 'снаружи', 'рядом', 'далеко', 'близко',
    
    // Типы мест
    'магазин', 'школа', 'больница', 'аптека', 'банк', 'офис',
    'ресторан', 'кафе', 'парк', 'сад', 'стадион', 'музей',
    'вокзал', 'аэропорт', 'порт', 'станция',
    
    // Предлоги места
    'в', 'на', 'у', 'около', 'возле', 'под', 'над', 'перед',
    'за', 'между', 'среди', 'через',
  };

  static final _locationPrefixes = {
    'ул.', 'пр.', 'пер.', 'б-р', 'г.', 'д.', 'к.', 'пос.', 'с.',
  };

  static final _countryNames = {
    'россия', 'рф', 'сша', 'китай', 'германия', 'франция', 'англия',
    'япония', 'индия', 'бразилия', 'канада', 'австралия',
  };

  static final _cityNames = {
    'москва', 'санкт-петербург', 'спб', 'нью-йорк', 'лондон',
    'париж', 'берлин', 'токио', 'пекин', 'сидней',
  };

  static bool isLocationWord(String word) {
    final cleanWord = word.toLowerCase().trim();
    
    return _locationWords.contains(cleanWord) ||
           _locationPrefixes.any((prefix) => cleanWord.startsWith(prefix)) ||
           _countryNames.contains(cleanWord) ||
           _cityNames.contains(cleanWord) ||
           _matchesLocationPattern(cleanWord) ||
           _isCapitalizedLocation(cleanWord, word);
  }

  static bool _matchesLocationPattern(String word) {
    final locationPatterns = [
      RegExp(r'^[А-Я][а-я]+\s*(область|край|район|республика)$'), // Московская область
      RegExp(r'^[А-Я][а-я]+-[А-Я][а-я]+$'), // Ростов-на-Дону
      RegExp(r'^[ул|пр|пер|б-р]\.\s+'), // ул. Ленина
      RegExp(r'^\d+[-–]\d+$'), // 5-й район
    ];

    return locationPatterns.any((pattern) => pattern.hasMatch(word));
  }

  static bool _isCapitalizedLocation(String cleanWord, String originalWord) {
    // Слова с заглавной буквы часто являются именами собственными (географическими)
    return originalWord.isNotEmpty && 
           originalWord[0] == originalWord[0].toUpperCase() &&
           cleanWord.length > 2 && // Исключаем короткие слова
           !_isCommonCapitalizedWord(cleanWord);
  }

  static bool _isCommonCapitalizedWord(String word) {
    final commonWords = {
      'я', 'ты', 'он', 'она', 'оно', 'мы', 'вы', 'они', // местоимения
      'это', 'то', 'вот', 'тут', 'там', 'здесь', // указательные
    };
    return commonWords.contains(word);
  }
  static EntityType _classifyEntityType(String word) {
    if (RegExp(r'[0-9]').hasMatch(word)) return EntityType.numeric;
    if (isTemporalWord(word)) return EntityType.temporal;
    if (isLocationWord(word)) return EntityType.location;
    return EntityType.concept;
  }
  

}

class SemanticAnalysisResult {
  final String text;
  final SemanticType semanticType;
  final double factConfidence;
  final List<SemanticEntity> entities;
  final List<SemanticRelation> relations;
  final bool isFactual;
  final bool isSubjective;
  
  SemanticAnalysisResult({
    required this.text,
    required this.semanticType,
    required this.factConfidence,
    required this.entities,
    required this.relations,
    required this.isFactual,
    required this.isSubjective,
  });
}

class SemanticEntity {
  final String text;
  final EntityType type;
  final int position;
  
  SemanticEntity({
    required this.text,
    required this.type,
    required this.position,
  });
}

enum EntityType { person, location, concept, numeric, temporal, object }

enum RelationType {
  isA,           // Таксономия: "кошка является животным"
  hasProperty,   // Свойство: "машина имеет колеса"
  partOf,        // Часть-целое: "рука является частью тела"
  causes,        // Причина: "дождь вызывает лужи"
  temporal,      // Временное: "завтрак перед работой"
  locatedIn,     // Локация: "Москва находится в России"
  comparesTo,    // Сравнение: "яблоко больше вишни"
  functional,    // Функциональное: "молоток используется для забивания"
  similarTo,     // Схожесть: "тигр похож на льва"
  oppositeTo,    // Противоположность: "день противоположен ночи"
}

class SemanticRelation {
  final RelationType type;
  final double confidence;
  final String? source;      // Источник отношения
  final String? target;      // Цель отношения
  final String? evidence;    // Текст, подтверждающий отношение
  final List<String>? tags;  // Дополнительные теги
  
  SemanticRelation({
    required this.type,
    required this.confidence,
    this.source,
    this.target,
    this.evidence,
    this.tags,
  });
  
  String get displayName => type.displayName;
  
  Map<String, dynamic> toJson() => {
    'type': type.name,
    'confidence': confidence,
    'source': source,
    'target': target,
    'evidence': evidence,
    'tags': tags,
  };
}

// Расширение для RelationType
extension RelationTypeExtensions on RelationType {
  String get displayName {
    return switch (this) {
      RelationType.isA => 'является',
      RelationType.hasProperty => 'имеет свойство',
      RelationType.partOf => 'является частью',
      RelationType.causes => 'вызывает',
      RelationType.temporal => 'временное отношение',
      RelationType.locatedIn => 'находится в',
      RelationType.comparesTo => 'сравнивается с',
      RelationType.functional => 'функциональное отношение',
      RelationType.similarTo => 'похож на',
      RelationType.oppositeTo => 'противоположен',
    };
  }
}

extension FragmentSemanticAnalysis on Fragment {
  SemanticAnalysisResult analyzeSemantics() {
    return SemanticAnalyzer1.analyze(text);
  }
  
  /// Быстрая проверка - является ли фрагмент фактом
  bool get isFactual {
    final analysis = analyzeSemantics();
    return analysis.isFactual;
  }
}
/*
extension NeuronSemanticAnalysis on Neuron {
  /// Анализирует семантику нейрона на основе его фрагментов
  List<SemanticAnalysisResult> analyzeFragmentsSemantics() {
    return fragmentLinks.map((fragmentId) {
      //final fragment = network.fragments[fragmentId];
      return fragment!.analyzeSemantics();
    }).toList();
  }
  
  /// Процент фактуальных фрагментов в нейроне
  double get factualPercentage {
    final analyses = analyzeFragmentsSemantics();
    if (analyses.isEmpty) return 0.0;
    
    final factualCount = analyses.where((a) => a.isFactual).length;
    return factualCount / analyses.length;
  }
}
*/
extension SemanticTypeExtensions on SemanticType {
  /// Для использования в UI
  String get capitalized {
    final name = displayName;
    return name[0].toUpperCase() + name.substring(1);
  }

  /// Для сохранения в базу данных
  String get databaseValue {
    return name;
  }

  /// Восстановление из строки
  static SemanticType? fromString(String value) {
    try {
      return SemanticType.values.firstWhere(
        (type) => type.name == value.toLowerCase() || 
                 type.displayName == value.toLowerCase(),
      );
    } catch (e) {
      return SemanticType.unknown;
    }
  }
}

class RelationExtractor {
  static List<SemanticRelation> extractRelations(String text) {
    final relations = <SemanticRelation>[];
    final cleanText = text.toLowerCase().trim();
    
    relations.addAll(_extractIsARelations(cleanText));
    relations.addAll(_extractHasRelations(cleanText));
    relations.addAll(_extractPartOfRelations(cleanText));
    relations.addAll(_extractCausalRelations(cleanText));
    relations.addAll(_extractTemporalRelations(cleanText));
    relations.addAll(_extractSpatialRelations(cleanText));
    relations.addAll(_extractComparativeRelations(cleanText));
    relations.addAll(_extractFunctionalRelations(cleanText));
    
    return relations;
  }
  
  /// Отношения "является" (таксономия)
  static List<SemanticRelation> _extractIsARelations(String text) {
    final relations = <SemanticRelation>[];
    final patterns = [
      // A является B
      RegExp(r'(\w+)\s+является\s+(\w+)'),
      // A - это B
      RegExp(r'(\w+)\s*—\s*это\s*(\w+)'),
      RegExp(r'(\w+)\s*-\s*это\s*(\w+)'),
      // A есть B
      RegExp(r'(\w+)\s+есть\s+(\w+)'),
      // A представляет собой B
      RegExp(r'(\w+)\s+представляет\s+собой\s+(\w+)'),
      // A считается B
      RegExp(r'(\w+)\s+считается\s+(\w+)'),
      // A называется B
      RegExp(r'(\w+)\s+называется\s+(\w+)'),
    ];
    
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount >= 2) {
          relations.add(SemanticRelation(
            type: RelationType.isA,
            confidence: 0.85,
            source: match.group(1),
            target: match.group(2),
            evidence: match.group(0),
          ));
        }
      }
    }
    
    return relations;
  }
  
  /// Отношения владения/свойства
  static List<SemanticRelation> _extractHasRelations(String text) {
    final relations = <SemanticRelation>[];
    final patterns = [
      // A имеет B
      RegExp(r'(\w+)\s+имеет\s+(\w+)'),
      // A обладает B
      RegExp(r'(\w+)\s+обладает\s+(\w+)'),
      // A содержит B
      RegExp(r'(\w+)\s+содержит\s+(\w+)'),
      // у A есть B
      RegExp(r'у\s+(\w+)\s+есть\s+(\w+)'),
      // A состоит из B
      RegExp(r'(\w+)\s+состоит\s+из\s+(\w+)'),
      // A включает B
      RegExp(r'(\w+)\s+включает\s+(\w+)'),
    ];
    
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount >= 2) {
          relations.add(SemanticRelation(
            type: RelationType.hasProperty,
            confidence: 0.8,
            source: match.group(1),
            target: match.group(2),
            evidence: match.group(0),
          ));
        }
      }
    }
    
    return relations;
  }
  
  /// Отношения "часть-целое"
  static List<SemanticRelation> _extractPartOfRelations(String text) {
    final relations = <SemanticRelation>[];
    final patterns = [
      // A является частью B
      RegExp(r'(\w+)\s+является\s+частью\s+(\w+)'),
      // A входит в B
      RegExp(r'(\w+)\s+входит\s+в\s+(\w+)'),
      // A находится в B
      RegExp(r'(\w+)\s+находится\s+в\s+(\w+)'),
      // A внутри B
      RegExp(r'(\w+)\s+внутри\s+(\w+)'),
      // A относится к B
      RegExp(r'(\w+)\s+относится\s+к\s+(\w+)'),
    ];
    
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount >= 2) {
          relations.add(SemanticRelation(
            type: RelationType.partOf,
            confidence: 0.75,
            source: match.group(1),
            target: match.group(2),
            evidence: match.group(0),
          ));
        }
      }
    }
    
    return relations;
  }
  
  /// Причинно-следственные отношения
  static List<SemanticRelation> _extractCausalRelations(String text) {
    final relations = <SemanticRelation>[];
    final patterns = [
      // A приводит к B
      RegExp(r'(\w+)\s+приводит\s+к\s+(\w+)'),
      // A вызывает B
      RegExp(r'(\w+)\s+вызывает\s+(\w+)'),
      // из-за A происходит B
      RegExp(r'из-за\s+(\w+)\s+происходит\s+(\w+)'),
      // A является причиной B
      RegExp(r'(\w+)\s+является\s+причиной\s+(\w+)'),
      // B зависит от A
      RegExp(r'(\w+)\s+зависит\s+от\s+(\w+)'),
      // если A, то B
      RegExp(r'если\s+(\w+),\s+то\s+(\w+)'),
    ];
    
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount >= 2) {
          relations.add(SemanticRelation(
            type: RelationType.causes,
            confidence: 0.7,
            source: match.group(1),
            target: match.group(2),
            evidence: match.group(0),
          ));
        }
      }
    }
    
    return relations;
  }
  
  /// Временные отношения
  static List<SemanticRelation> _extractTemporalRelations(String text) {
    final relations = <SemanticRelation>[];
    final patterns = [
      // A происходит до B
      RegExp(r'(\w+)\s+происходит\s+до\s+(\w+)'),
      // A следует за B
      RegExp(r'(\w+)\s+следует\s+за\s+(\w+)'),
      // A во время B
      RegExp(r'(\w+)\s+во\s+время\s+(\w+)'),
      // A после B
      RegExp(r'(\w+)\s+после\s+(\w+)'),
      // A перед B
      RegExp(r'(\w+)\s+перед\s+(\w+)'),
    ];
    
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount >= 2) {
          relations.add(SemanticRelation(
            type: RelationType.temporal,
            confidence: 0.65,
            source: match.group(1),
            target: match.group(2),
            evidence: match.group(0),
          ));
        }
      }
    }
    
    return relations;
  }
  
  /// Пространственные отношения
  static List<SemanticRelation> _extractSpatialRelations(String text) {
    final relations = <SemanticRelation>[];
    final patterns = [
      // A находится в B
      RegExp(r'(\w+)\s+находится\s+в\s+(\w+)'),
      // A расположен в B
      RegExp(r'(\w+)\s+расположен\s+в\s+(\w+)'),
      // A над B
      RegExp(r'(\w+)\s+над\s+(\w+)'),
      // A под B
      RegExp(r'(\w+)\s+под\s+(\w+)'),
      // A рядом с B
      RegExp(r'(\w+)\s+рядом\s+с\s+(\w+)'),
      // A между B и C
      RegExp(r'(\w+)\s+между\s+(\w+)\s+и\s+(\w+)'),
    ];
    
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount >= 2) {
          relations.add(SemanticRelation(
            type: RelationType.locatedIn,
            confidence: 0.7,
            source: match.group(1),
            target: match.group(2),
            evidence: match.group(0),
          ));
        }
      }
    }
    
    return relations;
  }
  
  /// Сравнительные отношения
  static List<SemanticRelation> _extractComparativeRelations(String text) {
    final relations = <SemanticRelation>[];
    final patterns = [
      // A больше, чем B
      RegExp(r'(\w+)\s+больше,\s*чем\s+(\w+)'),
      // A лучше, чем B
      RegExp(r'(\w+)\s+лучше,\s*чем\s+(\w+)'),
      // A отличается от B
      RegExp(r'(\w+)\s+отличается\s+от\s+(\w+)'),
      // A похож на B
      RegExp(r'(\w+)\s+похож\s+на\s+(\w+)'),
      // A такой же как B
      RegExp(r'(\w+)\s+такой\s+же\s+как\s+(\w+)'),
    ];
    
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount >= 2) {
          relations.add(SemanticRelation(
            type: RelationType.comparesTo,
            confidence: 0.6,
            source: match.group(1),
            target: match.group(2),
            evidence: match.group(0),
          ));
        }
      }
    }
    
    return relations;
  }
  
  /// Функциональные отношения
  static List<SemanticRelation> _extractFunctionalRelations(String text) {
    final relations = <SemanticRelation>[];
    final patterns = [
      // A используется для B
      RegExp(r'(\w+)\s+используется\s+для\s+(\w+)'),
      // A предназначен для B
      RegExp(r'(\w+)\s+предназначен\s+для\s+(\w+)'),
      // A служит для B
      RegExp(r'(\w+)\s+служит\s+для\s+(\w+)'),
      // A помогает B
      RegExp(r'(\w+)\s+помогает\s+(\w+)'),
      // A влияет на B
      RegExp(r'(\w+)\s+влияет\s+на\s+(\w+)'),
    ];
    
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount >= 2) {
          relations.add(SemanticRelation(
            type: RelationType.functional,
            confidence: 0.65,
            source: match.group(1),
            target: match.group(2),
            evidence: match.group(0),
          ));
        }
      }
    }
    
    return relations;
  }
}

// ========== СТОП-СЛОВА ==========
final Set<String> STOP_WORDS = {
  'и', 'в', 'во', 'не', 'что', 'он', 'на', 'я', 'с', 'со', 'как', 'а', 'то',
  'все', 'она', 'так', 'его', 'но', 'да', 'ты', 'к', 'у', 'же', 'вы', 'за',
  'бы', 'по', 'только', 'ее', 'её', 'мне', 'было', 'вот', 'от', 'меня',
  'еще', 'ещё', 'нет', 'о', 'из', 'ему', 'теперь', 'когда', 'даже', 'ну',
  'вдруг', 'ли', 'если', 'уже', 'или', 'ни', 'быть', 'был', 'него', 'до',
  'вас', 'нибудь', 'опять', 'уж', 'вам', 'ведь', 'там', 'потом', 'себя',
  'ничего', 'ей', 'может', 'они', 'тут', 'где', 'есть', 'надо', 'ней', 'для',
  'мы', 'тебя', 'их', 'чем', 'была', 'сам', 'чтоб', 'чтобы', 'без', 'будто',
  'чего', 'раз', 'тоже', 'себе', 'под', 'будет', 'ж', 'тогда', 'кто', 'этот',
  'того', 'потому', 'этого', 'какой', 'тот', 'какая', 'какое', 'какие', 'который',
  'та', 'тех', 'тем', 'теми', 'тому', 'тех', 'тех', 'тех', 'чей', 'чья', 'чье', 'чьи',
  'всё', 'всего', 'всей', 'всю', 'всею', 'всем', 'всех', 'всеми',
  'перед', 'при', 'об', 'про', 'над', 'через', 'после', 'между', 'из-за', 'изпод',
  'ибо', 'лишь', 'разве', 'пусть', 'давай', 'впрочем', 'зато', 'иначе',
  'ведь', 'уж', 'вон', 'всюду', 'где-то', 'куда', 'откуда', 'туда', 'сюда',
  'тогда-то', 'всё-таки', 'то-то', 'кое-кто', 'кое-что', 'кое-где', 'нигде',
  'никуда', 'никогда', 'ничто', 'никто', 'ничей', 'некто', 'нечто', 'некуда',
  'нельзя', 'всюду', 'здесь', 'сюда', 'отсюда', 'туда', 'оттуда', 'там', 'тут',
  'этим', 'этом', 'эти', 'эта', 'это', 'этих', 'этими', 'этому', 'этой', 'эту',
  'мой', 'моя', 'моё', 'мои', 'твой', 'твоя', 'твоё', 'твои', 'наш', 'наша', 'наше',
  'наши', 'ваш', 'ваша', 'ваше', 'ваши', 'ихний', 'ихняя', 'ихнее', 'ихние',
  'свой', 'своя', 'своё', 'свои', 'тот-то', 'этот-то', 'тот же', 'та же',
  'то же', 'те же', 'такой', 'такая', 'такое', 'такие', 'таков', 'такова',
  'таковы', 'таковое', 'таков-то', 'сей', 'сия', 'сие', 'сии', 'он же',
  'она же', 'оно же', 'они же', 'всякий', 'всякая', 'всякое', 'всякие',
  'каждый', 'каждая', 'каждое', 'каждые', 'самый', 'самая', 'самое', 'самые',
  'иной', 'иная', 'иное', 'иные', 'другой', 'другая', 'другое', 'другие',
  'какой-то', 'какая-то', 'какое-то', 'какие-то', 'чей-то', 'чья-то', 'чьё-то', 'чьи-то',
  'некоторый', 'некоторая', 'некоторое', 'некоторые', 'этак', 'так-то', 'вот-вот',
  'так-то', 'да-с', 'ага', ' ладно', 'ок', 'окей', 'ну-ка', 'ну же', 'ай', 'эй', 'ой',
  'алло', 'просто', 'почти', 'вроде', 'именно', 'всего', 'примерно', 'особенно',
  'давай-ка', 'всё ж', 'всё же', 'же', 'уж', 'либо', 'будь', 'будем', 'будешь',
  'будут', 'буду', 'есть', 'нету', 'неа', 'ага', 'эх', 'ах', 'ой', 'увы', 'увы', 'ага',
  'ну-ну', 'вон', 'отнюдь', 'едва', 'чуть', 'почти', 'сразу', 'опять-таки', 'ещё бы',
  'разве что', 'если бы', 'либо', 'ни-ни', 'неужели', 'чуть ли', 'чуть-чуть', 'едва ли',
  'хотя', 'пусть', 'пускай', 'раз', 'покуда', 'покамест', 'едва', 'пока', 'так как',
  'из-за того что', 'несмотря на', 'вследствие', 'чтобы не', 'дабы', 'ибо', 'затем',
  'вслед за', 'наряду с', 'при том', 'при этом', 'так же', 'в то время как', 'между тем',
  'тем не менее', 'однако', 'тоже', 'также', 'притом', 'зато', 'всё равно', 'всё-таки',
  'поэтому', 'следовательно', 'итак', 'таким образом', 'значит', 'ну а', 'а то', 'или же',
  'хотя бы', 'по крайней мере', 'по сути', 'в общем', 'в целом', 'по-моему', 'по-твоему',
  'по-нашему', 'по-вашему', 'возможно', 'наверное', 'кажется', 'якобы', 'словно', 'будто бы',
  'вроде бы', 'типа', 'мол', 'дескать', 'якобы', 'так сказать', 'в частности', 'то есть',
  'например', 'скажем', 'впрочем', 'однажды', 'некогда', 'всегда', 'часто', 'редко',
  'иногда', 'никогда', 'везде', 'где-либо', 'когда-либо', 'зачем', 'отчего', 'почему',
  'зачем-то', 'куда-либо', 'откуда-либо', 'когда-то', 'тогда-то', 'сейчас', 'теперь',
  'раньше', 'позже', 'вчера', 'сегодня', 'завтра', 'послезавтра', 'никогда', 'всегда',
  'едва ли', 'весь', 'вся', 'всё', 'все', 'всего', 'всей', 'всем', 'всеми', 'всех',
  'бывает', 'были', 'был', 'будет', 'будут', 'есть', 'нет', 'не было', 'не будет',
  'может', 'мог', 'смог', 'сможет', 'надо', 'нужно', 'следует', 'должен', 'следовало',
  'нельзя', 'можно', 'можно ли', 'нельзя ли', 'всё это', 'всё то', 'и так далее',
  'и тому подобное'
};

// ========== УТИЛИТЫ ==========
T min<T extends Comparable>(T a, T b) => a.compareTo(b) < 0 ? a : b;
T max<T extends Comparable>(T a, T b) => a.compareTo(b) > 0 ? a : b;

// ========== НОРМАЛИЗАЦИЯ ТЕКСТА ==========
class TextNormalizer {
  static String normalizeText(String text) {
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (!text.endsWith('.') && !text.endsWith('!') && !text.endsWith('?')) {
      text += '.';
    }
    if (text.isNotEmpty) {
      text = text[0].toUpperCase() + text.substring(1);
    }
    return text;
  }
}

// ========== СЕМАНТИЧЕСКИЙ АНАЛИЗ ==========
class SemanticAnalyzer {
  static String analyzeSemantics(String text) {
    text = text.toLowerCase();
    if (text.contains('?')) return 'вопрос';
    if (text.contains(RegExp(r'\b(да|нет|конечно|разумеется)\b'))) return 'утверждение';
    if (text.contains(RegExp(r'\b(сказал|ответил|спросил|продолжил)\b'))) return 'диалог';
    if (text.contains(RegExp(r'\b(потому|поэтому|следовательно|таким образом)\b'))) return 'объяснение';
    if (text.length < 50) return 'краткое высказывание';
    return 'повествование';
  }
}

// ========== СТЕММИНГ СЛОВ ==========
class WordStemmer {
  static final Map<String, String> _stemmingRules = {
    r'ся$': '', r'сь$': '', r'ое$': 'ый', r'ая$': 'ый', r'ие$': 'ий',
    r'ые$': 'ый', r'ому$': 'ый', r'ему$': 'ий', r'ими$': 'ий', r'ыми$': 'ый',
  };
  
  static String getStem(String word) {
    if (word.length < 3) return word;
    String stem = word.toLowerCase();
    for (final rule in _stemmingRules.entries) {
      final regex = RegExp(rule.key);
      if (regex.hasMatch(stem)) {
        stem = stem.replaceAll(regex, rule.value);
        break;
      }
    }
    return stem;
  }
}

// ========== ОПЕРАЦИИ С ВЕКТОРАМИ ==========
class VectorOperations {
  /// Находит пересечение двух векторов (только общие элементы)
  static Map<int, int> findCommonVector(Map<int, int> vec1, Map<int, int> vec2) {
    final common = <int, int>{};
    for (final entry in vec1.entries) {
      if (vec2.containsKey(entry.key)) {
        common[entry.key] = min(entry.value, vec2[entry.key]!);
      }
    }
    return common;
  }

  
  /// Самопроекция вектора: раскладывает все слова на собственные вектора и находит общее
  static Map<int, int> selfProjection(Map<int, int> vector, Map<int, Word> allWords) {
  if (vector.isEmpty) return {};
  
  final expandedVectors = <Map<int, int>>[];
  for (final wordId in vector.keys) {
    final word = allWords[wordId];
    if (word != null && word.ratings.isNotEmpty) {
      expandedVectors.add(word.ratings);
    }
  }
  
  if (expandedVectors.isEmpty) return vector;
  
  // Считаем частоту встречаемости и сумму значений для каждого индекса
  final indexFrequency = <int, int>{};
  final indexSum = <int, int>{};
  
  for (final vec in expandedVectors) {
    for (final entry in vec.entries) {
      final index = entry.key;
      final value = entry.value;
      
      indexFrequency[index] = (indexFrequency[index] ?? 0) + 1;
      indexSum[index] = (indexSum[index] ?? 0) + value;
    }
  }
  
  // Оставляем только индексы, встречающиеся как минимум 13 раз
  final commonVec = <int, int>{};
  for (final index in indexFrequency.keys) {
    if (indexFrequency[index]! >= 13) {
      commonVec[index] = indexSum[index]!;
    }
  }
  
  return commonVec;
}
  
  /// Поиск уникальных черт: слова с низким allRating но высоким ratings[contextWordId]
  static List<int> findUniqueFeatures(
    Map<int, int> vector,
    Map<int, Word> allWords,
    int limit,
  ) {
    final scores = <int, double>{};
    
    for (final entry in vector.entries) {
      final word = allWords[entry.key];
      if (word == null) continue;
      
      final avgConnectionStrength = entry.value / (word.allRating + 1);
      final uniquenessScore = avgConnectionStrength * 1000000 / (word.allRating + 1);
      scores[entry.key] = uniquenessScore;
    }
    
    final sortedEntries = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries.take(limit).map((e) => e.key).toList();
  }

  /// Вычисляет разность векторов (качественное различие)
  static double vectorQualityDifference(Map<int, int> vec1, Map<int, int> vec2) {
    double difference = 0.0;
    final allKeys = {...vec1.keys, ...vec2.keys};
    
    for (final key in allKeys) {
      final val1 = vec1[key] ?? 0;
      final val2 = vec2[key] ?? 0;
      difference += (val1 - val2).abs().toDouble();
    }
    
    return difference;
  }
  
  /// Оптимизация нейронных связей и пересчет весов
  static void optimizeNeuralConnectionsRebuildWeights(Map<int, Word> words) async {
    for (final word in words.values) {
      final projectedVector = selfProjection(word.ratings, words);
      
      for (final entry in projectedVector.entries) {
        final otherWord = words[entry.key];
        if (otherWord == null) continue;
        
        final rating1 = word.ratings[entry.key];
        final rating2 = otherWord.ratings[word.id];
        
        if (rating1 == null || rating2 == null) continue;
        
        final normalizedRating1 = word.allRating > 0 ? rating1 / word.allRating : 0;
        final normalizedRating2 = otherWord.allRating > 0 ? rating2 / otherWord.allRating : 0;
        
        final multiplier = ((normalizedRating1 + normalizedRating2) / 2).clamp(0.999999, 1.000001);
        
        word.ratings[entry.key] = (entry.value * multiplier).round();
        otherWord.ratings[word.id] = (rating2 * multiplier).round();
      }
      
      word.allRating = word.ratings.values.fold(0, (a, b) => a + b);
    }
  }
}
class DictionaryViewer extends StatefulWidget {
  final OptimizedNeuralNetwork network;
  
  const DictionaryViewer({Key? key, required this.network}) : super(key: key);
  
  @override
  _DictionaryViewerState createState() => _DictionaryViewerState();
}

class _DictionaryViewerState extends State<DictionaryViewer> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  DictionarySortMode _sortMode = DictionarySortMode.alphabetical;
  
  @override
  Widget build(BuildContext context) {
    final words = _getFilteredAndSortedWords();
    
    return Column(
      children: [
        // Панель управления
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск слова...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              DropdownButton<DictionarySortMode>(
                value: _sortMode,
                onChanged: (mode) {
                  setState(() {
                    _sortMode = mode!;
                  });
                },
                items: DictionarySortMode.values.map((mode) {
                  return DropdownMenuItem(
                    value: mode,
                    child: Text(_getSortModeText(mode)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        
        // Статистика
        Container(
          padding: EdgeInsets.all(8),
          color: Colors.grey[800],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Слов: ${words.length}', style: TextStyle(color: Colors.white)),
              Text('Всего связей: ${_getTotalConnections()}', style: TextStyle(color: Colors.white)),
              Text('Средний рейтинг: ${_getAverageRating()}', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        
        // Список слов
        Expanded(
          child: ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return _buildWordCard(word);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildWordCard(Word word) {
    final wordText = widget.network.wordLibrary[word.id] ?? 'unknown';
    final topConnections = word.getTopConnections(5);
    final bottomConnections = word.getBottomConnections(5, widget.network.words);
    final rareConnections = word.getRareConnections(3, widget.network.words);
    
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.grey[850],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(wordText[0].toUpperCase(), style: TextStyle(fontSize: 12)),
        ),
        title: Text(
          wordText,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Рейтинг: ${word.allRating}, Связей: ${word.ratings.length}',
          style: TextStyle(color: Colors.white70),
        ),
        children: [
          // Топ связи
          _buildConnectionSection('Топ связи', topConnections, Colors.green),
          
          // Связи с низким рейтингом
          _buildConnectionSection('Связи с низким рейтингом', bottomConnections, Colors.orange),
          
          // Редкие связи
          _buildConnectionSection('Редкие связи', rareConnections, Colors.red),
        ],
      ),
    );
  }
  
  Widget _buildConnectionSection(String title, List<MapEntry<int, int>> connections, Color color) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: connections.map((entry) {
              final wordText = widget.network.wordLibrary[entry.key] ?? 'unknown';
              final otherWord = widget.network.words[entry.key];
              final rating = otherWord?.allRating ?? 0;
              
              return Chip(
                label: Text('$wordText (${entry.value})'),
                backgroundColor: color.withOpacity(0.2),
                labelStyle: TextStyle(fontSize: 10),
                avatar: CircleAvatar(
                  backgroundColor: color,
                  radius: 8,
                  child: Text(
                    rating < 10000 ? 'R' : 'C',
                    style: TextStyle(fontSize: 6, color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  List<Word> _getFilteredAndSortedWords() {
    var words = widget.network.words.values.where((word) {
      final wordText = widget.network.wordLibrary[word.id] ?? '';
      return wordText.toLowerCase().contains(_searchQuery);
    }).toList();
    
    switch (_sortMode) {
      case DictionarySortMode.alphabetical:
        words.sort((a, b) {
          final textA = widget.network.wordLibrary[a.id] ?? '';
          final textB = widget.network.wordLibrary[b.id] ?? '';
          return textA.compareTo(textB);
        });
        break;
      case DictionarySortMode.rating:
        words.sort((a, b) => b.allRating.compareTo(a.allRating));
        break;
      case DictionarySortMode.connections:
        words.sort((a, b) => b.ratings.length.compareTo(a.ratings.length));
        break;
    }
    
    return words;
  }
  
  String _getSortModeText(DictionarySortMode mode) {
    switch (mode) {
      case DictionarySortMode.alphabetical: return 'А-Я';
      case DictionarySortMode.rating: return 'По рейтингу';
      case DictionarySortMode.connections: return 'По связям';
    }
  }
  
  int _getTotalConnections() {
    return widget.network.words.values.fold(0, (sum, word) => sum + word.ratings.length);
  }
  
  String _getAverageRating() {
    if (widget.network.words.isEmpty) return '0';
    final average = widget.network.words.values.fold(0, (sum, word) => sum + word.allRating) / 
                    widget.network.words.length;
    return average.toStringAsFixed(0);
  }
}

enum DictionarySortMode {
  alphabetical,
  rating,
  connections
}
// ========== КЛАССЫ ДАННЫХ ==========
class Word {
  final int id;
  Map<int, int> ratings;
  int allRating;
  double x, y, z;
  Set<int> sameWords;
  
  Word({
    required this.id,
    required this.ratings,
    required this.allRating,
    required this.x,
    required this.y,
    required this.z,
    Set<int>? sameWords,
  }) : sameWords = sameWords ?? <int>{};
  
  double get fontSize {
    if (allRating < 1000) return 12.0;
    if (allRating > 200000) return 18.0;
    return 12.0 + (allRating / 30000);
  }
  
  
  // Матрицы внимания
  Map<int, double> attentionWeights = {}; // веса внимания к другим словам
  Map<String, double> positionalEncoding = {}; // позиционное кодирование
  double bias = 0.0; // смещение для предсказания
  
  /// Обновить веса внимания на основе обратного распространения
  void updateAttentionWeights(Map<int, double> gradients, double learningRate) {
    for (final entry in gradients.entries) {
      final currentWeight = attentionWeights[entry.key] ?? 0.0;
      attentionWeights[entry.key] = currentWeight - learningRate * entry.value;
    }
  }
  
  /// Вычислить позиционное кодирование
  void computePositionalEncoding(int position, int dimension) {
    positionalEncoding.clear();
    for (int i = 0; i < dimension; i++) {
      final angle = position / pow(10000, 2 * i / dimension);
      if (i % 2 == 0) {
        positionalEncoding['pos_$i'] = sin(angle);
      } else {
        positionalEncoding['pos_$i'] = cos(angle);
      }
    }
  }

   /// Получить топ слов по рейтингу (верхняя часть вектора)
  List<MapEntry<int, int>> getTopConnections(int limit) {
    final sorted = ratings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).toList();
  }
  
  /// Получить слова с наименьшим allRating (нижняя часть вектора)
  List<MapEntry<int, int>> getBottomConnections(int limit, Map<int, Word> allWords) {
    final connectionsWithLowRating = <MapEntry<int, int>>[];
    
    for (final entry in ratings.entries) {
      final otherWord = allWords[entry.key];
      if (otherWord != null) {
        connectionsWithLowRating.add(entry);
      }
    }
    
    connectionsWithLowRating.sort((a, b) {
      final ratingA = allWords[a.key]?.allRating ?? 0;
      final ratingB = allWords[b.key]?.allRating ?? 0;
      return ratingA.compareTo(ratingB);
    });
    
    return connectionsWithLowRating.take(limit).toList();
  }
  
  /// Получить редкие слова в векторе (наименьший allRating)
  List<MapEntry<int, int>> getRareConnections(int limit, Map<int, Word> allWords) {
    final rareWords = <MapEntry<int, int>>[];
    
    for (final entry in ratings.entries) {
      final otherWord = allWords[entry.key];
      if (otherWord != null && otherWord.allRating < 10000) { // порог для "редких" слов
        rareWords.add(entry);
      }
    }
    
    rareWords.sort((a, b) {
      final ratingA = allWords[a.key]?.allRating ?? 0;
      final ratingB = allWords[b.key]?.allRating ?? 0;
      return ratingA.compareTo(ratingB);
    });
    
    return rareWords.take(limit).toList();
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'ratings': ratings.map((k, v) => MapEntry(k.toString(), v)),
    'all_rating': allRating,
    'x': x, 'y': y, 'z': z,
    'same_words': sameWords.toList(),
  };
  
  factory Word.fromJson(Map<String, dynamic> json) => Word(
    id: json['id'],
    ratings: (json['ratings'] as Map).map((k, v) => MapEntry(int.parse(k), v as int)),
    allRating: json['all_rating'] ?? 0,
    x: (json['x'] ?? 0.0).toDouble(),
    y: (json['y'] ?? 0.0).toDouble(),
    z: (json['z'] ?? 0.0).toDouble(),
    sameWords: Set<int>.from(json['same_words'] ?? []),
  );
}

class Fragment {
  final int id;
  final String text;
  List<int> wordIds;
  int? packageId;
  String semanticType;
  List<int> neuronIds;
Fragment({
    required this.id,
    required this.text,
    required this.wordIds,
    this.packageId,
    String? semanticType,
    List<int>? neuronIds,
  }) : neuronIds = neuronIds ?? [],
        semanticType = semanticType ?? SemanticAnalyzer.analyzeSemantics(text);
  
  
  List<int> get keywords {
    final wordCounts = <int, int>{};
    for (final wordId in wordIds) {
      wordCounts[wordId] = (wordCounts[wordId] ?? 0) + 1;
    }
    
    final sortedEntries = wordCounts.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries
        .take(5)
        .map((e) => e.key)
        .toList();
  }
  
  Map<String, dynamic> toJson() => {
    'id': id, 'text': text, 'word_ids': wordIds, 'neuron_ids': neuronIds,
    'package_id': packageId, 'semantic_type': semanticType,
  };
  
  factory Fragment.fromJson(Map<String, dynamic> json) => Fragment(
    id: json['id'],
    text: json['text'],
    wordIds: List<int>.from(json['word_ids']),
    neuronIds: List<int>.from(json['neuron_ids']) ?? [],
    packageId: json['package_id'],
    semanticType: json['semantic_type'] ?? 'повествование',
  );
}

enum PackageStatus { through, permanent, done }

class Package {
  final int id;
  List<int> signature;
 
  List<int> keywords;
  PackageStatus status;
  List<int> fragmentLinks;
  List<int> neuronLinks;
    Map<int, int> signatureRatings;
  Package({

    required this.id,
    required this.signature,
    List<int>? keywords,
    required this.status,
    List<int>? fragmentLinks,
    List<int>? neuronLinks,
      Map<int, int>? signatureRatings,
  }) : 
      signatureRatings = signatureRatings ?? {},
    keywords = keywords ?? List.from(signature),
    fragmentLinks = fragmentLinks ?? [],
    neuronLinks = neuronLinks ?? [];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'signature': signature, 'keywords': keywords,
    'status': status.index, 'fragment_links': fragmentLinks, 'neuron_links': neuronLinks,
  };
  
  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json['id'],
    signature: List<int>.from(json['signature']),
    keywords: List<int>.from(json['keywords']),
    status: PackageStatus.values[json['status']],
    fragmentLinks: List<int>.from(json['fragment_links']),
    neuronLinks: List<int>.from(json['neuron_links']),
  );
}
class Neuron {
  final int id;
  final int personalSynapseId;
  final String? sourceUrl;
  final String? pageTitle;
  String? fullPageContent;
  List<int> fragmentLinks;
  List<int> signature;
  List<int> keywords;
  List<int> packageLinks;
  Map<int, int> neuronRatings;
  int signature_allRating;
  Map<int, int> signatureRatings;
  double x;
  double y;
  double z;
  double screenX = 0;
  int allRating; // Убрали значение по умолчанию здесь
  double screenY = 0;
  
  Neuron({
    required this.id,
    required this.personalSynapseId,
    this.sourceUrl,
    this.pageTitle,
    this.fullPageContent,
    List<int>? fragmentLinks,
    List<int>? signature,
    List<int>? keywords,
    List<int>? packageLinks,
    Map<int, int>? neuronRatings,
    Map<int, int>? signatureRatings,
    int? signature_allRating,
    double? x,
    double? y,
    int? allRating, // Сделали nullable и убрали значение по умолчанию
    double? z,
  }) : 
    fragmentLinks = fragmentLinks ?? [],
    signature = signature ?? [],
    keywords = keywords ?? [],
    packageLinks = packageLinks ?? [],
    signature_allRating = signature_allRating ?? 0,
    neuronRatings = neuronRatings ?? {},
    allRating = allRating ?? 0, // Инициализируем здесь
    signatureRatings = signatureRatings ?? {},
    x = x ?? 0.0,
    y = y ?? 0.0,
    z = z ?? 0.0;
// Матрицы внимания для нейрона
  Map<int, Map<int, double>> attentionMatrix = {}; // матрица внимания между словами
  Map<int, double> contextWeights = {}; // веса контекстного окна
  
  /// Инициализировать матрицу внимания
  void initializeAttentionMatrix(List<int> wordIds) {
    for (final wordId1 in wordIds) {
      attentionMatrix[wordId1] = {};
      for (final wordId2 in wordIds) {
        // Инициализация маленькими случайными значениями
        attentionMatrix[wordId1]![wordId2] = Random().nextDouble() * 0.1;
      }
    }
  }
  
  void updateSignature(List<int> wordIds,OptimizedNeuralNetwork network) {
    final wordCounts = <int, int>{};
    for (final id in wordIds) {
      wordCounts[id] = (wordCounts[id] ?? 0) + 1;
    }
    
    // Обновляем signature ratings
    for (final entry in wordCounts.entries) {
      signatureRatings[entry.key] = (signatureRatings[entry.key] ?? 0) + entry.value;
      signature_allRating +=entry.value;
    }
    
    // Сортируем signature
    final sortedSignature = signatureRatings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    signature = sortedSignature.take(50).map((e) => e.key).toList();
    
    // Формируем keywords
    final top20 = sortedSignature.take(20).map((e) => e.key).toList();
    
    // Для bottom 10 берем только из оставшихся 30 слов (позиции 20-49)
    final remainingWords = sortedSignature.skip(20).take(30).map((e) => e.key).toList();
    final sortedByLowRating = remainingWords.toList()
      ..sort((a, b) {
        final ratingA = network.words[a]?.allRating ?? 0;
        final ratingB = network.words[b]?.allRating ?? 0;
        return ratingA.compareTo(ratingB);
      });
    
    final bottom10 = sortedByLowRating.take(10).toList();
    
    // Объединяем - гарантированно получим 30 уникальных элементов
    keywords = [...top20, ...bottom10];
  }
  
  /// Express: отправляет сигнатуру в связанные нейроны и получает релевантные фрагменты
  Future<Package> express(
    OptimizedNeuralNetwork network,
    {Map<int, int>? customVector}
  ) async {
    Map<int, int> expressVector;
    
    if (customVector != null) {
      final superVector = _computeSuperVector(network);
      final projectedCustom = VectorOperations.selfProjection(customVector, network.words);
      expressVector = _averageVectors(superVector, projectedCustom);
    } else {
      expressVector = _computeSuperVector(network);
    }
    
    final allFragments = <int>[];
    
    for (final synapseId in network.synapses.keys) {
      final synapse = network.synapses[synapseId];
      if (synapse == null) continue;
      
      for (final neuronId in synapse.neuronLinks) {
        if (neuronId == id) continue;
        
        final targetNeuron = network.neurons[neuronId];
        if (targetNeuron == null) continue;
        
        final similarity = _calculateSimilarity(signatureRatings, targetNeuron.signatureRatings);
        if (similarity < 0.1) continue;
        
        final relevantFragments = _getRelevantFragments(
          targetNeuron,
          expressVector,
          network,
        );
        
        allFragments.addAll(relevantFragments);
        
        neuronRatings[neuronId] = (neuronRatings[neuronId] ?? 0) + (similarity * 100).round();
        targetNeuron.neuronRatings[id] = (targetNeuron.neuronRatings[id] ?? 0) + (similarity * 100).round();
        allRating+=(similarity * 100).round();
        targetNeuron.allRating+=(similarity * 100).round();
      }
    }
    
    final sortedEntries = expressVector.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final keywords = sortedEntries.take(10).map((e) => e.key).toList();
    
    final pkg = Package(
      id: network.nextPackageId++,
      signature: expressVector.keys.toList(),
      keywords: keywords,
      status: PackageStatus.permanent,
      fragmentLinks: allFragments,
      neuronLinks: [id],
    );
    
    network.packages[pkg.id] = pkg;
    packageLinks.add(pkg.id);
    
    return pkg;
  }
  
  Map<int, int> _computeSuperVector(OptimizedNeuralNetwork network) {
    final superVector = <int, int>{};
    for (final fragId in fragmentLinks) {
      final frag = network.fragments[fragId];
      if (frag == null) continue;
      
      for (final wordId in frag.wordIds) {
        final word = network.words[wordId];
        if (word != null) {
          for (final entry in word.ratings.entries) {
            superVector[entry.key] = (superVector[entry.key] ?? 0) + entry.value;
          }
        }
      }
    }
    return VectorOperations.selfProjection(superVector, network.words);
  }
  
  Map<int, int> _averageVectors(Map<int, int> vec1, Map<int, int> vec2) {
    final avg = <int, int>{};
    final allKeys = {...vec1.keys, ...vec2.keys};
    
    for (final key in allKeys) {
      final val1 = vec1[key] ?? 0;
      final val2 = vec2[key] ?? 0;
      avg[key] = ((val1 + val2) / 2).round();
    }
    
    return avg;
  }
  
  List<int> _getRelevantFragments(
    Neuron targetNeuron,
    Map<int, int> expressVector,
    OptimizedNeuralNetwork network,
  ) {
    final fragmentScores = <int, double>{};
    
    for (final fragId in targetNeuron.fragmentLinks) {
      final frag = network.fragments[fragId];
      if (frag == null) continue;
      
      double score = 0.0;
      for (final wordId in frag.wordIds) {
        if (expressVector.containsKey(wordId)) {
          score += expressVector[wordId]!.toDouble();
        }
      }
      
      if (score > 0) {
        fragmentScores[fragId] = score;
      }
    }
    
    return (fragmentScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)))
      .take(20)
      .map((e) => e.key)
      .toList();
  }
  
double _calculateSimilarity(Map<int, int> sig1, Map<int, int> sig2) {
  if (sig1.isEmpty || sig2.isEmpty) return 0.0;
  
  // Находим общие слова
  final commonWords = sig1.keys.toSet().intersection(sig2.keys.toSet());
  if (commonWords.isEmpty) return 0.0;
  
  // Вычисляем суммы всех значений для нормализации
  final sum1 = sig1.values.reduce((a, b) => a + b).toDouble();
  final sum2 = sig2.values.reduce((a, b) => a + b).toDouble();
  
  double totalSimilarity = 0.0;
  int count = 0;
  
  for (final wordId in commonWords) {
    final value1 = sig1[wordId]!.toDouble();
    final value2 = sig2[wordId]!.toDouble();
    
    // Нормализуем значения
    final normalized1 = value1 / sum1;
    final normalized2 = value2 / sum2;
    
    // Вычисляем соотношение векторов
    final vectorRatio = normalized1 / ((normalized2 / ((value1 + value2) / 2)));
    
    // Добавляем к общей схожести
    totalSimilarity += vectorRatio;
    count++;
  }
  
  return count > 0 ? totalSimilarity / count : 0.0;
}
  
  double calculateSimilarityTo(Neuron other, Map<int, Word> words, Map<int, String> wordLibrary) {
    if (signature.isEmpty || other.signature.isEmpty) return 0.0;
    
    final set1 = signature.toSet();
    final set2 = other.signature.toSet();
    final intersection = set1.intersection(set2).length;
    final union = set1.union(set2).length;
    
    double semanticSimilarity = union > 0 ? intersection / union : 0.0;
    
    double connectionStrength = 0.0;
    int commonWordsCount = 0;
    
    final intersectionSet = set1.intersection(set2);
    for (final wordId in intersectionSet) {
      final word = words[wordId];
      if (word != null) {
        final rating1 = word.ratings[other.id] ?? 0;
        final rating2 = word.ratings[id] ?? 0;
        connectionStrength += (rating1 + rating2) / 2.0;
        commonWordsCount++;
      }
    }
    
    if (commonWordsCount > 0) {
      connectionStrength /= commonWordsCount;
      semanticSimilarity *= (1.0 + connectionStrength / 10000.0);
    }
    
    return semanticSimilarity.clamp(0.0, 1.0);
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'personal_synapse_id': personalSynapseId,
    'source_url': sourceUrl,
    'signature_ratings': signatureRatings.map((k, v) => MapEntry(k.toString(), v)),
    'page_title': pageTitle,
    'full_page_content': fullPageContent,
    'fragment_links': fragmentLinks,
    'signature': signature,
    'keywords': keywords,
    'package_links': packageLinks,
    'neuron_ratings': neuronRatings.map((k, v) => MapEntry(k.toString(), v)),
  };
  
  factory Neuron.fromJson(Map<String, dynamic> json) => Neuron(
    id: json['id'],
    personalSynapseId: json['personal_synapse_id'],
    sourceUrl: json['source_url'],
    pageTitle: json['page_title'],
    fullPageContent: json['full_page_content'],
    fragmentLinks: List<int>.from(json['fragment_links'] ?? []),
    signature: List<int>.from(json['signature'] ?? []),
    keywords: List<int>.from(json['keywords'] ?? []),
    packageLinks: List<int>.from(json['package_links'] ?? []),
    neuronRatings: (json['neuron_ratings'] as Map?)?.map((k, v) => MapEntry(int.parse(k), v as int)) ?? {},
    signatureRatings: (json['signature_ratings'] as Map?)?.map((k, v) => MapEntry(int.parse(k), v as int)) ?? {},
  );
}

class Synapse {
  final int id;
  List<int> synapseLinks;
  List<int> neuronLinks;
  
  Synapse({
    required this.id,
    List<int>? synapseLinks,
    List<int>? neuronLinks,
  }) : 
    synapseLinks = synapseLinks ?? [],
    neuronLinks = neuronLinks ?? [];
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'synapse_links': synapseLinks,
    'neuron_links': neuronLinks,
  };
  
  factory Synapse.fromJson(Map<String, dynamic> json) => Synapse(
    id: json['id'],
    synapseLinks: List<int>.from(json['synapse_links'] ?? []),
    neuronLinks: List<int>.from(json['neuron_links'] ?? []),
  );
}

// ========== КЛАСТЕР НЕЙРОНОВ ==========
class NeuronCluster {
  final String id;
  final String type;
  final String title;
  final String? domain;
  final String? path;
  final String? keyword;
  List<int> neuronIds;
  Map<int,int> signature;
  List<int> keywords;
  double x, y, z;
  bool isExpanded;
  bool isVisible;
  List<String> childClusterIds;
  String? parentClusterId;
  int depth;
  double size;
  DateTime lastUpdated;
  
  double animationProgress;
  double targetX, targetY, targetZ;
  double sourceX, sourceY, sourceZ;
  double glowIntensity;
  bool isDragging;
  
  NeuronCluster({
    required this.id,
    required this.type,
    required this.title,
    this.domain,
    this.path,
    this.keyword,
    List<int>? neuronIds,
    Map<int,int>? signature,
    List<int>? keywords,
    double? x,
    double? y,
    double? z,
    bool? isExpanded,
    bool? isVisible,
    List<String>? childClusterIds,
    this.parentClusterId,
    int? depth,
    double? size,
  }) : 
    neuronIds = neuronIds ?? [],
    signature = signature ?? {},
    keywords = keywords ?? [],
    x = x ?? 0.0,
    y = y ?? 0.0,
    z = z ?? 0.0,
    isExpanded = isExpanded ?? false,
    isVisible = isVisible ?? false,
    childClusterIds = childClusterIds ?? [],
    depth = depth ?? 0,
    size = size ?? 1.0,
    lastUpdated = DateTime.now(),
    animationProgress = 1.0,
    targetX = x ?? 0.0,
    targetY = y ?? 0.0,
    targetZ = z ?? 0.0,
    sourceX = x ?? 0.0,
    sourceY = y ?? 0.0,
    sourceZ = z ?? 0.0,
    glowIntensity = 0.0,
    isDragging = false;
  double hoverIntensity = 0.0;
  

  void startHover() {
    hoverIntensity = 0.2; // 20% прозрачности
  }

  void endHover() {
    // Hover будет плавно исчезать через updateAnimation
  }
  void updatePosition(double newX, double newY, double newZ) {
    sourceX = x;
    sourceY = y;
    sourceZ = z;
    targetX = newX;
    targetY = newY;
    targetZ = newZ;
    animationProgress = 0.0;
  }

  void updateAnimation(double deltaTime) {
    if (animationProgress < 1.0) {
      animationProgress = (animationProgress + deltaTime * 8.0).clamp(0.0, 1.0);
      final ease = _easeOutCubic(animationProgress);
      x = sourceX + (targetX - sourceX) * ease;
      y = sourceY + (targetY - sourceY) * ease;
      z = sourceZ + (targetZ - sourceZ) * ease;
    }
    
    // Анимация glow эффекта
    if (glowIntensity > 0.0) {
      glowIntensity = (glowIntensity - deltaTime * 2.0).clamp(0.0, 1.0);
    }
    
    // Анимация hover эффекта
    if (hoverIntensity > 0.0) {
      hoverIntensity = (hoverIntensity - deltaTime * 3.0).clamp(0.0, 0.2);
    }
  }

  double _easeOutCubic(double t) {
    return 1 - pow(1 - t, 3).toDouble();
  }

  

void updateSignature( OptimizedNeuralNetwork network) {
  final wordCounts = <int, int>{};

  List<int> wordIds = [];
  if (neuronIds!.isEmpty==false){
    for (final neuronId in neuronIds){
    final neuron = network.neurons[neuronId];
    if (neuron!=null) {
    for (final wordId in neuron!.keywords){
        wordIds.add(wordId);
    }}
    }
    
  }else{
    if (childClusterIds.isEmpty!=true){
      for (final clusterId in childClusterIds){
        final cluster = network.clusters[clusterId];
        if (cluster!=null){
            final sortedSignature = cluster!.signature.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            
            for (final entry in sortedSignature){
              signature[entry.key]= (signature[entry.key]??0) + entry.value.toInt();  
            }

        }
      }


    }
    return;
  }
  for (final id in wordIds) {
    wordCounts[id] = (wordCounts[id] ?? 0) + 1;
  }
  for (final neuronId in neuronIds) {
    final neuron = network.neurons[neuronId];
    if (neuron != null) {
      for (final wordId in neuron.signatureRatings.keys) {
        wordCounts[wordId] = (neuron.signatureRatings[wordId] ?? 0) + 1;
      }
    }
  }
  // Обновляем signature ratings
  for (final entry in wordCounts.entries) {
    signature[entry.key] = (signature[entry.key] ?? 0) + entry.value;
  }
  
  // Сортируем signature по убыванию значений
  final sortedSignature = signature.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  // Берем 20 самых высоких значений сигнатуры
  final top20 = sortedSignature
      .take(20)
      .map((e) => e.key)
      .toList();
  
  // Для bottom 10 берем только из оставшихся 30 слов (позиции 20-49)
  final remainingWords = sortedSignature.skip(20).map((e) => e.key).toList();
  final sortedByLowRating = remainingWords.toList()
    ..sort((a, b) {
      final ratingA = network.words[a]?.allRating ?? 0;
      final ratingB = network.words[b]?.allRating ?? 0;
      return ratingA.compareTo(ratingB);
    });
  
  final bottom10 = sortedByLowRating.take(10).toList();
  
  // Объединяем - гарантированно получим 30 уникальных элементов
  keywords = [...top20, ...bottom10];
}
  
  void startGlow() {
    glowIntensity = 1.0;
  }

  void startDrag() {
    isDragging = true;
    glowIntensity = 0.8;
  }

  void endDrag() {
    isDragging = false;
    glowIntensity = 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'domain': domain,
      'path': path,
      'keyword': keyword,
      'neuronIds': neuronIds,
      'signature': signature.map((k, v) => MapEntry(k.toString(), v)),
      'keywords': keywords,
      'x': x,
      'y': y,
      'z': z,
      'isExpanded': isExpanded,
      'isVisible': isVisible,
      'childClusterIds': childClusterIds,
      'parentClusterId': parentClusterId,
      'depth': depth,
      'size': size,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory NeuronCluster.fromJson(Map<String, dynamic> json) {
    return NeuronCluster(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      domain: json['domain'],
      path: json['path'],
      keyword: json['keyword'],
      neuronIds: List<int>.from(json['neuronIds'] ?? []),
      signature:   (json['signature_ratings'] as Map?)?.map((k, v) => MapEntry(int.parse(k), v as int)) ?? {},
      keywords: List<int>.from(json['keywords'] ?? []),
      x: (json['x'] ?? 0.0).toDouble(),
      y: (json['y'] ?? 0.0).toDouble(),
      z: (json['z'] ?? 0.0).toDouble(),
      isExpanded: json['isExpanded'] ?? false,
      isVisible: json['isVisible'] ?? true,
      childClusterIds: List<String>.from(json['childClusterIds'] ?? []),
      parentClusterId: json['parentClusterId'],
      depth: json['depth'] ?? 0,
      size: (json['size'] ?? 1.0).toDouble(),
    );
  }
}

class MetaObjectVisualizer extends StatefulWidget {
  const MetaObjectVisualizer({Key? key}) : super(key: key);
  
  @override
  _MetaObjectVisualizerState createState() => _MetaObjectVisualizerState();
}

class _MetaObjectVisualizerState extends State<MetaObjectVisualizer> {
  List<ui.Image> _images = [];
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _scale = 1.0;
  double _sliceDepth = 0.5;
  bool _isRightMouseDown = false;
  Offset? _lastMousePos;
  final TextEditingController _pathController = TextEditingController();
  bool _isLoading = false;
  String _statusMessage = 'Введите путь к директории с изображениями';

  @override
  void initState() {
    super.initState();
    // Авто-загрузка из стандартной директории при инициализации
    _loadDefaultDirectory();
  }

  void _loadDefaultDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${directory.path}/images');
    if (await imagesDir.exists()) {
      _pathController.text = imagesDir.path;
      _loadImages();
    }
  }

  Future<void> _loadImages() async {
    final directoryPath = _pathController.text.trim();
    if (directoryPath.isEmpty) {
      setState(() {
        _statusMessage = 'Путь не может быть пустым';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Загрузка изображений...';
    });

    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        setState(() {
          _statusMessage = 'Директория не существует: $directoryPath';
          _isLoading = false;
        });
        return;
      }

      final imageFiles = await directory.list()
          .where((entity) => _isImageFile(entity.path))
          .toList();

      if (imageFiles.isEmpty) {
        setState(() {
          _statusMessage = 'В директории нет изображений';
          _isLoading = false;
        });
        return;
      }

      final loadedImages = <ui.Image>[];
      int loadedCount = 0;

      for (final file in imageFiles) {
        try {
          final bytes = await File(file.path).readAsBytes();
          final image = await _loadImage(Uint8List.fromList(bytes));
          if (image != null) {
            loadedImages.add(image);
            loadedCount++;
            
            // Обновляем статус каждые 5 загруженных изображений
            if (loadedCount % 5 == 0) {
              setState(() {
                _statusMessage = 'Загружено $loadedCount/${imageFiles.length} изображений';
              });
            }
          }
        } catch (e) {
          print('Ошибка загрузки изображения ${file.path}: $e');
        }
      }

      setState(() {
        _images = loadedImages;
        _isLoading = false;
        _statusMessage = 'Загружено ${loadedImages.length} изображений';
      });

    } catch (e) {
      setState(() {
        _statusMessage = 'Ошибка доступа к директории: $e';
        _isLoading = false;
      });
    }
  }

  bool _isImageFile(String path) {
    final lowerPath = path.toLowerCase();
    return lowerPath.endsWith('.png') || 
           lowerPath.endsWith('.jpg') ||
           lowerPath.endsWith('.jpeg') ||
           lowerPath.endsWith('.gif') ||
           lowerPath.endsWith('.bmp') ||
           lowerPath.endsWith('.webp');
  }

  Future<ui.Image?> _loadImage(Uint8List bytes) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (image) {
      completer.complete(image);
    });
    return completer.future;
  }

  void _browseDirectory() async {
    // Для Flutter Desktop можно использовать file_selector или аналогичный пакет
    // В этом примере используем текстовый ввод, но можно добавить диалог выбора директории
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Выбор директории'),
        content: Text('Для выбора директории используйте поле ввода пути. '
            'Например: C:/Users/Username/Pictures или /home/username/images'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetView() {
    setState(() {
      _rotationX = 0.0;
      _rotationY = 0.0;
      _scale = 1.0;
      _sliceDepth = 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Панель управления с путем
        Container(
          padding: EdgeInsets.all(12),
          color: Colors.grey[900],
          child: Column(
            children: [
              // Строка ввода пути
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pathController,
                      decoration: InputDecoration(
                        hintText: 'Введите путь к директории с изображениями...',
                        prefixIcon: Icon(Icons.folder),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onSubmitted: (_) => _loadImages(),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Кнопка обзора
                  Tooltip(
                    message: 'Выбрать директорию',
                    child: IconButton(
                      icon: Icon(Icons.folder_open),
                      onPressed: _browseDirectory,
                    ),
                  ),
                  // Кнопка загрузки
                  Tooltip(
                    message: 'Загрузить изображения',
                    child: IconButton(
                      icon: _isLoading 
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.refresh),
                      onPressed: _isLoading ? null : _loadImages,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Статус и управление
              Row(
                children: [
                  // Статус
                  Expanded(
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _isLoading ? Colors.blue : Colors.white,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Информация
                  if (_images.isNotEmpty)
                    Text(
                      '${_images.length} изображений',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  SizedBox(width: 16),
                  // Кнопка сброса
                  if (_images.isNotEmpty)
                    Tooltip(
                      message: 'Сбросить вид',
                      child: IconButton(
                        icon: Icon(Icons.center_focus_strong, size: 18),
                        onPressed: _resetView,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // 3D визуализатор
        Expanded(
          child: _images.isEmpty
              ? _buildEmptyState()
              : MouseRegion(
                  onHover: _handleHover,
                  child: Listener(
                    onPointerDown: _handlePointerDown,
                    onPointerMove: _handlePointerMove,
                    onPointerUp: _handlePointerUp,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: MetaObjectPainter(
                        images: _images,
                        rotationX: _rotationX,
                        rotationY: _rotationY,
                        scale: _scale,
                        sliceDepth: _sliceDepth,
                      ),
                    ),
                  ),
                ),
        ),

        // Панель управления 3D (только когда есть изображения)
        if (_images.isNotEmpty)
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.grey[800],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildControlItem('Вращение', 'ЛКМ + движение'),
                _buildControlItem('Срез', 'ПКМ + движение вверх/вниз'),
                _buildControlItem('Масштаб', 'Колесо мыши'),
                _buildControlItem('Сброс', 'Кнопка выше'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 64, color: Colors.grey[700]),
            SizedBox(height: 16),
            Text(
              'Нет изображений для отображения',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Введите путь к директории с изображениями выше',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlItem(String title, String description) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          style: TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  void _handleHover(PointerHoverEvent event) {
    _lastMousePos = event.position;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (event.buttons == kSecondaryButton) {
      setState(() {
        _isRightMouseDown = true;
      });
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_isRightMouseDown && _lastMousePos != null) {
      final delta = event.position - _lastMousePos!;
      setState(() {
        _sliceDepth = (_sliceDepth + delta.dy * 0.001).clamp(0.0, 1.0);
      });
    } else if (event.buttons == kPrimaryButton && _lastMousePos != null) {
      final delta = event.position - _lastMousePos!;
      setState(() {
        _rotationY += delta.dx * 0.01;
        _rotationX += delta.dy * 0.01;
      });
    }
    _lastMousePos = event.position;
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (event.buttons == kSecondaryButton) {
      setState(() {
        _isRightMouseDown = false;
      });
    }
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }
}
 

// ========== ОПТИМИЗИРОВАННАЯ НЕЙРОСЕТЬ ==========
class OptimizedNeuralNetwork {
  final Map<int, String> wordLibrary = {};

  final Map<String, int> wordIndex = {};
  final Map<int, Word> words = {};
  final Map<int, Fragment> fragments = {};
  final Map<int, Neuron> neurons = {};
  final Map<int, Synapse> synapses = {};
  final Map<int, Package> packages = {};
  final Map<String, NeuronCluster> clusters = {};
  final SemanticSearchSystem searchSystem = SemanticSearchSystem(
        maxDimensions: 50000, // Максимальная размерность векторов
        numHyperplanes: 15,
        numBands: 20,
      );
  int nextWordId = 1;
  int nextFragmentId = 1;
  int nextNeuronId = 1;
  int nextSynapseId = 1;
  int nextPackageId = 1;
  
  final Random random = Random();
  
  static const int MAX_VECTOR_SIZE = 600;
  
  Map<int, int> currentSearchVector = {};
  List<int> currentSearchWords = [];
  
  final List<NavigationStep> navigationHistory = [];
  static const int maxHistorySteps = 10;
  
  Set<int> selectedWordIds = {};
  Set<int> selectedNeuronIds = {};
  Set<int> selectedFragmentIds = {};
  Set<String> expandedClusterIds = {};
  
  VisualizationMode visualizationMode = VisualizationMode.words;
  final List<String> clusterHistory = [];
  int historyIndex = -1;
  final Set<int> searchedNeurons = {};
  int currentSearchIndex = -1;
  
  bool _isAnimating = false;
  final Map<String, List<AnimationStage>> _animationQueue = {};
  
  final String clustersDataPath = 'qwa_ai_bd/neural_clusters_data_ai.json';
  
  // Новые поля для управления камерой и перетаскиванием
  double _cameraX = 0.0;
  double _cameraY = 0.0;
  double _cameraScale = 1.0;
  String? _draggedClusterId;
  Offset? _dragStartOffset;
  Offset? _clusterStartOffset;
  bool hasVisualChanges = false;
 final double learningRate = 0.01;
  final int contextWindowSize = 5;
  final int attentionDimension = 64;
  final Map<String, String> userWallets = {}; // userId -> walletAddress
  






   Future<List<int>> generateLine9ForAPrompt(List<int> promptWordIds) async {
    if (promptWordIds.isEmpty) {
      await AppLogger.writeLog("generateLine9 no prompt");
      return [];
    }
    
    // 1. Создание матриц внимания
    final attentionMatrices = _computeAttentionMatrices(promptWordIds);
    
    // 2. Взвешенная оценка слов промпта
    final weightedPrompt = _applyAttentionWeights(promptWordIds, attentionMatrices);
    
    // 3. Построение байесовской гипотезы на основе релевантных фрагментов
    final bayesianHypothesis = _buildBayesianHypothesis(weightedPrompt, promptWordIds);
    
    // 4. Предсказание следующего слова с обратным распространением
    final predictedWords = await _predictNextWordWithBackpropagation(
      promptWordIds, 
      weightedPrompt, 
      bayesianHypothesis
    );
    
    await AppLogger.writeLog("generateLine9 finished with ${predictedWords.length} words");
    return predictedWords;
  }
  
  /// Вычисление матриц внимания для слов промпта
  Map<int, Map<int, double>> _computeAttentionMatrices(List<int> promptWordIds) {
    final attentionMatrices = <int, Map<int, double>>{};
    
    for (final wordId in promptWordIds) {
      final word = words[wordId];
      if (word == null) continue;
      
      final attentionMatrix = <int, double>{};
      final queryVector = _computeQueryVector(word);
      
      for (final otherWordId in promptWordIds) {
        if (otherWordId == wordId) continue;
        
        final otherWord = words[otherWordId];
        if (otherWord == null) continue;
        
        final keyVector = _computeKeyVector(otherWord);
        final valueVector = _computeValueVector(otherWord);
        
        // Scaled dot-product attention
        final attentionScore = _dotProduct(queryVector, keyVector) / sqrt(attentionDimension.toDouble());
        final softmaxScore = _softmax(attentionScore, promptWordIds.length);
        
        attentionMatrix[otherWordId] = softmaxScore;
      }
      
      attentionMatrices[wordId] = attentionMatrix;
    }
    
    return attentionMatrices;
  }
  
  /// Применение весов внимания к словам промпта
  Map<int, double> _applyAttentionWeights(
    List<int> promptWordIds, 
    Map<int, Map<int, double>> attentionMatrices
  ) {
    final weightedVector = <int, double>{};
    
    for (final wordId in promptWordIds) {
      final word = words[wordId];
      if (word == null) continue;
      
      double totalWeight = 0.0;
      final wordMatrix = attentionMatrices[wordId] ?? {};
      
      for (final entry in wordMatrix.entries) {
        final otherWordId = entry.key;
        final attentionWeight = entry.value;
        final otherWord = words[otherWordId];
        
        if (otherWord != null) {
          final wordStrength = otherWord.allRating.toDouble();
          totalWeight += attentionWeight * wordStrength;
        }
      }
      
      // Гауссово взвешивание
      final gaussianWeight = _gaussianWeight(totalWeight, word.allRating.toDouble());
      weightedVector[wordId] = gaussianWeight;
    }
    
    return weightedVector;
  }
  
  /// Построение байесовской гипотезы на основе релевантных фрагментов
  Map<int, double> _buildBayesianHypothesis(
    Map<int, double> weightedPrompt, 
    List<int> promptWordIds
  ) {
    final hypothesis = <int, double>{};
    final relevantFragments = _findRelevantFragmentsForHypothesis(promptWordIds);
    
    // Байесовский вывод: P(word|context) ∝ P(context|word) * P(word)
    for (final fragment in relevantFragments) {
      for (final wordId in fragment.wordIds) {
        if (promptWordIds.contains(wordId)) continue;
        
        final word = words[wordId];
        if (word == null) continue;
        
        // P(context|word) - вероятность контекста при данном слове
        final contextProbability = _computeContextProbability(wordId, fragment, promptWordIds);
        
        // P(word) - априорная вероятность слова
        final priorProbability = word.allRating / _getTotalWordRating();
        
        // Байесовское обновление
        final posteriorProbability = contextProbability * priorProbability;
        
        hypothesis[wordId] = (hypothesis[wordId] ?? 0.0) + posteriorProbability;
      }
    }
    
    return hypothesis;
  }
  
  /// Предсказание следующего слова с обратным распространением
  Future<List<int>> _predictNextWordWithBackpropagation(
    List<int> promptWordIds,
    Map<int, double> weightedPrompt,
    Map<int, double> hypothesis
  ) async {
    final candidateScores = <int, double>{};
    final learningRate = 0.01;
    
    // Прямое распространение
    for (final candidateWordId in hypothesis.keys) {
      final candidateWord = words[candidateWordId];
      if (candidateWord == null) continue;
      
      double score = 0.0;
      
      // Вклад от взвешенного промпта
      for (final promptWordId in promptWordIds) {
        final promptWeight = weightedPrompt[promptWordId] ?? 0.0;
        final attentionWeight = candidateWord.attentionWeights[promptWordId] ?? 0.0;
        score += promptWeight * attentionWeight;
      }
      
      // Вклад от гипотезы
      score += hypothesis[candidateWordId] ?? 0.0;
      
      // Добавляем смещение
      score += candidateWord.bias;
      
      candidateScores[candidateWordId] = score;
    }
    
    // Обратное распространение для уточнения модели
    await _performBackwardPass(promptWordIds, candidateScores, learningRate);
    
    // Сортируем кандидатов по score
    final sortedCandidates = candidateScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedCandidates.take(20).map((e) => e.key).toList();
  }
  
  /// Выполнение обратного распространения
  Future<void> _performBackwardPass(
    List<int> promptWordIds,
    Map<int, double> candidateScores,
    double learningRate
  ) async {
    // Здесь реализуется упрощенное обратное распространение
    // В реальной системе это было бы более сложно
    
    for (final candidateWordId in candidateScores.keys) {
      final candidateWord = words[candidateWordId];
      if (candidateWord == null) continue;
      
      final gradients = <int, double>{};
      
      // Вычисляем градиенты для весов внимания
      for (final promptWordId in promptWordIds) {
        final error = _computePredictionError(candidateWordId, promptWordId);
        gradients[promptWordId] = error;
      }
      
      // Обновляем веса
      candidateWord.updateAttentionWeights(gradients, learningRate);
    }
  }
  
  // Вспомогательные математические функции
  List<double> _computeQueryVector(Word word) {
    // Упрощенная реализация - в реальной системе это был бы embedding
    return List.generate(attentionDimension, (i) => Random().nextDouble());
  }
  
  List<double> _computeKeyVector(Word word) {
    return List.generate(attentionDimension, (i) => Random().nextDouble());
  }
  
  List<double> _computeValueVector(Word word) {
    return List.generate(attentionDimension, (i) => Random().nextDouble());
  }
  
  double _dotProduct(List<double> vec1, List<double> vec2) {
    double result = 0.0;
    for (int i = 0; i < vec1.length; i++) {
      result += vec1[i] * vec2[i];
    }
    return result;
  }
  
  double _softmax(double value, int totalElements) {
    // Упрощенная softmax
    return exp(value) / totalElements;
  }
  
  double _gaussianWeight(double x, double mean) {
    final variance = 1.0;
    return exp(-pow(x - mean, 2) / (2 * variance));
  }
  
  List<Fragment> _findRelevantFragmentsForHypothesis(List<int> promptWordIds) {
    return fragments.values
        .where((fragment) => promptWordIds.any((wordId) => fragment.wordIds.contains(wordId)))
        .take(50)
        .toList();
  }
  
  double _computeContextProbability(int wordId, Fragment fragment, List<int> promptWordIds) {
    int matchCount = 0;
    for (final promptWordId in promptWordIds) {
      if (fragment.wordIds.contains(promptWordId)) {
        matchCount++;
      }
    }
    return matchCount / promptWordIds.length;
  }
  
  double _getTotalWordRating() {
    return words.values.fold(0, (sum, word) => sum + word.allRating).toDouble();
  }
  
  double _computePredictionError(int candidateWordId, int promptWordId) {
    // Упрощенная функция ошибки
    final candidateWord = words[candidateWordId];
    final promptWord = words[promptWordId];
    
    if (candidateWord == null || promptWord == null) return 0.0;
    
    final expected = candidateWord.ratings[promptWordId]?.toDouble() ?? 0.0;
    final actual = promptWord.ratings[candidateWordId]?.toDouble() ?? 0.0;
    
    return (expected - actual).abs();
  }
  // Добавить эти методы:
  /*
  String getOrCreateWallet(String userId) {
    if (!userWallets.containsKey(userId)) {
      final keyPair = cryptoSystem.generateKeyPair();
      userWallets[userId] = keyPair['address']!;
    }
    return userWallets[userId]!;
  }
  
  void processNeuralRewards() {
    // Награда за активность в нейросети
    for (final neuron in neurons.values) {
      if (neuron.allRating > 1000) {
        final wallet = getOrCreateWallet(neuron.id.toString());
        final reward = neuron.allRating / 10000.0;
        
        final transaction = Transaction(
          from: 'neural_network',
          to: wallet,
          amount: reward,
          type: 'neural_activity',
          metadata: {'neuron_id': neuron.id, 'rating': neuron.allRating},
        );
        
        cryptoSystem.addTransaction(transaction);
      }
    }
  }
  */


    /// Получить нейроны, содержащие выделенные фрагменты
  Set<int> getNeuronsFromSelectedFragments() {
    final neuronIds = <int>{};
    for (final fragmentId in selectedFragmentIds) {
      final fragment = fragments[fragmentId];
      if (fragment != null) {
        neuronIds.addAll(fragment.neuronIds);
      }
    }
    return neuronIds;
  }

  /// Создать карту слов из выделенных нейронов
  Map<int, double> createWordMapFromSelectedNeurons() {
    final wordMap = <int, double>{};
    
    for (final neuronId in selectedNeuronIds) {
      final neuron = neurons[neuronId];
      if (neuron != null) {
        for (final entry in neuron.signatureRatings.entries) {
          wordMap[entry.key] = (wordMap[entry.key] ?? 0.0) + entry.value.toDouble();
        }
      }
    }
    
    return wordMap;
  }

  /// Перейти к нейрону из фрагмента
  void navigateToNeuronFromFragment(int fragmentId) {
    final fragment = fragments[fragmentId];
    if (fragment != null && fragment.neuronIds.isNotEmpty) {
      // Берем первый нейрон из списка
      final neuronId = fragment.neuronIds.first;
      selectNeuron(neuronId);
      visualizationMode = VisualizationMode.neurons;
    }
  }

  /// Сохранить выделенные фрагменты в файл
  Future<void> saveSelectedFragmentsToFile() async {
    if (selectedFragmentIds.isEmpty) return;
    
    try {
      final fragmentsText = StringBuffer();
      fragmentsText.writeln('=== ВЫДЕЛЕННЫЕ ФРАГМЕНТЫ (${selectedFragmentIds.length}) ===');
      fragmentsText.writeln('Дата экспорта: ${DateTime.now()}');
      fragmentsText.writeln();
      
      for (final fragmentId in selectedFragmentIds) {
        final fragment = fragments[fragmentId];
        if (fragment != null) {
          fragmentsText.writeln('--- Фрагмент #$fragmentId ---');
          fragmentsText.writeln('Текст: ${fragment.text}');
          fragmentsText.writeln('Тип: ${fragment.semanticType}');
          fragmentsText.writeln('Слов: ${fragment.wordIds.length}');
          fragmentsText.writeln('Нейроны: ${fragment.neuronIds.join(', ')}');
          fragmentsText.writeln();
        }
      }
      
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/selected_fragments_${DateTime.now().millisecondsSinceEpoch}.txt');
      await file.writeAsString(fragmentsText.toString());
      
      // Также копируем в буфер обмена
      await Clipboard.setData(ClipboardData(text: fragmentsText.toString()));
      
      print('✅ Фрагменты сохранены в файл: ${file.path}');
    } catch (e) {
      print('❌ Ошибка сохранения фрагментов: $e');
    }
  }

  /// Открыть URL нейрона в браузере
  Future<void> openNeuronUrl(int neuronId) async {
    final neuron = neurons[neuronId];
    if (neuron?.sourceUrl != null) {
      final url = neuron!.sourceUrl!;
      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          print('❌ Не удалось открыть URL: $url');
        }
      } catch (e) {
        print('❌ Ошибка открытия URL: $e');
      }
    }
  }


  OptimizedNeuralNetwork() {
    _initializeRootNeuron();
    //createTestClusters();
  }
  
  void _initializeRootNeuron() {
    final rootSynapse = Synapse(id: 0);
    synapses[0] = rootSynapse;
    
    final rootNeuron = Neuron(id: 0, personalSynapseId: 0);
    neurons[0] = rootNeuron;
    
    rootSynapse.neuronLinks.add(0);
  }


  void updateAnimations(double deltaTime) {
    hasVisualChanges = false;
    
    for (final cluster in clusters.values) {
      final oldX = cluster.x;
      final oldY = cluster.y;
      final oldZ = cluster.z;
      final oldGlow = cluster.glowIntensity;
      final oldHover = cluster.hoverIntensity;
      
      cluster.updateAnimation(deltaTime);
      
      // Проверяем, были ли визуальные изменения
      if (cluster.x != oldX || cluster.y != oldY || cluster.z != oldZ ||
          cluster.glowIntensity != oldGlow || cluster.hoverIntensity != oldHover) {
        hasVisualChanges = true;
      }
    }}

List<Neuron> searchNeuronsByKeywords(String query) {
    final keywords = _extractWords(query);
    if (keywords.isEmpty) return [];

    final neuronScores = <Neuron, double>{};

    for (final neuron in neurons.values) {
      if (neuron.id == 0) continue;

      double score = 0.0;
      for (final keyword in keywords) {
        final wordId = wordIndex[keyword];
        if (wordId != null && neuron.signature.contains(wordId)) {
          score += 1.0;
        }
      }

      if (score > 0) {
        final signatureStrength = neuron.signature
            .where((wordId) => keywords.any((k) => wordIndex[k] == wordId))
            .map((wordId) => words[wordId]?.allRating ?? 0)
            .fold(0, (a, b) => a + b) / 1000.0;

        final totalScore = score * (1 + signatureStrength);
        neuronScores[neuron] = totalScore;
      }
    }

    final sortedEntries = neuronScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries.map((e) => e.key).toList();
  }
  Future<void> createTestClusters() async {
  print('🛠️ Creating test clusters...');
  return;
  // Очищаем существующие кластеры
  clusters.clear();
  
  // Создаем корневой кластер
  clusters['root'] = NeuronCluster(
    id: 'root',
    type: 'root',
    title: 'Root',
    x: 0.0,
    y: 300.0, // Помещаем внизу
    z: 0.0,
    depth: 0,
    size: 2.0,
    isExpanded: false,
    isVisible: true,
  );

  // Создаем несколько тестовых дочерних кластеров
  final testDomains = ['example.com', 'test.org', 'demo.net'];
  for (int i = 0; i < testDomains.length; i++) {
    final domain = testDomains[i];
    final clusterId = 'domain_$domain';
    
    clusters[clusterId] = NeuronCluster(
      id: clusterId,
      type: 'domain',
      title: domain,
      domain: domain,
      x: 0.0,
      y: 300.0 - (i * 100), // Располагаем выше родителя
      z: 0.0, // Немного разбрасываем по Z
      depth: 1,
      size: 1.5,
      isExpanded: false,
      isVisible: false, // Изначально скрыты
    );
    
    // Добавляем в дочерние корневого кластера
    clusters['root']!.childClusterIds.add(clusterId);
    clusters[clusterId]!.parentClusterId = 'root';
  }

  print('✅ Test clusters created: ${clusters.length} clusters');
  setState(() {});
}
  /// Поиск фрагментов по тексту
  List<Fragment> searchFragments(String query) {
    final keywords = query.toLowerCase().split(' ').where((w) => w.length > 2).toList();
    if (keywords.isEmpty) return [];

    final fragmentScores = <Fragment, int>{};

    for (final fragment in fragments.values) {
      int score = 0;
      final text = fragment.text.toLowerCase();

      for (final keyword in keywords) {
        if (text.contains(keyword)) {
          score += keyword.length;
        }
      }

      if (score > 0) {
        fragmentScores[fragment] = score;
      }
    }

    final sortedEntries = fragmentScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries.map((e) => e.key).toList();
  }

  // ========== ВЫБОР ЭЛЕМЕНТОВ ==========
  void selectWord(int wordId, {bool withShift = false}) {
    if (withShift) {
      if (selectedWordIds.contains(wordId)) {
        selectedWordIds.remove(wordId);
      } else {
        selectedWordIds.add(wordId);
      }
    } else {
      selectedWordIds = {wordId};
    }
    selectedNeuronIds.clear();
    selectedFragmentIds.clear();
    
    // Обновляем выделенные фрагменты на основе выбранных слов
    _updateFragmentsFromSelectedWords();
    
    addNavigationStep(NavigationStep(type: 'word', id: wordId));
  }
  
  void selectNeuron(int neuronId, {bool withShift = false}) {
    if (withShift) {
      if (selectedNeuronIds.contains(neuronId)) {
        selectedNeuronIds.remove(neuronId);
      } else {
        selectedNeuronIds.add(neuronId);
      }
    } else {
      selectedNeuronIds = {neuronId};
    }
    selectedWordIds.clear();
    selectedFragmentIds.clear();
    
    // Обновляем выделенные слова на основе выбранного нейрона
    //_updateWordsFromSelectedNeuron();
    
    addNavigationStep(NavigationStep(type: 'neuron', id: neuronId));
  }
  
  void selectFragment(int fragmentId, {bool withShift = false}) {
    if (withShift) {
      if (selectedFragmentIds.contains(fragmentId)) {
        selectedFragmentIds.remove(fragmentId);
      } else {
        selectedFragmentIds.add(fragmentId);
      }
    } else {
      selectedFragmentIds = {fragmentId};
    }
    selectedWordIds.clear();
    selectedNeuronIds.clear();
    
    // Обновляем выделенные слова на основе выбранного фрагмента
    _updateWordsFromSelectedFragment();
    
    addNavigationStep(NavigationStep(type: 'fragment', id: fragmentId));
  }
  
  void clearSelection() {
    selectedWordIds.clear();
    selectedNeuronIds.clear();
    selectedFragmentIds.clear();
  }
 // ========== ИСТОРИЯ НАВИГАЦИИ ==========
  void addNavigationStep(NavigationStep step) {
    navigationHistory.add(step);
    if (navigationHistory.length > maxHistorySteps) {
      navigationHistory.removeAt(0);
    }
  }
  
  void navigateToStep(int index) {
    if (index < 0 || index >= navigationHistory.length) return;
    
    final step = navigationHistory[index];
    switch (step.type) {
      case 'word':
        selectedWordIds = {step.id!};
        selectedNeuronIds.clear();
        selectedFragmentIds.clear();
        break;
      case 'neuron':
        selectedNeuronIds = {step.id!};
        selectedWordIds.clear();
        selectedFragmentIds.clear();
        break;
      case 'fragment':
        selectedFragmentIds = {step.id!};
        selectedWordIds.clear();
        selectedNeuronIds.clear();
        break;
      case 'search':
        // Восстанавливаем поисковый запрос
        currentSearchVector = _buildSearchVector(step.query!);
        break;
    }
  }
  
  /// Поиск фрагментов по нескольким словам
  List<Fragment> findFragmentsWithAllWords(Set<int> wordIds) {
    final result = <Fragment>[];
    
    for (final fragment in fragments.values) {
      final fragmentWordSet = fragment.wordIds.toSet();
      if (wordIds.every((wordId) => fragmentWordSet.contains(wordId))) {
        result.add(fragment);
      }
    }
    
    // Сортируем по релевантности (количество вхождений искомых слов)
    result.sort((a, b) {
      final countA = a.wordIds.where((id) => wordIds.contains(id)).length;
      final countB = b.wordIds.where((id) => wordIds.contains(id)).length;
      return countB.compareTo(countA);
    });
    
    return result;
  }

   /// Получение композитного вектора для набора слов
  Map<int, int> getCompositeVector(Set<int> wordIds) {
    final compositeVector = <int, int>{};
    
    for (final wordId in wordIds) {
      final word = words[wordId];
      if (word != null) {
        for (final entry in word.ratings.entries) {
          compositeVector[entry.key] = (compositeVector[entry.key] ?? 0) + entry.value;
        }
      }
    }
    
    return VectorOperations.selfProjection(compositeVector, words);
  }

  /// Слияние нескольких нейронов в один
  Future<Neuron> mergeNeurons(Set<int> neuronIds) async {
    final newNeuronId = nextNeuronId++;
    final newSynapseId = nextSynapseId++;
    
    final newSynapse = Synapse(id: newSynapseId);
    synapses[newSynapseId] = newSynapse;
    
    final allFragments = <int>[];
    final allPackages = <int>[];
    final neuronRatings = <int, int>{};
    String combinedTitle = '';
    
    for (final neuronId in neuronIds) {
      final neuron = neurons[neuronId];
      if (neuron == null) continue;
      
      allFragments.addAll(neuron.fragmentLinks);
      allPackages.addAll(neuron.packageLinks);
      
      for (final entry in neuron.neuronRatings.entries) {
        neuronRatings[entry.key] = (neuronRatings[entry.key] ?? 0) + entry.value;
      }
      
      if (neuron.pageTitle != null) {
        combinedTitle += '${neuron.pageTitle} + ';
      }
    }
    
    final newNeuron = Neuron(
      id: newNeuronId,
      personalSynapseId: newSynapseId,
      pageTitle: combinedTitle.isNotEmpty ? combinedTitle.substring(0, combinedTitle.length - 3) : 'Merged Neuron',
      fragmentLinks: allFragments,
      packageLinks: allPackages,
      neuronRatings: neuronRatings,
    );
    
    final allWordIds = <int>[];
    for (final fragId in allFragments) {
      final frag = fragments[fragId];
      if (frag != null) {
        allWordIds.addAll(frag.wordIds);
      }
    }
    newNeuron.updateSignature(allWordIds,this);
    
    neurons[newNeuronId] = newNeuron;
    newSynapse.neuronLinks.add(newNeuronId);
    
    for (final parentId in neuronIds) {
      newNeuron.neuronRatings[parentId] = 10000;
      final parent = neurons[parentId];
      if (parent != null) {
        parent.neuronRatings[newNeuronId] = 10000;
      }
    }
    
    return newNeuron;
  }
  
  /// Обработка связей между выбранными нейронами
  Future<void> processNeuronConnections(Set<int> neuronIds) async {
    final neuronsList = neuronIds
        .map((id) => neurons[id])
        .where((n) => n != null)
        .cast<Neuron>()
        .toList();
    
    for (int i = 0; i < neuronsList.length; i++) {
      final neuron1 = neuronsList[i];
      
      final superVec1 = <int, int>{};
      for (final fragId in neuron1.fragmentLinks) {
        final frag = fragments[fragId];
        if (frag == null) continue;
        for (final wordId in frag.wordIds) {
          final word = words[wordId];
          if (word != null) {
            for (final entry in word.ratings.entries) {
              superVec1[entry.key] = (superVec1[entry.key] ?? 0) + entry.value;
            }
          }
        }
      }
      final commonVec1 = VectorOperations.selfProjection(superVec1, words);
      
      for (int j = i + 1; j < neuronsList.length; j++) {
        final neuron2 = neuronsList[j];
        
        final superVec2 = <int, int>{};
        for (final fragId in neuron2.fragmentLinks) {
          final frag = fragments[fragId];
          if (frag == null) continue;
          for (final wordId in frag.wordIds) {
            final word = words[wordId];
            if (word != null) {
              for (final entry in word.ratings.entries) {
                superVec2[entry.key] = (superVec2[entry.key] ?? 0) + entry.value;
              }
            }
          }
        }
        final commonVec2 = VectorOperations.selfProjection(superVec2, words);
        
        final difference = VectorOperations.vectorQualityDifference(commonVec1, commonVec2);
        final similarity = 1000000 / (difference + 1);
        final rating = similarity.round();
        
        neuron1.neuronRatings[neuron2.id] = (neuron1.neuronRatings[neuron2.id] ?? 0) + rating;
        neuron2.neuronRatings[neuron1.id] = (neuron2.neuronRatings[neuron1.id] ?? 0) + rating;
      }
    }
  }
  
  /// Копирование текста из выбранных нейронов в буфер обмена
  Future<void> copyNeuronsToClipboard(Set<int> neuronIds) async {
    final allText = StringBuffer();
    
    for (final neuronId in neuronIds) {
      final neuron = neurons[neuronId];
      if (neuron == null) continue;
      
      if (neuron.pageTitle != null) {
        allText.writeln('=== ${neuron.pageTitle} ===');
      }
      
      for (final fragId in neuron.fragmentLinks) {
        final frag = fragments[fragId];
        if (frag != null) {
          allText.writeln(frag.text);
        }
      }
      allText.writeln();
    }
    
    await Clipboard.setData(ClipboardData(text: allText.toString()));
  }
  
  /// Копирование фрагментов в буфер обмена
  Future<void> copyFragmentsToClipboard(List<int> fragmentIds) async {
    final allText = StringBuffer();
    
    for (final fragId in fragmentIds) {
      final frag = fragments[fragId];
      if (frag != null) {
        allText.writeln(frag.text);
      }
    }
    
    await Clipboard.setData(ClipboardData(text: allText.toString()));
  }
  
  /// Создание визуализации слов для выбранных нейронов
  Map<int, Word> createNeuronWordsVisualization(Set<int> neuronIds) {
    final wordScores = <int, double>{};
    
    for (final neuronId in neuronIds) {
      final neuron = neurons[neuronId];
      if (neuron == null) continue;
      
      for (final fragId in neuron.fragmentLinks) {
        final frag = fragments[fragId];
        if (frag == null) continue;
        
        for (final wordId in frag.wordIds) {
          final word = words[wordId];
          if (word != null) {
            wordScores[wordId] = (wordScores[wordId] ?? 0.0) + word.allRating.toDouble();
          }
        }
      }
    }
    
    // Создаем новую проекцию слов
    final projectedWords = <int, Word>{};
    for (final entry in wordScores.entries) {
      final originalWord = words[entry.key];
      if (originalWord != null) {
        final projectedWord = Word(
          id: originalWord.id,
          ratings: Map.from(originalWord.ratings),
          allRating: originalWord.allRating,
          x: originalWord.x,
          y: originalWord.y,
          z: originalWord.z,
          sameWords: Set.from(originalWord.sameWords),
        );
        projectedWords[entry.key] = projectedWord;
      }
    }
    
    return projectedWords;
  }

  
  void _updateWordsFromSelectedFragment() {
    if (selectedFragmentIds.isEmpty) return;
    
    final wordSet = <int>{};
    for (final fragmentId in selectedFragmentIds) {
      final fragment = fragments[fragmentId];
      if (fragment != null) {
        wordSet.addAll(fragment.wordIds);
      }
    }
    selectedWordIds = wordSet;
  }
  
  void _updateFragmentsFromSelectedWords() {
    if (selectedWordIds.isEmpty) return;
    
    final fragmentScores = <int, int>{};
    for (final fragment in fragments.values) {
      int score = 0;
      for (final wordId in fragment.wordIds) {
        if (selectedWordIds.contains(wordId)) {
          score++;
        }
      }
      if (score > 0) {
        fragmentScores[fragment.id] = score;
      }
    }
    
    final sortedFragments = fragmentScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    selectedFragmentIds = sortedFragments.take(10).map((e) => e.key).toSet();
  }

  
  // ========== ПОИСК И ФИЛЬТРАЦИЯ ==========
  Map<int, int> _buildSearchVector(String query) {
    final wordTexts = _extractWords(query);
    final promptWordIds = wordTexts
        .map((w) => wordIndex[w])
        .where((id) => id != null)
        .cast<int>()
        .toList();
    
    if (promptWordIds.isEmpty) return {};
    
    final superVector = <int, int>{};
    for (final wordId in promptWordIds) {
      final word = words[wordId];
      if (word != null) {
        for (final entry in word.ratings.entries) {
          superVector[entry.key] = (superVector[entry.key] ?? 0) + entry.value;
        }
      }
    }
    
    return VectorOperations.selfProjection(superVector, words);
  }
  // ========== ОСНОВНЫЕ МЕТОДЫ КЛАСТЕРИЗАЦИИ ==========
  Future<void> updateClusters() async {
    print('🚀 Starting advanced cluster update with ${neurons.length} neurons');
    
    //await _loadClustersFromFile();
    
    if (!clusters.containsKey('root')) {
      clusters['root'] = NeuronCluster(
        id: 'root',
        type: 'root',
        title: 'Neural Network Root',
        x: 0.0,
        y: 0.0,
        z: 0.0,
        depth: 0,
        size: 2.0,
      );
    }
    clusters['root']!.isVisible=true;
     clusters['root']!.isExpanded=false;
    await _createIntermediateClusters();
    await _createUrlDomainClusters();
    //await _createKeywordClusters();
    
    //_positionAllClusters();
    //await _saveClustersToFile();

    await AppLogger.writeLog('✅ Cluster update complete: ${clusters.length} clusters');
  }


  
// НОВЫЙ МЕТОД: создаем промежуточные кластеры
Future<void> _createIntermediateClusters() async {
  print('🏗️ Creating intermediate clusters');
  
  // Создаем интернет-кластер как промежуточный
  if (!clusters.containsKey('internet')) {
    final internetCluster = NeuronCluster(
      id: 'internet',
      type: 'internet',
      title: 'Internet',
      depth: 1,
      size: 1.8,
    );
    clusters['internet'] = internetCluster;
    clusters['root']!.childClusterIds.add('internet');
    internetCluster.parentClusterId = 'root';
    print('➕ Created internet cluster');
  }
  
  // Создаем кластер для ключевых слов как промежуточный
  if (!clusters.containsKey('keyword_clusters')) {
    final keywordCluster = NeuronCluster(
      id: 'keyword_clusters',
      type: 'keyword_root',
      title: 'Keywords',
      depth: 1,
      size: 1.8,
    );
    clusters['keyword_clusters'] = keywordCluster;
    clusters['root']!.childClusterIds.add('keyword_clusters');
    keywordCluster.parentClusterId = 'root';
    print('➕ Created keyword_clusters container');
  }
}

Future<void> _createUrlDomainClusters() async {
  final domainNeuronsMap = <String, List<int>>{};
  final categoryNeuronsMap = <String, Map<String, List<int>>>{}; // категория -> домен -> нейроны
  final pathNeuronsMap = <String, Map<String, Map<String, List<int>>>>{}; // категория -> домен -> путь -> нейроны
  
  // Нормализация категорий (оставляем вашу функцию без изменений)
  String _normalizeCategory(String pathSegment) {
    final normalized = pathSegment.toLowerCase();
    
    // Форумные категории
    if (normalized.contains('forum')) return 'forums';
    if (normalized.contains('chat')) return 'chats';
    if (normalized.contains('board')) return 'forums';
    if (normalized.contains('discussion')) return 'forums';
    
    // Медиа категории
    if (normalized.contains('audio')) return 'audio';
    if (normalized.contains('music')) return 'audio';
    if (normalized.contains('video')) return 'video';
    if (normalized.contains('movie')) return 'video';
    if (normalized.contains('podcast')) return 'audio';
    
    // Текстовые категории
    if (normalized.contains('book')) return 'books';
    if (normalized.contains('wiki')) return 'wiki';
    if (normalized.contains('article')) return 'articles';
    if (normalized.contains('blog')) return 'blogs';
    if (normalized.contains('news')) return 'news';
    if (normalized.contains('story')) return 'stories';
    if (normalized.contains('song')) return 'songs';
    if (normalized.contains('poem')) return 'poems';
    
    // Пользовательские категории
    if (normalized.contains('user')) return 'users';
    if (normalized.contains('profile')) return 'profiles';
    if (normalized.contains('account')) return 'accounts';
    
    // Прочие
    if (normalized.contains('archive')) return 'archives';
    if (normalized.contains('download')) return 'downloads';
    if (normalized.contains('file')) return 'files';
    
    return normalized;
  }
  
  // Группировка по диапазонам (пагинация по 20 элементов)
  String _getRangeGroup(int number, int groupSize) {
    final lower = (number ~/ groupSize) * groupSize + 1;
    final upper = lower + groupSize - 1;
    return '$lower-$upper';
  }
  
  // Анализ URL и группировка
  for (final neuron in neurons.values) {
    if (neuron.id == 0 || neuron.sourceUrl == null) continue;
    
    try {
      final uri = Uri.parse(neuron.sourceUrl!);
      final domain = uri.host;
      
      // Группировка по доменам
      domainNeuronsMap[domain] = [...domainNeuronsMap[domain] ?? [], neuron.id];
      
      // Анализ пути для категоризации
      if (uri.path.isNotEmpty && uri.path != '/') {
        final pathSegments = uri.path.split('/').where((s) => s.isNotEmpty).toList();
        
        if (pathSegments.isNotEmpty) {
          final firstSegment = pathSegments[0];
          final category = _normalizeCategory(firstSegment);
          
          // Инициализация структур данных для категории
          if (!categoryNeuronsMap.containsKey(category)) {
            categoryNeuronsMap[category] = {};
          }
          if (!pathNeuronsMap.containsKey(category)) {
            pathNeuronsMap[category] = {};
          }
          
          // Группировка по доменам внутри категории
          categoryNeuronsMap[category]![domain] = [
            ...categoryNeuronsMap[category]![domain] ?? [],
            neuron.id
          ];
          
          // Анализ пути для создания иерархии
          if (pathSegments.length >= 2) {
            final secondSegment = pathSegments[1];
            
            // Определяем базовый путь (например, "book/1")
            final basePath = '$firstSegment/$secondSegment';
            
            if (!pathNeuronsMap[category]!.containsKey(domain)) {
              pathNeuronsMap[category]![domain] = {};
            }
            
            // Извлекаем числовой идентификатор для пагинации
            int? pageNumber;
            
            // Пытаемся найти числовой идентификатор в сегментах пути
            for (int i = 2; i < pathSegments.length; i++) {
              pageNumber = int.tryParse(pathSegments[i]);
              if (pageNumber != null) break;
            }
            
            // Если не нашли в последующих сегментах, пробуем второй сегмент
            if (pageNumber == null) {
              pageNumber = int.tryParse(secondSegment);
            }
            
            String groupKey;
            if (pageNumber != null) {
              // Группируем по диапазонам по 20 элементов
              groupKey = _getRangeGroup(pageNumber, 20);
            } else {
              // Если нет числового идентификатора, группируем по значению второго сегмента
              groupKey = secondSegment;
            }
            
            final pathKey = '$basePath/$groupKey';
            
            pathNeuronsMap[category]![domain]![pathKey] = [
              ...pathNeuronsMap[category]![domain]![pathKey] ?? [],
              neuron.id
            ];
          } else {
            // Если только один сегмент пути, добавляем в общую группу домена
            final pathKey = '$firstSegment/general';
            if (!pathNeuronsMap[category]!.containsKey(domain)) {
              pathNeuronsMap[category]![domain] = {};
            }
            pathNeuronsMap[category]![domain]![pathKey] = [
              ...pathNeuronsMap[category]![domain]![pathKey] ?? [],
              neuron.id
            ];
          }
        }
      }
    } catch (e) {
      print('⚠️ Error parsing URL for neuron ${neuron.id}: ${neuron.sourceUrl}');
    }
  }
  
  // Создание корневого кластера "internet"
  if (!clusters.containsKey('internet')) {
    clusters['internet'] = NeuronCluster(
      id: 'internet',
      type: 'root',
      title: 'Internet',
      neuronIds: [],
      depth: 0,
      size: 2.0,
    );
  }
  
  // Создание иерархии: категория → домен → пагинационные кластеры
  for (final category in categoryNeuronsMap.keys) {
    final categoryClusterId = 'category_$category';
    
    // Создаем кластер категории
    if (!clusters.containsKey(categoryClusterId)) {
      clusters[categoryClusterId] = NeuronCluster(
        id: categoryClusterId,
        type: 'category',
        title: category,
        neuronIds: [],
        depth: 1,
        size: 1.8,
      );
      
      // Привязываем к корневому кластеру
      clusters['internet']!.childClusterIds.add(categoryClusterId);
      clusters[categoryClusterId]!.parentClusterId = 'internet';
    }
    
    // Обрабатываем домены внутри категории
    for (final domain in categoryNeuronsMap[category]!.keys) {
      final domainClusterId = '${category}_domain_$domain';
      
      // Создаем доменный кластер
      if (!clusters.containsKey(domainClusterId)) {
        clusters[domainClusterId] = NeuronCluster(
          id: domainClusterId,
          type: 'domain',
          title: domain,
          domain: domain,
          neuronIds: [],
          depth: 2,
          size: 1.5,
        );
        
        // Привязываем к категории
        clusters[categoryClusterId]!.childClusterIds.add(domainClusterId);
        clusters[domainClusterId]!.parentClusterId = categoryClusterId;
      }
      
      // Обрабатываем пути внутри домена
      final domainPaths = pathNeuronsMap[category]?[domain] ?? {};
      
      for (final pathKey in domainPaths.keys) {
        final neuronsInPath = domainPaths[pathKey]!;
        
        if (neuronsInPath.length >= 5) {
          // Создаем пагинационный кластер
          final pageClusterId = '${domainClusterId}_$pathKey';
          
          clusters[pageClusterId] = NeuronCluster(
            id: pageClusterId,
            type: 'page_group',
            title: '$pathKey (${neuronsInPath.length})',
            domain: domain,
            path: pathKey,
            neuronIds: neuronsInPath,
            depth: 3,
            size: 1.1,
          );
          
          // Привязываем к доменному кластеру
          clusters[domainClusterId]!.childClusterIds.add(pageClusterId);
          clusters[pageClusterId]!.parentClusterId = domainClusterId;
        } else {
          // Мало нейронов - добавляем напрямую в доменный кластер
          clusters[domainClusterId]!.neuronIds.addAll(neuronsInPath);
        }
      }
      
      // Если в домене остались нейроны без специфичных путей, добавляем их
      final domainNeurons = categoryNeuronsMap[category]![domain]!;
      final assignedNeurons = domainPaths.values.expand((list) => list).toSet();
      final remainingNeurons = domainNeurons.where((id) => !assignedNeurons.contains(id)).toList();
      
      if (remainingNeurons.isNotEmpty) {
        clusters[domainClusterId]!.neuronIds.addAll(remainingNeurons);
      }
    }
  }
  
  // Также создаем отдельные доменные кластеры для нейронов без категорий
  for (final domain in domainNeuronsMap.keys) {
    final domainClusterId = 'domain_$domain';
    
    // Проверяем, не был ли уже создан этот домен в какой-либо категории
    final existsInCategory = clusters.values.any((cluster) => 
        cluster.id.contains('_domain_$domain') && cluster.type == 'domain');
    
    if (!existsInCategory && !clusters.containsKey(domainClusterId)) {
      clusters[domainClusterId] = NeuronCluster(
        id: domainClusterId,
        type: 'domain',
        title: domain,
        domain: domain,
        neuronIds: domainNeuronsMap[domain]!,
        depth: 1,
        size: 1.5,
      );
      
      // Привязываем к корневому кластеру
      clusters['internet']!.childClusterIds.add(domainClusterId);
      clusters[domainClusterId]!.parentClusterId = 'internet';
    }
  }
  
  // Обновление сигнатур всех кластеров
  for (final cluster in clusters.values) {
    if (cluster.neuronIds.isNotEmpty) {
      cluster.updateSignature(this);
    }
  }
  
  print('✅ Created URL hierarchy: ${clusters.length} clusters');
}
  

  Future<void> _createUrlDomainClustersDD() async {
  final domainNeuronsMap = <String, List<int>>{};
  final domainNeuronsMapChanging  = <String, List<int>>{};
  final categoryNeuronsMap = <String, Map<String, List<int>>>{}; // категория -> домен -> нейроны
  final pathNeuronsMap = <String, Map<String, Map<String, List<int>>>>{}; // категория -> домен -> путь -> нейроны
  
  // Нормализация категорий (оставляем вашу функцию без изменений)
  String _normalizeCategory(String pathSegment) {
    final normalized = pathSegment.toLowerCase();
    
    // Форумные категории
    if (normalized.contains('forum')) return 'forums';
    if (normalized.contains('chat')) return 'chats';
    if (normalized.contains('board')) return 'forums';
    if (normalized.contains('discussion')) return 'forums';
    
    // Медиа категории
    if (normalized.contains('audio')) return 'audio';
    if (normalized.contains('music')) return 'audio';
    if (normalized.contains('video')) return 'video';
    if (normalized.contains('movie')) return 'video';
    if (normalized.contains('podcast')) return 'audio';
    
    // Текстовые категории
    if (normalized.contains('book')) return 'books';
    if (normalized.contains('wiki')) return 'wiki';
    if (normalized.contains('article')) return 'articles';
    if (normalized.contains('blog')) return 'blogs';
    if (normalized.contains('news')) return 'news';
    if (normalized.contains('story')) return 'stories';
    if (normalized.contains('song')) return 'songs';
    if (normalized.contains('poem')) return 'poems';
    
    // Пользовательские категории
    if (normalized.contains('user')) return 'users';
    if (normalized.contains('profile')) return 'profiles';
    if (normalized.contains('account')) return 'accounts';
    
    // Прочие
    if (normalized.contains('archive')) return 'archives';
    if (normalized.contains('download')) return 'downloads';
    if (normalized.contains('file')) return 'files';
    
    return "generic";
  }
  
  // Группировка по диапазонам (пагинация по 20 элементов)
  String _getRangeGroup(int number, int groupSize) {
    final lower = (number ~/ groupSize) * groupSize + 1;
    final upper = lower + groupSize - 1;
    return '$lower-$upper';
  }
  
          final regex = RegExp(r'\d+');
         
  // Анализ URL и группировка
  for (final neuron in neurons.values) {
    if (neuron.id == 0 || neuron.sourceUrl == null) continue;
    
    try {
      final uri = Uri.parse(neuron.sourceUrl!);
      final domain = uri.host;
      
      // Группировка по доменам
      domainNeuronsMap[domain] = [...domainNeuronsMap[domain] ?? [], neuron.id];
      
      // Анализ пути для категоризации
      if (uri.path.isNotEmpty && uri.path != '/') {
        final pathSegments = uri.path.split('/').where((s) => s.isNotEmpty).toList();
          final firstSegment = pathSegments[0];
            final secondSegment = pathSegments[1];
            
        if (pathSegments.isNotEmpty) {
      String category = "generic";
          int indexCat = 0;
          for (final path in pathSegments) {
              category = _normalizeCategory(path);
              indexCat= pathSegments.indexOf(path);
              if (category != "generic") break;
          }
          

          
          // Инициализация структур данных для категории
          if (!categoryNeuronsMap.containsKey(category)) {
            categoryNeuronsMap[category] = {};
          }
          if (!pathNeuronsMap.containsKey(category)) {
            pathNeuronsMap[category] = {};
          }
          
          // Группировка по доменам внутри категории
          categoryNeuronsMap[category]![domain] = [
            ...categoryNeuronsMap[category]![domain] ?? [],
            neuron.id
          ];
          
          // Анализ пути для создания иерархии
          if (pathSegments.length >= 2) {
          
            // Определяем базовый путь (например, "book/1")
            final basePath = '$firstSegment/$secondSegment';
            
            if (!pathNeuronsMap[category]!.containsKey(domain)) {
              pathNeuronsMap[category]![domain] = {};
            }
            
            // Извлекаем числовой идентификатор для пагинации
            int? pageNumber;
            
            // Пытаемся найти числовой идентификатор в сегментах пути
            for (int i = 2; i < pathSegments.length; i++) {
              if (i==indexCat) continue;
              final matches = regex.allMatches(pathSegments[i]);
              for (final match in matches) {
                final number = int.tryParse(match.group(0)!);
                if (number != null) {
                  pageNumber = number;
                }
              }
              if (pageNumber != null) break;
            }
            
            // Если не нашли в последующих сегментах, пробуем второй сегмент
            if (pageNumber == null) {
              final matches = regex.allMatches(secondSegment);
              for (final match in matches) {
                final number = int.tryParse(match.group(0)!);
                if (number != null) {
                  pageNumber = number;
                }
              }
              if (pageNumber != null) break;
            }
            
            String groupKey;
            if (pageNumber != null) {
              // Группируем по диапазонам по 20 элементов
              groupKey = _getRangeGroup(pageNumber, 20);
            } else {
              // Если нет числового идентификатора, группируем по значению второго сегмента
              groupKey = secondSegment;
            }
            
            final pathKey = '$basePath/$groupKey';
            
            pathNeuronsMap[category]![domain]![pathKey] = [
              ...pathNeuronsMap[category]![domain]![pathKey] ?? [],
              neuron.id
            ];
          } else {
            // Если только один сегмент пути, добавляем в общую группу домена
            final pathKey = '$firstSegment/general';
            if (!pathNeuronsMap[category]!.containsKey(domain)) {
              pathNeuronsMap[category]![domain] = {};
            }
            pathNeuronsMap[category]![domain]![pathKey] = [
              ...pathNeuronsMap[category]![domain]![pathKey] ?? [],
              neuron.id
            ];
          }
        }
      }
    } catch (e) {
      print('⚠️ Error parsing URL for neuron ${neuron.id}: ${neuron.sourceUrl}');
    }
  }
  
  // Создание корневого кластера "internet"
  if (!clusters.containsKey('internet')) {
    clusters['internet'] = NeuronCluster(
      id: 'internet',
      type: 'root',
      title: 'Internet',
      neuronIds: [],
      depth: 0,
      size: 2.0,
    );
  }
  
  // Создание иерархии: категория → домен → пагинационные кластеры
  for (final category in categoryNeuronsMap.keys) {
    final categoryClusterId = 'category_$category';
    
    // Создаем кластер категории
    if (!clusters.containsKey(categoryClusterId)) {
      clusters[categoryClusterId] = NeuronCluster(
        id: categoryClusterId,
        type: 'category',
        title: category,
        neuronIds: [],
        depth: 1,
        size: 1.8,
      );
      
      // Привязываем к корневому кластеру
      clusters['internet']!.childClusterIds.add(categoryClusterId);
      clusters[categoryClusterId]!.parentClusterId = 'internet';
    }
    
    // Обрабатываем домены внутри категории
    for (final domain in categoryNeuronsMap[category]!.keys) {
      final domainClusterId = '${category}_domain_$domain';
      
      // Создаем доменный кластер
      if (!clusters.containsKey(domainClusterId)) {
        clusters[domainClusterId] = NeuronCluster(
          id: domainClusterId,
          type: 'domain',
          title: domain,
          domain: domain,
          neuronIds: [],
          depth: 2,
          size: 1.5,
        );
        
        // Привязываем к категории
        clusters[categoryClusterId]!.childClusterIds.add(domainClusterId);
        clusters[domainClusterId]!.parentClusterId = categoryClusterId;
      }
      
      // Обрабатываем пути внутри домена
      final domainPaths = pathNeuronsMap[category]?[domain] ?? {};
      
      for (final pathKey in domainPaths.keys) {
        final neuronsInPath = domainPaths[pathKey]!;
        
        if (neuronsInPath.length >= 5) {
          // Создаем пагинационный кластер
          final pageClusterId = '${domainClusterId}_$pathKey';
          
          clusters[pageClusterId] = NeuronCluster(
            id: pageClusterId,
            type: 'page_group',
            title: '$pathKey (${neuronsInPath.length})',
            domain: domain,
            path: pathKey,
            neuronIds: neuronsInPath,
            depth: 3,
            size: 1.1,
          );
          
          // Привязываем к доменному кластеру
          clusters[domainClusterId]!.childClusterIds.add(pageClusterId);
          clusters[pageClusterId]!.parentClusterId = domainClusterId;
        } else {
          // Мало нейронов - добавляем напрямую в доменный кластер
          clusters[domainClusterId]!.neuronIds.addAll(neuronsInPath);
        }
      }
      
      // Если в домене остались нейроны без специфичных путей, добавляем их
      final domainNeurons = categoryNeuronsMap[category]![domain]!;
      final assignedNeurons = domainPaths.values.expand((list) => list).toSet();
      final remainingNeurons = domainNeurons.where((id) => !assignedNeurons.contains(id)).toList();
      
      if (remainingNeurons.isNotEmpty) {
        clusters[domainClusterId]!.neuronIds.addAll(remainingNeurons);
      }
    }
  }
  
  // Также создаем отдельные доменные кластеры для нейронов без категорий
  for (final domain in domainNeuronsMap.keys) {
    final domainClusterId = 'domain_$domain';
    
    // Проверяем, не был ли уже создан этот домен в какой-либо категории
    final existsInCategory = clusters.values.any((cluster) => 
        cluster.id.contains('_domain_$domain') && cluster.type == 'domain');
    
    if (!existsInCategory && !clusters.containsKey(domainClusterId)) {
      clusters[domainClusterId] = NeuronCluster(
        id: domainClusterId,
        type: 'domain',
        title: domain,
        domain: domain,
        neuronIds: domainNeuronsMap[domain]!,
        depth: 1,
        size: 1.5,
      );
      
      // Привязываем к корневому кластеру
      clusters['internet']!.childClusterIds.add(domainClusterId);
      clusters[domainClusterId]!.parentClusterId = 'internet';
    }
  }
  
  // Обновление сигнатур всех кластеров
  for (final cluster in clusters.values) {
    if (cluster.neuronIds.isNotEmpty) {
      cluster.updateSignature(this);
    }
  }
  
  print('✅ Created URL hierarchy: ${clusters.length} clusters');
}



Future<void> _createUrlDomainClustersShouldRework() async {
  final domainNeuronsMap = <String, List<int>>{};
  final categoryNeuronsMap = <String, Map<String, List<int>>>{};
  final pathNeuronsMap = <String, Map<String, Map<String, List<int>>>>{};
  final keywordNeuronsMap = <String, Map<String, List<int>>>{}; // keyword -> domain -> neurons
  final numericPatternsMap = <String, Map<String, List<int>>>{}; // pattern -> domain -> neurons

  // Расширенный словарь нормализации категорий
  String _normalizeCategory(String pathSegment) {
    final normalized = pathSegment.toLowerCase();
    
    // Форумные категории
    if (normalized.contains('forum')) return 'forums';
    if (normalized.contains('chat')) return 'chats';
    if (normalized.contains('board')) return 'forums';
    if (normalized.contains('discussion')) return 'forums';
    if (normalized.contains('thread')) return 'threads';
    if (normalized.contains('topic')) return 'topics';
    
    // Медиа категории
    if (normalized.contains('audio')) return 'audio';
    if (normalized.contains('music')) return 'audio';
    if (normalized.contains('video')) return 'video';
    if (normalized.contains('movie')) return 'video';
    if (normalized.contains('film')) return 'video';
    if (normalized.contains('podcast')) return 'audio';
    if (normalized.contains('stream')) return 'streams';
    if (normalized.contains('live')) return 'live';
    
    // Текстовые категории
    if (normalized.contains('book')) return 'books';
    if (normalized.contains('wiki')) return 'wiki';
    if (normalized.contains('article')) return 'articles';
    if (normalized.contains('blog')) return 'blogs';
    if (normalized.contains('news')) return 'news';
    if (normalized.contains('story')) return 'stories';
    if (normalized.contains('song')) return 'songs';
    if (normalized.contains('poem')) return 'poems';
    if (normalized.contains('text')) return 'texts';
    if (normalized.contains('doc')) return 'documents';
    if (normalized.contains('document')) return 'documents';
    
    // Пользовательские категории
    if (normalized.contains('user')) return 'users';
    if (normalized.contains('profile')) return 'profiles';
    if (normalized.contains('account')) return 'accounts';
    if (normalized.contains('member')) return 'members';
    
    // Поиск и теги
    if (normalized.contains('search')) return 'search';
    if (normalized.contains('query')) return 'search';
    if (normalized.contains('tag')) return 'tags';
    if (normalized.contains('category')) return 'categories';
    if (normalized.contains('label')) return 'labels';
    
    // Прочие важные категории
    if (normalized.contains('archive')) return 'archives';
    if (normalized.contains('download')) return 'downloads';
    if (normalized.contains('file')) return 'files';
    if (normalized.contains('image')) return 'images';
    if (normalized.contains('photo')) return 'photos';
    if (normalized.contains('picture')) return 'images';
    if (normalized.contains('gallery')) return 'galleries';
    if (normalized.contains('product')) return 'products';
    if (normalized.contains('item')) return 'items';
    if (normalized.contains('shop')) return 'shop';
    if (normalized.contains('store')) return 'store';
    
    return normalized;
  }

  // Универсальный парсер числовых паттернов
  Map<String, dynamic> _parseNumericPattern(List<String> pathSegments) {
    final numbers = <int>[];
    final patterns = <String>[];
    
    for (final segment in pathSegments) {
      // Пытаемся извлечь чисто числовые значения
      final number = int.tryParse(segment);
      if (number != null) {
        numbers.add(number);
        continue;
      }
      
      // Ищем числовые паттерны в смешанных строках
      final regex = RegExp(r'(\d+)');
      final matches = regex.allMatches(segment);
      
      for (final match in matches) {
        final numericValue = int.tryParse(match.group(0)!);
        if (numericValue != null) {
          numbers.add(numericValue);
        }
      }
      
      // Анализируем паттерны типа: page1, item_123, v2.0 и т.д.
      if (segment.contains(RegExp(r'[a-zA-Z]+\d+'))) {
        patterns.add(segment);
      }
    }
    
    // Определяем тип числового паттерна
    String patternType = 'unknown';
    if (numbers.isNotEmpty) {
      numbers.sort();
      final range = numbers.last - numbers.first;
      final count = numbers.length;
      
      if (count >= 3 && range <= 100) {
        patternType = 'sequential';
      } else if (count >= 2 && numbers.every((n) => n % 10 == 0)) {
        patternType = 'pagination';
      } else if (numbers.any((n) => n > 1000000)) {
        patternType = 'id_large';
      } else if (numbers.any((n) => n > 1000)) {
        patternType = 'id_medium';
      } else {
        patternType = 'id_small';
      }
    }
    
    return {
      'numbers': numbers,
      'patterns': patterns,
      'pattern_type': patternType,
      'primary_number': numbers.isNotEmpty ? numbers.first : null,
    };
  }

  // Извлечение ключевых слов из query параметров и хэштегов
  List<String> _extractKeywords(Uri uri) {
    final keywords = <String>{};
    
    // Из query параметров
    if (uri.hasQuery) {
      final queryParams = uri.queryParameters;
      for (final key in ['q', 'query', 'search', 'tag', 'keyword']) {
        final value = queryParams[key];
        if (value != null && value.isNotEmpty) {
          keywords.addAll(value.split(RegExp(r'[+\s,]')).where((word) => 
              word.length > 2).map((word) => word.toLowerCase()));
        }
      }
    }
    
    // Из фрагмента (хэштеги)
    if (uri.fragment.isNotEmpty) {
      final fragment = uri.fragment;
      if (fragment.contains('#')) {
        keywords.addAll(fragment.split('#').where((tag) => 
            tag.length > 2).map((tag) => tag.toLowerCase()));
      }
    }
    
    return keywords.toSet().toList();
  }

  // Анализ URL и группировка
  for (final neuron in neurons.values) {
    if (neuron.id == 0 || neuron.sourceUrl == null) continue;
    
    try {
      final uri = Uri.parse(neuron.sourceUrl!);
      final domain = uri.host;
      
      // Группировка по доменам
      domainNeuronsMap[domain] = [...domainNeuronsMap[domain] ?? [], neuron.id];
      
      // Извлечение ключевых слов
      final keywords = _extractKeywords(uri);
      for (final keyword in keywords) {
        if (!keywordNeuronsMap.containsKey(keyword)) {
          keywordNeuronsMap[keyword] = {};
        }
        keywordNeuronsMap[keyword]![domain] = [
          ...keywordNeuronsMap[keyword]![domain] ?? [],
          neuron.id
        ];
      }
      
      // Анализ пути для категоризации
      if (uri.path.isNotEmpty && uri.path != '/') {
        final pathSegments = uri.path.split('/').where((s) => s.isNotEmpty).toList();
        
        if (pathSegments.isNotEmpty) {
          // Анализ числовых паттернов
          final numericAnalysis = _parseNumericPattern(pathSegments);
          final numbers = numericAnalysis['numbers'] as List<int>;
          final patternType = numericAnalysis['pattern_type'] as String;
          
          if (numbers.isNotEmpty) {
            final patternKey = '${patternType}_${numbers.length}';
            if (!numericPatternsMap.containsKey(patternKey)) {
              numericPatternsMap[patternKey] = {};
            }
            numericPatternsMap[patternKey]![domain] = [
              ...numericPatternsMap[patternKey]![domain] ?? [],
              neuron.id
            ];
          }
          
          // Обработка категорий на основе первого сегмента
          final firstSegment = pathSegments[0];
          final category = _normalizeCategory(firstSegment);
          
          // Инициализация структур данных для категории
          if (!categoryNeuronsMap.containsKey(category)) {
            categoryNeuronsMap[category] = {};
          }
          if (!pathNeuronsMap.containsKey(category)) {
            pathNeuronsMap[category] = {};
          }
          
          // Группировка по доменам внутри категории
          categoryNeuronsMap[category]![domain] = [
            ...categoryNeuronsMap[category]![domain] ?? [],
            neuron.id
          ];
          
          // Создание иерархии пути
          String pathKey = firstSegment;
          
          if (pathSegments.length >= 2) {
            final secondSegment = pathSegments[1];
            final secondCategory = _normalizeCategory(secondSegment);
            
            // Если второй сегмент тоже является категорией, используем комбинацию
            if (secondCategory != secondSegment.toLowerCase()) {
              pathKey = '$firstSegment/$secondCategory';
            } else {
              pathKey = '$firstSegment/$secondSegment';
            }
            
            // Добавляем числовую информацию если есть
            if (numbers.isNotEmpty) {
              final primaryNumber = numericAnalysis['primary_number'] as int?;
              if (primaryNumber != null) {
                pathKey = '$pathKey/$primaryNumber';
              }
            }
          }
          
          if (!pathNeuronsMap[category]!.containsKey(domain)) {
            pathNeuronsMap[category]![domain] = {};
          }
          
          pathNeuronsMap[category]![domain]![pathKey] = [
            ...pathNeuronsMap[category]![domain]![pathKey] ?? [],
            neuron.id
          ];
        }
      }
    } catch (e) {
      print('⚠️ Error parsing URL for neuron ${neuron.id}: ${neuron.sourceUrl}');
    }
  }
  
  // Создание корневого кластера "internet"
  if (!clusters.containsKey('internet')) {
    clusters['internet'] = NeuronCluster(
      id: 'internet',
      type: 'root',
      title: 'Internet',
      neuronIds: [],
      depth: 0,
      size: 2.0,
    );
  }
  
  // Создание кластера для ключевых слов
  if (!clusters.containsKey('keywords') && keywordNeuronsMap.isNotEmpty) {
    clusters['keywords'] = NeuronCluster(
      id: 'keywords',
      type: 'keyword_root',
      title: 'Keywords',
      neuronIds: [],
      depth: 1,
      size: 1.8,
    );
    clusters['internet']!.childClusterIds.add('keywords');
    clusters['keywords']!.parentClusterId = 'internet';
  }
  
  // Создание кластеров для ключевых слов
  for (final keyword in keywordNeuronsMap.keys) {
    final keywordClusterId = 'keyword_${keyword.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';
    
    clusters[keywordClusterId] = NeuronCluster(
      id: keywordClusterId,
      type: 'keyword',
      title: 'Keyword: $keyword',
      neuronIds: [],
      depth: 2,
      size: 1.3,
    );
    
    // Привязываем к корню ключевых слов
    clusters['keywords']!.childClusterIds.add(keywordClusterId);
    clusters[keywordClusterId]!.parentClusterId = 'keywords';
    
    // Создаем подкластеры по доменам для каждого ключевого слова
    for (final domain in keywordNeuronsMap[keyword]!.keys) {
      final domainKeywordClusterId = '${keywordClusterId}_$domain';
      final neurons = keywordNeuronsMap[keyword]![domain]!;
      
      clusters[domainKeywordClusterId] = NeuronCluster(
        id: domainKeywordClusterId,
        type: 'keyword_domain',
        title: '$domain: $keyword',
        domain: domain,
        neuronIds: neurons,
        depth: 3,
        size: 1.1,
      );
      
      clusters[keywordClusterId]!.childClusterIds.add(domainKeywordClusterId);
      clusters[domainKeywordClusterId]!.parentClusterId = keywordClusterId;
    }
  }
  
  // Создание кластера для числовых паттернов
  if (!clusters.containsKey('numeric_patterns') && numericPatternsMap.isNotEmpty) {
    clusters['numeric_patterns'] = NeuronCluster(
      id: 'numeric_patterns',
      type: 'numeric_root',
      title: 'Numeric Patterns',
      neuronIds: [],
      depth: 1,
      size: 1.8,
    );
    clusters['internet']!.childClusterIds.add('numeric_patterns');
    clusters['numeric_patterns']!.parentClusterId = 'internet';
  }
  
  // Создание кластеров для числовых паттернов
  for (final pattern in numericPatternsMap.keys) {
    final patternClusterId = 'pattern_${pattern.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_')}';
    
    clusters[patternClusterId] = NeuronCluster(
      id: patternClusterId,
      type: 'numeric_pattern',
      title: 'Pattern: $pattern',
      neuronIds: [],
      depth: 2,
      size: 1.4,
    );
    
    clusters['numeric_patterns']!.childClusterIds.add(patternClusterId);
    clusters[patternClusterId]!.parentClusterId = 'numeric_patterns';
    
    for (final domain in numericPatternsMap[pattern]!.keys) {
      final domainPatternClusterId = '${patternClusterId}_$domain';
      final neurons = numericPatternsMap[pattern]![domain]!;
      
      clusters[domainPatternClusterId] = NeuronCluster(
        id: domainPatternClusterId,
        type: 'pattern_domain',
        title: '$domain: $pattern',
        domain: domain,
        neuronIds: neurons,
        depth: 3,
        size: 1.1,
      );
      
      clusters[patternClusterId]!.childClusterIds.add(domainPatternClusterId);
      clusters[domainPatternClusterId]!.parentClusterId = patternClusterId;
    }
  }
  
  // Создание иерархии: категория → домен → пагинационные кластеры
  for (final category in categoryNeuronsMap.keys) {
    final categoryClusterId = 'category_$category';
    
    // Создаем кластер категории
    if (!clusters.containsKey(categoryClusterId)) {
      clusters[categoryClusterId] = NeuronCluster(
        id: categoryClusterId,
        type: 'category',
        title: category,
        neuronIds: [],
        depth: 1,
        size: 1.8,
      );
      
      // Привязываем к корневому кластеру
      clusters['internet']!.childClusterIds.add(categoryClusterId);
      clusters[categoryClusterId]!.parentClusterId = 'internet';
    }
    
    // Обрабатываем домены внутри категории
    for (final domain in categoryNeuronsMap[category]!.keys) {
      final domainClusterId = '${category}_domain_$domain';
      
      // Создаем доменный кластер
      if (!clusters.containsKey(domainClusterId)) {
        clusters[domainClusterId] = NeuronCluster(
          id: domainClusterId,
          type: 'domain',
          title: domain,
          domain: domain,
          neuronIds: [],
          depth: 2,
          size: 1.5,
        );
        
        // Привязываем к категории
        clusters[categoryClusterId]!.childClusterIds.add(domainClusterId);
        clusters[domainClusterId]!.parentClusterId = categoryClusterId;
      }
      
      // Обрабатываем пути внутри домена
      final domainPaths = pathNeuronsMap[category]?[domain] ?? {};
      
      for (final pathKey in domainPaths.keys) {
        final neuronsInPath = domainPaths[pathKey]!;
        
        if (neuronsInPath.length >= 3) { // Уменьшил порог для лучшего покрытия
          // Создаем пагинационный кластер
          final pageClusterId = '${domainClusterId}_${pathKey.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';
          
          clusters[pageClusterId] = NeuronCluster(
            id: pageClusterId,
            type: 'page_group',
            title: '$pathKey (${neuronsInPath.length})',
            domain: domain,
            path: pathKey,
            neuronIds: neuronsInPath,
            depth: 3,
            size: 1.1,
          );
          
          // Привязываем к доменному кластеру
          clusters[domainClusterId]!.childClusterIds.add(pageClusterId);
          clusters[pageClusterId]!.parentClusterId = domainClusterId;
        } else {
          // Мало нейронов - добавляем напрямую в доменный кластер
          clusters[domainClusterId]!.neuronIds.addAll(neuronsInPath);
        }
      }
      
      // Если в домене остались нейроны без специфичных путей, добавляем их
      final domainNeurons = categoryNeuronsMap[category]![domain]!;
      final assignedNeurons = domainPaths.values.expand((list) => list).toSet();
      final remainingNeurons = domainNeurons.where((id) => !assignedNeurons.contains(id)).toList();
      
      if (remainingNeurons.isNotEmpty) {
        clusters[domainClusterId]!.neuronIds.addAll(remainingNeurons);
      }
    }
  }
  
  // Также создаем отдельные доменные кластеры для нейронов без категорий
  for (final domain in domainNeuronsMap.keys) {
    final domainClusterId = 'domain_$domain';
    
    // Проверяем, не был ли уже создан этот домен в какой-либо категории
    final existsInCategory = clusters.values.any((cluster) => 
        cluster.id.contains('_domain_$domain') && cluster.type == 'domain');
    
    if (!existsInCategory && !clusters.containsKey(domainClusterId)) {
      clusters[domainClusterId] = NeuronCluster(
        id: domainClusterId,
        type: 'domain',
        title: domain,
        domain: domain,
        neuronIds: domainNeuronsMap[domain]!,
        depth: 1,
        size: 1.5,
      );
      
      // Привязываем к корневому кластеру
      clusters['internet']!.childClusterIds.add(domainClusterId);
      clusters[domainClusterId]!.parentClusterId = 'internet';
    }
  }
  
  // Обновление сигнатур всех кластеров
  for (final cluster in clusters.values) {
    if (cluster.neuronIds.isNotEmpty) {
      cluster.updateSignature(this);
    }
  }
  
  print('✅ Created URL hierarchy: ${clusters.length} clusters');
  print('   - Categories: ${categoryNeuronsMap.length}');
  print('   - Keywords: ${keywordNeuronsMap.length}');
  print('   - Numeric patterns: ${numericPatternsMap.length}');
  print('   - Domains: ${domainNeuronsMap.length}');
}

void _buildClusterHierarchy(Map<String, Map<String, dynamic>> structuredClusters) {
  if (!clusters.containsKey('internet')) {
    clusters['internet'] = NeuronCluster(
      id: 'internet', type: 'root', title: 'Internet', neuronIds: [], depth: 0, size: 2.0,
    );
  }
  
  for (final category in structuredClusters.keys) {
    final categoryClusterId = 'category_$category';
    clusters[categoryClusterId] = NeuronCluster(
      id: categoryClusterId, type: 'category', 
      title: '${category[0].toUpperCase()}${category.substring(1)}',
      neuronIds: [], depth: 1, size: 1.8,
    );
    
    clusters['internet']!.childClusterIds.add(categoryClusterId);
    clusters[categoryClusterId]!.parentClusterId = 'internet';
    
    final categoryData = structuredClusters[category]!;
    
    for (final domain in categoryData['domains'].keys) {
      final domainData = categoryData['domains'][domain];
      final domainClusterId = '${category}_$domain';
      
      clusters[domainClusterId] = NeuronCluster(
        id: domainClusterId, type: 'domain', title: domain, domain: domain,
        neuronIds: [], depth: 2, size: 1.5,
      );
      
      clusters[categoryClusterId]!.childClusterIds.add(domainClusterId);
      clusters[domainClusterId]!.parentClusterId = categoryClusterId;
      
      // Кластеры для книг
      for (final bookId in domainData['books'].keys) {
        final bookNeurons = domainData['books'][bookId];
        final bookClusterId = '${domainClusterId}_book_$bookId';
        clusters[bookClusterId] = NeuronCluster(
          id: bookClusterId, type: 'book', title: 'Book $bookId (${bookNeurons.length})',
          neuronIds: bookNeurons, depth: 3, size: 1.3,
        );
        clusters[domainClusterId]!.childClusterIds.add(bookClusterId);
        clusters[bookClusterId]!.parentClusterId = domainClusterId;
      }
      
      // Кластеры для страниц
      for (final pageRange in domainData['pages'].keys) {
        final pageNeurons = domainData['pages'][pageRange];
        if (pageNeurons.length >= 3) {
          final pageClusterId = '${domainClusterId}_pages_$pageRange';
          clusters[pageClusterId] = NeuronCluster(
            id: pageClusterId, type: 'page_range', title: 'Pages $pageRange (${pageNeurons.length})',
            neuronIds: pageNeurons, depth: 3, size: 1.1,
          );
          clusters[domainClusterId]!.childClusterIds.add(pageClusterId);
          clusters[pageClusterId]!.parentClusterId = domainClusterId;
        } else {
          clusters[domainClusterId]!.neuronIds.addAll(pageNeurons);
        }
      }
      
      // Оставшиеся нейроны
      final assignedNeurons = [
        ...domainData['books'].values.expand((list) => list),
        ...domainData['pages'].values.expand((list) => list),
        ...domainData['chapters'].values.expand((list) => list),
      ].toSet();
      
      final remainingNeurons = domainData['neurons']
          .where((id) => !assignedNeurons.contains(id)).toList();
      
      clusters[domainClusterId]!.neuronIds.addAll(remainingNeurons);
    }
  }
}

  
  Future<void> _createKeywordClusters() async {
    final keywordNeuronsMap = <String, List<int>>{};
    final keywordScores = <String, double>{};
    
    for (final neuron in neurons.values) {
      if (neuron.id == 0) continue;
      
      final topKeywords = _getTopKeywordsForNeuron(neuron, 10);
      for (final keyword in topKeywords) {
        if (!keywordNeuronsMap.containsKey(keyword)) {
          keywordNeuronsMap[keyword] = [];
        }
        keywordNeuronsMap[keyword]!.add(neuron.id);
        
        final wordEntry = wordIndex[keyword];

        double allRatingWordEntry = (words[wordEntry]!.allRating ?? 0).toDouble();
        double neuronAllRating = (neuron.allRating ?? 0).toDouble();
    keywordScores[keyword] = keywordScores[keyword] ?? 0.0 + allRatingWordEntry +neuronAllRating;
      }
    }
    
    final sortedKeywords = keywordScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (final entry in sortedKeywords) {
      final keyword = entry.key;
      final neuronIds = keywordNeuronsMap[keyword]!;
      
      if (neuronIds.length >= 5) {
        await _createKeywordClusterHierarchy(keyword, neuronIds);
      }
    }
  }
  
  Future<void> _createKeywordClusterHierarchy(String keyword, List<int> neuronIds) async {
    const maxNeuronsPerCluster = 100;
    int clusterIndex = 0;
    
    for (int i = 0; i < neuronIds.length; i += maxNeuronsPerCluster) {
      final endIndex = min(i + maxNeuronsPerCluster, neuronIds.length);
      final clusterNeuronIds = neuronIds.sublist(i, endIndex);
      
      final clusterId = 'keyword_${keyword.hashCode}_$clusterIndex';
      clusterIndex++;
      
      if (!clusters.containsKey(clusterId)) {
        final cluster = NeuronCluster(
          id: clusterId,
          type: 'keyword',
          title: '$keyword [${clusterIndex + 1}]',
          keyword: keyword,
          neuronIds: clusterNeuronIds,
          depth: 1,
          size: 1.0,
        );
        
        clusters[clusterId] = cluster;
        clusters['root']!.childClusterIds.add(clusterId);
        cluster.parentClusterId = 'root';
      } else {
        clusters[clusterId]!.neuronIds = clusterNeuronIds;
        clusters[clusterId]!.updateSignature( this);
      }
    }
  }
  
  List<String> _getTopKeywordsForNeuron(Neuron neuron, int limit) {

  final wordScores = <int, double>{};
  
  // Сначала вычисляем scores для слов из signatureRatings нейрона
   for (final wordId in neuron.signatureRatings.keys) {
    final word = network.words[wordId];
    if (word != null) {
      double score = neuron.signatureRatings[wordId]!.toDouble();
      for (final otherWordId in network.words.keys) {
        final otherWord = network.words[otherWordId];
        if (otherWord != word) {
          final connection = network.words[otherWordId]!.ratings[wordId] ?? 0;
          score += connection * 0.1;
        }
      }
      wordScores[wordId] = score;
    }
  }
  
  
  final sortedWords = wordScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  // Топ-15 с самым высоким рейтингом
  final topKeywords = sortedWords
      .take(15)
      .map((entry) => network.wordLibrary[entry.key] ?? 'unknown')
      .where((word) => word.length > 2)
      .toList();
  
  // Для нижних 5 используем рейтинг из network.words
  final bottomWords = <MapEntry<int, double>>[];
  
  for (final wordId in neuron.signatureRatings.keys) {
    final word = network.words[wordId];
    if (word != null) {
      // Используем allRating из network.words как основной рейтинг
      final globalScore = word.allRating.toDouble();
      bottomWords.add(MapEntry(wordId, globalScore));
    }
  }
  
  // Сортируем по возрастанию рейтинга из network.words
  bottomWords.sort((a, b) => a.value.compareTo(b.value));
  
  final bottomKeywords = bottomWords
      .take(5)
      .map((entry) => network.wordLibrary[entry.key] ?? 'unknown')
      .where((word) => word.length > 2)
      .toList();
  
  return [...topKeywords, ...bottomKeywords];
}


  // ========== ПОЗИЦИОНИРОВАНИЕ КЛАСТЕРОВ ==========
  void _positionAllClusters() {
    print('📍 Positioning ${clusters.length} clusters');
    
    clusters['root']?.updatePosition(0.0, 0.0, 0.0);
    //3_positionChildClusters('root', 0.0, 0.0, 0);
    
    for (final cluster in clusters.values) {
      cluster.updateSignature(  this);
    }
  }
  
  void _positionChildClusters(String parentId, double parentX, double parentY, int depth) {
    final parent = clusters[parentId];
    if (parent == null) return;
    
    final children = parent.childClusterIds
        .map((id) => clusters[id])
        .whereType<NeuronCluster>()
        .toList();
    
    if (children.isEmpty) return;
    
    final angleStep = (2 * pi) / children.length;
    final radius = 250.0 + (depth * 50.0);
    
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      final angle = i * angleStep;
      
      double childX, childY, childZ;
      
      // Чередуем направления: четная глубина - вверх, нечетная - вправо
      if (depth % 2 == 0) {
        // Вверх
        childX = parentX + radius * cos(angle) * 0.3;
        childY = parentY - radius * 0.8;
        childZ = radius * sin(angle) * 0.5;
      } else {
        // Вправо
        childX = parentX + radius * 0.8;
        childY = parentY + radius * sin(angle) * 0.3;
        childZ = radius * cos(angle) * 0.5;
      }
      
      //child?.updatePosition(childX, childY, childZ);
      child?.depth = depth + 1;
      child?.size = 1.0 / (depth * 0.3 + 1);
      
      // Рекурсивно позиционируем детей, но только если кластер развернут
      if (child?.isExpanded == true) {
        _positionChildClusters(child!.id, childX, childY, depth + 1);
      }
    }
  }
  
  // ИСПРАВЛЕННЫЙ МЕТОД - убираем рекурсию
  int _countExpandedChildren(String clusterId) {
    final cluster = clusters[clusterId];
    if (cluster == null) return 0;
    
    int count = 0;
    final queue = Queue<String>();
    queue.addAll(cluster.childClusterIds);
    
    while (queue.isNotEmpty) {
      final currentId = queue.removeFirst();
      final current = clusters[currentId];
      if (current == null) continue;
      
      if (current.isExpanded) {
        count++;
        queue.addAll(current.childClusterIds);
        
        // Если это листовой кластер, добавляем нейроны
        if (current.childClusterIds.isEmpty) {
          count += current.neuronIds.length.toInt();
        }
      }
    }
    
    return count;
  }

  // ========== УПРАВЛЕНИЕ КЛАСТЕРАМИ И АНИМАЦИЯ ==========
  Future<void> toggleClusterExpansion(String clusterId) async {
    final cluster = clusters[clusterId];
    if (cluster == null || _isAnimating) return;
    
    _isAnimating = true;
    
    clusterHistory.add(clusterId);
    historyIndex = clusterHistory.length - 1;
    
    if (cluster.isExpanded) {
      await _collapseCluster(cluster);
    } else {
      await _expandCluster(cluster);
    }
    
    _isAnimating = false;
    await _saveClustersToFile();
  }
  
  Future<void> _expandCluster(NeuronCluster cluster) async {
    cluster.isExpanded = true;
    expandedClusterIds.add(cluster.id);
    
    for (final childId in cluster.childClusterIds) {
      final child = clusters[childId];
      if (child != null) {
        child.isVisible = true;
        child.updatePosition(child.targetX, child.targetY, child.targetZ);
      }
    }
    
    if (cluster.childClusterIds.isEmpty) {
      _positionNeuronsInCluster(cluster);
    }
    
    await _animateClusterExpansion(cluster);
    _adjustCameraToFitClusters();
  }
  
  Future<void> _collapseCluster(NeuronCluster cluster) async {
    cluster.isExpanded = false;
    expandedClusterIds.remove(cluster.id);
    
    _hideAllChildren(cluster.id);
    _resetNeuronsToCluster(cluster);
    
    await _animateClusterCollapse(cluster);
    _adjustCameraToFitClusters();
  }
  
  void _hideAllChildren(String clusterId) {
    final cluster = clusters[clusterId];
    if (cluster == null) return;
    
    for (final childId in cluster.childClusterIds) {
      final child = clusters[childId];
      if (child != null) {
        child.isVisible = false;
        child.isExpanded = false;
        expandedClusterIds.remove(childId);
        _hideAllChildren(childId);
      }
    }
  }

  Future<void> _animateClusterExpansion(NeuronCluster cluster) async {
    final stages = <AnimationStage>[];
    final childCount = cluster.childClusterIds.length;
    
    stages.add(AnimationStage(
      duration: 0.1,
      action: () {
        cluster.size = 1.2;
        cluster.startGlow();
      },
    ));
    
    for (int i = 0; i < cluster.childClusterIds.length; i++) {
      final childId = cluster.childClusterIds[i];
      final child = clusters[childId];
      if (child != null) {
        final duration = 0.15 - (i * 0.01);
        stages.add(AnimationStage(
          duration: duration.clamp(0.05, 0.15),
          action: () {
            child.isVisible = true;
            child.animationProgress = 0.0;
            child.sourceX = cluster.x;
            child.sourceY = cluster.y;
            child.sourceZ = cluster.z;
            child.startGlow();
          },
        ));
      }
    }
    
    stages.add(AnimationStage(
      duration: 0.05,
      action: () {
        cluster.size = 1.0;
      },
    ));
    
    await _executeAnimationStages(stages);
  }
  
  Future<void> _animateClusterCollapse(NeuronCluster cluster) async {
    final stages = <AnimationStage>[];
    
    stages.add(AnimationStage(
      duration: 0.1,
      action: () {
        cluster.size = 0.9;
        cluster.startGlow();
      },
    ));
    
    stages.add(AnimationStage(
      duration: 0.1,
      action: () {
        cluster.size = 1.0;
      },
    ));
    
    await _executeAnimationStages(stages);
  }
  
  Future<void> _executeAnimationStages(List<AnimationStage> stages) async {
    for (final stage in stages) {
      stage.action();
      await Future.delayed(Duration(milliseconds: (stage.duration * 1000).round()));
    }
  }
  
  void _positionNeuronsInCluster(NeuronCluster cluster) {
    final clusterNeurons = cluster.neuronIds
        .map((id) => neurons[id])
        .whereType<Neuron>()
        .toList();
    
    final angleStep = pi / (clusterNeurons.length + 1);
    
    for (int i = 0; i < clusterNeurons.length; i++) {
      final neuron = clusterNeurons[i];
      final angle = (i + 1) * angleStep;
      final radius = 150.0;
      
      neuron.x = cluster.x + radius * cos(angle - pi/2);
      neuron.y = cluster.y + radius * sin(angle - pi/2);
      neuron.z = cluster.z;
    }
  }
  
  void _resetNeuronsToCluster(NeuronCluster cluster) {
    final random = Random(cluster.id.hashCode);
    
    for (final neuronId in cluster.neuronIds) {
      final neuron = neurons[neuronId];
      if (neuron == null) continue;
      
      neuron.x = cluster.x + random.nextDouble() * 40 - 20;
      neuron.y = cluster.y + random.nextDouble() * 40 - 20;
      neuron.z = cluster.z;
    }
  }

  // ========== УПРАВЛЕНИЕ ПЕРЕТАСКИВАНИЕМ ==========
  void startClusterDrag(String clusterId, Offset startOffset) {
    final cluster = clusters[clusterId];
    if (cluster == null) return;
    
    _draggedClusterId = clusterId;
    _dragStartOffset = startOffset;
    _clusterStartOffset = Offset(cluster.x, cluster.y);
    cluster.startDrag();
  }
  
  void updateClusterDrag(Offset currentOffset) {
    if (_draggedClusterId == null || _dragStartOffset == null || _clusterStartOffset == null) return;
    
    final cluster = clusters[_draggedClusterId!];
    if (cluster == null) return;
    
    final delta = currentOffset - _dragStartOffset!;
    final newX = _clusterStartOffset!.dx + delta.dx / _cameraScale;
    final newY = _clusterStartOffset!.dy + delta.dy / _cameraScale;
    
    cluster.updatePosition(newX, newY, cluster.z);
    
    if (cluster.isExpanded) {
      _moveNeuronsWithCluster(cluster, newX, newY);
    }
  }
  
  void endClusterDrag() {
    if (_draggedClusterId != null) {
      final cluster = clusters[_draggedClusterId!];
      cluster?.endDrag();
    }
    
    _draggedClusterId = null;
    _dragStartOffset = null;
    _clusterStartOffset = null;
  }
  
  void _moveNeuronsWithCluster(NeuronCluster cluster, double newX, double newY) {
    final deltaX = newX - cluster.x;
    final deltaY = newY - cluster.y;
    
    for (final neuronId in cluster.neuronIds) {
      final neuron = neurons[neuronId];
      if (neuron != null) {
        neuron.x += deltaX;
        neuron.y += deltaY;
      }
    }
  }

  // ========== УПРАВЛЕНИЕ КАМЕРОЙ ==========
  void _adjustCameraToFitClusters() {
    if (clusters.isEmpty) return;
    
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    
    for (final cluster in clusters.values) {
      if (!cluster.isVisible) continue;
      
      minX = min(minX, cluster.x);
      maxX = max(maxX, cluster.x);
      minY = min(minY, cluster.y);
      maxY = max(maxY, cluster.y);
    }
    
    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;
    final width = maxX - minX;
    final height = maxY - minY;
    final maxDimension = max(width, height);
    
    _cameraX = -centerX;
    _cameraY = -centerY;
    _cameraScale = maxDimension > 0 ? 800 / maxDimension : 1.0;
  }
  
  void moveCameraToNeuron(int neuronId) {
    final neuron = neurons[neuronId];
    if (neuron == null) return;
    
    _cameraX = -neuron.x;
    _cameraY = -neuron.y;
    _cameraScale = 2.0;
  }

  // ========== УПРАВЛЕНИЕ ИСТОРИЕЙ И ПОИСКОМ ==========
  void undo() {
    if (historyIndex > 0) {
      historyIndex--;
      final clusterId = clusterHistory[historyIndex];
      final cluster = clusters[clusterId];
      if (cluster != null && cluster.isExpanded) {
        toggleClusterExpansion(clusterId);
      }
    }
  }
  
  void redo() {
    if (historyIndex < clusterHistory.length - 1) {
      historyIndex++;
      final clusterId = clusterHistory[historyIndex];
      final cluster = clusters[clusterId];
      if (cluster != null && !cluster.isExpanded) {
        toggleClusterExpansion(clusterId);
      }
    }
  }
  
  void setSearchedNeurons(Set<int> neuronIds) {
    searchedNeurons.clear();
    searchedNeurons.addAll(neuronIds);
    currentSearchIndex = searchedNeurons.isNotEmpty ? 0 : -1;
    
    _expandClustersToNeurons(neuronIds);
    if (neuronIds.isNotEmpty) {
      moveCameraToNeuron(neuronIds.first);
    }
  }
  
  void _expandClustersToNeurons(Set<int> neuronIds) {
    final clustersToExpand = <String>{};
    
    for (final neuronId in neuronIds) {
      final neuron = neurons[neuronId];
      if (neuron == null) continue;
      
      for (final cluster in clusters.values) {
        if (cluster.neuronIds.contains(neuronId)) {
          _addClusterAndAncestorsToSet(cluster.id, clustersToExpand);
        }
      }
    }
    
    for (final clusterId in clustersToExpand) {
      final cluster = clusters[clusterId];
      if (cluster != null && !cluster.isExpanded) {
        toggleClusterExpansion(clusterId);
      }
    }
  }
  
  void _addClusterAndAncestorsToSet(String clusterId, Set<String> clusterSet) {
    if (clusterSet.contains(clusterId)) return;
    
    clusterSet.add(clusterId);
    
    final cluster = clusters[clusterId];
    if (cluster?.parentClusterId != null) {
      _addClusterAndAncestorsToSet(cluster!.parentClusterId!, clusterSet);
    }
  }
  
  void navigateToNextSearchedNeuron() {
    if (searchedNeurons.isEmpty) return;
    
    currentSearchIndex = (currentSearchIndex + 1) % searchedNeurons.length;
    _focusOnNeuron(searchedNeurons.elementAt(currentSearchIndex));
  }
  
  void navigateToPreviousSearchedNeuron() {
    if (searchedNeurons.isEmpty) return;
    
    currentSearchIndex = (currentSearchIndex - 1) % searchedNeurons.length;
    if (currentSearchIndex < 0) currentSearchIndex = searchedNeurons.length - 1;
    
    _focusOnNeuron(searchedNeurons.elementAt(currentSearchIndex));
  }
  
  void _focusOnNeuron(int neuronId) {
    moveCameraToNeuron(neuronId);
  }

  // ========== СОХРАНЕНИЕ И ЗАГРУЗКА ==========
  Future<void> _saveClustersToFile() async {
    try {
      final clustersJson = {
        'clusters': clusters.values.map((cluster) => cluster.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$clustersDataPath');
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode(clustersJson));
      
      print('💾 Clusters saved to: $clustersDataPath');
    } catch (e) {
      print('❌ Error saving clusters: $e');
    }
  }
  
  Future<void> _loadClustersFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$clustersDataPath');
      
      if (await file.exists()) {
        final data = await file.readAsString();
        final jsonData = jsonDecode(data);
        clusters.clear();
        
        for (final clusterJson in jsonData['clusters']) {
          final cluster = NeuronCluster.fromJson(clusterJson);
          clusters[cluster.id] = cluster;
        }
        
        print('📂 Loaded ${clusters.length} clusters from file');
      }
    } catch (e) {
      print('❌ Error loading clusters: $e');
      clusters.clear();
    }
  }



  // ========== ОСТАЛЬНЫЕ МЕТОДЫ ==========
  void setState(VoidCallback fn) {
    fn();
  }

  List<String> _extractWords(String text) {
    return text
        .toLowerCase()
        .split(RegExp(r'[^\wа-яА-ЯёЁ]+', unicode: true))
        .where((w) => w.length > 2)
        .toList();
  }



  Future<void> trainTest(Function(String) onProgress) async {
    onProgress('Начало обучения...');
    
    for (int chapter = 1; chapter <= 121; chapter++) {
      final url = 'https://hpmor.ru/book/1/$chapter/';
      
      onProgress('Обработка главы $chapter/121...');
      
      try {
        await processWebsite(url, onProgress);
        
        final fragmentCount = fragments.length;
        final wordCount = words.length;
        onProgress('Глава $chapter: $wordCount слов, $fragmentCount фрагментов');
        
        final recentFragments = fragments.values
            .where((f) => f.id > max(0, fragmentCount - 50))
            .take(10)
            .toList();
        
        for (final fragment in recentFragments) {
          final shortText = fragment.text.length > 60 
              ? fragment.text.substring(0, 60) + "..." 
              : fragment.text;
        }
        
        final topWords = getTopWords(10);
        final topWordsText = topWords
            .map((w) => '${wordLibrary[w.id]}:${w.allRating}')
            .join(', ');
        onProgress('  Топ слова: $topWordsText');
        
        if (chapter % 10 == 0) {
          await saveToFile();
          onProgress('Чекпоинт главы $chapter сохранён');
        }
      } catch (e) {
        onProgress('Ошибка главы $chapter: $e');
      }
      
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    await saveToFile();
    onProgress('Обучение завершено! ${words.length} слов, ${fragments.length} фрагментов');
  }


  Future<void> trainTest2(Function(String) onProgress) async {
    onProgress('Начало обучения...');
    
    for (int chapter = 1; chapter <= 98; chapter++) {
      final url = 'https://strugacki.ru/book_25/${1002+chapter}.html';
      
      onProgress('Обработка главы $chapter/93...');
      
      try {
        await processWebsite(url, onProgress);
        
        final fragmentCount = fragments.length;
        final wordCount = words.length;
        onProgress('Глава $chapter: $wordCount слов, $fragmentCount фрагментов');
        
        final recentFragments = fragments.values
            .where((f) => f.id > max(0, fragmentCount - 50))
            .take(10)
            .toList();
        
        for (final fragment in recentFragments) {
          final shortText = fragment.text.length > 60 
              ? fragment.text.substring(0, 60) + "..." 
              : fragment.text;
        }
        
        final topWords = getTopWords(10);
        final topWordsText = topWords
            .map((w) => '${wordLibrary[w.id]}:${w.allRating}')
            .join(', ');
        onProgress('  Топ слова: $topWordsText');
        
        if (chapter % 10 == 0) {
          await saveToFile();
          onProgress('Чекпоинт главы $chapter сохранён');
        }
      } catch (e) {
        onProgress('Ошибка главы $chapter: $e');
      }
      
      await Future.delayed(Duration(milliseconds: 1000));
    }
    
    await saveToFile();
    onProgress('Обучение завершено! ${words.length} слов, ${fragments.length} фрагментов');
  }
  
  List<int> _removeDuplicateFragments(List<int> fragmentIds) {
    final seenTexts = <String>{};
    final uniqueIds = <int>[];
    
    for (final id in fragmentIds) {
      final fragment = fragments[id];
      if (fragment != null && !seenTexts.contains(fragment.text)) {
        seenTexts.add(fragment.text);
        uniqueIds.add(id);
      }
    }
    return uniqueIds;
  }
  
  Future<List<int>> _generateLine2WithPossibilityVector(List<int> line1Words, List<int> promptWordIds) async {
    final possibilityVector = <int, int>{};
    
    for (final wordId in line1Words) {
      for (final fragment in fragments.values) {
        final wordIds = fragment.wordIds;
        for (int i = 0; i < wordIds.length - 1; i++) {
          if (wordIds[i] == wordId) {
            final nextWordId = wordIds[i + 1];
            if (!STOP_WORDS.contains(wordLibrary[nextWordId])) {
              possibilityVector[nextWordId] = (possibilityVector[nextWordId] ?? 0) + 1;
            }
          }
        }
      }
    }
    
    if (possibilityVector.isEmpty) {
      final line2SuperVector = <int, int>{};
      for (final wordId in line1Words) {
        final word = words[wordId];
        if (word != null) {
          for (final entry in word.ratings.entries) {
            line2SuperVector[entry.key] = 
                (line2SuperVector[entry.key] ?? 0) + entry.value;
          }
        }
      }
      
      return (line2SuperVector.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)))
          .take(50)
          .map((e) => e.key)
          .toList();
    }
    
    final totalOccurrences = possibilityVector.values.fold(0, (a, b) => a + b);
    final weightVector = <int, double>{};
    for (final entry in possibilityVector.entries) {
      weightVector[entry.key] = entry.value / totalOccurrences;
    }
    
    final scoredWords = <int, double>{};
    for (final wordId in weightVector.keys) {
      final word = words[wordId];
      if (word != null) {
        final wordVectorSum = word.ratings.values.fold(0, (a, b) => a + b);
        final contextScore = wordVectorSum > 0 ? word.allRating / wordVectorSum : 0.0;
        scoredWords[wordId] = weightVector[wordId]! * contextScore;
      }
    }
    
    return (scoredWords.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)))
        .take(50)
        .map((e) => e.key)
        .toList();
  }

/// Генерация пятой линии - интеллектуальный ответ с максимальным allRating
Future<List<int>> makeLine5ForAPrompt(List<int> promptWordIds) async {
  if (promptWordIds.isEmpty) {
    
    await AppLogger.writeLog("makeLine5 no prompt");
    return [];}
  
  // Строим супервектор из промпта
  final promptSuperVector = <int, int>{};
  for (final wordId in promptWordIds) {
    final word = words[wordId];
    if (word != null) {
      for (final entry in word.ratings.entries) {
        promptSuperVector[entry.key] = (promptSuperVector[entry.key] ?? 0) + entry.value;
      }
    }
  }
  
  // Самопроекция для получения качественного вектора
  final promptVector = VectorOperations.selfProjection(promptSuperVector, words);
  if (promptVector.isEmpty) return [];
  
  // Находим слова с максимальным пересечением и высоким allRating
  final wordScores = <int, _WordScore>{};
  
  for (final wordId in promptVector.keys) {
    final word = words[wordId];
    if (word == null) continue;
    
    // Вычисляем пересечение векторов (схожесть)
    double vectorIntersection = 0.0;
    for (final entry in word.ratings.entries) {
      if (promptVector.containsKey(entry.key)) {
        vectorIntersection += min(entry.value, promptVector[entry.key]!).toDouble();
      }
    }
    
    // Нормализуем пересечение
    final maxPossibleIntersection = word.ratings.values.fold(0, (a, b) => a + b);
    final normalizedIntersection = maxPossibleIntersection > 0 ? 
        vectorIntersection / maxPossibleIntersection : 0.0;
    
    // Учитываем allRating
    final allRatingScore = word.allRating / 1000000.0; // Нормализуем
    
    // Комбинированный score: 70% пересечение, 30% allRating
    final combinedScore = (normalizedIntersection * 0.7) + (allRatingScore * 0.3);
    
    wordScores[wordId] = _WordScore(
      wordId: wordId,
      intersectionScore: normalizedIntersection,
      allRatingScore: allRatingScore,
      combinedScore: combinedScore,
    );
  }
  
  // Сортируем по комбинированному score
  final sortedScores = wordScores.values.toList()
    ..sort((a, b) => b.combinedScore.compareTo(a.combinedScore));
  await AppLogger.writeLog("makeLine5 finished with ${sortedScores.length} output");
  // Берем топ 50 слов
  return sortedScores.take(50).map((score) => score.wordId).toList();
}



/// Нормализация вектора по формуле: (rating1/allRating1 + rating2/allRating2) / 2
Map<int, double> _normalizeVectorWithMutualProbability(Map<int, int> vector) {
  final normalized = <int, double>{};
  final wordIds = vector.keys.toList();
  
  // Для каждой пары слов в векторе вычисляем взаимную вероятность
  for (int i = 0; i < wordIds.length; i++) {
    final word1Id = wordIds[i];
    final word1 = network.words[word1Id];
    if (word1 == null) continue;
    
    for (int j = 0; j < wordIds.length; j++) {
      if (i == j) continue; // Пропускаем одинаковые слова
      
      final word2Id = wordIds[j];
      final word2 = network.words[word2Id];
      if (word2 == null) continue;
      
      // Вычисляем взаимные рейтинги
      final rating1to2 = word1.ratings[word2Id] ?? 0;
      final rating2to1 = word2.ratings[word1Id] ?? 0;
      
      // Применяем формулу: (rating1/allRating1 + rating2/allRating2) / 2
      final prob1 = word1.allRating > 0 ? rating1to2 / word1.allRating : 0;
      final prob2 = word2.allRating > 0 ? rating2to1 / word2.allRating : 0;
      
      final mutualProbability = (prob1 + prob2) / 2;
      
      // Распределяем вероятность между обоими словами
      normalized[word1Id] = (normalized[word1Id] ?? 0) + mutualProbability;
      normalized[word2Id] = (normalized[word2Id] ?? 0) + mutualProbability;
    }
  }
  
  // Нормализуем чтобы сумма вероятностей = 1
  final total = normalized.values.fold(0.0, (a, b) => a + b);
  if (total > 0) {
    for (final key in normalized.keys) {
      normalized[key] = normalized[key]! / total;
    }
  }
  
  return normalized;
}
_VectorStats _analyzeVector(Map<int, int> vector) {
  if (vector.isEmpty) {
    return _VectorStats(
      network: network,
      minValue: 0.0,
      maxValue: 0.0,
      valueRange: 0.0,
      mean: 0.0,
      standardDeviation: 0.0,
    );
  }

  // Нормализуем вектор по формуле взаимных вероятностей
  final normalizedVector = _normalizeVectorWithMutualProbability(vector);
  
  final values = normalizedVector.values.toList();
  final minValue = values.reduce((a, b) => a < b ? a : b);
  final maxValue = values.reduce((a, b) => a > b ? a : b);
  final valueRange = maxValue - minValue;
  
  final mean = values.fold(0.0, (a, b) => a + b) / values.length;
  final variance = values.map((v) => pow(v - mean, 2)).fold(0.0, (a, b) => a + b) / values.length;
  final standardDeviation = sqrt(variance);

  return _VectorStats(
    network: network,
    minValue: minValue,
    maxValue: maxValue,
    valueRange: valueRange,
    mean: mean,
    standardDeviation: standardDeviation,
  );
}




/// Генерация строки — «line8» — осмысленный ответ (string)
Future<String> makeLine8ForAPrompt(List<int> promptWordIds) async {
  if (promptWordIds.isEmpty) {
    await AppLogger.writeLog("makeLine8 no prompt");
    return '';
  }

  // Получаем кандидатов из уже существующих генераторов параллельно
  final results = await Future.wait([
   makeLine6ForAPrompt(promptWordIds),
    makeLine5ForAPrompt(promptWordIds),
  ]);

  final candidates7 = results[0]; // вероятно более «сложные» кандидаты
  final candidates5 = results[1]; // более частотные / глобальные

  // Собираем и взвешиваем кандидатов
  final scoreMap = <int, double>{};
  int pos = 0;
  for (final id in candidates7) {
    // даём больший вес тем что из makeLine7 (ранг + allRating)
    final w = words[id];
    final base = (w?.allRating ?? 1).toDouble();
    scoreMap[id] = (scoreMap[id] ?? 0.0) + base * (1.0 + (100.0 / (1 + pos)));
    pos++;
  }
  pos = 0;
  for (final id in candidates5) {
    final w = words[id];
    final base = (w?.allRating ?? 1).toDouble();
    scoreMap[id] = (scoreMap[id] ?? 0.0) + base * (0.6 + (50.0 / (1 + pos)));
    pos++;
  }

  if (scoreMap.isEmpty) {
    await AppLogger.writeLog("makeLine8 no candidates");
    return '';
  }

  // Сортируем кандидатов по скору
  final sorted = scoreMap.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  // Убираем дубликаты, стоп-слова и собираем финальный порядок
  final used = <int>{};
  final finalIds = <int>[];
  final rng = Random();

  // Список коннекторов для естественности
  final connectors = ['и', 'но', 'а', 'также', 'затем', 'однако'];

  // Функция проверки стоп-слов (использует существующий STOP_WORDS set)
  bool isStopWordId(int id) {
    final wname = wordLibrary[id];
    if (wname == null) return true;
    return STOP_WORDS.contains(wname.toLowerCase());
  }

  // Сначала пробуем взять первый значимый (не-стоп) как начало
  for (final e in sorted) {
    final id = e.key;
    if (used.contains(id)) continue;
    if (isStopWordId(id)) continue;
    finalIds.add(id);
    used.add(id);
    break;
  }

  // Затем добавляем ещё слов до длины предложения (6..12)
  final targetLen = min(12, max(6, 6 + rng.nextInt(7))); // 6..12
  for (final e in sorted) {
    if (finalIds.length >= targetLen) break;
    final id = e.key;
    if (used.contains(id)) continue;
    finalIds.add(id);
    used.add(id);
  }

  // Если получилось мало слов — добавим несколько стоп-слов по необходимости
  if (finalIds.length < 4) {
    for (final e in sorted) {
      if (finalIds.length >= 4) break;
      final id = e.key;
      if (used.contains(id)) continue;
      finalIds.add(id);
      used.add(id);
    }
  }

  // Построение строки с простыми связками: вставляем периодически коннектор
  final wordsOut = <String>[];
  for (int i = 0; i < finalIds.length; i++) {
    final id = finalIds[i];
    final token = wordLibrary[id] ?? '';
    if (token.isEmpty) continue;

    // Иногда вставляем связку перед словом для естественности
    if (i > 1 && rng.nextDouble() < 0.18) {
      wordsOut.add(connectors[rng.nextInt(connectors.length)]);
    }

    wordsOut.add(token);
  }

  if (wordsOut.isEmpty) return '';

  // Преобразование в валидную фразу: корректировка пунктуации, заглавная буква
  String sentence = wordsOut.join(' ');

  // Убираем лишние пробелы перед запятыми/точками (если такие возникнут)
  sentence = sentence.replaceAll(RegExp(r'\s+,'), ',');
  sentence = sentence.replaceAll(RegExp(r'\s+\.'), '.');

  // Ограничение длины символов (без разрыва слов)
  if (sentence.length > 240) {
    sentence = sentence.substring(0, 240);
    // Обрезаем до последнего пробела чтобы не резать слово
    final lastSpace = sentence.lastIndexOf(' ');
    if (lastSpace > 0) sentence = sentence.substring(0, lastSpace);
    sentence = sentence.trim();
    sentence = sentence + '...';
  }

  // Заглавная первая буква
  sentence = sentence.trim();
  if (sentence.isNotEmpty) {
    sentence = sentence[0].toUpperCase() + sentence.substring(1);
  }

  // Завершающий знак
  if (!RegExp(r'[.!?]$').hasMatch(sentence)) {
    sentence = '$sentence.';
  }

  await AppLogger.writeLog("makeLine8 finished: $sentence");
  return sentence;
}


Future<List<int>> makeLine7ForAPrompt(List<int> promptWordIds) async {
  if (promptWordIds.isEmpty) {
    await AppLogger.writeLog("makeLine7 no prompt");
    return [];
  }
  return [];

  // Кэшируем нормализованные векторы слов чтобы не пересчитывать каждый раз
  final normalizedWordCache = <int, Map<int, double>>{};
  
  // Строим супервектор из промпта и самопроекция
  final promptSuperVector = <int, int>{};
  for (final wordId in promptWordIds) {
    final word = words[wordId];
    if (word != null) {
      for (final entry in word.ratings.entries) {
        promptSuperVector[entry.key] = (promptSuperVector[entry.key] ?? 0) + entry.value;
      }
    }
  }
  
  final originalPromptVector = VectorOperations.selfProjection(promptSuperVector, words);
  if (originalPromptVector.isEmpty) return [];

  // Нормализуем исходный вектор по новой формуле
  final normalizedPromptVector = _normalizeVectorWithFormula(originalPromptVector);
  
  final resultWords = <int>[];
  Map<int, double> currentVector = Map<int, double>.from(normalizedPromptVector);
  final usedWordIds = Set<int>.from(promptWordIds);
  
  // Статистика по allRating для балансировки
  int highRatingCount = 0;
  int mediumRatingCount = 0;
  int lowRatingCount = 0;

  // Предварительно вычисляем тензорные операции для промпта
  Map<int, double> processedVector = _applyTensorOperations(currentVector);
  double currentEntropy = _calculateShannonEntropy(processedVector);
  _VectorStats vectorStats = _analyzeEnhancedVector(processedVector);

  // Пошагово добавляем 11 слов с оптимизированной логикой
  for (int step = 0; step < 9; step++) {
    final allRatingBalance = _calculateAllRatingBalance(highRatingCount, mediumRatingCount, lowRatingCount);
    
    final strategy = _determineEnhancedStrategy(
      currentEntropy, 
      vectorStats, 
      allRatingBalance,
      step
    );

    await AppLogger.writeLog(
      "Step $step: entropy=${currentEntropy.toStringAsFixed(3)}, "
      "balance=[H:$highRatingCount M:$mediumRatingCount L:$lowRatingCount]"
    );

    final candidateScores = <int, _EnhancedCandidateScore>{};

    // Ограничиваем поиск кандидатов только топ-N слов из текущего вектора
    final candidateWordIds = _getTopCandidateWords(processedVector, 100); // Ограничиваем до 100 кандидатов

    for (final wordId in candidateWordIds) {
      if (usedWordIds.contains(wordId)) continue;
      
      final word = words[wordId];
      if (word == null) continue;

      // Используем кэш для нормализованного вектора слова
      final wordNormalized = normalizedWordCache[wordId] ?? _normalizeWordVector(word);
      normalizedWordCache[wordId] = wordNormalized;

      // Быстрое вычисление сходства без полного перебора
      final similarityScore = _calculateFastSimilarity(processedVector, wordNormalized);
      
      // Быстрое предсказание нового вектора (простое сложение)
      final predictedVector = _fastVectorAddition(processedVector, wordNormalized);
      
      // Применяем тензорные операции к предсказанному вектору
      final predictedProcessedVector = _applyTensorOperations(predictedVector);
      final predictedEntropy = _calculateShannonEntropy(predictedProcessedVector);
      final entropyChange = predictedEntropy - currentEntropy;

      // Оценка баланса allRating
      final wordAllRating = word.allRating;
      final allRatingScore = _evaluateAllRatingContribution(
        wordAllRating, 
        strategy, 
        highRatingCount, 
        mediumRatingCount, 
        lowRatingCount
      );

      final combinedScore = strategy.calculateScore(
        similarityScore: similarityScore,
        entropyChange: entropyChange,
        allRatingScore: allRatingScore,
        currentStep: step,
      );

      candidateScores[wordId] = _EnhancedCandidateScore(
        wordId: wordId,
        similarityScore: similarityScore,
        entropyChange: entropyChange,
        allRatingScore: allRatingScore,
        combinedScore: combinedScore,
        wordAllRating: wordAllRating,
      );
    }

    if (candidateScores.isEmpty) break;

    // Выбираем лучшего кандидата
    final bestCandidate = _getBestCandidate(candidateScores);
    final bestWordId = bestCandidate.wordId;
    final bestWord = words[bestWordId];

    // Добавляем слово и обновляем статистику
    resultWords.add(bestWordId);
    usedWordIds.add(bestWordId);
    
    // Обновляем счетчики allRating
    if (bestWord != null) {
      if (bestWord.allRating > 500000) highRatingCount++;
      else if (bestWord.allRating > 100000) mediumRatingCount++;
      else lowRatingCount++;
    }

    // ОПТИМИЗАЦИЯ: Быстрое обновление текущего вектора
    final bestWordNormalized = normalizedWordCache[bestWordId] ?? _normalizeWordVector(bestWord!);
    currentVector = _fastVectorAddition(currentVector, bestWordNormalized!);
    
    // ОПТИМИЗАЦИЯ: Обновляем processedVector и энтропию инкрементально
    processedVector = _applyTensorOperations(currentVector);
    currentEntropy = _calculateShannonEntropy(processedVector);
    vectorStats = _analyzeEnhancedVector(processedVector);

    // Упрощенное согласование с промптом
    _fastReconcileWithPrompt(currentVector, normalizedPromptVector, step / 11.0);
  }
final line7 = resultWords.map((id)=>wordLibrary[id]??'').join(' ');
  await AppLogger.writeLog("makeLine7 finished with ${resultWords.length} words: ${resultWords} line7: ${line7}");
  

  return resultWords;
}

/// ОПТИМИЗИРОВАННЫЕ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ

/// Быстрое сложение векторов
Map<int, double> _fastVectorAddition(Map<int, double> vector1, Map<int, double> vector2) {
  final result = Map<int, double>.from(vector1);
  for (final entry in vector2.entries) {
    result[entry.key] = (result[entry.key] ?? 0) + entry.value;
  }
  return result;
}

/// Быстрое вычисление сходства
double _calculateFastSimilarity(Map<int, double> vector, Map<int, double> wordVector) {
  double similarity = 0.0;
  int commonCount = 0;
  
  // Итерируем только по меньшему вектору для оптимизации
  final searchVector = wordVector.length < vector.length ? wordVector : vector;
  final targetVector = wordVector.length < vector.length ? vector : wordVector;
  
  for (final entry in searchVector.entries) {
    if (targetVector.containsKey(entry.key)) {
      similarity += min(entry.value, targetVector[entry.key]!);
      commonCount++;
    }
  }
  
  return commonCount > 0 ? similarity / commonCount : 0.0;
}

/// Выбор топ-N кандидатов для ограничения поиска
List<int> _getTopCandidateWords(Map<int, double> vector, int limit) {
  final entries = vector.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  final topWords = entries.take(limit).map((e) => e.key).toList();
  final bottomWords = entries.reversed.take(15).map((e) => e.key).toList();
  
  return [...topWords, ...bottomWords];
}

/// Быстрый выбор лучшего кандидата
_EnhancedCandidateScore _getBestCandidate(Map<int, _EnhancedCandidateScore> candidates) {
  _EnhancedCandidateScore? bestCandidate;
  double bestScore = -double.infinity;
  
  for (final candidate in candidates.values) {
    if (candidate.combinedScore > bestScore) {
      bestScore = candidate.combinedScore;
      bestCandidate = candidate;
    }
  }
  
  return bestCandidate!;
}

/// Упрощенное согласование с промптом
void _fastReconcileWithPrompt(
  Map<int, double> currentVector, 
  Map<int, double> promptVector, 
  double progress
) {
  final promptWeight = 0.3 * (1.0 - progress);
  
  for (final entry in promptVector.entries) {
    currentVector[entry.key] = (currentVector[entry.key] ?? 0) * (1 - promptWeight) + 
                              entry.value * promptWeight;
  }
}
 
double _calculateShannonEntropy(Map<int, double> vector) {
  if (vector.isEmpty) return 0.0;

  final values = vector.values.toList();
  final total = values.fold(0.0, (a, b) => a + b);
  
  if (total <= 0 || total.isInfinite || total.isNaN) return 0.0;

  double entropy = 0.0;
  for (final value in values) {
    if (value <= 0) continue;
    final probability = value / total;
    if (probability > 0 && !probability.isInfinite && !probability.isNaN) {
      entropy -= probability * log(probability);
    }
  }

  // Защита от некорректных значений
  return entropy.isNaN || entropy.isInfinite ? 0.0 : entropy;
}
/// Нормализация вектора по формуле: (rating1/allRating1 + rating2/allRating2) / 2
Map<int, double> _normalizeVectorWithFormula(Map<int, int> vector) {
  final normalized = <int, double>{};
  final wordIds = vector.keys.toList();
  
  for (int i = 0; i < wordIds.length; i++) {
    for (int j = i + 1; j < wordIds.length; j++) {
      final word1Id = wordIds[i];
      final word2Id = wordIds[j];
      
      final word1 = words[word1Id];
      final word2 = words[word2Id];
      
      if (word1 == null || word2 == null) continue;
      
      final rating1to2 = word1.ratings[word2Id] ?? 0;
      final rating2to1 = word2.ratings[word1Id] ?? 0;
      
      final prob1 = word1.allRating > 0 ? rating1to2 / word1.allRating : 0;
      final prob2 = word2.allRating > 0 ? rating2to1 / word2.allRating : 0;
      
      final mutualWeight = (prob1 + prob2) / 2;
      
      // Распределяем вес между обоими словами
      normalized[word1Id] = (normalized[word1Id] ?? 0) + mutualWeight;
      normalized[word2Id] = (normalized[word2Id] ?? 0) + mutualWeight;
    }
  }
  
  return normalized;
}

/// Нормализация вектора отдельного слова
Map<int, double> _normalizeWordVector(Word word) {
  final normalized = <int, double>{};
  
  for (final entry in word.ratings.entries) {
    final otherWord = words[entry.key];
    if (otherWord != null) {
      final rating1to2 = entry.value;
      final rating2to1 = otherWord.ratings[word.id] ?? 0;
      
      final prob1 = word.allRating > 0 ? rating1to2 / word.allRating : 0;
      final prob2 = otherWord.allRating > 0 ? rating2to1 / otherWord.allRating : 0;
      
      final mutualWeight = (prob1 + prob2) / 2;
      
      normalized[entry.key] = mutualWeight;
    }
  }
  
  return normalized;
}

/// Тензорные операции для обработки вектора
Map<int, double> _applyTensorOperations(Map<int, double> vector) {
  if (vector.isEmpty) return vector;
  
  final processed = Map<int, double>.from(vector);
  
  // 1. Нормализация L2 с защитой от деления на ноль
  final l2Norm = sqrt(vector.values.map((v) => v * v).fold(0.0, (a, b) => a + b));
  if (l2Norm > 1e-10) { // Защита от слишком малых значений
    for (final key in processed.keys) {
      processed[key] = processed[key]! / l2Norm;
    }
  }
  
  // 2. Нелинейное преобразование с ограничением
  for (final key in processed.keys) {
    processed[key] = max(0.0, min(1.0, processed[key]! * 1.5 - 0.2)); // Ограничиваем диапазон
  }
  
  // 3. Softmax с защитой от переполнения
  final maxVal = processed.values.fold(-double.infinity, (a, b) => max(a, b));
  final expValues = processed.values.map((v) => exp(v - maxVal)).toList(); // Стабилизация
  final sumExp = expValues.fold(0.0, (a, b) => a + b);
  
  if (sumExp > 1e-10) {
    final keys = processed.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      processed[keys[i]] = expValues[i] / sumExp;
    }
  }
  
  return processed;
}
/// Расчет баланса allRating
double _calculateAllRatingBalance(int high, int medium, int low) {
  final total = high + medium + low;
  if (total == 0) return 0.5;
  
  final highRatio = high / total;
  final lowRatio = low / total;
  
  // Идеальный баланс: 40% high, 30% medium, 30% low
  const idealHigh = 0.4;
  const idealLow = 0.3;
  
  final highDeviation = (highRatio - idealHigh).abs();
  final lowDeviation = (lowRatio - idealLow).abs();
  
  return 1.0 - (highDeviation + lowDeviation) / 2;
}



/// Генерация шестой линии - минимальный allRating, максимальная связь
Future<List<int>> makeLine6ForAPrompt(List<int> promptWordIds) async {
    if (promptWordIds.isEmpty) {
    
    await AppLogger.writeLog("makeLine6 no prompt");
    return [];}
  
  // Строим супервектор из промпта
  final promptSuperVector = <int, int>{};
  for (final wordId in promptWordIds) {
    final word = words[wordId];
    if (word != null) {
      for (final entry in word.ratings.entries) {
        promptSuperVector[entry.key] = (promptSuperVector[entry.key] ?? 0) + entry.value;
      }
    }
  }
  
  final promptVector = VectorOperations.selfProjection(promptSuperVector, words);
  if (promptVector.isEmpty) return [];
  
  final wordScores = <int, _WordScore>{};
  
  for (final wordId in promptVector.keys) {
    final word = words[wordId];
    if (word == null) continue;
    
    // Вычисляем пересечение векторов
    double vectorIntersection = 0.0;
    for (final entry in word.ratings.entries) {
      if (promptVector.containsKey(entry.key)) {
        vectorIntersection += min(entry.value, promptVector[entry.key]!).toDouble();
      }
    }
    
    final maxPossibleIntersection = word.ratings.values.fold(0, (a, b) => a + b);
    final normalizedIntersection = maxPossibleIntersection > 0 ? 
        vectorIntersection / maxPossibleIntersection : 0.0;
    
    // Инвертируем allRating (чем меньше - тем лучше)
    final invertedAllRating = 1.0 / (word.allRating + 1); // +1 чтобы избежать деления на 0
    
    // Комбинированный score: 80% пересечение, 20% инвертированный allRating
    final combinedScore = (normalizedIntersection * 0.8) + (invertedAllRating * 0.2);
    
    wordScores[wordId] = _WordScore(
      wordId: wordId,
      intersectionScore: normalizedIntersection,
      allRatingScore: invertedAllRating,
      combinedScore: combinedScore,
    );
  }
  
  final sortedScores = wordScores.values.toList()
    ..sort((a, b) => b.combinedScore.compareTo(a.combinedScore));
  await AppLogger.writeLog("makeLine6 finished with ${sortedScores.length} output");
  return sortedScores.take(50).map((score) => score.wordId).toList();
}

  // ========== ОБРАБОТКА ЗАПРОСОВ ==========

/// Обновляем метод обработки запросов
Future<Map<String, dynamic>> processQueryAdvanced(String query) async {
  final wordTexts = _extractWords(query);
  final promptWordIds = wordTexts
      .map((w) => wordIndex[w])
      .where((id) => id != null)
      .cast<int>()
      .toList();
  
  if (promptWordIds.isEmpty) {
    return {'line1': '', 'line2': '', 'line3': '', 'line5': '', 'line6': '','line7':'', 'fragments': []};
  }
  
  currentSearchWords = promptWordIds;
  //selectedWordIds = promptWordIds.toSet();
  final querySemantics = SemanticAnalyzer.analyzeSemantics(query);
  
  final superVector = <int, int>{};
  for (final wordId in promptWordIds) {
    final word = words[wordId];
    if (word != null) {
      for (final entry in word.ratings.entries) {
        superVector[entry.key] = (superVector[entry.key] ?? 0) + entry.value;
      }
    }
  }
  
  final promptVector = VectorOperations.selfProjection(superVector, words);
  currentSearchVector = promptVector;
  
  // Генерация всех линий
  final line1Words = promptWordIds.take(10).toList();
  final line1 = line1Words.map((id) => wordLibrary[id] ?? '').join(' ');
  
  final line2Words = await _generateLine2WithPossibilityVector(line1Words, promptWordIds);
  final line2 = TextNormalizer.normalizeText(
      line2Words.map((id) => wordLibrary[id] ?? '').join(' '));
  
  final line3Fragments = await _findFragmentsWithMaxCoverage(promptVector, promptWordIds, querySemantics);
  final uniqueFragments = _removeDuplicateFragments(line3Fragments);
  final line3 = uniqueFragments
      .take(10)
      .map((id) => fragments[id]?.text ?? '')
      .join(' ... ');
  
  // Новые линии 5 и 6
  final line5Words = await makeLine5ForAPrompt(promptWordIds);
  final line5 = line5Words.take(20).map((id) => wordLibrary[id] ?? '').join(' ');
  
  final line6Words = await makeLine6ForAPrompt(promptWordIds);
  final line6 = line6Words.take(20).map((id) => wordLibrary[id] ?? '').join(' ');
  

  final line7Words = await makeLine7ForAPrompt(promptWordIds);
  final line7 = line7Words.map((id)=>wordLibrary[id]??'').join(' ');
  await AppLogger.writeLog("generated line7: ${line7}");
 
 final pkg = Package(
    id: nextPackageId++,
    signature: promptWordIds,
    keywords: promptWordIds,
    status: PackageStatus.through,
    fragmentLinks: List.from(uniqueFragments),
  );
  await AppLogger.writeLog("generated line7: ${line7}");
    AppLogger.writeLog("package made");
  packages[pkg.id] = pkg;
  
  await _routePackage(pkg, 0, <int>{});
   await AppLogger.writeLog("package sent and returned");
  final uniqueResultFragments = _removeDuplicateFragments(pkg.fragmentLinks)
      .take(100)
      .map((id) => fragments[id]?.text ?? '')
      .where((t) => t.isNotEmpty)
      .toList();
  
  return {
    'line1': line1,
    'line2': line2,
    'line3': line3,
    'line5': line5,
    'line6': line6,
    'line7': line7,
    'fragments': uniqueResultFragments,
    'package_status': pkg.status.toString(),
    'semantics': querySemantics,
  };
}


  OptimizedNeuralNetwork get self => this;
  
  // или
  OptimizedNeuralNetwork get network => this;
/// Улучшенный анализ вектора с дополнительной статистикой
/// Улучшенный анализ вектора с поддержкой double
_VectorStats _analyzeEnhancedVector(Map<int, double> vector) {
  if (vector.isEmpty) {
    return _VectorStats(
      network: network,
      minValue: 0.0,
      maxValue: 0.0,
      valueRange: 0.0,
      mean: 0.0,
      standardDeviation: 0.0,
    );
  }

  final values = vector.values.toList();
  final minValue = values.reduce((a, b) => a < b ? a : b);
  final maxValue = values.reduce((a, b) => a > b ? a : b);
  final valueRange = maxValue - minValue;
  
  final mean = values.fold(0.0, (a, b) => a + b) / values.length;
  final variance = values.map((v) => pow(v - mean, 2)).fold(0.0, (a, b) => a + b) / values.length;
  final standardDeviation = sqrt(variance);

  return _VectorStats(
    network: network,
    minValue: minValue,
    maxValue: maxValue,
    valueRange: valueRange,
    mean: mean,
    standardDeviation: standardDeviation,
  );
}
/// Расчет сходства между вектором и словом
double _calculateVectorSimilarity(Map<int, double> vector, Word word) {
  double similarity = 0.0;
  int commonWords = 0;
  
  for (final entry in word.ratings.entries) {
    if (vector.containsKey(entry.key)) {
      final wordObj = words[entry.key];
      if (wordObj != null) {
        // Используем нормализованные веса
        final rating1to2 = entry.value;
        final rating2to1 = wordObj.ratings[word.id] ?? 0;
        
        final prob1 = word.allRating > 0 ? rating1to2 / word.allRating : 0;
        final prob2 = wordObj.allRating > 0 ? rating2to1 / wordObj.allRating : 0;
        
        final mutualWeight = (prob1 + prob2) / 2;
        final vectorWeight = vector[entry.key] ?? 0;
        
        similarity += min(mutualWeight, vectorWeight);
        commonWords++;
      }
    }
  }
  
  // Нормализуем по количеству общих слов
  return commonWords > 0 ? similarity / commonWords : 0.0;
}

/// Оценка вклада allRating в баланс
double _evaluateAllRatingContribution(
  int wordAllRating, 
  _EnhancedStrategy strategy,
  int highCount, 
  int mediumCount, 
  int lowCount
) {
  final total = highCount + mediumCount + lowCount;
  if (total == 0) return 1.0;
  
  final highRatio = highCount / total;
  final lowRatio = lowCount / total;
  
  // Определяем категорию текущего слова
  final bool isHighRating = wordAllRating > 500000;
  final bool isLowRating = wordAllRating < 100000;
  
  // Оцениваем нужность этого слова для баланса
  if (strategy.preferHighRating && isHighRating) {
    // Награждаем высокорейтинговые слова если их мало
    return highRatio < 0.4 ? 1.5 : 0.8;
  }
  
  if (strategy.preferLowRating && isLowRating) {
    // Награждаем низкорейтинговые слова если их мало
    return lowRatio < 0.3 ? 1.5 : 0.8;
  }
  
  if (!strategy.preferHighRating && isHighRating) {
    // Штрафуем высокорейтинговые слова если их много
    return highRatio > 0.5 ? 0.3 : 0.7;
  }
  
  if (!strategy.preferLowRating && isLowRating) {
    // Штрафуем низкорейтинговые слова если их много
    return lowRatio > 0.4 ? 0.3 : 0.7;
  }
  
  // Среднерейтинговые слова всегда хороши для баланса
  return 1.0;
}

/// Согласование текущего вектора с промптом
void _reconcileWithPromptVector(
  Map<int, double> currentVector, 
  Map<int, double> promptVector, 
  double progress
) {
  // Вес промпта уменьшается по мере прогресса
  final promptWeight = 0.5 * (1.0 - progress);
  final currentWeight = 1.0 - promptWeight;
  
  // Создаем объединенный набор ключей
  final allKeys = {...currentVector.keys, ...promptVector.keys};
  
  for (final key in allKeys) {
    final currentValue = currentVector[key] ?? 0;
    final promptValue = promptVector[key] ?? 0;
    
    // Взвешенное усреднение
    currentVector[key] = (currentValue * currentWeight) + (promptValue * promptWeight);
  }
  
  // Нормализуем результат
  final maxValue = currentVector.values.fold(0.0, (a, b) => max(a, b));
  if (maxValue > 0) {
    for (final key in currentVector.keys) {
      currentVector[key] = currentVector[key]! / maxValue;
    }
  }
}
  Future<void> _routePackage(Package pkg, int synapseId, Set<int> visited) async {
    if (pkg.status == PackageStatus.done) return;
    if (pkg.fragmentLinks.length >= 100) {
      pkg.status = PackageStatus.done;
      pkg.neuronLinks.add(0);
      return;
    }
    
    if (visited.contains(synapseId)) return;
    visited.add(synapseId);
    
    final synapse = synapses[synapseId];
    if (synapse == null) return;
    
    // Получаем ключевые слова пакета
    final pkgKeywords = _getPackageKeywords(pkg);
    final minKeywordMatch = (pkgKeywords.length * 0.15).ceil(); // 15% от ключевых слов
    
    for (final neuronId in synapse.neuronLinks) {
      final neuron = neurons[neuronId];
      if (neuron == null) continue;
      
      final similarity = _calculateSimilarity(pkg.signatureRatings, neuron.signatureRatings);
      
      if (similarity >= 0.7) {
        // Проверяем постоянные пакеты нейрона
        for (final packageId in neuron.packageLinks) {
          final permPkg = packages[packageId];
          if (permPkg != null && (permPkg.status == PackageStatus.permanent || permPkg.status == PackageStatus.done)) {
            // Фильтруем фрагменты по ключевым словам
            final filteredFragments = _filterFragmentsByKeywords(
              permPkg.fragmentLinks, 
              pkgKeywords, 
              minKeywordMatch
            );
            pkg.fragmentLinks.addAll(filteredFragments);
          }
        }
        
        // Фильтруем фрагменты нейрона по ключевым словам
        final filteredNeuronFragments = _filterFragmentsByKeywords(
          neuron.fragmentLinks, 
          pkgKeywords, 
          minKeywordMatch
        );
        pkg.fragmentLinks.addAll(filteredNeuronFragments);
        
        // Обновляем рейтинги связей между нейронами
        for (final linkedNeuronId in pkg.neuronLinks) {
          final linkedNeuron = neurons[linkedNeuronId];
          if (linkedNeuron != null && linkedNeuronId != neuronId) {
            linkedNeuron.neuronRatings[neuronId] = 
                (linkedNeuron.neuronRatings[neuronId] ?? 0) + (similarity * 100).round().toInt();
            neuron.neuronRatings[linkedNeuronId] = 
                (neuron.neuronRatings[linkedNeuronId] ?? 0) + (similarity * 100).round().toInt();
          }
        }
        
        if (pkg.fragmentLinks.length >= 100) {
          pkg.status = PackageStatus.done;
          pkg.neuronLinks.add(neuronId);
          neurons[neuronId]!.packageLinks.add(pkg.id);
          return;
        }
      }
    }
    
    for (final linkedSynapseId in synapse.synapseLinks) {
      if (linkedSynapseId != synapseId && !visited.contains(linkedSynapseId)) {
        await _routePackage(pkg, linkedSynapseId, visited);
        if (pkg.status == PackageStatus.done) return;
      }
    }
  }

  // Вспомогательные методы

  /// Извлекает ключевые слова из пакета на основе signatureRatings
  List<int> _getPackageKeywords(Package pkg) {
    final keywordScores = <int, double>{};
    
    for (final entry in pkg.signatureRatings.entries) {
      final wordId = entry.key;
      final score = entry.value;

      keywordScores[wordId] = score.toDouble();
    }
    
    // Сортируем по убыванию рейтинга и берем топ-20
    final sortedKeywords = keywordScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedKeywords
        .take(40)
        .map((entry) => entry.key)
        .toList();
  }

  /// Фильтрует фрагменты по ключевым словам
  List<int> _filterFragmentsByKeywords(
    List<int> fragmentIds, 
    List<int> keywords, 
    int minKeywordMatch
  ) {
    if (keywords.isEmpty || minKeywordMatch == 0) {
      return fragmentIds; // Если нет ключевых слов, возвращаем все фрагменты
    }
    
    final filteredFragments = <int>[];
    
    for (final fragmentId in fragmentIds) {
      final fragment = fragments[fragmentId];
      if (fragment == null) continue;

      // Считаем количество совпадающих ключевых слов
      int matchCount = 0;
      for (final keyword in keywords) {
 
        if (fragment.wordIds.contains(keyword)) {
          matchCount++;
          if (matchCount >= minKeywordMatch) {
            break; // Достаточно совпадений
          }
        }
      }
      
      // Добавляем фрагмент если достаточно совпадений
      if (matchCount >= minKeywordMatch) {
        filteredFragments.add(fragmentId);
      }
    }
    
    return filteredFragments;
  }

  /// Альтернативная версия фильтрации с использованием signature фрагментов
  List<int> _filterFragmentsBySignature(
    List<int> fragmentIds, 
    List<int> pkgKeywords, 
    int minKeywordMatch
  ) {
    if (pkgKeywords.isEmpty || minKeywordMatch == 0) {
      return fragmentIds;
    }
    
    final filteredFragments = <int>[];
    
    for (final fragmentId in fragmentIds) {
      final fragment = fragments[fragmentId];
      if (fragment == null) continue;
      
      // Получаем ключевые слова фрагмента из его signature
      final fragmentKeywords = _getFragmentKeywords(fragment);
      
      // Считаем пересечение ключевых слов
      final intersection = pkgKeywords.toSet().intersection(
        fragmentKeywords.toSet()
      );
      
      // Добавляем фрагмент если достаточно совпадений
      if (intersection.length >= minKeywordMatch) {
        filteredFragments.add(fragmentId);
      }
    }
    
    return filteredFragments;
  }

  /// Извлекает ключевые слова из фрагмента на основе его signature
  List<int> _getFragmentKeywords(Fragment fragment) {
    final keywords = <int>[];
    
    for (final wordId in fragment.wordIds) {
      keywords.add(wordId);
    }
    
    return keywords;
  }
double _calculateSimilarity(Map<int, int> sig1, Map<int, int> sig2) {
  if (sig1.isEmpty || sig2.isEmpty) return 0.0;
  
  // Находим общие слова
  final commonWords = sig1.keys.toSet().intersection(sig2.keys.toSet());
  if (commonWords.isEmpty) return 0.0;
  
  // Вычисляем суммы всех значений для нормализации
  final sum1 = sig1.values.reduce((a, b) => a + b).toDouble();
  final sum2 = sig2.values.reduce((a, b) => a + b).toDouble();
  
  double totalSimilarity = 0.0;
  int count = 0;
  
  for (final wordId in commonWords) {
    final value1 = sig1[wordId]!.toDouble();
    final value2 = sig2[wordId]!.toDouble();
    
    // Нормализуем значения
    final normalized1 = value1 / sum1;
    final normalized2 = value2 / sum2;
    
    // Вычисляем соотношение векторов
    final vectorRatio = normalized1 / ((normalized2 / ((value1 + value2) / 2)));
    
    // Добавляем к общей схожести
    totalSimilarity += vectorRatio;
    count++;
  }
  
  return count > 0 ? totalSimilarity / count : 0.0;
}
Future<void> processWebsite(String url, Function(String) onProgress) async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(url));
      client.close();
      
      if (response.statusCode != 200) {
        onProgress('  Ошибка HTTP: ${response.statusCode}');
        return;
      }

      // Улучшенное определение кодировки
      String html;
      final contentType = response.headers['content-type'];
      
      if (contentType?.contains('windows-1251') == true) {
        html = await _decodeWindows1251(response.bodyBytes);
        onProgress('  Декодируем windows-1251');
      } else {
        // Пробуем определить кодировку по содержимому
        html = await _autoDetectEncoding(response.bodyBytes);
        onProgress('  Автоопределение кодировки');
      }

      final document = html_parser.parse(html);
      
      String? pageTitle;
      final titleElement = document.querySelector('title');
      if (titleElement != null) {
        pageTitle = titleElement.text.trim();
        onProgress('  Заголовок: $pageTitle');
        
        // Проверяем корректность заголовка
        if (_containsGibberish(pageTitle)) {
          onProgress('  ⚠️ Заголовок содержит некорректные символы - проблема с кодировкой');
        }
      }

      final texts = <String>[];
      String fullContent = '';
      
      // Целевые селекторы для этого сайта
   
        onProgress('  Пробуем альтернативные селекторы...');
        final alternativeSelectors = ['p', '.text', 'div', 'span','p.text','div.cont p', '.text p'];
        for (final selector in alternativeSelectors) {
          final elements = document.querySelectorAll(selector);
          onProgress('  Селектор $selector: ${elements.length} элементов');
          for (final element in elements) {
            final text = element.text.trim();
            if (text.length > 30 && 
                !_containsGibberish(text) &&
                !_isNavigation(text)) {
              texts.add(text);
              fullContent += text + ' ';
              
            }
          }
        
        }
   

      // Если все еще пусто, пробуем получить весь текст из body
      if (texts.isEmpty) {
        onProgress('  Пробуем извлечь весь текст из body...');
        final bodyText = document.body?.text ?? '';
        if (bodyText.length > 100 && !_containsGibberish(bodyText)) {
          // Разбиваем на предложения
          final sentences = bodyText.split(RegExp(r'[.!?]+'));
          for (final sentence in sentences) {
            final trimmed = sentence.trim();
            if (trimmed.length > 20 && !_isNavigation(trimmed)) {
              texts.add(trimmed);
              fullContent += trimmed + ' ';
            }
          }
        }
      }

      onProgress('  Итого текстовых блоков: ${texts.length}');
      onProgress('  Общий объем текста: ${fullContent.length} символов');
      
      if (texts.isEmpty) {
        onProgress('  Не удалось извлечь текстовое содержимое');
        
        // Для отладки выведем первые 500 символов сырого HTML
        final rawPreview = html.length > 500 ? html.substring(0, 500) + '...' : html;
        onProgress('  Сырой HTML (первые 500 символов): $rawPreview');
        return;
      }
      
      // Проверяем качество извлеченного текста
      if (_containsGibberish(fullContent)) {
        onProgress('  ⚠️ Извлеченный текст содержит некорректные символы');
      }
      
      final neuronId = nextNeuronId++;
      final synapseId = nextSynapseId++;
      
      onProgress('  Создаем нейрон #$neuronId...');
      
      final synapse = Synapse(id: synapseId);
      synapses[synapseId] = synapse;
      
      final neuron = Neuron(
        id: neuronId,
        personalSynapseId: synapseId,
        sourceUrl: url,
        pageTitle: pageTitle,
        fullPageContent: fullContent.trim(),
      );
      neurons[neuronId] = neuron;
      
      synapse.neuronLinks.add(neuronId);
      
      if (neurons.length > 1) {
        final rootSynapse = synapses[0]!;
        rootSynapse.synapseLinks.add(synapseId);
        synapse.synapseLinks.add(0);
      }
      
      final allWordIds = <int>[];
      onProgress('  Обрабатываем тексты...');
      
      // Обрабатываем тексты с прогрессом
      for (int i = 0; i < texts.length; i++) {
        onProgress('  Текст ${i + 1}/${texts.length}...');
        await _processText(texts[i], neuron, allWordIds);
      }
      
      if (allWordIds.isNotEmpty) {
        neuron.updateSignature(allWordIds,network);
        onProgress('  Сигнатура обновлена: ${allWordIds.length} слов');
      }
      
      onProgress('  Создаем пакеты для фрагментов...');
      for (final fragmentId in neuron.fragmentLinks) {
        final fragment = fragments[fragmentId];
        if (fragment != null && fragment.wordIds.isNotEmpty) {
          await _createPackageForFragment(fragment, neuron);
        }
      }
      
      await _checkNeuronSimilarity(neuron, onProgress);
      //await neuron.express(this);
      onProgress('  Express создан для нейрона #$neuronId');
      
      //await updateClusters();
      onProgress('  ✅ Обработка завершена');
      
    } catch (e) {
      onProgress('  ❌ Исключение при обработке: $e');
    }
  }

Future<String> _decodeWindows1251(List<int> bytes) async {
  try {
    // Конвертируем List<int> в Uint8List
    final uint8List = Uint8List.fromList(bytes);
    final result = await CharsetConverter.decode('windows-1251', uint8List);
    return result ?? utf8.decode(bytes, allowMalformed: true);
  } catch (e) {
    return utf8.decode(bytes, allowMalformed: true);
  }
}
String _manualEncodingFix(String text) {
  final replacements = {
    'Ð': 'Н', 'Ñ': 'О', 'Ò': 'П', 'Ó': 'Р', 'Ô': 'С', 'Õ': 'Т', 'Ö': 'У',
    '×': 'Ф', 'Ø': 'Х', 'Ù': 'Ц', 'Ú': 'Ч', 'Û': 'Ш', 'Ü': 'Щ', 'Ý': 'Ъ',
    'Þ': 'Ы', 'ß': 'Ь', 'à': 'Э', 'á': 'Ю', 'â': 'Я',
    'ã': 'а', 'ä': 'б', 'å': 'в', 'æ': 'г', 'ç': 'д', 'è': 'е', 'é': 'ж',
    'ê': 'з', 'ë': 'и', 'ì': 'й', 'í': 'к', 'î': 'л', 'ï': 'м', 'ð': 'н',
    'ñ': 'о', 'ò': 'п', 'ó': 'р', 'ô': 'с', 'õ': 'т', 'ö': 'у', '÷': 'ф',
    'ø': 'х', 'ù': 'ц', 'ú': 'ч', 'û': 'ш', 'ü': 'щ', 'ý': 'ъ', 'þ': 'ы',
    'ÿ': 'ь',
    'Â': 'А', 'Ã': 'Б', 'Ä': 'В', 'Å': 'Г', 'Æ': 'Д', 'Ç': 'Е', 'È': 'Ж',
    'É': 'З', 'Ê': 'И', 'Ë': 'Й', 'Ì': 'К', 'Í': 'Л', 'Î': 'М', 'Ï': 'Н',
  };
  
  String result = text;
  replacements.forEach((wrong, correct) {
    result = result.replaceAll(wrong, correct);
  });
  
  return result;
}

/// Автоопределение кодировки
Future<String> _autoDetectEncoding(List<int> bytes) async {
  // Сначала пробуем UTF-8
  try {
    final utf8Text = utf8.decode(bytes, allowMalformed: false);
    if (!_containsGibberish(utf8Text)) {
      return utf8Text;
    }
  } catch (e) {}
  
  // Пробуем windows-1251
  try {
    final win1251Text = await _decodeWindows1251(bytes);
    if (!_containsGibberish(win1251Text)) {
      return win1251Text;
    }
  } catch (e) {}
  
  // Пробуем latin1
  try {
    final latin1Text = latin1.decode(bytes);
    final convertedText = _latin1ToCyrillic(latin1Text);
    if (!_containsGibberish(convertedText)) {
      return convertedText;
    }
  } catch (e) {}
  
  // Последний вариант
  return utf8.decode(bytes, allowMalformed: true);
}

/// Проверка на "абракадабру" (некорректные символы)
bool _containsGibberish(String text) {
  // Проверяем наличие некорректных последовательностей символов
  final gibberishPattern = RegExp(r'[ÂÐâð]'); // Типичные артефакты неправильной кодировки
  final cyrillicPattern = RegExp(r'[а-яА-ЯёЁ]');
  
  // Если есть артефакты И мало кириллицы - вероятно проблема с кодировкой
  final hasGibberish = gibberishPattern.hasMatch(text);
  final hasCyrillic = cyrillicPattern.hasMatch(text);
  final cyrillicRatio = text.split('').where((c) => cyrillicPattern.hasMatch(c)).length / text.length;
  
  return hasGibberish || (text.isNotEmpty && cyrillicRatio < 0.1);
}

/// Конвертация latin1 в кириллицу (простая замена)
String _latin1ToCyrillic(String text) {
  final Map<String, String> replacements = {
    'Â': 'А', 'â': 'а', 'Ð': 'Д', 'ð': 'д',
    '': 'Е', '': 'В', '': 'Р'
  };
  
  String result = text;
  replacements.forEach((from, to) {
    result = result.replaceAll(from, to);
  });
  
  return result;
}


  bool _isNavigation(String text) {
    final navigationPatterns = [
      'главная', 'биография', 'отзыв', 'следующая', 'предыдущая', 
      'оглавление', 'страница', 'комментарии', '©', 'яндекс.метрика',
      '1, 2, 3,', '4, 5, 6,'
    ];
    return navigationPatterns.any((pattern) => text.toLowerCase().contains(pattern));
  }

 

  bool _containsCyrillic(String text) {
    return RegExp(r'[а-яА-ЯёЁ]').hasMatch(text);
  }

  Future<void> _processText(String text, Neuron neuron, List<int> allWordIds) async {
    final sentences = _splitIntoSentences(text);
    
    for (final sentence in sentences) {
      if (sentence.trim().length < 3) continue;
      
      final wordTexts = _extractWords(sentence);
      if (wordTexts.isEmpty) continue;
      
      final fragment = Fragment(
        id: nextFragmentId++,
        text: sentence,
        wordIds: [],
        neuronIds:[neuron.id],
      );
      
      fragments[fragment.id] = fragment;
      neuron.fragmentLinks.add(fragment.id);
      
      final sentenceWordIds = <int>[];
      for (final wordText in wordTexts) {
        final wordId = _getOrCreateWordId(wordText);
        if (wordId > 0) {
          sentenceWordIds.add(wordId);
          allWordIds.add(wordId);
        }
      }
      
      for (final wordId in sentenceWordIds) {
        final wordText = wordLibrary[wordId]!;
        if (!STOP_WORDS.contains(wordText)) {
          fragment.wordIds.add(wordId);
        }
      }
      
      _computeRatingsForSentence(sentenceWordIds);
    }
  }

  List<String> _splitIntoSentences(String text) {
    return text
        .split(RegExp(r'[.!?]+'))
        .map((s) => s.trim())
        .where((s) => s.length > 3)
        .toList();
  }

  int _getOrCreateWordId(String wordText) {
    final normalizedWord = wordText.toLowerCase().trim();
    
    if (normalizedWord.isEmpty || normalizedWord.length < 2) return -1;
    if (!RegExp(r'[а-яА-ЯёЁa-zA-Z]').hasMatch(normalizedWord)) return -1;
    
    int? wordId = wordIndex[normalizedWord];
    
    if (wordId == null) {
      wordId = nextWordId++;
      wordLibrary[wordId] = normalizedWord;
      wordIndex[normalizedWord] = wordId;
      
      words[wordId] = Word(
        id: wordId,
        ratings: {},
        allRating: 0,
        x: random.nextDouble() * 1000,
        y: random.nextDouble() * 1000,
        z: random.nextDouble() * 1000,
      );

    }
    
    return wordId;
  }

  void _computeRatingsForSentence(List<int> wordIds) {
    for (int i = 0; i < wordIds.length; i++) {
      final wordId = wordIds[i];
      final wordText = wordLibrary[wordId]!;
      if (STOP_WORDS.contains(wordText)) continue;

      double leftBonus = 1.0;
      for (int left = i - 1; left >= 0 && left >= i - 1; left--) {
        final leftWordText = wordLibrary[wordIds[left]]!;
        if (STOP_WORDS.contains(leftWordText)) {
          leftBonus += 0.01;
        } else {
          break;
        }
      }

      for (int j = max(0, i - 15); j <= min(wordIds.length - 1, i + 15); j++) {
        if (i == j) continue;
        final otherWordId = wordIds[j];
        final otherWordText = wordLibrary[otherWordId]!;
        if (STOP_WORDS.contains(otherWordText)) continue;

        final distance = (i - j).abs();
        double betweenBonus = 1.0;

        int stopWordsBetween = 0;
        for (int k = min(i, j) + 1; k < max(i, j); k++) {
          final betweenWordText = wordLibrary[wordIds[k]]!;
          if (STOP_WORDS.contains(betweenWordText)) stopWordsBetween++;
        }

        betweenBonus += stopWordsBetween * 0.005;
        final totalBonus = leftBonus + betweenBonus;
        final rating = (15.0 / distance) * totalBonus * (2-(words[otherWordId]!.allRating/((words[otherWordId]!.allRating+words[wordId]!.allRating)/2)).clamp(1.0,4.0) ).round();

        _updateWordRating(wordId, otherWordId, rating.toInt());
      }
    }
  }

  void _updateWordRating(int wordId, int otherId, int rating) {
    final word = words[wordId];
    if (word == null) return;
    
    word.ratings[otherId] = (word.ratings[otherId] ?? 0) + rating;
    
    if (word.ratings.length > MAX_VECTOR_SIZE) {
      final sorted = word.ratings.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      word.ratings.clear();
      for (int i = 0; i < MAX_VECTOR_SIZE; i++) {
        word.ratings[sorted[i].key] = sorted[i].value;
      }
    }
    
    word.allRating = word.ratings.values.fold(0, (a, b) => a + b);
    
    final otherWord = words[otherId];
    if (otherWord != null) {
      otherWord.ratings[wordId] = (otherWord.ratings[wordId] ?? 0) + (rating ~/ 2);
      if (otherWord.ratings.length > MAX_VECTOR_SIZE) {
        final sorted = otherWord.ratings.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        otherWord.ratings.clear();
        for (int i = 0; i < MAX_VECTOR_SIZE; i++) {
          otherWord.ratings[sorted[i].key] = sorted[i].value;
        }
      }
      otherWord.allRating = otherWord.ratings.values.fold(0, (a, b) => a + b);
    }
  }

  Future<void> _createPackageForFragment(Fragment fragment, Neuron neuron) async {
    if (fragment.wordIds.isEmpty) return;
    
    final pkg = Package(
      id: nextPackageId++,
      signature: List.from(fragment.wordIds),
      keywords: fragment.wordIds.take(10).toList(),
      status: PackageStatus.permanent,
      fragmentLinks: [fragment.id],
      neuronLinks: [neuron.id],
    );
    
    packages[pkg.id] = pkg;
    fragment.packageId = pkg.id;
    neuron.packageLinks.add(pkg.id);
  }

  Future<List<int>> _findFragmentsWithMaxCoverage(
    Map<int, int> superVector, 
    List<int> promptWordIds, 
    String querySemantics
  ) async {
    final fragmentScores = <int, double>{};
    final usedWords = Set<int>.from(promptWordIds);
    
    for (final fragment in fragments.values) {
      if (fragment.semanticType != querySemantics && querySemantics != 'повествование') {
        continue;
      }
      
      final fragmentWordSet = fragment.wordIds.toSet();
      final relevantWords = fragmentWordSet.difference(usedWords);
      if (relevantWords.isEmpty) continue;
      
      double coverageScore = 0.0;
      int coveredCount = 0;
      
      for (final wordId in relevantWords) {
        if (superVector.containsKey(wordId)) {
          coverageScore += superVector[wordId]!;
          coveredCount++;
        }
      }
      
      final coverageRatio = coveredCount / relevantWords.length;
      final lengthBonus = fragment.wordIds.length > 10 ? 1.0 : 0.5;
      
      final normalizedScore = coverageScore * coverageRatio * lengthBonus;
      fragmentScores[fragment.id] = normalizedScore;
    }
    
    final sortedFragments = fragmentScores.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedFragments
        .where((entry) => entry.value > 0)
        .take(20)
        .map((e) => e.key)
        .toList();
  }
  Future<void> _checkNeuronSimilarity(Neuron newNeuron, Function(String) onProgress) async {
    for (final existingNeuron in neurons.values) {
      if (existingNeuron.id == newNeuron.id || existingNeuron.id == 0) continue;
      
      final similarity = _calculateSimilarity(
        newNeuron.signatureRatings,
        existingNeuron.signatureRatings,
      );
      
      if (similarity > 0.3) {
        newNeuron.neuronRatings[existingNeuron.id] = (similarity * 1000).round();
        existingNeuron.neuronRatings[newNeuron.id] = (similarity * 1000).round();
        
        onProgress('  Связь с нейроном #${existingNeuron.id}: ${(similarity * 100).toStringAsFixed(1)}%');
      }
    }
  }


  // ... остальные методы остаются без изменений
  void optimizeWordPositions() {
    for (int i = 0; i < 20; i++) {
      Future.delayed(Duration(milliseconds: 1100), () {
        optimizeWordPositions1();
      });
    }
  }

  void optimizeWordPositions1() {
    final topWords = getTopWords(150);
    if (topWords.length < 2) return;
    
    _initializeStemBasedPositions(topWords);
    _applyStrongWordRepulsion(topWords);
    _applyStrongWordAttraction(topWords);
    _applyClusterAttraction(topWords);
    _applyFinalStabilization(topWords);
  }

  void _initializeStemBasedPositions(List<Word> topWords) {
    final stemGroups = <String, List<Word>>{};
    
    for (final word in topWords) {
      final wordText = wordLibrary[word.id] ?? '';
      final stem = WordStemmer.getStem(wordText);
      
      if (!stemGroups.containsKey(stem)) {
        stemGroups[stem] = [];
      }
      stemGroups[stem]!.add(word);
    }
    
    final groups = stemGroups.values.toList();
    final groupCount = groups.length;
    
    for (int i = 0; i < groupCount; i++) {
      final group = groups[i];
      if (group.length == 1) continue;
      
      final phi = acos(-1.0 + 2.0 * i / groupCount);
      final theta = sqrt(groupCount * pi) * phi;
      
      final centerX = 500.0 + 300.0 * sin(phi) * cos(theta);
      final centerY = 500.0 + 300.0 * sin(phi) * sin(theta);
      final centerZ = 500.0 + 300.0 * cos(phi);
      
      for (int j = 0; j < group.length; j++) {
        final word = group[j];
        final angle = 2 * pi * j / group.length;
        final radius = 20.0 + (word.allRating / 1550000).clamp(0.0, 50.0);
        
        word.x = centerX + radius * cos(angle);
        word.y = centerY + radius * sin(angle);
        word.z = centerZ + (j % 2 == 0 ? radius * 0.5 : -radius * 0.5);
      }
    }
    
    for (final word in topWords) {
      if (word.x == 0.0 && word.y == 0.0 && word.z == 0.0) {
        word.x = random.nextDouble() * 800 + 100;
        word.y = random.nextDouble() * 800 + 100;
        word.z = random.nextDouble() * 800 + 100;
      }
    }
  }

  void _applyStrongWordRepulsion(List<Word> topWords) {
    final strongWords = topWords.where((w) => w.allRating > 1550000).toList();
    
    for (int i = 0; i < strongWords.length; i++) {
      final word1 = strongWords[i];
      
      for (int j = i + 1; j < strongWords.length; j++) {
        final word2 = strongWords[j];
        
        final dx = word1.x - word2.x;
        final dy = word1.y - word2.y;
        final dz = word1.z - word2.z;
        final distance = sqrt(dx * dx + dy * dy + dz * dz);
        
        final minDistance = 150.0 + (word1.allRating + word2.allRating) / 150000.0;
        
        if (distance < minDistance) {
          final force = (minDistance - distance) / distance * 0.5;
          
          word1.x += dx * force * (word1.allRating / (word1.allRating + word2.allRating));
          word1.y += dy * force * (word1.allRating / (word1.allRating + word2.allRating));
          word1.z += dz * force * (word1.allRating / (word1.allRating + word2.allRating));
          
          word2.x -= dx * force * (word2.allRating / (word1.allRating + word2.allRating));
          word2.y -= dy * force * (word2.allRating / (word1.allRating + word2.allRating));
          word2.z -= dz * force * (word2.allRating / (word1.allRating + word2.allRating));
        }
      }
    }
  }

  void _applyStrongWordAttraction(List<Word> topWords) {
    final strongWords = topWords.where((w) => w.allRating > 1550000).toList();
    
    for (final strongWord in strongWords) {
      final attractionStrength = (strongWord.allRating / 1550000.0).clamp(0.1, 2.0);
      
      final strongConnections = strongWord.ratings.entries
          .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
      
      final connectionsToProcess = strongConnections.take(30).toList();
      
      for (final connection in connectionsToProcess) {
        final otherWord = words[connection.key];
        if (otherWord == null || otherWord == strongWord) continue;
        
        final connectionStrength = connection.value / strongWord.allRating;
        
        final dx = strongWord.x - otherWord.x;
        final dy = strongWord.y - otherWord.y;
        final dz = strongWord.z - otherWord.z;
        final distance = sqrt(dx * dx + dy * dy + dz * dz);
        
        final targetDistance = 50.0 + (1.0 - connectionStrength) * 200.0;
        
        if (distance > targetDistance) {
          final force = (distance - targetDistance) / distance * 
                       connectionStrength * 
                       attractionStrength * 0.3;
          
          otherWord.x += dx * force;
          otherWord.y += dy * force;
          otherWord.z += dz * force;
        }
      }
    }
  }

  void _applyClusterAttraction(List<Word> topWords) {
    final clusterCenters = <Word>[];
    
    for (final word in topWords) {
      if (word.allRating > 20000 && word.ratings.length > 10) {
        clusterCenters.add(word);
      }
    }
    
    final clusterPositions = <Word, List<double>>{};
    
    for (final center in clusterCenters) {
      double sumX = center.x;
      double sumY = center.y;
      double sumZ = center.z;
      int count = 1;
      
      final strongConnections = center.ratings.entries
          .where((e) => e.value > center.allRating * 0.1)
          .take(20)
          .toList();
      
      for (final connection in strongConnections) {
        final otherWord = words[connection.key];
        if (otherWord != null) {
          sumX += otherWord.x;
          sumY += otherWord.y;
          sumZ += otherWord.z;
          count++;
        }
      }
      
      clusterPositions[center] = [sumX / count, sumY / count, sumZ / count];
    }
    
    final clusters = clusterPositions.entries.toList();
    
    for (int i = 0; i < clusters.length; i++) {
      final cluster1 = clusters[i];
      
      for (int j = i + 1; j < clusters.length; j++) {
        final cluster2 = clusters[j];
        
        final commonConnections = _findCommonStrongConnections(
          cluster1.key, 
          cluster2.key
        );
        
        if (commonConnections > 3) {
          final dx = cluster1.value[0] - cluster2.value[0];
          final dy = cluster1.value[1] - cluster2.value[1];
          final dz = cluster1.value[2] - cluster2.value[2];
          final distance = sqrt(dx * dx + dy * dy + dz * dz);
          
          final targetDistance = 100.0 + commonConnections * 20.0;
          
          if (distance > targetDistance) {
            final force = (distance - targetDistance) / distance * 0.1;
            
            _moveClusterTowards(cluster1.key, cluster2.value, force * 0.5);
            _moveClusterTowards(cluster2.key, cluster1.value, force * 0.5);
          }
        }
      }
    }
  }

  void _moveClusterTowards(Word center, List<double> target, double force) {
    final dx = target[0] - center.x;
    final dy = target[1] - center.y;
    final dz = target[2] - center.z;
    
    center.x += dx * force;
    center.y += dy * force;
    center.z += dz * force;
    
    final strongConnections = center.ratings.entries
        .where((e) => e.value > center.allRating * 0.1)
        .take(15)
        .toList();
    
    for (final connection in strongConnections) {
      final otherWord = words[connection.key];
      if (otherWord != null) {
        otherWord.x += dx * force * 0.3;
        otherWord.y += dy * force * 0.3;
        otherWord.z += dz * force * 0.3;
      }
    }
  }

  int _findCommonStrongConnections(Word word1, Word word2) {
    int commonCount = 0;
    
    final threshold1 = word1.allRating * 0.05;
    final threshold2 = word2.allRating * 0.05;
    
    for (final entry in word1.ratings.entries) {
      if (entry.value > threshold1) {
        final otherRating = word2.ratings[entry.key];
        if (otherRating != null && otherRating > threshold2) {
          commonCount++;
        }
      }
    }
    
    return commonCount;
  }

  void _applyFinalStabilization(List<Word> topWords) {
    for (final word in topWords) {
      word.x = word.x.clamp(50.0, 950.0);
      word.y = word.y.clamp(50.0, 950.0);
      word.z = word.z.clamp(50.0, 950.0);
    }
    
    for (final word in topWords) {
      if (word.allRating < 5000) {
        word.x += (random.nextDouble() - 0.5) * 10.0;
        word.y += (random.nextDouble() - 0.5) * 10.0;
        word.z += (random.nextDouble() - 0.5) * 10.0;
      }
    }
  }

  List<Word> getTopWords(int limit) {
     final sorted = words.values.toList()
    ..sort((a, b) => b.allRating.compareTo(a.allRating));
  
  final filtered = sorted.where((word) => 
    !STOP_WORDS.contains(wordLibrary[word.id]!.toLowerCase())
  ).toList();
  
  final topWords = filtered.take(limit).toList();
  final bottomWords = filtered.reversed.take(15).toList();
  
  return [...topWords, ...bottomWords];
}


  Future<void> saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/neural_network_v2.json');
      
      final data = {
        'word_library': wordLibrary.map((k, v) => MapEntry(k.toString(), v)),
        'words': words.map((k, v) => MapEntry(k.toString(), v.toJson())),
        'fragments': fragments.map((k, v) => MapEntry(k.toString(), v.toJson())),
        'neurons': neurons.map((k, v) => MapEntry(k.toString(), v.toJson())),
        'synapses': synapses.map((k, v) => MapEntry(k.toString(), v.toJson())),
        'packages': packages.map((k, v) => MapEntry(k.toString(), v.toJson())),
        'next_word_id': nextWordId,
        'next_fragment_id': nextFragmentId,
        'next_neuron_id': nextNeuronId,
        'next_synapse_id': nextSynapseId,
        'next_package_id': nextPackageId,
      };
      
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Ошибка сохранения: $e');
    }
  }

  Future<void> loadFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/neural_network_v2.json');
      
      if (!await file.exists()) return;
      
      final content = await file.readAsString();
      final data = jsonDecode(content);
      
      wordLibrary.clear();
      wordIndex.clear();
      (data['word_library'] as Map).forEach((k, v) {
        final id = int.parse(k);
        wordLibrary[id] = v;
        wordIndex[v] = id;
      });
      
      words.clear();
      (data['words'] as Map).forEach((k, v) {
        words[int.parse(k)] = Word.fromJson(v);
      });
      
      fragments.clear();
      (data['fragments'] as Map).forEach((k, v) {
        fragments[int.parse(k)] = Fragment.fromJson(v);
      });
      
      neurons.clear();
      if (data['neurons'] != null) {
        (data['neurons'] as Map).forEach((k, v) {
          neurons[int.parse(k)] = Neuron.fromJson(v);
        });
      }
      
      synapses.clear();
      if (data['synapses'] != null) {
        (data['synapses'] as Map).forEach((k, v) {
          synapses[int.parse(k)] = Synapse.fromJson(v);
        });
      }
      
      packages.clear();
      if (data['packages'] != null) {
        (data['packages'] as Map).forEach((k, v) {
          packages[int.parse(k)] = Package.fromJson(v);
        });
      }
      
      nextWordId = data['next_word_id'] ?? 1;
      nextFragmentId = data['next_fragment_id'] ?? 1;
      nextNeuronId = data['next_neuron_id'] ?? 1;
      nextSynapseId = data['next_synapse_id'] ?? 1;
      nextPackageId = data['next_package_id'] ?? 1;
      
      optimizeWordPositions();
      

      for (final word in words.entries){

        searchSystem.addVector("word_${word.key}", word.value.ratings);
      }
      
      
      for (final fragment in fragments.entries){
        final Map<int,double> fragmentVector = {};
        for(final wordId in fragment.value.wordIds){
          fragmentVector[wordId]=fragmentVector[wordId]?? 0+1;
        }
        searchSystem.addVector("fragment_${fragment.key}", fragmentVector);
      }
      
      for (final neuron in neurons.entries){

        searchSystem.addVector("neuron_${neuron.key}", neuron.value.signatureRatings);
      }


      
      print('Загружено: ${words.length} слов, ${fragments.length} фрагментов, ${neurons.length} нейронов');
    } catch (e) {
      print('Ошибка загрузки: $e');
    }
  }
}

// ========== ВСПОМОГАТЕЛЬНЫЕ КЛАССЫ ==========
class NavigationStep {
  final String type;
  final int? id;
  final String? query;
  final DateTime timestamp;
  
  NavigationStep({
    required this.type,
    this.id,
    this.query,
  }) : timestamp = DateTime.now();
  
  String get displayText {
    switch (type) {
      case 'word':
        return 'Слово #$id';
      case 'neuron':
        return 'Нейрон #$id';
      case 'fragment':
        return 'Фрагмент #$id';
      case 'search':
        return 'Поиск: $query';
      default:
        return 'Неизвестный шаг';
    }
  }
}

enum VisualizationMode {
  words,
  neurons,
  fragments
}
class _WordScore {
  final int wordId;
  final double intersectionScore;
  final double allRatingScore;
  final double combinedScore;
  
  _WordScore({
    required this.wordId,
    required this.intersectionScore,
    required this.allRatingScore,
    required this.combinedScore,
  });
}
class AnimationStage {
  final double duration;
  final VoidCallback action;
  
  AnimationStage({required this.duration, required this.action});
}

class Projected3D {
  final double dx;
  final double dy;
  final double depth;
  
  Projected3D({required this.dx, required this.dy, required this.depth});
}

// ========== ВИЗУАЛИЗАТОРЫ ==========
class InteractiveWordVisualization3D extends StatefulWidget {
  final OptimizedNeuralNetwork network;
  final Set<int> selectedWordIds;
  final Function(int, bool) onWordSelected;
  
  const InteractiveWordVisualization3D({
    Key? key,
    required this.network,
    required this.selectedWordIds,
    required this.onWordSelected,
  }) : super(key: key);
  
  @override
  _InteractiveWordVisualization3DState createState() => _InteractiveWordVisualization3DState();
}

class _InteractiveWordVisualization3DState extends State<InteractiveWordVisualization3D> {
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset? _lastLeftPanPosition;
  Offset? _lastRightPanPosition;
  bool _isRightMouseDown = false;
  int? _primaryButtonPointer;
  int? _secondaryButtonPointer;
  bool _shiftPressed = false;

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.shiftLeft || 
        event.logicalKey == LogicalKeyboardKey.shiftRight) {
      setState(() {
        _shiftPressed = event is RawKeyDownEvent;
      });
    } 
    
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          setState(() {
            _scale = (_scale * (1.0 + pointerSignal.scrollDelta.dy * -0.001))
                .clamp(0.1, 3.0);
          });
        }
      },
      onPointerDown: (event) {
        if (event.kind == PointerDeviceKind.mouse) {
          if (event.buttons == kPrimaryButton) {
            _primaryButtonPointer = event.pointer;
            _lastLeftPanPosition = event.position;
          } else if (event.buttons == kSecondaryButton) {
            _secondaryButtonPointer = event.pointer;
            _lastRightPanPosition = event.position;
            _isRightMouseDown = true;
          }
        } else {
          _primaryButtonPointer = event.pointer;
          _lastLeftPanPosition = event.position;
        }
      },
      onPointerMove: (event) {
        if (event.kind == PointerDeviceKind.mouse) {
          if (_primaryButtonPointer == event.pointer && _lastLeftPanPosition != null) {
            setState(() {
              final delta = event.position - _lastLeftPanPosition!;
              _rotationY += delta.dx * 0.01;
              _rotationX += delta.dy * 0.01;
              _lastLeftPanPosition = event.position;
            });
          } else if (_secondaryButtonPointer == event.pointer && _lastRightPanPosition != null) {
            setState(() {
              final delta = event.position - _lastRightPanPosition!;
              _offset += Offset(delta.dx, delta.dy);
              _lastRightPanPosition = event.position;
            });
          }
        } else if (_primaryButtonPointer == event.pointer && _lastLeftPanPosition != null) {
          setState(() {
            final delta = event.position - _lastLeftPanPosition!;
            _rotationY += delta.dx * 0.01;
            _rotationX += delta.dy * 0.01;
            _lastLeftPanPosition = event.position;
          });
        }
      },
      onPointerUp: (event) {
        if (_primaryButtonPointer == event.pointer) {
          _primaryButtonPointer = null;
          _lastLeftPanPosition = null;
        }
        if (_secondaryButtonPointer == event.pointer) {
          _secondaryButtonPointer = null;
          _lastRightPanPosition = null;
          _isRightMouseDown = false;
        }
      },
      onPointerCancel: (event) {
        if (_primaryButtonPointer == event.pointer) {
          _primaryButtonPointer = null;
          _lastLeftPanPosition = null;
        }
        if (_secondaryButtonPointer == event.pointer) {
          _secondaryButtonPointer = null;
          _lastRightPanPosition = null;
          _isRightMouseDown = false;
        }
      },
      child: MouseRegion(
        onHover: (event) {
          if (event.kind == PointerDeviceKind.mouse) {
            if (event.buttons == kPrimaryButton && _primaryButtonPointer == null) {
              _primaryButtonPointer = -1;
              _lastLeftPanPosition = event.position;
            } else if (event.buttons == kSecondaryButton && _secondaryButtonPointer == null) {
              _secondaryButtonPointer = -1;
              _lastRightPanPosition = event.position;
              _isRightMouseDown = true;
            }
          }
        },
        child: GestureDetector(
          onScaleUpdate: (details) {
            if (!_isRightMouseDown) {
              setState(() {
                _scale = (_scale * details.scale).clamp(0.1, 3.0);
              });
            }
          },
          onTapDown: (details) {
            final shiftPressed = _isShiftKeyPressed();
            _handleTap(details.localPosition, shiftPressed);
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: Word3DPainter(
              words: widget.network.getTopWords(150),
              wordLibrary: widget.network.wordLibrary,
              allWords: widget.network.words,
              rotationX: _rotationX,
              rotationY: _rotationY,
              scale: _scale,
              offset: _offset,
              selectedWordIds: widget.selectedWordIds,
              searchVector: widget.network.currentSearchVector,
              searchWords: widget.network.currentSearchWords,
            ),
          ),
        ),
      ),
    );
  }

  bool _isShiftKeyPressed() {
    return _shiftPressed;
  }

  void _handleTap(Offset position, bool shiftPressed) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final words = widget.network.getTopWords(150);
    final centerX = size.width / 2 + _offset.dx;
    final centerY = size.height / 2 + _offset.dy;
    
    int? clickedWordId;
    double minDistance = 30.0;
    
    for (final word in words) {
      final projected = _project3DTo2D(
        word.x - 500, word.y - 500, word.z - 500,
        centerX, centerY, _rotationX, _rotationY, _scale,
      );
      
      final distance = sqrt(
        pow(projected.dx - position.dx, 2) + 
        pow(projected.dy - position.dy, 2)
      );
      
      if (distance < minDistance) {
        minDistance = distance;
        clickedWordId = word.id;
      }
    }
    
    if (clickedWordId != null) {
      widget.onWordSelected(clickedWordId, shiftPressed);
    }
  }
  
  Offset _project3DTo2D(double x, double y, double z, double centerX, double centerY, 
                        double rotationX, double rotationY, double scale) {
    final cosY = cos(rotationY);
    final sinY = sin(rotationY);
    final cosX = cos(rotationX);
    final sinX = sin(rotationX);
    
    var x1 = x * cosY - z * sinY;
    var z1 = x * sinY + z * cosY;
    var y1 = y;
    
    final y2 = y1 * cosX - z1 * sinX;
    final z2 = y1 * sinX + z1 * cosX;
    
    final perspective = 1000 / (1000 + z2);
    final screenX = centerX + x1 * scale * perspective;
    final screenY = centerY + y2 * scale * perspective;
    
    return Offset(screenX, screenY);
  }
}

class Word3DPainter extends CustomPainter {
  final List<Word> words;
  final Map<int, String> wordLibrary;
  final Map<int, Word> allWords;
  final double rotationX;
  final double rotationY;
  final double scale;
  final Offset offset;
  final Set<int> selectedWordIds;
  final Map<int, int> searchVector;
  final List<int> searchWords;
  
  Word3DPainter({
    required this.words,
    required this.wordLibrary,
    required this.allWords,
    required this.rotationX,
    required this.rotationY,
    required this.scale,
    required this.offset,
    required this.selectedWordIds,
    required this.searchVector,
    required this.searchWords,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (words.isEmpty) return;
    
    final centerX = size.width / 2 + offset.dx;
    final centerY = size.height / 2 + offset.dy;
    
    final projectedWords = <_ProjectedWord>[];
    
    for (final word in words) {
      final pos = _project3DTo2D(
        word.x - 500, word.y - 500, word.z - 500,
        centerX, centerY,
      );
      
      projectedWords.add(_ProjectedWord(
        word: word,
        screenX: pos.dx,
        screenY: pos.dy,
        depth: pos.depth,
      ));
    }
    
    projectedWords.sort((a, b) => a.depth.compareTo(b.depth));
    
    final selectedWords = selectedWordIds.map((id) => allWords[id]).whereType<Word>().toList();
    final connectedWordIds = <int>{};
    
    for (final selectedWord in selectedWords) {
      connectedWordIds.addAll(selectedWord.ratings.keys);
    }
    
    final searchVectorWords = searchVector.keys.toSet();
    final commonSearchWords = <int>{};
    
    if (searchWords.isNotEmpty) {
      for (final wordId in searchVectorWords) {
        if (searchWords.contains(wordId)) {
          commonSearchWords.add(wordId);
        }
      }
    }
    
    for (final projWord in projectedWords) {
      if (selectedWordIds.contains(projWord.word.id)) {
        _drawConnections(canvas, projWord, projectedWords, true, Colors.amber);
      }
    }
    
    for (final projWord in projectedWords) {
      if (searchWords.contains(projWord.word.id) && !selectedWordIds.contains(projWord.word.id)) {
        _drawConnections(canvas, projWord, projectedWords, false, Colors.green);
      }
    }
    
    for (final projWord in projectedWords) {
      final isSelected = selectedWordIds.contains(projWord.word.id);
      final isConnected = connectedWordIds.contains(projWord.word.id);
      final isInSearch = searchVectorWords.contains(projWord.word.id);
      final isCommonSearch = commonSearchWords.contains(projWord.word.id);
       _drawConnections(canvas, projWord, projectedWords, false, Colors.purple.withOpacity(0.69));
      double opacity = 1.0;
      if (selectedWordIds.isNotEmpty && !isSelected && !isConnected) {
        opacity = 0.3;
      }
      
      if (searchVectorWords.isNotEmpty && !isInSearch && selectedWordIds.isEmpty) {
        opacity = 0.2;
      }
      
      Color textColor;
      if (isSelected) {
        textColor = Color(0xFFFFD700);
      } else if (isCommonSearch) {
        textColor = Color(0xFF00FF7F);
      } else if (isInSearch) {
        textColor = Colors.lightGreen;
      } else if (isConnected && selectedWords.isNotEmpty) {
        double maxConnectionStrength = 0.0;
        for (final selectedWord in selectedWords) {
          final rating = selectedWord.ratings[projWord.word.id] ?? 0;
          if (rating > 0) {
            final maxRating = selectedWord.ratings.values.reduce((a, b) => a > b ? a : b);
            final strength = rating / maxRating.toDouble();
            maxConnectionStrength = max(maxConnectionStrength, strength);
          }
        }
        
        final baseColor = _getColorFromText(wordLibrary[projWord.word.id] ?? '');
        textColor = Color.lerp(baseColor, Colors.white, maxConnectionStrength * 0.7)!;
      } else {
        textColor = _getColorFromText(wordLibrary[projWord.word.id] ?? '');
      }
      
      _drawWord(canvas, projWord, opacity, textColor);
    }
  }
  
  void _drawConnections(Canvas canvas, _ProjectedWord projWord, List<_ProjectedWord> allProjected, bool isSelected, Color baseColor) {
    final word = projWord.word;
    if (word.ratings.isEmpty) return;
    bool isUsualConnect = (baseColor ==  Colors.purple.withOpacity(0.69));
    final sortedConnections = word.ratings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final connectionsToProcess = sortedConnections.take(isSelected ? 10 : 5).toList();
    
    for (final entry in connectionsToProcess) {
      final otherWord = allWords[entry.key];
      if (otherWord == null) continue;
      
      final otherProj = allProjected.firstWhere(
        (p) => p.word.id == entry.key,
        orElse: () => _ProjectedWord(word: otherWord, screenX: projWord.screenX, screenY: projWord.screenY, depth: 0),
      );
      
      final maxRating = word.ratings.values.reduce((a, b) => a > b ? a : b);
      final normalizedRating = entry.value / maxRating.toDouble();
      
      double opacity = isSelected ? (normalizedRating * 0.8).clamp(0.3, 0.9) : 0.2;
      double strokeWidth = isSelected ? (normalizedRating * 4 + 1.0).clamp(1.0, 3.0) : 1.0;
      
      final connectionColor = isSelected ? 
          Color.lerp(baseColor.withOpacity(0.5), baseColor, normalizedRating)! :
          baseColor.withOpacity(opacity);
      
      final paint = Paint()
        ..color = connectionColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      
      canvas.drawLine(
        Offset(projWord.screenX, projWord.screenY),
        Offset(otherProj.screenX, otherProj.screenY),
        paint,
      );
      
      if (isSelected && normalizedRating > 0.3) {
        final dotPaint = Paint()
          ..color = baseColor.withOpacity(normalizedRating * 0.8)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(
          Offset(otherProj.screenX, otherProj.screenY),
          1 * strokeWidth,
          dotPaint,
        );
      }
    }
  }
  
  void _drawWord(Canvas canvas, _ProjectedWord projWord, double opacity, Color color) {
    final wordText = wordLibrary[projWord.word.id] ?? 'unknown';
    final scaleFactor = projWord.word.allRating / (words.isNotEmpty ? words[0].allRating : 1);
    final baseSize = 12.0 * scale;
    final fontSize = baseSize + scaleFactor * 6 * scale;
    
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(opacity * 0.7)
      ..style = PaintingStyle.fill;
    
    final textSpan = TextSpan(
      text: wordText,
      style: TextStyle(
        color: color.withOpacity(opacity),
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 3.0,
            color: Colors.black.withOpacity(opacity * 0.8),
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
    );
    
    textPainter.layout();
    
    final textOffset = Offset(
      projWord.screenX - textPainter.width / 2,
      projWord.screenY - textPainter.height / 2,
    );
    
    final backgroundRect = Rect.fromCenter(
      center: Offset(projWord.screenX, projWord.screenY),
      width: textPainter.width + 8,
      height: textPainter.height + 4,
    );
    
    canvas.drawRect(backgroundRect, backgroundPaint);
    
    textPainter.paint(canvas, textOffset);
    
    if (selectedWordIds.contains(projWord.word.id)) {
      final highlightPaint = Paint()
        ..color = Colors.yellow.withOpacity(0.3)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      
      canvas.drawCircle(
        Offset(projWord.screenX, projWord.screenY),
        textPainter.width / 2 + 6,
        highlightPaint,
      );
    }
  }
  
  _Projected3D _project3DTo2D(double x, double y, double z, double centerX, double centerY) {
    final cosY = cos(rotationY);
    final sinY = sin(rotationY);
    final cosX = cos(rotationX);
    final sinX = sin(rotationX);
    
    var x1 = x * cosY - z * sinY;
    var z1 = x * sinY + z * cosY;
    var y1 = y;
    
    final y2 = y1 * cosX - z1 * sinX;
    final z2 = y1 * sinX + z1 * cosX;
    
    final perspective = 1000 / (1000 + z2);
    final screenX = centerX + x1 * scale * perspective;
    final screenY = centerY + y2 * scale * perspective;
    
    return _Projected3D(dx: screenX, dy: screenY, depth: z2);
  }
  
  Color _getColorFromText(String text) {
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    int r = ((hash & 0xFF0000) >> 16);
    int g = ((hash & 0x00FF00) >> 8);
    int b = (hash & 0x0000FF);
    
    r = (r * 1.4).toInt().clamp(0, 255);
    g = (g * 1.4).toInt().clamp(0, 255);
    b = (b * 1.4).toInt().clamp(0, 255);
    
    return Color.fromRGBO(r, g, b, 1.0);
  }
  
  @override
  bool shouldRepaint(Word3DPainter oldDelegate) {
    return oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.scale != scale ||
        oldDelegate.offset != offset ||
        oldDelegate.selectedWordIds.length != selectedWordIds.length ||
        oldDelegate.searchVector.length != searchVector.length;
  }
}

class _ProjectedWord {
  final Word word;
  final double screenX;
  final double screenY;
  final double depth;
  
  _ProjectedWord({required this.word, required this.screenX, required this.screenY, required this.depth});
}

class _Projected3D {
  final double dx;
  final double dy;
  final double depth;
  
  _Projected3D({required this.dx, required this.dy, required this.depth});
}

// ========== ОСНОВНОЕ ПРИЛОЖЕНИЕ ==========
class NeuralNetworkApp extends StatefulWidget {
  @override
  _NeuralNetworkAppState createState() => _NeuralNetworkAppState();
}

class _NeuralNetworkAppState extends State<NeuralNetworkApp> {
  final OptimizedNeuralNetwork network = OptimizedNeuralNetwork();
  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<ChatMessage1> _messages = [];
  bool _isProcessing = false;
  bool _shiftPressed = false;
  bool _ctrlPressed = false;
    int _selectedTab = 0;
  @override
  void initState() {
    super.initState();
    _loadNetwork();
    RawKeyboard.instance.addListener(_handleKeyEvent);
    
    
  }
  
  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }
  
  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.shiftLeft || 
        event.logicalKey == LogicalKeyboardKey.shiftRight) {
      setState(() {
        _shiftPressed = event is RawKeyDownEvent;
      });
    } else if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
               event.logicalKey == LogicalKeyboardKey.controlRight) {
      setState(() {
        _ctrlPressed = event is RawKeyDownEvent;
      });
    }
    
    if (event is RawKeyDownEvent) {
      if (_ctrlPressed) {
        if (event.logicalKey == LogicalKeyboardKey.keyZ) {
          if (_shiftPressed) {
            network.redo();
          } else {
            network.undo();
          }
          setState(() {});
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          network.navigateToNextSearchedNeuron();
          setState(() {});
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          network.navigateToPreviousSearchedNeuron();
          setState(() {});
        }
      }
    }
  }

  Future<void> _loadNetwork() async {
    await network.loadFromFile();
    await network.updateClusters();
    _addMessage('Система загружена: ${network.words.length} слов, ${network.neurons.length} нейронов', isSystem: true);
  }
  
  void _addMessage(String text, {bool isSystem = false}) {
    setState(() {
      _messages.add(ChatMessage1(
        text: text,
        isSystem: isSystem,
        timestamp: DateTime.now(),
      ));
    });
  }
 Future<void> _trainFromRange(String command) async {
  try {
    final parts = command.split(' ');
    if (parts.length < 5 || parts[0] != '--train' || parts[1] != 'from' || parts[3] != 'to') {
      _addMessage('Invalid command format. Use: --train from START_URL to END_URL', isSystem: true);
      return;
    }
    
    final startUrl = parts[2];
    final endUrl = parts[4];
    
    // Находим числовую разницу между URL
    final result = _findNumericDifference(startUrl, endUrl);
    
    if (result == null) {
      _addMessage('Could not find numeric difference between URLs', isSystem: true);
      return;
    }
    
    final (baseUrl, startNumber, endNumber, formatNumber) = result;
    
    if (startNumber >= endNumber) {
      _addMessage('Start number must be less than end number', isSystem: true);
      return;
    }
    
    final total = endNumber - startNumber + 1;
    _addMessage('Training: from $startNumber to $endNumber ($total URLs)', isSystem: true);
    
    int processed = 0;
    
    for (int i = startNumber; i <= endNumber; i++) {
      final formattedNumber = formatNumber(i);
      final currentUrl = baseUrl.replaceFirst('{NUM}', formattedNumber.toString());
      
      _addMessage('[$processed/$total] Processing: $currentUrl', isSystem: true);
      
      try {
        await network.processWebsite(currentUrl, (progress) {
          _addMessage('  $progress', isSystem: true);
        });
        processed++;
        
        await Future.delayed(Duration(milliseconds: 500));
        
      } catch (e) {
        _addMessage('  Failed: $e', isSystem: true);
      }
    }
    
    _addMessage('Completed! Processed $processed/$total URLs', isSystem: true);
    setState(() {});
    
  } catch (e) {
    _addMessage('Error: $e', isSystem: true);
  }
}

(String, int, int, String Function(int))? _findNumericDifference(String startUrl, String endUrl) {
  // Ищем все числовые последовательности в URL
  final startNumbers = _extractAllNumbers(startUrl);
  final endNumbers = _extractAllNumbers(endUrl);
  
  if (startNumbers.isEmpty || endNumbers.isEmpty) {
    return null;
  }
  
  // Ищем первую пару чисел, которые отличаются
  for (int i = 0; i < min(startNumbers.length, endNumbers.length); i++) {
    final startNum = startNumbers[i];
    final endNum = endNumbers[i];
    
    if (startNum.value != endNum.value) {
      // Нашли различающиеся числа
      final startNumber = startNum.value;
      final endNumber = endNum.value;
      
      // Создаем базовый URL с плейсхолдером
      final baseUrl = startUrl.replaceFirst(startNum.match, '{NUM}');
      
      // Функция для форматирования числа (сохраняет ведущие нули если есть)
      String formatNumber(int num) {
        if (startNum.match.length > endNum.match.length) {
          // Сохраняем форматирование из startUrl
          return num.toString().padLeft(startNum.match.length, '0');
        } else if (endNum.match.length > startNum.match.length) {
          // Сохраняем форматирование из endUrl
          return num.toString().padLeft(endNum.match.length, '0');
        }
        return num.toString();
      }
      
      return (baseUrl, startNumber, endNumber, formatNumber);
    }
  }
  
  return null;
}

List<NumberMatch> _extractAllNumbers(String url) {
  final matches = <NumberMatch>[];
  final regex = RegExp(r'\d+');
  final allMatches = regex.allMatches(url);
  
  for (final match in allMatches) {
    final number = int.tryParse(match.group(0)!);
    if (number != null) {
      matches.add(NumberMatch(
        value: number,
        match: match.group(0)!,
        start: match.start,
        end: match.end,
      ));
    }
  }
  
  return matches;
}


int? _extractNumberFromUrl(String url) {
  // Ищем последовательность цифр в URL
  final regex = RegExp(r'/(\d+)(?:\?|$|/)');
  final match = regex.firstMatch(url);
  
  if (match != null) {
    return int.tryParse(match.group(1)!);
  }
  
  return null;
}

String _replaceNumberInUrl(String url, int newNumber) {
  // Заменяем число в URL на новое
  return url.replaceAllMapped(
    RegExp(r'/(\d+)(?:\?|$|/)'),
    (match) => '/$newNumber${match.group(2) ?? ''}'
  );
}
Future<void> testHash(String text) async {
  // Поиск похожих
  final Map<int, double> myQueryVector = {};
  final splitter = text.trim().split(" ");
  
  for (final word in splitter) {
    final wordElement = network.wordIndex[word]; // Добавил network.
    if (wordElement != null) {
      final wordObject = network.words[wordElement]; // Добавил network.
      if (wordObject != null) {
        final vector = wordObject.ratings;
        for (final element in vector.entries) { // Исправил 'element' на 'final element'
          myQueryVector[element.key] = (myQueryVector[element.key] ?? 0) + 
                                      (element.value / wordObject.allRating);
        }
      }
    }
  }
  
  final similarDocs = network.searchSystem.findSimilarVectors(myQueryVector); // Добавил network.
  List<String> all_elements = [];
  
  for (final message in similarDocs) {
    if (message.startsWith("word_")) {
      final number = int.tryParse(message.substring(5));
      if (number != null) {
        final word = network.wordLibrary[number]; // Добавил network.
        if (word != null) all_elements.add(word);
      }
    } else if (message.startsWith("fragment_")) {
      final number = int.tryParse(message.substring(9));
      if (number != null) {
        final fragment = network.fragments[number]; // Добавил network.
        if (fragment != null) all_elements.add(fragment.text);
      }
    } else if (message.startsWith("neuron_")) {
      final number = int.tryParse(message.substring(7));
      if (number != null) {
        final neuron = network.neurons[number]; // Исправил wordLibrary на neurons
        if (neuron?.pageTitle != null) all_elements.add(neuron!.pageTitle!);
      }
    }
  }

  _addMessage("Some answer done ${all_elements.take(100).join(', ')}"); // Исправил скобку
}
  Future<void> _handleMessage(String text) async {
    if (text.isEmpty) return;
    
    _addMessage(text);
    _chatController.clear();
    setState(() => _isProcessing = true);
    
    try {
      if (text.startsWith("search: ")){
        await testHash(text.substring(7,text.length));
      
      }else
      if (text.startsWith("--train ")){
        await _trainFromRange(text);
      
      }else
      if (text.startsWith("http://") || text.startsWith("https://")) {
        await network.processWebsite(text, (progress) {
          _addMessage(progress, isSystem: true);
        });
        setState(() {});
      } else if (text == '/train') {
        await network.trainTest((progress) {
          _addMessage(progress, isSystem: true);
        });
        setState(() {});
      } else if (text == '/train2') {
        await network.trainTest2((progress) {
          _addMessage(progress, isSystem: true);
        });
        setState(() {});
      }else if (text == '/optimize') {
        network.optimizeWordPositions();
        _addMessage('Позиции слов оптимизированы', isSystem: true);
        setState(() {});
      } else if (text == '/optimizeNeuralConnectionsRebuildWeights') {
        VectorOperations.optimizeNeuralConnectionsRebuildWeights(network.words);
        _addMessage('Нейронные связи оптимизированы', isSystem: true);
        setState(() {});
      } else {
        final result = await network.processQueryAdvanced(text);
        
        if (result['line1'].toString().isNotEmpty) {
          _addMessage('Ключевые слова: ${result['line1']}', isSystem: true);
        }
        
        if (result['line2'].toString().isNotEmpty) {
          _addMessage('Контекст: ${result['line2']}', isSystem: true);
        }
        if (result['line3'].toString().isNotEmpty) {
          _addMessage('Контекст: ${result['line3']}', isSystem: true);
        }
      
        if (result['line5'].toString().isNotEmpty) {
          _addMessage('Entropy Increase: ${result['line5']}', isSystem: true);
         
        }
         if (result['line6'].toString().isNotEmpty) {
          _addMessage('Entropy descrease: ${result['line6']}', isSystem: true);
        }
         if (result['line7'].toString().isNotEmpty) {
          _addMessage('Entropy descrease: ${result['line7']}', isSystem: true);
        }
        final fragments = result['fragments'] as List<String>;
        if (fragments.isNotEmpty) {
          _addMessage('Найдено ${fragments.length} релевантных фрагментов', isSystem: true);
          for (int i = 0; i < min(5, fragments.length); i++) {
            _addMessage(fragments[i]);
          }
        }
        
        setState(() {});
      }
    } catch (e) {
      _addMessage('Ошибка: $e', isSystem: true);
    }
    
    setState(() => _isProcessing = false);
  }
  
  void _handleSearchUpdate(String text) {
    if (text.isEmpty) {
      setState(() {
        network.currentSearchVector.clear();
        network.currentSearchWords.clear();
      });
      return;
    }
    
    switch (network.visualizationMode) {
      case VisualizationMode.words:
        _handleWordSearch(text);
        break;
      case VisualizationMode.neurons:
        _handleNeuronSearch(text);
        break;
      case VisualizationMode.fragments:
        _handleFragmentSearch(text);
        break;
    }
  }
  
  void _handleWordSearch(String text) {
    final wordTexts = network._extractWords(text);
    final promptWordIds = wordTexts
        .map((w) => network.wordIndex[w])
        .where((id) => id != null)
        .cast<int>()
        .toList();
    
    if (promptWordIds.isEmpty) return;
    
    final superVector = <int, int>{};
    for (final wordId in promptWordIds) {
      final word = network.words[wordId];
      if (word != null) {
        for (final entry in word.ratings.entries) {
          superVector[entry.key] = (superVector[entry.key] ?? 0) + entry.value;
        }
      }
    }
    
    final projectedVector = VectorOperations.selfProjection(superVector, network.words);
    
    setState(() {
      network.currentSearchVector = projectedVector;
      network.currentSearchWords = promptWordIds;
    });
  }
  
  void _handleNeuronSearch(String text) {
    final foundNeurons = network.searchNeuronsByKeywords(text);
    setState(() {
      network.selectedNeuronIds = foundNeurons.take(10).map((n) => n.id).toSet();
    });
  }
  
  void _handleFragmentSearch(String text) {
    final foundFragments = network.searchFragments(text);
    setState(() {
      network.selectedFragmentIds = foundFragments.take(10).map((f) => f.id).toSet();
    });
  }
  
  void _handleWordSelected(int wordId, bool withShift) {
    setState(() {
      network.selectWord(wordId, withShift: withShift || _shiftPressed);
    });
  }
  
  void _handleNeuronSelected(int neuronId, bool withShift) {
    setState(() {
      network.selectNeuron(neuronId, withShift: withShift || _shiftPressed);
    });
  }

  void _handleFragmentSelected(int fragmentId, bool withShift) {
    setState(() {
      network.selectFragment(fragmentId, withShift: withShift || _shiftPressed);
      
      if (network.selectedFragmentIds.isNotEmpty) {
        final allFragmentWordIds = <int>{};
        for (final selectedFragmentId in network.selectedFragmentIds) {
          final fragment = network.fragments[selectedFragmentId];
          if (fragment != null) {
            allFragmentWordIds.addAll(fragment.wordIds);
          }
        }
        network.selectedWordIds = allFragmentWordIds;
      }
    });
  }

  void _handleClusterTapped(String clusterId) {
    network.toggleClusterExpansion(clusterId);
    setState(() {});
  }

  void _changeVisualizationMode(VisualizationMode mode) {
    setState(() {
      network.visualizationMode = mode;
      _searchController.clear();
      network.currentSearchVector.clear();
      network.currentSearchWords.clear();
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          // Компактная навигация - 30% ширины экрана
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavButton(Icons.chat, 'Чат', 0),
                _buildNavButton(Icons.auto_awesome, '3D', 1),
                _buildNavButton(Icons.book, 'Словарь', 2),
                _buildNavButton(Icons.layers, 'Мета', 3),
              ],
            ),
          ),
          Spacer(),
          Text('Advanced Neural Network System'),
          Spacer(),
          // Действия справа
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.save, size: 20),
                onPressed: () => network.saveToFile(),
                tooltip: 'Сохранить',
              ),
              IconButton(
                icon: Icon(Icons.auto_awesome, size: 20),
                onPressed: () {
                  network.optimizeWordPositions();
                  _addMessage('Оптимизация запущена', isSystem: true);
                  setState(() {});
                },
                tooltip: 'Оптимизировать',
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple,
    ),
    body: _buildCurrentView(),
  );
}

Widget _buildNavButton(IconData icon, String label, int tabIndex) {
  final isSelected = _selectedTab == tabIndex;
  
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedTab = tabIndex;
      });
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.white70,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}


Widget _buildCurrentView() {
  return Row(
    children: [
      // Основное содержимое - 2/3 экрана
      Expanded(
        flex: 2,
        child: _buildMainContent(),
      ),
      
      // Детальная панель - 1/3 экрана (только если есть выбранные элементы)
      if (_hasSelection())
        Container(
          width: MediaQuery.of(context).size.width * 0.33,
          child: _buildDetailsPanel(),
        ),
    ],
  );
}

Widget _buildMainContent() {
  switch (_selectedTab) {
    case 0: // Чат
      return _buildChatPanel();
    case 1: // 3D Визуализация
      return _buildVisualizationPanel();
    case 2: // Словарь
      return DictionaryViewer(network: network);
    case 3: // Мета-объект
      return MetaObjectVisualizer(
       
      );
    default:
      return _buildChatPanel();
  }
}

bool _hasSelection() {
  return network.selectedWordIds.isNotEmpty || 
         network.selectedNeuronIds.isNotEmpty || 
         network.selectedFragmentIds.isNotEmpty;
}

  
  Widget _buildChatPanel() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(Icons.chat, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text('Нейро-чат', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Spacer(),
                if (_isProcessing)
                  Row(
                    children: [
                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 8),
                      Text('${network.words.length} слов', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ChatBubble(
                  message: message,
                  onWordTap: (word) {
                    _searchController.text = word;
                    _handleSearchUpdate(word);
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'URL, /neurons, /optimize или запрос...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _handleMessage,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleMessage(_chatController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizationPanel() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      _getVisualizationTitle(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _getSearchHint(),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: _handleSearchUpdate,
                ),
                if (network.navigationHistory.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Container(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: network.navigationHistory.length,
                      itemBuilder: (context, index) {
                        final step = network.navigationHistory[index];
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(
                              step.displayText,
                              style: TextStyle(fontSize: 9),
                            ),
                            onPressed: () => network.navigateToStep(index),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: OverflowBox(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              child: ClipRect(
                child: _buildVisualization(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 1.0),
              ),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVisualizationButton('Слова', Icons.text_fields, VisualizationMode.words),
                _buildVisualizationButton('Нейроны', Icons.hub, VisualizationMode.neurons),
                _buildVisualizationButton('Фрагменты', Icons.article, VisualizationMode.fragments),
                _buildStatItem('Слова', network.words.length.toString()),
                _buildStatItem('Фрагменты', network.fragments.length.toString()),
                _buildStatItem('Нейроны', network.neurons.length.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualization() {
    switch (network.visualizationMode) {
      case VisualizationMode.words:
        return InteractiveWordVisualization3D(
          network: network,
          selectedWordIds: network.selectedWordIds,
          onWordSelected: _handleWordSelected,
        );
      case VisualizationMode.neurons:
        return AdvancedNeuron3DVisualization(
          network: network,
          selectedNeuronIds: network.selectedNeuronIds,
          onNeuronSelected: _handleNeuronSelected,
          onClusterTapped: _handleClusterTapped,
          sendMessage: _addMessage,
        );
      case VisualizationMode.fragments:
         return FragmentTextViewer(
        network: network,
        selectedFragmentIds: network.selectedFragmentIds,
        onFragmentSelected: _handleFragmentSelected,
        neuronIds: network.selectedNeuronIds.isNotEmpty ? 
            network.selectedNeuronIds : null,
      );
    }
  }
  
  Widget _buildVisualizationButton(String label, IconData icon, VisualizationMode mode) {
    return GestureDetector(
      onTap: () => _changeVisualizationMode(mode),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: network.visualizationMode == mode ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailsPanel() {
    if (network.selectedWordIds.isNotEmpty) {
      return _buildWordDetailsPanel();
    } else if (network.selectedNeuronIds.isNotEmpty) {
      return _buildNeuronDetailsPanel();
    } else if (network.selectedFragmentIds.isNotEmpty) {
      return _buildFragmentDetailsPanel();
    }
    return SizedBox.shrink();
  }

 
Widget _buildWordDetailsPanel() {
  final wordId = network.selectedWordIds.isNotEmpty ? network.selectedWordIds.first : null;
  if (wordId == null) return SizedBox.shrink();
  
  final word = network.words[wordId];
  if (word == null) return SizedBox.shrink();
  
  final wordText = network.wordLibrary[wordId] ?? 'Unknown';
  
  return Container(
    width: MediaQuery.of(context).size.width * 0.3,
    height: MediaQuery.of(context).size.height,
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.orange),
      borderRadius: BorderRadius.circular(8),
      color: Colors.black.withOpacity(0.9),
    ),
    child: DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.label, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          wordText,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () => network.clearSelection(),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.orange,
                  tabs: [
                    Tab(text: 'Connections'),
                    Tab(text: 'Fragments'),
                    Tab(text: 'Composite'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildConnectionsTab(word),
                _buildFragmentsTab(word),
                _buildCompositeTab(word),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildFragmentsTab(Word word) {
 final allFragments = network.fragments.values
      .where((f) => f.wordIds.contains(word.id))
      .take(100) // Берем только первые 100 фрагментов
      .toList();
  return Column(
    children: [
      // Кнопка сохранения выделенных фрагментов
      if (network.selectedFragmentIds.isNotEmpty)
        Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.save, size: 16),
                  label: Text('Сохранить выделенные (${network.selectedFragmentIds.length})'),
                  onPressed: () async {
                    await network.saveSelectedFragmentsToFile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Фрагменты сохранены в файл и буфер обмена')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: allFragments.length,
          itemBuilder: (context, index) {
            final frag = allFragments[index];
            final isSelected = network.selectedFragmentIds.contains(frag.id);
            
            return Card(
              color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.grey[850],
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  frag.text,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: [
                        Chip(
                          label: Text(frag.semanticType),
                          backgroundColor: Colors.blue,
                          labelStyle: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        if (frag.neuronIds.isNotEmpty)
                          Chip(
                            label: Text('${frag.neuronIds.length} нейронов'),
                            backgroundColor: Colors.purple,
                            labelStyle: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Кнопка перехода к нейрону
                    if (frag.neuronIds.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.hub, size: 16, color: Colors.purple),
                        onPressed: () {
                          network.navigateToNeuronFromFragment(frag.id);
                          setState(() {});
                        },
                        tooltip: 'Перейти к нейрону',
                      ),
                    // Индикатор выделения
                    if (isSelected) 
                      Icon(Icons.check_circle, color: Colors.blue, size: 20),
                  ],
                ),
                onTap: () {
                  setState(() {
                    if (_shiftPressed) {
                      if (isSelected) {
                        network.selectedFragmentIds.remove(frag.id);
                      } else {
                        network.selectedFragmentIds.add(frag.id);
                      }
                    } else {
                      network.selectedFragmentIds = {frag.id};
                    }
                  });
                },
              ),
            );
          },
        ),
      ),
    ],
  );
}

  Widget _buildConnectionsTab(Word word) {
      final connections = word.ratings.entries.toList();
      connections.sort((a, b) => b.value.compareTo(a.value));

      final topWords = connections.take(40).map((e) => e.key).toList();
      final bottomWords = connections.reversed.take(20).map((e) => e.key).toList();
      final listToShow = [...topWords, ...bottomWords];

    //votsuda 
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: min(listToShow.length, 50),
      itemBuilder: (context, index) {
        final conn = connections[index];
        final connWord = network.wordLibrary[conn.key] ?? 'Unknown';
        
        return Card(
          color: Colors.grey[850],
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text('${index + 1}', style: TextStyle(fontSize: 10)),
            ),
            title: Text(connWord, style: TextStyle(color: Colors.white)),
            trailing: Chip(
              label: Text('${conn.value}'),
              backgroundColor: Colors.orange,
            ),
            onTap: () => _handleWordSelected(conn.key, _shiftPressed),
          ),
        );
      },
    );
  }


  Widget _buildCompositeTab(Word word) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Text('Выделенные слова: ${network.selectedWordIds.length}', 
                      style: TextStyle(color: Colors.white)),
                  Spacer(),
                  if (network.selectedWordIds.length > 1)
                    ElevatedButton.icon(
                      icon: Icon(Icons.search, size: 16),
                      label: Text('Поиск по словам'),
                      onPressed: _searchWithSelectedWords,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _buildCompositeSearchResults(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompositeSearchResults() {
    if (network.selectedWordIds.length < 2) {
      return Center(
        child: Text('Выделите несколько слов (Shift+Click)', 
            style: TextStyle(color: Colors.white70)),
      );
    }
    
    final fragments = network.findFragmentsWithAllWords(network.selectedWordIds);
    final compositeVector = network.getCompositeVector(network.selectedWordIds);
    
    final uniqueFragments = _removeDuplicateFragments(fragments);
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('Композитный вектор: ${compositeVector.length} связей\n'
                      'Уникальных фрагментов: ${uniqueFragments.length}',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: uniqueFragments.length,
            itemBuilder: (context, index) {
              final fragment = uniqueFragments[index];
              final isSelected = network.selectedFragmentIds.contains(fragment.id);
              
              return Card(
                color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.grey[850],
                margin: EdgeInsets.all(4),
                child: ListTile(
                  title: Text(
                    fragment.text,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  trailing: isSelected ? Icon(Icons.check_circle, color: Colors.blue) : null,
                  onTap: () {
                    setState(() {
                      if (_shiftPressed) {
                        if (isSelected) {
                          network.selectedFragmentIds.remove(fragment.id);
                        } else {
                          network.selectedFragmentIds.add(fragment.id);
                        }
                      } else {
                        network.selectedFragmentIds = {fragment.id};
                      }
                      
                      _highlightWordsInFragment(fragment);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Fragment> _removeDuplicateFragments(List<Fragment> fragments) {
    final seenTexts = <String>{};
    final uniqueFragments = <Fragment>[];
    
    for (final fragment in fragments) {
      final normalizedText = fragment.text.trim().toLowerCase();
      if (!seenTexts.contains(normalizedText)) {
        seenTexts.add(normalizedText);
        uniqueFragments.add(fragment);
      }
    }
    
    return uniqueFragments;
  }

  void _highlightWordsInFragment(Fragment fragment) {
    final fragmentWordIds = fragment.wordIds.toSet();
    setState(() {
      network.selectedWordIds = fragmentWordIds;
    });
  }

  void _searchWithSelectedWords() {
    if (network.selectedWordIds.length < 2) return;
    
    final compositeVector = network.getCompositeVector(network.selectedWordIds);
    final fragments = network.findFragmentsWithAllWords(network.selectedWordIds);
    
    setState(() {
      network.currentSearchVector = compositeVector;
    });
    
    _addMessage('Найдено ${fragments.length} фрагментов с выделенными словами', isSystem: true);
  }
Widget _buildNeuronDetailsPanel() {
  return Container(
    width: MediaQuery.of(context).size.width * 0.3,
    height: MediaQuery.of(context).size.height,
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.purple),
      borderRadius: BorderRadius.circular(8),
      color: Colors.black.withOpacity(0.9),
    ),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            children: [
              Icon(Icons.hub, color: Colors.purple),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${network.selectedNeuronIds.length} нейронов выбрано',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => network.clearSelection(),
              ),
            ],
          ),
        ),
        
        // НОВЫЕ КНОПКИ ДЛЯ НЕЙРОНОВ
        if (network.selectedNeuronIds.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Кнопка "Составить карту"
                ElevatedButton.icon(
                  icon: Icon(Icons.auto_awesome),
                  label: Text('Составить карту'),
                  onPressed: () {
                    final wordMap = network.createWordMapFromSelectedNeurons();
                    // Переключаемся в режим слов и устанавливаем поисковый вектор
                    network.visualizationMode = VisualizationMode.words;
                    network.currentSearchVector = wordMap.map((k, v) => MapEntry(k, v.round()));
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                
                // Кнопка "Перейти на сайт" (только для одного выделенного нейрона)
                if (network.selectedNeuronIds.length == 1)
                  ElevatedButton.icon(
                    icon: Icon(Icons.open_in_browser),
                    label: Text('Перейти на сайт'),
                    onPressed: () {
                      final neuronId = network.selectedNeuronIds.first;
                      network.openNeuronUrl(neuronId);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                
                // Существующие кнопки
                if (network.selectedNeuronIds.length >= 2) ...[
                  ElevatedButton.icon(
                    icon: Icon(Icons.merge),
                    label: Text('New Neuron'),
                    onPressed: _mergeSelectedNeurons,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.link),
                    label: Text('Process'),
                    onPressed: _processSelectedNeurons,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ],
                ElevatedButton.icon(
                  icon: Icon(Icons.article),
                  label: Text('Show Fragments'),
                  onPressed: _createFragmentVisualizationFromNeurons,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.content_copy),
                  label: Text('Copy'),
                  onPressed: _copySelectedNeuronsToClipboard,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.auto_awesome),
                  label: Text('Show Words'),
                  onPressed: _createWordsVisualizationFromNeurons,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                ),
              ],
            ),
          ),
        ],
        
        Expanded(
          child: _buildNeuronFragmentsList(),
        ),
      ],
    ),
  );
}
  void _createFragmentVisualizationFromNeurons() {
    if (network.selectedNeuronIds.isEmpty) return;
    
    setState(() {
      network.visualizationMode = VisualizationMode.fragments;
    });
    
    _addMessage('Создана визуализация фрагментов для ${network.selectedNeuronIds.length} нейронов', isSystem: true);
  }

  Future<void> _mergeSelectedNeurons() async {
    if (network.selectedNeuronIds.length < 2) return;
    
    final newNeuron = await network.mergeNeurons(network.selectedNeuronIds);
    _addMessage('Создан объединенный нейрон #${newNeuron.id} из ${network.selectedNeuronIds.length} нейронов', isSystem: true);
    
    setState(() {
      network.selectedNeuronIds = {newNeuron.id};
    });
  }

  Future<void> _processSelectedNeurons() async {
    if (network.selectedNeuronIds.length < 2) return;
    
    await network.processNeuronConnections(network.selectedNeuronIds);
    _addMessage('Обработано ${network.selectedNeuronIds.length} нейронов, связи усилены', isSystem: true);
    setState(() {});
  }

  Future<void> _copySelectedNeuronsToClipboard() async {
    if (network.selectedNeuronIds.isEmpty) return;
    
    await network.copyNeuronsToClipboard(network.selectedNeuronIds);
    _addMessage('Текст ${network.selectedNeuronIds.length} нейронов скопирован в буфер', isSystem: true);
  }

  Future<void> _copySelectedFragmentsToClipboard() async {
    if (network.selectedFragmentIds.isEmpty) return;
    
    await network.copyFragmentsToClipboard(network.selectedFragmentIds.toList());
    _addMessage('Текст ${network.selectedFragmentIds.length} фрагментов скопирован в буфер', isSystem: true);
  }

  Widget _buildNeuronFragmentsList() {
    final selectedNeuronId = network.selectedNeuronIds.isNotEmpty ? network.selectedNeuronIds.first : null;
    if (selectedNeuronId == null) return Center(child: Text('Выберите нейрон', style: TextStyle(color: Colors.white)));
    
    final neuron = network.neurons[selectedNeuronId];
    if (neuron == null) return Center(child: Text('Нейрон не найден', style: TextStyle(color: Colors.white)));
    
    final fragmentIds = neuron.fragmentLinks;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text('Фрагменты: ${fragmentIds.length}', 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Spacer(),
                  if (network.selectedFragmentIds.isNotEmpty)
                    ElevatedButton.icon(
                      icon: Icon(Icons.content_copy, size: 16),
                      label: Text('Копировать выделенные'),
                      onPressed: _copySelectedFragmentsToClipboard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: fragmentIds.length,
                itemBuilder: (context, index) {
                  final fragmentId = fragmentIds[index];
                  final fragment = network.fragments[fragmentId];
                  if (fragment == null) return SizedBox.shrink();
                  
                  final isSelected = network.selectedFragmentIds.contains(fragmentId);
                  
                  return Card(
                    color: isSelected ? Colors.green.withOpacity(0.3) : Colors.grey[850],
                    margin: EdgeInsets.all(4),
                    child: ListTile(
                      title: Text(
                        fragment.text.length > 100 
                            ? fragment.text.substring(0, 100) + "..." 
                            : fragment.text,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            children: fragment.keywords.take(3).map((wordId) {
                              final wordText = network.wordLibrary[wordId] ?? '';
                              return GestureDetector(
                                onTap: () => _handleWordTap(wordText),
                                child: Chip(
                                  label: Text(wordText, style: TextStyle(fontSize: 8)),
                                  backgroundColor: Colors.purple.withOpacity(0.5),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      trailing: isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
                      onTap: () {
                        setState(() {
                          if (_shiftPressed) {
                            if (isSelected) {
                              network.selectedFragmentIds.remove(fragmentId);
                            } else {
                              network.selectedFragmentIds.add(fragmentId);
                            }
                          } else {
                            network.selectedFragmentIds = {fragmentId};
                          }
                        });
                      },
                      onLongPress: () {
                        _showFragmentDetail(fragment);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFragmentDetail(Fragment fragment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Icon(Icons.article, color: Colors.green),
            SizedBox(width: 8),
            Text('Фрагмент #${fragment.id}', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: _buildFragmentDetailContent(fragment),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Закрыть', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: fragment.text));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Текст скопирован в буфер')),
              );
            },
            child: Text('Копировать текст'),
          ),
        ],
      ),
    );
  }

  Widget _buildFragmentDetailContent(Fragment fragment) {
    final containingNeurons = network.neurons.values
        .where((neuron) => neuron.fragmentLinks.contains(fragment.id))
        .toList();
    
    final allFragments = network.fragments.values.toList();
    final currentIndex = allFragments.indexWhere((f) => f.id == fragment.id);
    final previousFragment = currentIndex > 0 ? allFragments[currentIndex - 1] : null;
    final nextFragment = currentIndex < allFragments.length - 1 ? allFragments[currentIndex + 1] : null;
    
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: 'Текст'),
              Tab(text: 'Ключевые слова'),
              Tab(text: 'Контекст'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: SelectableText(
                    fragment.text,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                
                _buildKeywordsTab(fragment),
                
                _buildContextTab(fragment, containingNeurons, previousFragment, nextFragment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordsTab(Fragment fragment) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ключевые слова:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fragment.keywords.map((wordId) {
              final wordText = network.wordLibrary[wordId] ?? '';
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  network.selectWord(wordId);
                  setState(() {});
                },
                child: Chip(
                  label: Text(wordText),
                  backgroundColor: Colors.green.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text('Сигнатура:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            fragment.semanticType,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildContextTab(Fragment fragment, List<Neuron> containingNeurons, Fragment? previousFragment, Fragment? nextFragment) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Принадлежит нейронам:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (containingNeurons.isEmpty)
            Text('Не принадлежит ни одному нейрону', style: TextStyle(color: Colors.white70)),
          ...containingNeurons.map((neuron) => ListTile(
            leading: Icon(Icons.hub, color: Colors.purple),
            title: Text(neuron.pageTitle ?? 'Neuron #${neuron.id}', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pop();
              network.selectNeuron(neuron.id);
              setState(() {});
            },
          )).toList(),
          
          SizedBox(height: 16),
          Text('Соседние фрагменты:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (previousFragment != null) 
            _buildNeighborFragmentTile(previousFragment, 'Предыдущий'),
          if (nextFragment != null)
            _buildNeighborFragmentTile(nextFragment, 'Следующий'),
        ],
      ),
    );
  }

  Widget _buildNeighborFragmentTile(Fragment fragment, String label) {
    return Card(
      color: Colors.grey[850],
      child: ListTile(
        leading: Icon(Icons.article, color: Colors.blue),
        title: Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          fragment.text.length > 100 ? fragment.text.substring(0, 100) + "..." : fragment.text,
          style: TextStyle(color: Colors.white70),
        ),
        onTap: () {
          Navigator.of(context).pop();
          _showFragmentDetail(fragment);
        },
      ),
    );
  }

  void _createWordsVisualizationFromNeurons() {
    if (network.selectedNeuronIds.isEmpty) return;
    
    final projectedWords = network.createNeuronWordsVisualization(network.selectedNeuronIds);
    
    setState(() {
      network.visualizationMode = VisualizationMode.words;
    });
    
    _addMessage('Создана визуализация слов для ${network.selectedNeuronIds.length} нейронов', isSystem: true);
  }

  void _handleWordTap(String wordText) {
    _searchController.text = wordText;
    _handleSearchUpdate(wordText);
  }

  
 Widget _buildFragmentDetailsPanel() {
  return Container(
    height: MediaQuery.of(context).size.height,
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.green),
      borderRadius: BorderRadius.circular(8),
      color: Colors.black.withOpacity(0.9),
    ),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            children: [
              Icon(Icons.article, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${network.selectedFragmentIds.length} фрагментов выбрано',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => network.clearSelection(),
              ),
            ],
          ),
        ),
        
        // НОВАЯ КНОПКА ДЛЯ ПЕРЕХОДА К НЕЙРОНАМ
        if (network.selectedFragmentIds.isNotEmpty)
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.hub),
                    label: Text('Показать нейроны (${network.getNeuronsFromSelectedFragments().length})'),
                    onPressed: () {
                      final neuronIds = network.getNeuronsFromSelectedFragments();
                      if (neuronIds.isNotEmpty) {
                        network.visualizationMode = VisualizationMode.neurons;
                        network.selectedNeuronIds = neuronIds;
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  label: Text('Сохранить'),
                  onPressed: () async {
                    await network.saveSelectedFragmentsToFile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Фрагменты сохранены в файл и буфер обмена')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        
        Expanded(
          child: _buildFragmentDetailsList(),
        ),
      ],
    ),
  );
}
Widget _buildFragmentDetailsList() {
  if (network.selectedFragmentIds.isEmpty) {
    return Center(
      child: Text(
        'Выберите фрагменты для просмотра',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  final fragmentList = network.selectedFragmentIds
      .map((id) => network.fragments[id])
      .whereType<Fragment>()
      .toList();

  return ListView.builder(
    padding: EdgeInsets.all(8),
    itemCount: fragmentList.length,
    itemBuilder: (context, index) {
      final fragment = fragmentList[index];
      return Card(
        color: Colors.grey[850],
        margin: EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с ID и типом
              Row(
                children: [
                  Chip(
                    label: Text(
                      '#${fragment.id}',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor: Colors.grey[700],
                  ),
                  SizedBox(width: 8),
                  Chip(
                    label: Text(
                      fragment.semanticType,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  Spacer(),
                  // Кнопка перехода к нейрону
                  if (fragment.neuronIds.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.hub, size: 16, color: Colors.purple),
                      onPressed: () {
                        network.navigateToNeuronFromFragment(fragment.id);
                        setState(() {});
                      },
                      tooltip: 'Перейти к нейрону',
                    ),
                  IconButton(
                    icon: Icon(Icons.close, size: 16, color: Colors.white70),
                    onPressed: () {
                      setState(() {
                        network.selectedFragmentIds.remove(fragment.id);
                      });
                    },
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // Текст фрагмента
              SelectableText(
                fragment.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
              
              SizedBox(height: 8),
              
              // Мета-информация
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Chip(
                    label: Text(
                      '${fragment.wordIds.length} слов',
                      style: TextStyle(fontSize: 9, color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  if (fragment.neuronIds.isNotEmpty)
                    Chip(
                      label: Text(
                        'Нейроны: ${fragment.neuronIds.join(', ')}',
                        style: TextStyle(fontSize: 9, color: Colors.white),
                      ),
                      backgroundColor: Colors.purple,
                    ),
                  // Ключевые слова
                  ...fragment.keywords.take(3).map((wordId) {
                    final wordText = network.wordLibrary[wordId] ?? '';
                    return Chip(
                      label: Text(
                        wordText,
                        style: TextStyle(fontSize: 9, color: Colors.white),
                      ),
                      backgroundColor: Colors.orange,
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  String _getVisualizationTitle() {
    switch (network.visualizationMode) {
      case VisualizationMode.words:
        return '3D Визуализация слов';
      case VisualizationMode.neurons:
        return '3D Граф нейронов';
      case VisualizationMode.fragments:
        return '3D Визуализация фрагментов';
    }
  }

  String _getSearchHint() {
    switch (network.visualizationMode) {
      case VisualizationMode.words:
        return 'Поиск слов...';
      case VisualizationMode.neurons:
        return 'Поиск нейронов...';
      case VisualizationMode.fragments:
        return 'Поиск фрагментов...';
    }
  }
}


class NumberMatch {
  final int value;
  final String match;
  final int start;
  final int end;
  
  NumberMatch({
    required this.value,
    required this.match,
    required this.start,
    required this.end,
  });
}

class ChatMessage1 {
  final String text;
  final bool isSystem;
  final DateTime timestamp;
  
  ChatMessage1({required this.text, required this.isSystem, required this.timestamp});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage1 message;
  final Function(String)? onWordTap;
  
  const ChatBubble({Key? key, required this.message, this.onWordTap}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            message.isSystem ? Icons.settings : Icons.person,
            size: 16,
            color: message.isSystem ? Colors.grey : Colors.blue,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isSystem ? Colors.grey.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildClickableText(message.text),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildClickableText(String text) {
    final words = text.split(' ');
    return Wrap(
      children: words.map((word) {
        return GestureDetector(
          onTap: () => onWordTap?.call(word),
          child: Container(
            margin: EdgeInsets.only(right: 4),
            child: Text(
              '$word ',
              style: TextStyle(
                fontSize: 14,
                color: _isClickableWord(word) ? Colors.blue : null,
                decoration: _isClickableWord(word) ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  bool _isClickableWord(String word) {
    return word.length > 3 && 
           RegExp(r'^[a-zA-Zа-яА-ЯёЁ]+$').hasMatch(word) &&
           !STOP_WORDS.contains(word.toLowerCase());
  }
}
class AdvancedNeuron3DVisualization extends StatefulWidget {
  final OptimizedNeuralNetwork network;
  final Set<int> selectedNeuronIds;
  final Function(int, bool) onNeuronSelected;
  final Function(String) onClusterTapped;
  final Function(String, {bool isSystem}) sendMessage; // Измените здесь
  
  const AdvancedNeuron3DVisualization({
    Key? key,
    required this.network,
    required this.selectedNeuronIds,
    required this.onNeuronSelected,
    required this.onClusterTapped,
    required this.sendMessage,
  }) : super(key: key);
  
  @override
  _AdvancedNeuron3DVisualizationState createState() => _AdvancedNeuron3DVisualizationState();
}

class _AdvancedNeuron3DVisualizationState extends State<AdvancedNeuron3DVisualization> 
    with SingleTickerProviderStateMixin {
  // Новая система координат - камера смотрит на сцену
  double _cameraX = 0.0;
  double _cameraY = 0.0;
  double _cameraZ = 1000.0; // Камера смотрит сверху
  double _cameraScale = 1.0;
  
  // Вращение камеры
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  
  // Перетаскивание
  Offset? _lastPanOffset;
  bool _isPanning = false;
  String? _hoveredClusterId;
  String? _draggedClusterId;
  Offset? _dragStartOffset;
  Offset? _clusterStartOffset;
  
  // Анимация
  late AnimationController _animationController;
  final Map<String, double> _clusterGlowIntensities = {};
  final Map<String, double> _connectionWeights = {};
    bool _isAnimating = false;
  String? _expandingClusterId;
  @override
  void initState() {
    super.initState();
    
    // Инициализация позиции корневого кластера внизу сцены
    _initializeRootClusterPosition();
    
        _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 16),
    )..addListener(_onAnimationTick);
    
    
    _animationController.repeat();
    _initializeConnectionWeights();
  }
   
  void _onAnimationTick() {
    if (!mounted) return;
    
    widget.network.updateAnimations(1/60);
    _updateConnectionWeights();
    
    // Обновляем состояние только если есть изменения
    if (widget.network.hasVisualChanges) {
      setState(() {});
    }
  }
  void _initializeRootClusterPosition() {
    final rootCluster = widget.network.clusters['root'];
    if (rootCluster != null) {
      // Помещаем корневой кластер внизу сцены
      rootCluster.updatePosition(0.0, 300.0, 0.0);
      
      // Позиционируем дочерние кластеры вокруг него вверх
      _positionChildClusters('root', 0.0, 300.0, 0);
    }
  }
  
  void _positionChildClusters(String parentId, double parentX, double parentY, int depth) {
    final parent = widget.network.clusters[parentId];
    if (parent == null) return;
    
    final children = parent.childClusterIds
        .map((id) => widget.network.clusters[id])
        .whereType<NeuronCluster>()
        .toList();
    
    if (children.isEmpty) return;
    
    final angleStep = (2 * pi) / children.length;
    final radius = 150.0 + (depth * 50.0);
    
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      final angle = i * angleStep;
      
      double childX, childY, childZ;
      
      // Чередуем направления: четная глубина - вверх, нечетная - вправо
      if (depth % 2 == 0) {
        // Вверх
        childX = parentX - (children.length*200)/2+i*200;
        childY = parentY - 300;
        
      } else {
        // Вправо
        childX = parentX + radius * 0.8;
        childY = parentY + radius * sin(angle) * 0.3;
        
      }
      
      child?.updatePosition(childX, childY, 0);
      child?.depth = depth + 1;
      child?.size = 1.0 / (depth * 0.3 + 1);
      
      // Рекурсивно позиционируем детей, но только если кластер развернут
     if (child?.childClusterIds.isNotEmpty ?? false) {
      _positionChildClusters(child!.id, childX, childY, depth + 1);
    }
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _initializeConnectionWeights() {
    for (final cluster in widget.network.clusters.values) {
      if (cluster.parentClusterId != null) {
        final weight = _calculateConnectionWeight(cluster.id);
        _connectionWeights[cluster.id] = weight;
      }
    }
  }
  
  void _updateConnectionWeights() {
    for (final cluster in widget.network.clusters.values) {
      if (cluster.parentClusterId != null) {
        final weight = _calculateConnectionWeight(cluster.id);
        _connectionWeights[cluster.id] = weight;
      }
    }
  }
  
  double _calculateConnectionWeight(String clusterId) {
    final cluster = widget.network.clusters[clusterId];
    if (cluster == null || cluster.parentClusterId == null) return 1.0;
    
    double weight = 1.0;
    int expandedCount = _countExpandedChildren(clusterId);
    weight += expandedCount * 0.05;
    
    final depth = cluster.depth;
    weight += depth * 0.02;
    
    return weight.clamp(1.0, 3.0);
  }
  
  
  // ИСПРАВЛЕННЫЙ МЕТОД - убираем рекурсию
  int _countExpandedChildren(String clusterId) {
    final cluster = widget.network.clusters[clusterId];
    if (cluster == null) return 0;
    
    int count = 0;
    final queue = Queue<String>();
    queue.addAll(cluster.childClusterIds);
    
    while (queue.isNotEmpty) {
      final currentId = queue.removeFirst();
      final current = widget.network.clusters[currentId];
      if (current == null) continue;
      
      if (current.isExpanded) {
        count++;
        queue.addAll(current.childClusterIds);
        
        // Если это листовой кластер, добавляем нейроны
        if (current.childClusterIds.isEmpty) {
          count += current.neuronIds.length;
        }
      }
    }
    
    return count;
  }

  // ПЕРЕИМЕНОВАЛ в _toggleClusterExpansion
Future<void> _toggleClusterExpansion(String clusterId) async {
  if (_isAnimating) return;
  
  _isAnimating = true;
  _expandingClusterId = clusterId;
  
  final cluster = widget.network.clusters[clusterId];
  if (cluster == null) {
    _isAnimating = false;
    _expandingClusterId = null;
    return;
  }
  
  // Переключаем состояние
  final wasExpanded = cluster.isExpanded;
  cluster.isExpanded = !wasExpanded;
  
  widget.sendMessage('🎯 Toggling cluster ${cluster.id} from $wasExpanded to ${cluster.isExpanded}. ${cluster.childClusterIds.length} ${cluster.neuronIds.length}');
  
  if (cluster.isExpanded) {
    // РАЗВОРАЧИВАЕМ - показываем детей
    await _showChildClusters(clusterId);
  } else {
    // СВОРАЧИВАЕМ - скрываем детей
    await _hideChildClusters(clusterId);
  }
  
  // ОБНОВЛЯЕМ ПОЗИЦИИ после изменения состояния
  //_updateClusterPositions();
  
  // ФОРСИРУЕМ ОБНОВЛЕНИЕ UI
  if (mounted) {
          setState(() {});
        }
  
  _isAnimating = false;
  _expandingClusterId = null;
}
  
  Future<void> _showChildClusters(String parentId) async {
    final parent = widget.network.clusters[parentId];
    if (parent == null) return;
    List<String> myReports = [];
    for (final childId in parent.childClusterIds) {
      final child = widget.network.clusters[childId];
      if (child != null) {
        child.isVisible = true;

        // Анимация появления с задержкой
        final index = parent.childClusterIds.indexOf(childId);
        //await Future.delayed(Duration(milliseconds: 150 - (10 * index).clamp(50, 150)));
        final newX = parent.x+(35-(parent.childClusterIds.length*90)/2+90*index)*_cameraScale;
        final newY = parent.y-60*_cameraScale;
        if (child.neuronIds.isEmpty!=true){
            myReports.add("opening parent cluster ${parent.id}, ${parent.x}, ${parent.y}, ${newX}, ${newY}, ${parent.childClusterIds.length}, ${index}");
        }
        
        child.x=newX;
        child.y=newY;
        
      }
    }

    for (final report in myReports){
      //await AppLogger.writeLog(report);
    }

  }
  
  Future<void> _hideChildClusters(String parentId) async {
    final parent = widget.network.clusters[parentId];
    if (parent == null) return;
    
    // Скрываем всех детей рекурсивно
    final allChildren = _getAllChildren(parentId);
    for (final childId in allChildren) {
      final child = widget.network.clusters[childId];
      if (child != null) {
        child.isVisible = false;
        child.isExpanded = false; // Сворачиваем тоже
      }
    }
    
   
  }
  
  // Вспомогательный метод для получения всех детей (включая вложенных)
  List<String> _getAllChildren(String parentId) {
    final result = <String>[];
    final queue = Queue<String>();
    queue.addAll(widget.network.clusters[parentId]?.childClusterIds ?? []);
    
    while (queue.isNotEmpty) {
      final currentId = queue.removeFirst();
      result.add(currentId);
      queue.addAll(widget.network.clusters[currentId]?.childClusterIds ?? []);
    }
    
    return result;
  }
  
  void _updateClusterPositions() {
    final rootCluster = widget.network.clusters['root'];
    if (rootCluster != null) {
      _positionChildClusters('root', rootCluster.x, rootCluster.y, 0);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _lastPanOffset = details.focalPoint;
        _isPanning = true;
      },
      onScaleUpdate: (details) {
        if (_isPanning && _lastPanOffset != null) {
          final delta = details.focalPoint - _lastPanOffset!;
          setState(() {
            // Панорамирование сцены
            _cameraX -= delta.dx / _cameraScale;
            _cameraY -= delta.dy / _cameraScale;
          });
          _lastPanOffset = details.focalPoint;
        }
        
        // Зум
        if (details.scale != 1.0) {
          setState(() {
            _cameraScale = (_cameraScale * details.scale).clamp(0.1, 5.0);
          });
        }
      },
      onScaleEnd: (details) {
        _isPanning = false;
        _lastPanOffset = null;
      },
      onTapDown: (details) {
        _handleTap(details.localPosition);
      },
      child: MouseRegion(
        onHover: (event) {
          _handleHover(event.localPosition);
        },
        onExit: (event) {
          setState(() {
            _hoveredClusterId = null;
          });
        },
        child: Listener(
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              setState(() {
                _cameraScale = (_cameraScale * (1.0 + pointerSignal.scrollDelta.dy * -0.001))
                    .clamp(0.05, 2.0);
              });
            }
          },
          onPointerDown: (event) {
            _handlePointerDown(event.position);
          },
          onPointerMove: (event) {
            _handlePointerMove(event.position);
          },
          onPointerUp: (event) {
            _handlePointerUp();
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: _AdvancedNeuron3DPainter(
              network: widget.network,
              cameraX: _cameraX,
              cameraY: _cameraY,
              cameraZ: _cameraZ,
              cameraScale: _cameraScale,
              rotationX: _rotationX,
              rotationY: _rotationY,
              selectedNeuronIds: widget.selectedNeuronIds,
              hoveredClusterId: _hoveredClusterId,
              draggedClusterId: _draggedClusterId,
              connectionWeights: _connectionWeights,
            ),
          ),
        ),
      ),
    );
  }
  
  void _handleHover(Offset position) {
    final hitResult = _findHitObject(position);
    setState(() {
      _hoveredClusterId = hitResult.clusterId;
      
      if (hitResult.clusterId != null) {
        _clusterGlowIntensities[hitResult.clusterId!] = 0.2;
      }
    });
  }
  void _startClusterGlowAnimation(String clusterId) {
  final cluster = widget.network.clusters[clusterId];
  if (cluster == null) return;

  // Запускаем анимацию свечения
  cluster.glowIntensity = 1.0;
  setState(() {});

  // Плавно уменьшаем свечение в течение 500 мс
  const totalDuration = 500;
  const steps = 10;
  const stepDuration = totalDuration ~/ steps;
  
  for (int i = 1; i <= steps; i++) {
    Future.delayed(Duration(milliseconds: stepDuration * i), () {
      if (mounted && widget.network.clusters.containsKey(clusterId)) {
        final currentCluster = widget.network.clusters[clusterId];
        if (currentCluster != null) {
          currentCluster.glowIntensity = 1.0 - (i / steps);
          setState(() {});
        }
      }
    });
  }
}
  void _handleTap(Offset position) {
    final hitResult = _findHitObject(position);
    
    if (hitResult.clusterId != null) {
            _startClusterGlowAnimation(hitResult.clusterId!);
      _toggleClusterExpansion(hitResult.clusterId!);
      //widget.onClusterTapped(hitResult.clusterId!);
    } else if (hitResult.neuronId != null) {
      widget.onNeuronSelected(hitResult.neuronId!, false);
    }
  }
  
  void _handlePointerDown(Offset position) {
    return;
    final hitResult = _findHitObject(position);
    
    if (hitResult.clusterId != null) {
      _draggedClusterId = hitResult.clusterId;
      _dragStartOffset = position;
      final cluster = widget.network.clusters[hitResult.clusterId]!;
      _clusterStartOffset = Offset(cluster.x, cluster.y);
      
      _clusterGlowIntensities[hitResult.clusterId!] = 0.8;
    }
  }
  
  void _handlePointerMove(Offset position) {
    return;
    if (_draggedClusterId != null && _dragStartOffset != null && _clusterStartOffset != null) {
      final cluster = widget.network.clusters[_draggedClusterId!];
      if (cluster != null) {
        final delta = (position - _dragStartOffset!) / _cameraScale;
        final newX = _clusterStartOffset!.dx + delta.dx;
        final newY = _clusterStartOffset!.dy + delta.dy;
        
        cluster.updatePosition(newX, newY, cluster.z);
        
        if (cluster.isExpanded && cluster.childClusterIds.isEmpty) {
          _moveNeuronsWithCluster(cluster, newX, newY);
        }
        
        setState(() {});
      }
    }
  }
  
  void _handlePointerUp() {
    return;
    if (_draggedClusterId != null) {
      _clusterGlowIntensities[_draggedClusterId!] = 0.0;
    }
    _draggedClusterId = null;
    _dragStartOffset = null;
    _clusterStartOffset = null;
  }
  
  void _moveNeuronsWithCluster(NeuronCluster cluster, double newX, double newY) {
    final deltaX = newX - cluster.x;
    final deltaY = newY - cluster.y;
    
    for (final neuronId in cluster.neuronIds) {
      final neuron = widget.network.neurons[neuronId];
      if (neuron != null) {
        neuron.x += deltaX;
        neuron.y += deltaY;
      }
    }
  }
  
  void _startClusterExpansionAnimation(String clusterId) {
    final cluster = widget.network.clusters[clusterId];
    if (cluster == null) return;
    
    _clusterGlowIntensities[clusterId] = 1.0;
    
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _clusterGlowIntensities[clusterId] = 0.0;
        });
      }
    });
  }


  HitResult _findHitObject(Offset position) {
  final box = context.findRenderObject() as RenderBox;
  final size = box.size;
  
  final centerX = size.width / 2 - _cameraX;
  final centerY = size.height / 2 - _cameraY;
  
  // Проверяем кластеры
  for (final cluster in widget.network.clusters.values) {
    if (!cluster.isVisible) continue;
    
    final projected = _projectToScreen(cluster.x, cluster.y, cluster.z, centerX, centerY);
    final clusterSize = 40.0 * _cameraScale * cluster.size;
    final distance = (Offset(projected.dx, projected.dy) - position).distance;
    
    if (distance < clusterSize) {
      return HitResult(clusterId: cluster.id);
    }
  }
  
  // Проверяем нейроны в развернутых кластерах
  for (final cluster in widget.network.clusters.values) {
    if (!cluster.isExpanded || !cluster.isVisible || cluster.childClusterIds.isNotEmpty) continue;
    
    final clusterScreenPos = _projectToScreen(cluster.x, cluster.y, cluster.z, centerX, centerY);
    final startX = clusterScreenPos.dx +  35* _cameraScale - cluster.neuronIds.length.clamp(1,5)*31/2 * _cameraScale;
    final startY = clusterScreenPos.dy - 10* _cameraScale - (cluster.neuronIds.length*11/(cluster.neuronIds.length~/5)) * _cameraScale;
    
    for (int i = 0; i < cluster.neuronIds.length; i++) {
      final neuronId = cluster.neuronIds[i];
      final neuron = widget.network.neurons[neuronId];
      if (neuron == null) continue;
      
      // Вычисляем позицию так же как при отрисовке
      final neuronX = startX + (30 * (i%5)) * _cameraScale;
      final neuronY = startY + (i~/5 * 11.0) * _cameraScale;
      
      final neuronRect = Rect.fromCenter(
        center: Offset(neuronX, neuronY),
        width: 30.0 * _cameraScale,
        height: 10.0 * _cameraScale,
      );
      
      if (neuronRect.contains(position)) {
        return HitResult(neuronId: neuronId);
      }
    }
  }
  
  return HitResult();
}
  
  Offset _projectToScreen(double x, double y, double z, double centerX, double centerY) {
    // Упрощенная проекция 3D в 2D с учетом камеры
    final screenX = centerX + (x * _cameraScale);
    final screenY = centerY + (y * _cameraScale);
    
    return Offset(screenX, screenY);
  }
}



class _AdvancedNeuron3DPainter extends CustomPainter {
  final OptimizedNeuralNetwork network;
  final double cameraX;
  final double cameraY;
  final double cameraZ;
  final double cameraScale;
  final double rotationX;
  final double rotationY;
  final Set<int> selectedNeuronIds;
  final String? hoveredClusterId;
  final String? draggedClusterId;
  final Map<String, double> connectionWeights;
  
  _AdvancedNeuron3DPainter({
    required this.network,
    required this.cameraX,
    required this.cameraY,
    required this.cameraZ,
    required this.cameraScale,
    required this.rotationX,
    required this.rotationY,
    required this.selectedNeuronIds,
    required this.hoveredClusterId,
    required this.draggedClusterId,
    required this.connectionWeights,
  });
    final Map<String, ui.Picture> _neuronCardCache = {};
  double _lastCameraScale = 1.0;
  
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2 - cameraX;
    final centerY = size.height / 2 - cameraY;
    
    // Сначала вычисляем позиции всех кластеров с учетом коллизий
    //_resolveClusterCollisions(size, centerX, centerY);
    
    _drawConnections(canvas, size, centerX, centerY);
    _drawClusters(canvas, size, centerX, centerY);
    _drawNeurons(canvas, size, centerX, centerY);
    _lastCameraScale = cameraScale;
  }

  void _resolveClusterCollisions(Size size, double centerX, double centerY) {
    final clusters = network.clusters.values.where((c) => c.isVisible).toList();
    
    // Сортируем по глубине для обработки от дальних к ближним
    clusters.sort((a, b) => a.depth.compareTo(b.depth));
    
    for (int i = 0; i < clusters.length; i++) {
      final clusterA = clusters[i];
      final posA = _projectToScreen(clusterA.x, clusterA.y, clusterA.z, centerX, centerY);
      final baseSizeA = 40.0 * cameraScale * clusterA.size;
      final rectA = Rect.fromCircle(center: posA, radius: baseSizeA);
      
      // Расширенный прямоугольник с учетом минимальных отступов
      final expandedRectA = Rect.fromLTRB(
        rectA.left - 50 * cameraScale,
        rectA.top - 75 * cameraScale,  
        rectA.right + 50 * cameraScale,
        rectA.bottom + 75 * cameraScale,
      );
      
      for (int j = i + 1; j < clusters.length; j++) {
        final clusterB = clusters[j];
        final posB = _projectToScreen(clusterB.x, clusterB.y, clusterB.z, centerX, centerY);
        final baseSizeB = 40.0 * cameraScale * clusterB.size;
        final rectB = Rect.fromCircle(center: posB, radius: baseSizeB);
        
        final expandedRectB = Rect.fromLTRB(
          rectB.left - 50 * cameraScale,
          rectB.top - 75 * cameraScale,
          rectB.right + 50 * cameraScale,
          rectB.bottom + 75 * cameraScale,
        );
        
        // Проверяем пересечение расширенных прямоугольников
        if (expandedRectA.overlaps(expandedRectB)) {
          _resolveCollision(clusterA, clusterB, posA, posB, expandedRectA, expandedRectB, centerX, centerY);
        }
      }
    }
  }

  void _resolveCollision(
    NeuronCluster clusterA, 
    NeuronCluster clusterB, 
    Offset posA, 
    Offset posB,
    Rect rectA,
    Rect rectB,
    double centerX,
    double centerY,
  ) {
    final intersection = rectA.intersect(rectB);
    
    if (intersection.width > 0 && intersection.height > 0) {
      // Вычисляем вектор отталкивания
      final centerA = rectA.center;
      final centerB = rectB.center;
      
      final dx = centerB.dx - centerA.dx;
      final dy = centerB.dy - centerA.dy;
      final distance = sqrt(dx * dx + dy * dy);
      
      if (distance > 0) {
        // Минимальное расстояние между центрами с учетом отступов
        final minDistance = (rectA.width / 2) + (rectB.width / 2);
        final overlap = minDistance - distance;
        
        if (overlap > 0) {
          // Нормализованный вектор направления
          final nx = dx / distance;
          final ny = dy / distance;
          
          // Смещение для устранения коллизии
          final offsetX = nx * overlap * 0.5;
          final offsetY = ny * overlap * 0.5;
          
          // Применяем смещение к обоим кластерам
          // Обновляем реальные координаты кластера B
          final newScreenX = posB.dx + offsetX;
          final newScreenY = posB.dy + offsetY;
          
          // Конвертируем обратно в мировые координаты
          final newWorldX = (newScreenX - centerX) / cameraScale;
          final newWorldY = (newScreenY - centerY) / cameraScale;
          
          // Обновляем позицию кластера B
          clusterB.x = newWorldX;
          clusterB.y = newWorldY;
        }
      }
    }
  }


  void _drawDebugCollisionZones(Canvas canvas, List<Rect> clusterRects) {
    // Включите эту функцию для отладки коллизий
    final bool showDebug = false;
    
    if (showDebug) {
      for (final rect in clusterRects) {
        final expandedRect = Rect.fromLTRB(
          rect.left - 50 * cameraScale,
          rect.top - 75 * cameraScale,
          rect.right + 50 * cameraScale,
          rect.bottom + 75 * cameraScale,
        );
        
        final debugPaint = Paint()
          ..color = Colors.red.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
          
        canvas.drawRect(expandedRect, debugPaint);
      }
    }
  }
  
  void _drawConnections(Canvas canvas, Size size, double centerX, double centerY) {
    for (final cluster in network.clusters.values) {
      if (!cluster.isVisible || cluster.parentClusterId == null) continue;
      
      final parent = network.clusters[cluster.parentClusterId!];
      if (parent != null && parent.isVisible) {
        _drawConnectionLine(canvas, parent, cluster, centerX, centerY);
      }
    }
  }

void _drawNeuronConnections(Canvas canvas, Neuron neuron, Offset neuronPosition, Size size) {
  // Упрощенный поиск связей - только по общим словам в сигнатурах
  final connectedNeurons = <int, double>{}; // neuronId -> strength
  
  // Ищем нейроны с общими словами в сигнатурах
  final neuronWords = neuron.keywords.toSet();
  double summaryStrength=0;
  for (final cluster in network.clusters.values){
    if (!cluster.isVisible || !cluster.isExpanded || cluster.neuronIds.isEmpty){continue;}

    for (final otherNeuron in network.neurons.values) {
          if (otherNeuron.id == neuron.id) continue;
          
          final otherWords = otherNeuron.keywords.toSet();
          final commonWords = neuronWords.intersection(otherWords);
          
          if (commonWords.isNotEmpty) {
            // Сила связи = количество общих слов
            double strength = (commonWords.length/neuronWords.length + commonWords.length/neuronWords.length)/2;
            connectedNeurons[otherNeuron.id] = strength;
            if (strength>summaryStrength){
              summaryStrength=(summaryStrength+strength)/2;
            }
          }
        }
  }
  
  
  // Берем топ-3 самых сильных связей
  final topConnections = connectedNeurons.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value))
    ..take(14);
  
  for (final entry in topConnections) {
    if (entry.value> summaryStrength/3*2){
      continue;
    }
    final otherNeuron = network.neurons[entry.key];
    if (otherNeuron == null) continue;
    
    // Находим позицию связанного нейрона в мировых координатах
      final otherPosition = _findNeuronPosition(otherNeuron, size);
    if (otherPosition == null) continue;
    
    // Нормализуем силу связи (0.0 - 1.0)
    final normalizedStrength = min(entry.value / 40.0, 1.0);
    
    // Простой цвет от фиолетового к голубому в зависимости от силы связи
    final color = Color.lerp(
      Colors.purple,
      Colors.cyan,
      normalizedStrength,
    )!.withOpacity(0.1);
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5 + normalizedStrength * 1.0 // Толщина от силы связи
      ..style = PaintingStyle.stroke;
    
    // Простая слегка изогнутая линия
    final path = Path();
    path.moveTo(neuronPosition.dx, neuronPosition.dy);
    
    final midX = (neuronPosition.dx + otherPosition.dx) / 2;
    final midY = (neuronPosition.dy + otherPosition.dy) / 2;
    
    // Небольшой изгиб
    final controlX = midX + (otherPosition.dy - neuronPosition.dy) * 0.1;
    final controlY = midY - (otherPosition.dx - neuronPosition.dx) * 0.1;
    
    path.quadraticBezierTo(
      controlX, controlY,
      otherPosition.dx, otherPosition.dy,
    );
    
    canvas.drawPath(path, paint);
  }
}

// Вспомогательная функция для поиска позиции нейрона
Offset? _findNeuronPosition(Neuron neuron, Size size) {
  // Получаем размеры канваса из контекста
  final centerX = size.width / 2 - cameraX;
  final centerY = size.height / 2 - cameraY;
  
  // Ищем нейрон в развернутых кластерах
  for (final cluster in network.clusters.values) {
    if (cluster.isExpanded && cluster.isVisible && cluster.neuronIds.contains(neuron.id) ) {
      final clusterScreenPos = _projectToScreen(cluster.x, cluster.y, cluster.z, centerX, centerY);
      final neuronIndex = cluster.neuronIds.indexOf(neuron.id);
      if (neuronIndex != -1) {
        final neuronX = neuron.screenX; //clusterScreenPos.dx + 35* cameraScale  -   cluster.neuronIds.length.clamp(1,5)*31/2* cameraScale   +    (31 * (neuronIndex%5)) * cameraScale ;
        final neuronY = neuron.screenY;//clusterScreenPos.dy - 10* cameraScale  -   (cluster.neuronIds.length*11/(cluster.neuronIds.length~/5)* cameraScale + neuronIndex~/5 * 11.0) * cameraScale;
        return Offset(neuronX, neuronY);
      }
    }
  }
  
  // Если не нашли в развернутых кластерах, используем позицию кластера
  for (final cluster in network.clusters.values) {
    if (cluster.neuronIds.contains(neuron.id)) {
      return _projectToScreen(cluster.x, cluster.y, cluster.z, centerX, centerY);
    }
  }
  
  return null;
}
  void _drawConnectionLine(Canvas canvas, NeuronCluster parent, NeuronCluster child, 
                        double centerX, double centerY) {
  final parentCenter = _projectToScreen(parent.x, parent.y, parent.z, centerX, centerY);
  final childCenter = _projectToScreen(child.x, child.y, child.z, centerX, centerY);
  
  // Рассчитываем размеры кластеров
  final parentSize = 40.0 * cameraScale * parent.size;
  final childSize = 40.0 * cameraScale * child.size;
  
  // Находим точки на границах кластеров
  final start = _getExitPoint(parentCenter, childCenter, parentSize);
  final end = _getEntryPoint(childCenter, parentCenter, childSize);
  
  final weight = connectionWeights[child.id] ?? 1.0;
  final strokeWidth = 2.0 * weight * cameraScale;
  
  final path = Path();
  path.moveTo(start.dx, start.dy);
  
  final dx = end.dx - start.dx;
  final dy = end.dy - start.dy;
  final distance = sqrt(dx * dx + dy * dy);
  
  // Высоты для различных фаз кривой
  final totalHeight = (start.dy - end.dy).abs();
  final phase1Height = totalHeight * 0.3; // 30% - начальный подъем
  final phase2Height = totalHeight * 0.5; // 50% - основное движение
  final phase3Height = totalHeight * 0.2; // 20% - финальный подход
  
  if (distance > 50) {
    // Точки контроля для кубической кривой Безье
    final control1 = Offset(
      start.dx + dx * 0.1,
      start.dy - phase1Height,
    );
    
    final control2 = Offset(
      start.dx + dx * 0.4,
      start.dy - phase1Height - phase2Height * 0.3,
    );
    
    final control3 = Offset(
      start.dx + dx * 0.6,
      end.dy + phase3Height + phase2Height * 0.3,
    );
    
    final control4 = Offset(
      start.dx + dx * 0.9,
      end.dy + phase3Height,
    );
    
    // Создаем плавную кривую через несколько контрольных точек
    path.cubicTo(
      control1.dx, control1.dy,
      control2.dx, control2.dy,
      (control2.dx + control3.dx) / 2, (control2.dy + control3.dy) / 2
    );
    
    path.cubicTo(
      control3.dx, control3.dy,
      control4.dx, control4.dy,
      end.dx, end.dy
    );
    
  } else {
    // Для близких кластеров - прямая линия
    path.lineTo(end.dx, end.dy);
  }
  
  // Градиент от родителя к ребенку
  final gradientColors = [
    Colors.blue.withOpacity(0.8),
    Colors.purple.withOpacity(0.6),
  ];
  
  final gradient = LinearGradient(colors: gradientColors);
  final rect = Rect.fromPoints(start, end);
  final paint = Paint()
    ..shader = gradient.createShader(rect)
    ..strokeWidth = strokeWidth
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  
  canvas.drawPath(path, paint);
  
  _drawConnectionArrow(canvas, path, paint, weight);
}
 void _drawConnectionArrow(Canvas canvas, Path path, Paint paint, double weight) {
  try {
    final metrics = path.computeMetrics();
    final metric = metrics.first;
    
    // Находим точку на 95% пути для стрелки (близко к концу, но не в самой конечной точке)
    final arrowOffset = max(metric.length * 0.95, 5.0);
    final tangent = metric.getTangentForOffset(arrowOffset);
    
    if (tangent != null) {
      final arrowPoint = tangent.position;
      final angle = tangent.angle;
      
      final arrowSize = 8.0 * weight * cameraScale;
      
      final arrowPath = Path();
      arrowPath.moveTo(
        arrowPoint.dx - arrowSize * cos(angle - pi / 6),
        arrowPoint.dy - arrowSize * sin(angle - pi / 6),
      );
      arrowPath.lineTo(arrowPoint.dx, arrowPoint.dy);
      arrowPath.lineTo(
        arrowPoint.dx - arrowSize * cos(angle + pi / 6),
        arrowPoint.dy - arrowSize * sin(angle + pi / 6),
      );
      arrowPath.close();
      
      final arrowPaint = Paint()
        ..color = Colors.red.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(arrowPath, arrowPaint);
    }
  } catch (e) {
    // Игнорируем ошибки отрисовки стрелки
  }
}
  Offset _getExitPoint(Offset fromCenter, Offset toCenter, double fromSize) {
  final angle = atan2(toCenter.dy - fromCenter.dy, toCenter.dx - fromCenter.dx);
  
  // Вычисляем точку на границе круга в направлении цели
  return Offset(
    fromCenter.dx + cos(angle) * fromSize,
    fromCenter.dy + sin(angle) * fromSize,
  );
}

Offset _getEntryPoint(Offset toCenter, Offset fromCenter, double toSize) {
  final angle = atan2(toCenter.dy - fromCenter.dy, toCenter.dx - fromCenter.dx);
  
  // Вычисляем точку на границе круга с противоположной стороны
  return Offset(
    toCenter.dx - cos(angle) * toSize,
    toCenter.dy - sin(angle) * toSize,
  );
}
   void _drawClusters(Canvas canvas, Size size, double centerX, double centerY) {
    final sortedClusters = network.clusters.values.toList()
      ..sort((a, b) => a.depth.compareTo(b.depth));
    
    // Временный список для отладки коллизий
    final List<Rect> debugRects = [];
    
    for (final cluster in sortedClusters) {
      if (!cluster.isVisible) continue;
      
      final projected = _projectToScreen(cluster.x, cluster.y, cluster.z, centerX, centerY);
      final baseSize = 40.0 * cameraScale * cluster.size;
      
      // Сохраняем для отладки
      debugRects.add(Rect.fromCircle(center: projected, radius: baseSize));
      
      _drawSingleCluster(canvas, cluster, centerX, centerY);
    }
    
    // Опционально: отладка - отрисовка зон коллизий
    //_drawDebugCollisionZones(canvas, debugRects);
  }

  void _drawSingleCluster(Canvas canvas, NeuronCluster cluster, double centerX, double centerY) {
  final projected = _projectToScreen(cluster.x, cluster.y, cluster.z, centerX, centerY);
  final center = Offset(projected.dx, projected.dy);
  final baseSize = 40.0 * cameraScale * cluster.size;
  
  final isHovered = cluster.id == hoveredClusterId;
  final isDragged = cluster.id == draggedClusterId;
  final isExpanded = cluster.isExpanded;
  final isNeuronCluster = cluster.neuronIds.length > 0;
  
  // Свечение
  final glowIntensity = _getClusterGlowIntensity(cluster.id);
  if (glowIntensity > 0.0) {
    final glowPaint = Paint()
      ..color = isNeuronCluster? Colors.purple.withOpacity(glowIntensity*0.7) : Colors.yellow.withOpacity(glowIntensity * 0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * cameraScale);
    
    canvas.drawCircle(center, baseSize * (1.0 + glowIntensity), glowPaint);
  }
  
  // Градиент для заливки
  final gradientColors = [
    isNeuronCluster ? Colors.purple.withOpacity(isExpanded ? 1.0 : 0.75) : 
                     Colors.blue.withOpacity(isExpanded ? 0.53 : 0.22),
    isNeuronCluster ? Colors.green.withOpacity(isExpanded ? 1.0 : 0.75) : 
                     Colors.purple.withOpacity(isExpanded ? 0.53 : 0.22),
  ];
  
  // Создаем градиент для размера круга
  final gradientRect = Rect.fromCircle(center: center, radius: baseSize);
  final gradient = LinearGradient(colors: gradientColors);
  
  // Заливка круга
  final fillPaint = Paint()
    ..shader = gradient.createShader(gradientRect)
    ..style = PaintingStyle.fill; // Исправлено: fill вместо stroke
  
  canvas.drawCircle(center, baseSize, fillPaint);
  
  // Граница
  final borderColor = isExpanded ? Colors.greenAccent : 
                     isHovered ? Colors.yellow : Colors.white;
  
  final borderPaint = Paint()
    ..color = isNeuronCluster ? Colors.purple : borderColor
    ..strokeWidth = isExpanded ? 3.0 : (isHovered ? 2.5 : 2.0)
    ..style = PaintingStyle.stroke;
  
  canvas.drawCircle(center, baseSize, borderPaint);
  
  // Текст
  _drawClusterText(canvas, cluster, center, baseSize);
}
  
  double _getClusterGlowIntensity(String clusterId) {
    if (clusterId == hoveredClusterId) return 0.2;
    if (clusterId == draggedClusterId) return 0.8;
    return 0.0;
  }
  
  void _drawClusterText(Canvas canvas, NeuronCluster cluster, Offset center, double baseSize) {
    final text = _getClusterDisplayText(cluster);
    final textStyle = ui.TextStyle(
      color: Colors.white,
      fontSize: 10 * cameraScale * cluster.size,
      fontWeight: FontWeight.bold,
    );
    
    final textBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    ))
      ..pushStyle(textStyle)
      ..addText(text);
    
    final textParagraph = textBuilder.build();
    textParagraph.layout(ui.ParagraphConstraints(width: baseSize * 3));
    
    canvas.drawParagraph(
      textParagraph, 
      Offset(center.dx - textParagraph.width / 2, center.dy - textParagraph.height / 2)
    );
  }



Map<int, double> getFastTopConnectionsByKeywords(){
  final Map<int,double> topConnections = {};
  final List<int> keywordList = [];
  
  for (final neuronId in selectedNeuronIds){
    keywordList.addAll(network.neurons[neuronId]?.keywords ?? []);
  }
  
  // Получаем уникальные ключевые слова и сортируем по allRating (чем ниже - тем важнее)
  final List<int> neuronWords = keywordList.toSet().toList();
  
  // Сортируем слова по allRating (по возрастанию - чем меньше рейтинг, тем важнее)
  neuronWords.sort((a, b) {
    final ratingA = network.words[a]?.allRating ?? double.infinity;
    final ratingB = network.words[b]?.allRating ?? double.infinity;
    return ratingA.compareTo(ratingB); // Сортировка по возрастанию
  });
  
  final Map<int,double> myWordRatings = {};
  
  for (final keyword in neuronWords){
    final dictionary = network.words[keyword]?.ratings ?? {};
    // Дополнительная логика обработки рейтингов...
  }
  
  double summaryStrength = 0;
  final Map<int, double> connectedNeurons = {};
  
  // Получаем текущий нейрон (предполагая, что есть доступ к neuron.id)
  // Если нужно обработать несколько выбранных нейронов, измените логику
  final currentNeuron = network.neurons[selectedNeuronIds.first];
  if (currentNeuron == null) return {};
  
  for (final otherNeuron in network.neurons.values) {
    if (selectedNeuronIds.contains(otherNeuron.id)) continue;
    
    final otherWords = otherNeuron.keywords.toSet();
    final commonWords = neuronWords.toSet().intersection(otherWords);
    
    if (commonWords.isNotEmpty) {
      // Учитываем важность слов: слова с меньшим allRating имеют больший вес
      double strength = 0;
      for (final word in commonWords) {
        final wordRating = network.words[word]?.allRating ?? 1.0;
        // Инвертируем рейтинг: чем меньше allRating, тем больше вес
        final wordWeight = 1.0 / (wordRating + 1); // +1 чтобы избежать деления на 0
        strength += wordWeight;
      }
      
      strength /= neuronWords.length; // Нормализуем
      connectedNeurons[otherNeuron.id] = strength;
      summaryStrength += strength;
    }
  }
  
  // Берем топ-15 самых сильных связей
  final topConnectionsList = connectedNeurons.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value))
    ..take(15);
  
  return Map.fromEntries(topConnectionsList.take(15));
}




  double max_similairty_top_neurons = 0;
    double min_similairty_top_neurons = 0;
  Map<int, double> _topNeuronIds = {};
  List<int> _presetSelectedNeurons = [];


  void _drawNeurons(Canvas canvas, Size size, double centerX, double centerY) {
      Map<int, double> topNeurons = {};

      if (_areSetsEqual(_presetSelectedNeurons.toSet(),selectedNeuronIds.toSet())==false){
        _presetSelectedNeurons=selectedNeuronIds.toList();
        topNeurons = getFastTopConnectionsByKeywords();
        _topNeuronIds=topNeurons;
      }
      
        // Находим максимальное значение
        // Находим максимальное значение
    max_similairty_top_neurons = _topNeuronIds!.isEmpty ? 0 : _topNeuronIds!.entries.reduce(
      (a, b) => a.value > b.value ? a : b
    ).value;

    // Находим минимальное значение  
    min_similairty_top_neurons = _topNeuronIds!.isEmpty ? 0 : _topNeuronIds!.entries.reduce(
      (a, b) => a.value < b.value ? a : b
    ).value;
    for (final cluster in network.clusters.values) {
      if (!cluster.isExpanded || !cluster.isVisible || cluster.childClusterIds.isNotEmpty) continue;
      
      final clusterScreenPos = _projectToScreen(cluster.x, cluster.y, cluster.z, centerX, centerY);
      final startX = clusterScreenPos.dx + 35 * cameraScale - cluster.neuronIds.length.clamp(1,5)*31/2* cameraScale ;
      final startY = clusterScreenPos.dy - 10* cameraScale  - (cluster.neuronIds.length*11/(cluster.neuronIds.length~/5)) * cameraScale;
      //        final neuronX = clusterScreenPos.dx + (20 + 30 * (neuronIndex%5)) * cameraScale ;
//        final neuronY = clusterScreenPos.dy - (cluster.neuronIds.length*11/5 + neuronIndex%5 * 11.0) * cameraScale;
      for (int i = 0; i < cluster.neuronIds.length; i++) {
        final neuronId = cluster.neuronIds[i];
        final neuron = network.neurons[neuronId];
        if (neuron == null) continue;
        
        // Сохраняем экранные координаты в нейрон
        neuron.screenX = startX + 31 * (i%5) * cameraScale;
        neuron.screenY = startY + (i~/5*11) * cameraScale;
        
        _drawSingleNeuron(canvas, neuron, neuron.screenX, neuron.screenY,size);
        
        // Рисуем связи для выделенных нейронов, передавая size
        if (selectedNeuronIds.contains(neuron.id)) {
          _drawNeuronConnections(canvas, neuron, Offset(neuron.screenX, neuron.screenY), size);
        }
   
      // Рисуем усиленные желтые связи к топ нейронам
      if (topNeurons.containsKey(neuron.id)) {
        final similarityScore = topNeurons[neuron.id]!;
        _drawEnhancedConnection(
          canvas,
          neuron,
          similarityScore,
          size
        );
      }
    }
  }
}
(String, int, int, String Function(int))? _findNumericDifference(String startUrl, String endUrl) {
  if (startUrl == endUrl) return null;
  
  // Находим позицию первого отличающегося символа
  int diffIndex = 0;
  final minLength = min(startUrl.length, endUrl.length);
  
  while (diffIndex < minLength && startUrl.codeUnitAt(diffIndex) == endUrl.codeUnitAt(diffIndex)) {
    diffIndex++;
  }
  
  if (diffIndex >= minLength) return null;
  
  // Ищем числовые последовательности вокруг позиции различия
  final startNum = _findNumberAtPosition(startUrl, diffIndex);
  final endNum = _findNumberAtPosition(endUrl, diffIndex);
  
  if (startNum == null || endNum == null || startNum.value == endNum.value) {
    return null;
  }
  
  // Создаем базовый URL
  final beforeDiff = startUrl.substring(0, startNum.start);
  final afterDiff = startUrl.substring(startNum.end);
  final baseUrl = '$beforeDiff{NUM}$afterDiff';
  
  // Функция форматирования с сохранением стиля
  String formatNumber(int num) {
    final original = startNum.match;
    
    // Сохраняем ведущие нули
    if (original.startsWith('0')) {
      final targetLength = original.length;
      return num.toString().padLeft(targetLength, '0');
    }
    
    return num.toString();
  }
  
  return (baseUrl, startNum.value, endNum.value, formatNumber);
}

NumberMatch? _findNumberAtPosition(String text, int position) {
  // Ищем начало числа
  int start = position;
  while (start > 0 && _isDigit(text.codeUnitAt(start - 1))) {
    start--;
  }
  
  // Ищем конец числа
  int end = position;
  while (end < text.length && _isDigit(text.codeUnitAt(end))) {
    end++;
  }
  
  if (start >= end) return null;
  
  final numberStr = text.substring(start, end);
  final number = int.tryParse(numberStr);
  
  if (number == null) return null;
  
  return NumberMatch(
    value: number,
    match: numberStr,
    start: start,
    end: end,
  );
}

bool _isDigit(int codeUnit) {
  return codeUnit >= 48 && codeUnit <= 57; // '0' - '9'
}

Map<String, Map<int, double>> _getTopAndBottomSignatureWords() {
  if (selectedNeuronIds.isEmpty) return {'top': {}, 'bottom': {}};

  final Map<int, double> neuronSignatures = {};
  
  // Суммируем сигнатуры
  for (final selectedId in selectedNeuronIds) {
    final selectedNeuron = network.neurons[selectedId];
    if (selectedNeuron != null) {
      for (final entry in selectedNeuron.signatureRatings.entries) {
        final wordId = entry.key;
        final value = entry.value.toDouble();
        neuronSignatures[wordId] = (neuronSignatures[wordId] ?? 0) + value;
      }
    }
  }

  if (neuronSignatures.isEmpty) return {'top': {}, 'bottom': {}};

  // Сортируем по значению
  final sortedEntries = neuronSignatures.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  // Берем топ 30 и bottom 20 с сохранением значений
  final topWords = Map.fromEntries(sortedEntries.take(30));
  final bottomWords = Map.fromEntries(sortedEntries.reversed.take(20));

  return {
    'top': topWords,
    'bottom': bottomWords,
  };
}


Map<int,double> _calculateTopNeuronsByCombinedSimilarity() {
  final Map<int, double> combinedScores = {};
  
  if (selectedNeuronIds.isEmpty) return combinedScores;
  final Map<String, Map<int,double>> wordsForUse = _getTopAndBottomSignatureWords();

  final Map<int,double> top = wordsForUse['top'] ?? {};
  final Map<int,double> bottom = wordsForUse['bottom'] ?? {};
  
  // 1. Собираем neuronRatings similarity (35%)
  final Map<int, double> neuronSimilarities = {};
  double averageSimilarity = 0;
  int similarityCount = 0;
  
  for (final selectedId in selectedNeuronIds) {
    final selectedNeuron = network.neurons[selectedId];
    if (selectedNeuron != null) {
      for (final entry in selectedNeuron.neuronRatings.entries) {
        final neuronId = entry.key;
        final similarity = entry.value.toDouble();
        neuronSimilarities[neuronId] = (neuronSimilarities[neuronId] ?? 0.25 + similarity)/2; 
        averageSimilarity += similarity;
        similarityCount++;
      }
    }
  }
  
  // Calculate average similarity
  if (similarityCount > 0) {
    averageSimilarity /= similarityCount;
  }
  
  final Map<int, double> finalSimilarity = {};
  final Map<int, double> comparedVector = {};
  
  for (final entry in neuronSimilarities.entries) {
    if (entry.value > averageSimilarity / 3 * 2) {
      continue;
    }
    
    final key = entry.key;
    final neuron = network.neurons[key];
   
    if (neuron == null) continue;
    
    final signature_allRating = neuron.signature_allRating;
    int counter = 0;
    
    for (final neuronKeyword in neuron.keywords) {
      if (!top.containsKey(neuronKeyword) && !bottom.containsKey(neuronKeyword)) continue;

      double multiplier = bottom.containsKey(neuronKeyword) ? 1.08 : 1.0;
      final neuronSignatureElement = neuron.signatureRatings[neuronKeyword] ?? 0.0;
      
      if (signature_allRating > 0 && neuronSignatureElement / signature_allRating < 0.15) continue;
      
      comparedVector[key] = (comparedVector[key] ?? 0.0) + neuronSignatureElement * multiplier; 
      counter++;
    }
    
    if (counter > 0) {
      comparedVector[key] = (comparedVector[key] ?? 0.0) / counter;
    }
    
    if (counter > 5) {
      finalSimilarity[key] = comparedVector[key] ?? 0.0;
    }
  }
  
  return finalSimilarity;
}
Map<int, double> _calculateTopNeuronsByCombinedSimilarityDD() {
  final Map<int, double> combinedScores = {};
  
  if (selectedNeuronIds.isEmpty || network.neurons.isEmpty) {
    return combinedScores;
  }

  // 1. Neuron ratings similarity (35%)
  final Map<int, double> neuronSimilarities = {};
  
  for (final selectedId in selectedNeuronIds) {
    final selectedNeuron = network.neurons[selectedId];
    if (selectedNeuron != null && selectedNeuron.neuronRatings.isNotEmpty) {
      for (final entry in selectedNeuron.neuronRatings.entries) {
      
        // Пропускаем выбранные нейроны
        if (selectedNeuronIds.contains(entry.key)) continue;

        neuronSimilarities[entry.key]=entry.value.toDouble();
      }
    }
  }
  
  // 2. Keywords similarity (65%)
  final Map<int, double> keywordSimilarities = {};
  final Map<int, int> keywordFrequency = {};
  final Map<int,double> similarityAll = {};
  // Считаем частоту keywords
  for (final selectedId in selectedNeuronIds) {
    final selectedNeuron = network.neurons[selectedId];
    if (selectedNeuron != null && selectedNeuron.keywords.isNotEmpty) {
      for (final keywordId in selectedNeuron.keywords) {
        keywordFrequency[selectedId] = keywordFrequency[selectedId] ?? 0 +1; 
      }
    }
  }
  
  // Keyword similarity для каждого нейрона
  for (final neuron in network.neurons.values) {
    if (selectedNeuronIds.contains(neuron.id)) continue;
    
    double keywordScore = 0.0;
    if (neuron.keywords.isNotEmpty) {
      for (final keywordId in neuron.keywords) {
        final frequency = neuron.signatureRatings[keywordId] ?? 0;
        keywordScore += frequency.toDouble()/(neuron.signature_allRating);
      }
    }
    if (keywordScore > 0) {
      keywordSimilarities[neuron.id] = keywordScore;
      similarityAll[neuron.id] = similarityAll[neuron.id]??0 + keywordScore;
    }
  }
  
  // 3. Комбинируем scores с проверками на пустоту
  final allNeuronIds = {...neuronSimilarities.keys, ...keywordSimilarities.keys};
  
  if (allNeuronIds.isEmpty) return combinedScores;


  for (final neuronId in allNeuronIds) {
    final neuronRatingScore = (neuronSimilarities[neuronId] ?? 0.001 )/(network.neurons[neuronId]!.allRating+0.001);
    final keywordScore = ( keywordSimilarities[neuronId]! ?? 0.001 )/(similarityAll[neuronId]!+0.001);
    
    final combinedScore = (neuronRatingScore * 0.35) + (keywordScore * 0.65);
    combinedScores[neuronId] = combinedScore;
  }
  
  // Топ 50 нейронов
  return Map.fromEntries(
    combinedScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..take(50)
  );
}



void _drawEnhancedConnection(
  Canvas canvas,
  Neuron neuron,
  double similarityScore,
  Size size
) {
  final neuronPosition = Offset(neuron.screenX, neuron.screenY);
  
  for (final selectedId in selectedNeuronIds) {
    final selectedNeuron = network.neurons[selectedId];
    if (selectedNeuron == null) continue;
    
    final hasConnection = _hasConnectionBetween(neuron, selectedNeuron);
    
    if (hasConnection>0.15) {
      final selectedPosition = _findNeuronPosition(selectedNeuron, size);
      if (selectedPosition == null) continue;
      
      final intensity = similarityScore.clamp(0.0, 1.0);
      final color = Color.lerp(
        Colors.yellow.withOpacity(0.1),
        Colors.orange.withOpacity(0.2),
        intensity,
      )!;
      
      final strokeWidth = 0.7 + (intensity * 1.0);
      
      final paint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      
      // Точная копия алгоритма из _drawNeuronConnections
      _drawCurvedLine(
        canvas,
        selectedPosition,
        neuronPosition,
        paint,
      );
      
      // Свечение для сильных связей
      if (intensity > 0.7) {
        final glowPaint = Paint()
          ..color = Colors.orange.withOpacity(0.2)
          ..strokeWidth = strokeWidth * 1.2
          ..style = PaintingStyle.stroke
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);
        
        _drawCurvedLine(
          canvas,
          selectedPosition,
          neuronPosition,
          glowPaint,
        );
      }
    }
  }
}

// Вынесенная функция для рисования кривой линии (как в оригинале)
void _drawCurvedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  final path = Path();
  path.moveTo(start.dx, start.dy);
  
  final midX = (start.dx + end.dx) / 2;
  final midY = (start.dy + end.dy) / 2;
  
  // Тот же алгоритм расчета контрольных точек
  final controlX = midX + (end.dy - start.dy) * 0.1;
  final controlY = midY - (end.dx - start.dx) * 0.1;
  
  path.quadraticBezierTo(
    controlX, controlY,
    end.dx, end.dy,
  );
  
  canvas.drawPath(path, paint);
}

double _hasConnectionBetween(Neuron neuron1, Neuron neuron2) {
  // Проверяем связь по neuronRatings
  if (neuron1.neuronRatings.containsKey(neuron2.id) || 
      neuron2.neuronRatings.containsKey(neuron1.id)) {
    return neuron2.neuronRatings[neuron1.id]!/neuron2.allRating;
  }
  
  // Проверяем связь по общим keywords
  final keywords1 = neuron1.keywords.toSet();
  final keywords2 = neuron2.keywords.toSet();
  final commonKeywords = keywords1.intersection(keywords2);
  
  return commonKeywords.length/((keywords1.length+keywords2.length+0.1)/2);
}

  void _drawSingleNeuron(Canvas canvas, Neuron neuron, double screenX, double screenY, Size size) {
  final position = Offset(screenX, screenY);
  final isSelected = selectedNeuronIds.contains(neuron.id);
  
  _drawNeuronCardCached(canvas, neuron, position, isSelected);
  
  // Рисуем связи только для выделенных нейронов или по настройке
  if (selectedNeuronIds.contains(neuron.id)) {
    _drawNeuronConnections(canvas, neuron, position, size);
  }
}
  
  void _drawNeuronCardCached(Canvas canvas, Neuron neuron, Offset position, bool isSelected) {
    final cacheKey = _getNeuronCacheKey(neuron, isSelected);
    
    if (_neuronCardCache.containsKey(cacheKey) && _lastCameraScale == cameraScale) {
      final cachedPicture = _neuronCardCache[cacheKey]!;
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.drawPicture(cachedPicture);
      canvas.restore();
      return;
    }
    
    // Создаем новую картинку и кэшируем
    final recorder = ui.PictureRecorder();
    final cardCanvas = Canvas(recorder);
    
    _drawNeuronCardContent(cardCanvas, neuron, isSelected);
    
    final picture = recorder.endRecording();
    _neuronCardCache[cacheKey] = picture;
    
    if (_neuronCardCache.length > 50) {
      _neuronCardCache.remove(_neuronCardCache.keys.first);
    }
    
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.drawPicture(picture);
    canvas.restore();
  }
  
  void _drawNeuronCardContent(Canvas canvas, Neuron neuron, bool isSelected) {
    // Компактные размеры 120x50
    final cardWidth = 30.0 * cameraScale;
    final cardHeight = 10.0 * cameraScale;
   final bool isTopNeuron = _topNeuronIds.containsKey(neuron.id);
    final double neuronTopConnectionStr = _topNeuronIds[neuron.id]?? 0;
    final double difference =max_similairty_top_neurons-min_similairty_top_neurons;
    final double max_d = max_similairty_top_neurons-difference;
    final double min_d = max_similairty_top_neurons-difference;
    final double my_d = neuronTopConnectionStr-difference;
    final double percent_similairty = my_d/max_d;
    final double percent_more_than_min = my_d/min_d;
    final bool isSomethingSelected = !selectedNeuronIds.isEmpty;
    //  double max_similairty_top_neurons = 0;
    //double min_similairty_top_neurons = 0;
    final cardRect = Rect.fromCenter(
      center: Offset.zero,
      width: cardWidth,
      height: cardHeight
    );

    // Фон карточки
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        isSelected ? Colors.orange.withOpacity(0.9) :isTopNeuron? Colors.green.withOpacity(0.6*percent_similairty): isSomethingSelected? Colors.grey.withOpacity(0.25) : Colors.blue.withOpacity(0.5),
        isSelected ? Colors.pink.withOpacity(0.7) : isTopNeuron? Colors.cyan.withOpacity(0.5*percent_similairty):isSomethingSelected? Colors.brown.withOpacity(0.20): Colors.purple.withOpacity(0.5),
      ],
    );
    
    final backgroundPaint = Paint()
      ..shader = gradient.createShader(cardRect)
      ..style = PaintingStyle.fill;
    
    // Тень
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * cameraScale);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(cardRect.shift(Offset(2, 2)), Radius.circular(6 * cameraScale)),
      shadowPaint
    );
    
    // Основная карточка
    canvas.drawRRect(
      RRect.fromRectAndRadius(cardRect, Radius.circular(6 * cameraScale)),
      backgroundPaint
    );
    if (isSelected || isTopNeuron) {
      final myColor = isTopNeuron ? Colors.green.withOpacity(0.5) : Colors.yellow.withOpacity(0.6);
      final borderPaint = Paint()
        ..color = myColor
        ..strokeWidth = 1 * cameraScale
        ..style = PaintingStyle.stroke;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(cardRect, Radius.circular(6 * cameraScale)),
        borderPaint
      );
    }
    final title = neuron.pageTitle ?? 'Neuron #${neuron.id}';
    final shortenedTitle = _shortenText(title, 35); // Ограничиваем длину заголовка
    
    // Заголовок (верхняя строка)
    _drawText(
      canvas,
      shortenedTitle,
      TextStyle(
        color: Colors.white,
        fontSize: 1.1 * cameraScale, // Уменьшенный шрифт
        fontWeight: FontWeight.bold,
      ),
      Offset(-cardWidth/2 + 1 * cameraScale, -cardHeight/2 + 2 * cameraScale),
      cardWidth - 2 * cameraScale,
    );
    
    // URL (средняя строка)
    if (neuron.sourceUrl != null) {
      final displayUrl = _shortenUrl(neuron.sourceUrl!);
      _drawText(
        canvas,
        displayUrl,
        TextStyle(
          color: Colors.white70,
          fontSize: 0.7 * cameraScale, // Уменьшенный шрифт
        ),
        Offset(-cardWidth/2 + 1 * cameraScale, -cardHeight/2 + 6 * cameraScale),
        cardWidth - 2 * cameraScale,
      );
    }
    
    // Ключевые слова (нижняя строка)
    final keywords = _getTopKeywords(neuron).take(6).join(', '); // Берем только 2 ключевых слова
    if (keywords.isNotEmpty) {
      final shortKeywords = _shortenText(keywords, 25);
      _drawText(
        canvas,
        shortKeywords,
        TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 0.6 * cameraScale, // Уменьшенный шрифт
        ),
        Offset(-cardWidth/2 + 1 * cameraScale, -cardHeight/2 + 7 * cameraScale),
        cardWidth - 1 * cameraScale,
      );
    }
    
    // ID нейрона в правом нижнем углу
    _drawText(
      canvas,
      '#${neuron.id}',
      TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 5 * cameraScale, // Уменьшенный шрифт
      ),
      Offset(cardWidth/2 - 15 * cameraScale, cardHeight/2 - 9 * cameraScale),
      5 * cameraScale,
      align: TextAlign.right,
    );
  }

  String _shortenText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
  void _drawText(
    Canvas canvas, 
    String text, 
    TextStyle style, 
    Offset position, 
    double maxWidth, {
    TextAlign align = TextAlign.left,
  }) {
    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textDirection: ui.TextDirection.ltr,
      textAlign: align,
    ))
      ..pushStyle(style.getTextStyle())
      ..addText(text);
    
    final paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: maxWidth));
    
    canvas.drawParagraph(paragraph, position);
  }
  
  String _getNeuronCacheKey(Neuron neuron, bool isSelected) {
    final contentHash = _getNeuronContentHash(neuron);
    return 'neuron_${neuron.id}_${isSelected}_${cameraScale.toStringAsFixed(2)}_$contentHash';
  }
  
  String _getNeuronContentHash(Neuron neuron) {
    // Создаем хэш на основе содержимого, которое влияет на отображение
    final content = '${neuron.pageTitle}_${neuron.sourceUrl}_${_getTopKeywords(neuron).join(",")}';
    return content.hashCode.toString();
  }
  

List<String> _getTopKeywords(Neuron neuron) {
  final wordScores = <int, double>{};
  
  // Сначала вычисляем scores для слов из signatureRatings нейрона
   for (final wordId in neuron.keywords) {
    final word = network.words[wordId];
    if (word != null) {
      double score = neuron.signatureRatings[wordId]!.toDouble();
      for (final otherWordId in neuron.keywords) {
        final otherWord = network.words[otherWordId];
        if (otherWord != word) {
          final connection = network.words[otherWordId]!.ratings[wordId] ?? 0;
          score += connection * 0.1;
        }
      }
      wordScores[wordId] = score;
    }
  }
  
  
  final sortedWords = wordScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  // Топ-15 с самым высоким рейтингом
  final topKeywords = sortedWords
      .take(4)
      .map((entry) => network.wordLibrary[entry.key] ?? 'unknown')
      .where((word) => word.length > 2)
      .toList();
  
  // Для нижних 5 используем рейтинг из network.words
  final bottomWords = <MapEntry<int, double>>[];
  
  for (final wordId in neuron.signatureRatings.keys) {
    final word = network.words[wordId];
    if (word != null) {
      // Используем allRating из network.words как основной рейтинг
      final globalScore = word.allRating.toDouble();
      bottomWords.add(MapEntry(wordId, globalScore));
    }
  }
  
  // Сортируем по возрастанию рейтинга из network.words
  bottomWords.sort((a, b) => a.value.compareTo(b.value));
  
  final bottomKeywords = bottomWords
      .take(2)
      .map((entry) => network.wordLibrary[entry.key] ?? 'unknown')
      .where((word) => word.length > 2)
      .toList();
  
  return [...topKeywords, ...bottomKeywords];
}

  void clearCache() {
    _neuronCardCache.clear();
  }

  Color _getClusterColor(NeuronCluster cluster) {
    final hue = (cluster.id.hashCode % 360).toDouble();
    
    switch (cluster.type) {
      case 'domain':
        return HSLColor.fromAHSL(1.0, hue, 0.8, 0.6).toColor();
      case 'keyword':
        return HSLColor.fromAHSL(1.0, hue, 0.9, 0.4).toColor();
      case 'root':
        return Colors.deepPurple;
      default:
        return HSLColor.fromAHSL(1.0, hue, 0.6, 0.5).toColor();
    }
  }
  
  String _getClusterDisplayText(NeuronCluster cluster) {
    String text = cluster.title;
    
    if (cluster.neuronIds.isNotEmpty) {
      text += '\n${cluster.neuronIds.length}';
    }
    
    if (text.length > 15) {
      text = text.substring(0, 12) + '...';
    }
    
    return text;
  }
    String _shortenUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host;
      final path = uri.path;
      if (path.length > 20) {
        return '$host${path.substring(0, 20)}...';
      }
      return '$host$path';
    } catch (e) {
      return url.length > 30 ? '${url.substring(0, 30)}...' : url;
    }
  }
  
  Offset _projectToScreen(double x, double y, double z, double centerX, double centerY) {
    // Простая проекция 3D в 2D
    final screenX = centerX + (x * cameraScale);
    final screenY = centerY + (y * cameraScale);
    
    return Offset(screenX, screenY);
  }
  
    @override
  bool shouldRepaint(_AdvancedNeuron3DPainter oldDelegate) {
    return oldDelegate.cameraX != cameraX ||
        oldDelegate.cameraY != cameraY ||
        oldDelegate.cameraScale != cameraScale ||
        oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        !_areSetsEqual(oldDelegate.selectedNeuronIds, selectedNeuronIds) ||
        oldDelegate.hoveredClusterId != hoveredClusterId ||
        oldDelegate.draggedClusterId != draggedClusterId;
  }
  
    bool _areSetsEqual<T>(Set<T> set1, Set<T> set2) {
    if (set1.length != set2.length) return false;
    for (final item in set1) {
      if (!set2.contains(item)) return false;
    }
    return true;
  }
}
class HitResult {
  final String? clusterId;
  final int? neuronId;
  
  HitResult({this.clusterId, this.neuronId});
}
/// Улучшенная стратегия с учетом баланса allRating
class _EnhancedStrategy {
  final String description;
  final double similarityWeight;
  final double entropyWeight;
  final double allRatingWeight;
  final bool preferHighRating;
  final bool preferLowRating;
  
  const _EnhancedStrategy({
    required this.description,
    required this.similarityWeight,
    required this.entropyWeight,
    required this.allRatingWeight,
    required this.preferHighRating,
    required this.preferLowRating,
  });
  
  double calculateScore({
    required double similarityScore,
    required double entropyChange,
    required double allRatingScore,
    required int currentStep,
  }) {
    // Динамические веса в зависимости от шага
    final stepFactor = currentStep / 25.0;
    final dynamicSimilarityWeight = similarityWeight * (1.0 - stepFactor * 0.3);
    final dynamicEntropyWeight = entropyWeight * (1.0 + stepFactor * 0.5);
    
    return similarityScore * dynamicSimilarityWeight +
           entropyChange * dynamicEntropyWeight +
           allRatingScore * allRatingWeight;
  }
}

_determineEnhancedStrategy(
  double entropy, 
  _VectorStats stats, 
  double balance,
  int step
) {


    if (entropy > 2.5) {
    return _EnhancedStrategy(
      description: "ENTROPY: Focus content",
      similarityWeight: 0.6,
      entropyWeight: 0.3,
      allRatingWeight: 0.1,
      preferHighRating: false,
      preferLowRating: true,
    );
  }
  
  // Ранние шаги: фокус на сходстве
  if (step < 5) {
    return _EnhancedStrategy(
      description: "EARLY: Focus similarity",
      similarityWeight: 0.7,
      entropyWeight: 0.2,
      allRatingWeight: 0.1,
      preferHighRating: true,
      preferLowRating: false,
    );
  }
  
  // Балансировка allRating
  if (balance < 0.3) {
    return _EnhancedStrategy(
      description: "BALANCE: Correct rating imbalance",
      similarityWeight: 0.4,
      entropyWeight: 0.3,
      allRatingWeight: 0.3,
      preferHighRating: stats.mean < 0.3,
      preferLowRating: stats.mean > 0.7,
    );
  }
  
  // Управление энтропией
  if (entropy < 1.5) {
    return _EnhancedStrategy(
      description: "ENTROPY: Increase diversity",
      similarityWeight: 0.3,
      entropyWeight: 0.6,
      allRatingWeight: 0.1,
      preferHighRating: false,
      preferLowRating: true,
    );
  }
  

  // Стандартная стратегия
  return _EnhancedStrategy(
    description: "STANDARD: Balanced approach",
    similarityWeight: 0.5,
    entropyWeight: 0.3,
    allRatingWeight: 0.2,
    preferHighRating: true,
    preferLowRating: false,
  );
}
/// Анализ характеристик вектора
class _VectorStats {
  final OptimizedNeuralNetwork network;
  final double minValue;
  final double maxValue;
  final double valueRange;
  final double mean;
  final double standardDeviation;

  _VectorStats({
    required this.network,
    required this.minValue,
    required this.maxValue,
    required this.valueRange,
    required this.mean,
    required this.standardDeviation,
  });
}

/// Класс для хранения оценок кандидатов
class _EnhancedCandidateScore {
  final int wordId;
  final double similarityScore;
  final double entropyChange;
  final double allRatingScore;
  final double combinedScore;
  final int wordAllRating;

  _EnhancedCandidateScore({
    required this.wordId,
    required this.similarityScore,
    required this.entropyChange,
    required this.allRatingScore,
    required this.combinedScore,
    required this.wordAllRating,
  });
}

/// Расчет энтропии Шеннона для нормализованного вектора
double _calculateShannonEntropy(Map<int, double> vector) {
  if (vector.isEmpty) return 0.0;

  final values = vector.values.toList();
  final total = values.fold(0.0, (a, b) => a + b);
  
  if (total <= 0 || total.isInfinite || total.isNaN) return 0.0;

  double entropy = 0.0;
  for (final value in values) {
    if (value <= 0) continue;
    final probability = value / total;
    if (probability > 0 && !probability.isInfinite && !probability.isNaN) {
      entropy -= probability * log(probability);
    }
  }

  // Защита от некорректных значений
  return entropy.isNaN || entropy.isInfinite ? 0.0 : entropy;
}
/// Вспомогательный класс для хранения оценок кандидатов
class _Line7CandidateScore {
  final int wordId;
  final double intersectionScore;
  final double entropyChange;
  final double predictedEntropy;
  final double combinedScore;

  _Line7CandidateScore({
    required this.wordId,
    required this.intersectionScore,
    required this.entropyChange,
    required this.predictedEntropy,
    required this.combinedScore,
  });
}




class FragmentTextViewer extends StatefulWidget {
  final OptimizedNeuralNetwork network;
  final Set<int> selectedFragmentIds;
  final Function(int, bool) onFragmentSelected;
  final Set<int>? neuronIds;
  
  const FragmentTextViewer({
    Key? key,
    required this.network,
    required this.selectedFragmentIds,
    required this.onFragmentSelected,
    this.neuronIds,
  }) : super(key: key);
  
  @override
  _FragmentTextViewerState createState() => _FragmentTextViewerState();
}

class _FragmentTextViewerState extends State<FragmentTextViewer> {
  final ScrollController _scrollController = ScrollController();
  bool _shiftPressed = false;

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.shiftLeft || 
        event.logicalKey == LogicalKeyboardKey.shiftRight) {
      setState(() {
        _shiftPressed = event is RawKeyDownEvent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fragments = _getFragmentsToDisplay();
    
    return Column(
      children: [
        // Панель управления
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Row(
            children: [
              Text(
                'Фрагменты: ${fragments.length}',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              if (widget.selectedFragmentIds.isNotEmpty)
                ElevatedButton.icon(
                  icon: Icon(Icons.save, size: 16),
                  label: Text('Сохранить выделенные (${widget.selectedFragmentIds.length})'),
                  onPressed: () async {
                    await widget.network.saveSelectedFragmentsToFile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Фрагменты сохранены в файл и буфер обмена')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                icon: Icon(Icons.article, size: 16),
                label: Text('Показать карточки'),
                onPressed: () {
                  widget.network.visualizationMode = VisualizationMode.fragments;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: fragments.length,
              itemBuilder: (context, index) {
                final fragment = fragments[index];
                final isSelected = widget.selectedFragmentIds.contains(fragment.id);
                
                return _buildFragmentTextItem(fragment, isSelected, index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFragmentTextItem(Fragment fragment, bool isSelected, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          widget.onFragmentSelected(fragment.id, _shiftPressed);
          setState(() {});
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Текст фрагмента
              SelectableText(
                fragment.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              
              SizedBox(height: 8),
              
              // Мета-информация
              Row(
                children: [
                  Chip(
                    label: Text(
                      '#${fragment.id}',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor: Colors.grey[700],
                  ),
                  SizedBox(width: 6),
                  Chip(
                    label: Text(
                      fragment.semanticType,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox(width: 6),
                  Chip(
                    label: Text(
                      '${fragment.wordIds.length} слов',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  if (fragment.neuronIds.isNotEmpty) ...[
                    SizedBox(width: 6),
                    Chip(
                      label: Text(
                        '${fragment.neuronIds.length} нейронов',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      backgroundColor: Colors.purple,
                    ),
                  ],
                  Spacer(),
                  
                  // Кнопка перехода к нейрону
                  if (fragment.neuronIds.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.hub, size: 16, color: Colors.purple),
                      onPressed: () {
                        widget.network.navigateToNeuronFromFragment(fragment.id);
                      },
                      tooltip: 'Перейти к нейрону',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Fragment> _getFragmentsToDisplay() {
    if (widget.neuronIds != null && widget.neuronIds!.isNotEmpty) {
      final allFragments = <Fragment>[];
      for (final neuronId in widget.neuronIds!) {
        final neuron = widget.network.neurons[neuronId];
        if (neuron != null) {
          for (final fragmentId in neuron.fragmentLinks) {
            final fragment = widget.network.fragments[fragmentId];
            if (fragment != null) {
              allFragments.add(fragment);
            }
          }
        }
      }
      return allFragments;
    } else {
      return widget.network.fragments.values.toList();
    }
  }
}



class Fragment3DVisualization extends StatefulWidget {
  final OptimizedNeuralNetwork network;
  final Set<int> selectedFragmentIds;
  final Function(int, bool) onFragmentSelected;
  final Set<int>? neuronIds;
  
  const Fragment3DVisualization({
    Key? key,
    required this.network,
    required this.selectedFragmentIds,
    required this.onFragmentSelected,
    this.neuronIds,
  }) : super(key: key);
  
  @override
  _Fragment3DVisualizationState createState() => _Fragment3DVisualizationState();
}

class _Fragment3DVisualizationState extends State<Fragment3DVisualization> {
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset? _lastLeftPanPosition;
  Offset? _lastRightPanPosition;
  bool _isRightMouseDown = false;
  bool _shiftPressed = false;
  int? _primaryButtonPointer;
  int? _secondaryButtonPointer;

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.shiftLeft || 
        event.logicalKey == LogicalKeyboardKey.shiftRight) {
      setState(() {
        _shiftPressed = event is RawKeyDownEvent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          setState(() {
            _scale = (_scale * (1.0 + pointerSignal.scrollDelta.dy * -0.001))
                .clamp(0.1, 3.0);
          });
        }
      },
      onPointerDown: (event) {
        _handlePointerDown(event);
      },
      onPointerMove: (event) {
        _handlePointerMove(event);
      },
      onPointerUp: (event) {
        _handlePointerUp(event);
      },
      onPointerCancel: (event) {
        _handlePointerCancel(event);
      },
      child: MouseRegion(
        onHover: (event) {
          if (event.kind == PointerDeviceKind.mouse) {
            if ((event.buttons & kPrimaryButton) != 0 && !_isRightMouseDown) {
            }
          }
        },
        child: GestureDetector(
          onScaleUpdate: (details) {
            if (!_isRightMouseDown) {
              setState(() {
                _scale = (_scale * details.scale).clamp(0.1, 3.0);
              });
            }
          },
          onTapDown: (details) {
            _handleTap(details.localPosition, _shiftPressed);
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: Fragment3DPainter(
              network: widget.network,
              neuronIds: widget.neuronIds,
              rotationX: _rotationX,
              rotationY: _rotationY,
              scale: _scale,
              offset: _offset,
              selectedFragmentIds: widget.selectedFragmentIds,
            ),
          ),
        ),
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (event.kind == PointerDeviceKind.mouse) {
      if (event.buttons == kPrimaryButton) {
        _primaryButtonPointer = event.pointer;
        _lastLeftPanPosition = event.position;
      } else if (event.buttons == kSecondaryButton) {
        _secondaryButtonPointer = event.pointer;
        _lastRightPanPosition = event.position;
        _isRightMouseDown = true;
      }
    } else {
      _primaryButtonPointer = event.pointer;
      _lastLeftPanPosition = event.position;
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.kind == PointerDeviceKind.mouse) {
      if (_primaryButtonPointer == event.pointer && _lastLeftPanPosition != null) {
        setState(() {
          final delta = event.position - _lastLeftPanPosition!;
          _rotationY += delta.dx * 0.01;
          _rotationX += delta.dy * 0.01;
          _lastLeftPanPosition = event.position;
        });
      } else if (_secondaryButtonPointer == event.pointer && _lastRightPanPosition != null) {
        setState(() {
          final delta = event.position - _lastRightPanPosition!;
          _offset += Offset(delta.dx, delta.dy);
          _lastRightPanPosition = event.position;
        });
      }
    } else if (_primaryButtonPointer == event.pointer && _lastLeftPanPosition != null) {
      setState(() {
        final delta = event.position - _lastLeftPanPosition!;
        _rotationY += delta.dx * 0.01;
        _rotationX += delta.dy * 0.01;
        _lastLeftPanPosition = event.position;
      });
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    _resetPointer(event.pointer);
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _resetPointer(event.pointer);
  }

  void _resetPointer(int pointerId) {
    if (_primaryButtonPointer == pointerId) {
      _primaryButtonPointer = null;
      _lastLeftPanPosition = null;
    }
    if (_secondaryButtonPointer == pointerId) {
      _secondaryButtonPointer = null;
      _lastRightPanPosition = null;
      _isRightMouseDown = false;
    }
  }

  void _handleTap(Offset position, bool shiftPressed) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final centerX = size.width / 2 + _offset.dx;
    final centerY = size.height / 2 + _offset.dy;
    
    final fragments = _getFragmentsToDisplay();
    final projectedFragments = <_ProjectedFragment>[];
    
    for (int i = 0; i < fragments.length; i++) {
      final fragment = fragments[i];
      final pos = _project3DTo2D(
        fragment.x - 500, fragment.y - 500, fragment.z - 500,
        centerX, centerY,
      );
      
      projectedFragments.add(_ProjectedFragment(
        fragment: fragment,
        screenX: pos.dx,
        screenY: pos.dy,
        depth: pos.depth,
        index: i,
      ));
    }
    
    for (final projFragment in projectedFragments) {
      final distance = sqrt(
        pow(projFragment.screenX - position.dx, 2) + 
        pow(projFragment.screenY - position.dy, 2)
      );
      
      if (distance < 60.0) {
        widget.onFragmentSelected(projFragment.fragment.id, shiftPressed);
        return;
      }
    }
  }

  List<Fragment> _getFragmentsToDisplay() {
    if (widget.neuronIds != null && widget.neuronIds!.isNotEmpty) {
      final allFragments = <Fragment>[];
      for (final neuronId in widget.neuronIds!) {
        final neuron = widget.network.neurons[neuronId];
        if (neuron != null) {
          for (final fragmentId in neuron.fragmentLinks) {
            final fragment = widget.network.fragments[fragmentId];
            if (fragment != null) {
              allFragments.add(fragment);
            }
          }
        }
      }
      return allFragments;
    } else {
      return widget.network.fragments.values.toList();
    }
  }
  
  Projected3D _project3DTo2D(double x, double y, double z, double centerX, double centerY) {
    final cosY = cos(_rotationY);
    final sinY = sin(_rotationY);
    final cosX = cos(_rotationX);
    final sinX = sin(_rotationX);
    
    var x1 = x * cosY - z * sinY;
    var z1 = x * sinY + z * cosY;
    var y1 = y;
    
    final y2 = y1 * cosX - z1 * sinX;
    final z2 = y1 * sinX + z1 * cosX;
    
    final perspective = 1000 / (1000 + z2);
    final screenX = centerX + x1 * _scale * perspective;
    final screenY = centerY + y2 * _scale * perspective;
    
    return Projected3D(dx: screenX, dy: screenY, depth: z2);
  }
}

class Fragment3DPainter extends CustomPainter {
  final OptimizedNeuralNetwork network;
  final Set<int>? neuronIds;
  final double rotationX;
  final double rotationY;
  final double scale;
  final Offset offset;
  final Set<int> selectedFragmentIds;
  
  Fragment3DPainter({
    required this.network,
    required this.neuronIds,
    required this.rotationX,
    required this.rotationY,
    required this.scale,
    required this.offset,
    required this.selectedFragmentIds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2 + offset.dx;
    final centerY = size.height / 2 + offset.dy;
    
    final fragments = _getFragmentsToDisplay();
    final projectedFragments = <_ProjectedFragment>[];
    
    _positionFragmentsByNeurons(fragments);
    
    for (int i = 0; i < fragments.length; i++) {
      final fragment = fragments[i];
      final pos = _project3DTo2D(
        fragment.x - 500, fragment.y - 500, fragment.z - 500,
        centerX, centerY,
      );
      
      projectedFragments.add(_ProjectedFragment(
        fragment: fragment,
        screenX: pos.dx,
        screenY: pos.dy,
        depth: pos.depth,
        index: i,
      ));
    }
    
    projectedFragments.sort((a, b) => a.depth.compareTo(b.depth));
    
    for (final projFragment in projectedFragments) {
      _drawFragmentCard(canvas, projFragment);
    }
  }

  void _positionFragmentsByNeurons(List<Fragment> fragments) {
    if (fragments.isEmpty) return;
    
    final neuronFragments = <int, List<Fragment>>{};
    
    for (final fragment in fragments) {
      for (final neuron in network.neurons.values) {
        if (neuron.fragmentLinks.contains(fragment.id)) {
          if (!neuronFragments.containsKey(neuron.id)) {
            neuronFragments[neuron.id] = [];
          }
          neuronFragments[neuron.id]!.add(fragment);
          break;
        }
      }
    }
    
    if (neuronFragments.isEmpty) {
      _positionFragmentsBySemantics(fragments);
      return;
    }
    
    final neuronEntries = neuronFragments.entries.toList();
    final neuronCount = neuronEntries.length;
    
    for (int neuronIndex = 0; neuronIndex < neuronCount; neuronIndex++) {
      final entry = neuronEntries[neuronIndex];
      final neuronFrags = entry.value;
      
      final planeX = 100.0 + (neuronIndex % 3) * 600.0;
      final planeY = 100.0 + (neuronIndex ~/ 3) * 400.0;
      final planeZ = (neuronIndex % 2) * 200.0;
      
      for (int fragIndex = 0; fragIndex < neuronFrags.length; fragIndex++) {
        final fragment = neuronFrags[fragIndex];
        final row = fragIndex ~/ 4;
        final col = fragIndex % 4;
        
        fragment.x = planeX + col * 280.0;
        fragment.y = planeY + row * 120.0;
        fragment.z = planeZ;
      }
    }
    
    for (final fragment in fragments) {
      if (fragment.x == 0.0 && fragment.y == 0.0 && fragment.z == 0.0) {
        fragment.x = network.random.nextDouble() * 800 + 100;
        fragment.y = network.random.nextDouble() * 800 + 100;
        fragment.z = network.random.nextDouble() * 800 + 100;
      }
    }
  }

  List<List<Fragment>> _clusterFragmentsBySemantics(List<Fragment> fragments) {
    final clusters = <List<Fragment>>[];
    final visited = <int>{};
    
    for (final fragment in fragments) {
      if (visited.contains(fragment.id)) continue;
      
      final cluster = <Fragment>[fragment];
      visited.add(fragment.id);
      
      for (final other in fragments) {
        if (visited.contains(other.id)) continue;
        
        final similarity = _calculateFragmentSimilarity(fragment, other);
        if (similarity > 0.3) {
          cluster.add(other);
          visited.add(other.id);
        }
      }
      
      if (cluster.isNotEmpty) {
        clusters.add(cluster);
      }
    }
    
    return clusters;
  }
  
  double _calculateFragmentSimilarity(Fragment frag1, Fragment frag2) {
    final set1 = frag1.wordIds.toSet();
    final set2 = frag2.wordIds.toSet();
    final intersection = set1.intersection(set2).length;
    final union = set1.union(set2).length;
    
    double lexicalSimilarity = union > 0 ? intersection / union : 0.0;
    
    double semanticBonus = frag1.semanticType == frag2.semanticType ? 0.2 : 0.0;
    
    final lengthFactor = min(frag1.text.length, frag2.text.length) / 1000.0;
    
    return (lexicalSimilarity * 0.6 + semanticBonus * 0.2 + lengthFactor * 0.2).clamp(0.0, 1.0);
  }

  void _positionFragmentsBySemantics(List<Fragment> fragments) {
    final clusters = _clusterFragmentsBySemantics(fragments);
    final clusterCount = clusters.length;
    
    for (int i = 0; i < clusterCount; i++) {
      final cluster = clusters[i];
      final phi = acos(-1.0 + 2.0 * i / clusterCount);
      final theta = sqrt(clusterCount * pi) * phi;
      
      final centerX = 500.0 + 300.0 * sin(phi) * cos(theta);
      final centerY = 500.0 + 300.0 * sin(phi) * sin(theta);
      final centerZ = 500.0 + 300.0 * cos(phi);
      
      for (int j = 0; j < cluster.length; j++) {
        final fragment = cluster[j];
        final angle = 2 * pi * j / cluster.length;
        final radius = 80.0;
        
        fragment.x = centerX + radius * cos(angle);
        fragment.y = centerY + radius * sin(angle);
        fragment.z = centerZ;
      }
    }
  }

  void _drawFragmentCard(Canvas canvas, _ProjectedFragment projFragment) {
    final fragment = projFragment.fragment;
    final isSelected = selectedFragmentIds.contains(fragment.id);
    
    final center = Offset(projFragment.screenX, projFragment.screenY);
    const double maxWidth = 250.0;
    final double width = maxWidth * scale;
    final double height = 80.0 * scale;
    
    final cardRect = Rect.fromCenter(
      center: center,
      width: width,
      height: height
    );
    
    final backgroundPaint = Paint()
      ..color = Color(0xFF2D2D2D).withOpacity(0.9)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(cardRect, Radius.circular(8 * scale)),
      backgroundPaint
    );
    
    if (isSelected) {
      final borderPaint = Paint()
        ..color = Colors.amber.withOpacity(0.8)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(cardRect, Radius.circular(8 * scale)),
        borderPaint
      );
    }
    
    final textPainter = _createTextPainter(fragment.text, width - 3, 9 * scale);
    
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2
    );
    
    textPainter.paint(canvas, textOffset);
    
    final infoText = '#${fragment.id} • ${fragment.semanticType} • ${fragment.wordIds.length} слов';
    final infoPainter = _createTextPainter(infoText, width - 16, 8 * scale, color: Colors.white70);
    
    final infoOffset = Offset(
      center.dx - infoPainter.width / 2,
      center.dy + height / 2 - infoPainter.height - 4
    );
    
    infoPainter.paint(canvas, infoOffset);
  }

  TextPainter _createTextPainter(String text, double maxWidth, double fontSize, {Color color = Colors.white}) {
    final textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
      height: 1.2,
    );
    
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
      maxLines: 5,
      ellipsis: '...',
    );
    
    textPainter.layout(maxWidth: maxWidth);
    return textPainter;
  }

  void _positionFragmentsInGrid(List<Fragment> fragments) {
    const double maxWidth = 1008.0;
    const double cardWidth = 250.0;
    const double cardHeight = 80.0;
    const double horizontalSpacing = 2.0;
    const double verticalSpacing = 2.0;
    
    double currentX = 0;
    double currentY = 0;
    double currentZ = 0.0;
    int rowFragmentCount = 0;
    
    for (final fragment in fragments) {
      if (currentX + cardWidth > maxWidth) {
        currentX = 0;
        currentY += cardHeight + verticalSpacing;
        rowFragmentCount = 0;
      }
      
      fragment.x = currentX;
      fragment.y = currentY;
      fragment.z = currentZ;
      
      currentX += cardWidth + horizontalSpacing;
      rowFragmentCount++;
      
      currentZ += 5.0;
    }
  }

  List<Fragment> _getFragmentsToDisplay() {
    List<Fragment> fragments;
    
    if (neuronIds != null && neuronIds!.isNotEmpty) {
      final allFragments = <Fragment>[];
      for (final neuronId in neuronIds!) {
        final neuron = network.neurons[neuronId];
        if (neuron != null) {
          for (final fragmentId in neuron.fragmentLinks) {
            final fragment = network.fragments[fragmentId];
            if (fragment != null) {
              allFragments.add(fragment);
            }
          }
        }
      }
      fragments = allFragments;
    } else {
      fragments = network.fragments.values.take(100).toList();
    }
    
    _positionFragmentsInGrid(fragments);
    return fragments;
  }
  
  _Projected3D _project3DTo2D(double x, double y, double z, double centerX, double centerY) {
    final cosY = cos(rotationY);
    final sinY = sin(rotationY);
    final cosX = cos(rotationX);
    final sinX = sin(rotationX);
    
    var x1 = x * cosY - z * sinY;
    var z1 = x * sinY + z * cosY;
    var y1 = y;
    
    final y2 = y1 * cosX - z1 * sinX;
    final z2 = y1 * sinX + z1 * cosX;
    
    final perspective = 1000 / (1000 + z2);
    final screenX = centerX + x1 * scale * perspective;
    final screenY = centerY + y2 * scale * perspective;
    
    return _Projected3D(dx: screenX, dy: screenY, depth: z2);
  }
  
  @override
  bool shouldRepaint(Fragment3DPainter oldDelegate) {
    return oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.scale != scale ||
        oldDelegate.offset != offset ||
        oldDelegate.selectedFragmentIds.length != selectedFragmentIds.length;
  }
}

class _ProjectedFragment {
  final Fragment fragment;
  final double screenX;
  final double screenY;
  final double depth;
  final int index;
  
  _ProjectedFragment({
    required this.fragment,
    required this.screenX,
    required this.screenY,
    required this.depth,
    required this.index,
  });
}

// Расширение для добавления координат фрагментам
extension Fragment3DExtension on Fragment {
  static final Map<int, double> _xCoords = {};
  static final Map<int, double> _yCoords = {};
  static final Map<int, double> _zCoords = {};
  
  double get x => _xCoords[id] ?? 0.0;
  set x(double value) => _xCoords[id] = value;
  
  double get y => _yCoords[id] ?? 0.0;
  set y(double value) => _yCoords[id] = value;
  
  double get z => _zCoords[id] ?? 0.0;
  set z(double value) => _zCoords[id] = value;
}



extension TextStyleExtension on TextStyle {
  ui.TextStyle getTextStyle() {
    return ui.TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
    );
  }
}




























class DigitalCreationSystem {
  final OptimizedNeuralNetwork network;
  final Map<String, List<Citation>> _citations = {};
  final Map<String, Set<String>> _keywordSources = {};
  
  DigitalCreationSystem(this.network);
  
  /// Создание цифрового создания с цитированием
  Future<DigitalCreation> createDigitalCreation(
    List<String> keywords, 
    String context
  ) async {
    final creation = DigitalCreation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      keywords: keywords,
      context: context,
      createdAt: DateTime.now(),
    );
    
    // Поиск релевантного контента
    final relevantContent = await _findRelevantContent(keywords);
    
    // Генерация с привязкой к источникам
    final generated = await _generateWithCitations(keywords, relevantContent);
    
    creation.content = generated.content;
    creation.citations = generated.citations;
    
    return creation;
  }
  
  /// Поиск релевантного контента с источниками
  Future<List<RelevantContent>> _findRelevantContent(List<String> keywords) async {
    final relevant = <RelevantContent>[];
    
    for (final keyword in keywords) {
      // Поиск в нейронах
      final neurons = network.searchNeuronsByKeywords(keyword);
      for (final neuron in neurons.take(5)) {
        relevant.add(RelevantContent(
          content: neuron.pageTitle ?? neuron.sourceUrl ?? '',
          source: ContentSource(
            type: 'neuron',
            id: neuron.id.toString(),
            url: neuron.sourceUrl,
            title: neuron.pageTitle,
          ),
          relevance: 0.8,
          keywords: [keyword],
        ));
      }
      
      // Поиск во фрагментах
      final fragments = network.searchFragments(keyword);
      for (final fragment in fragments.take(10)) {
        relevant.add(RelevantContent(
          content: fragment.text,
          source: ContentSource(
            type: 'fragment', 
            id: fragment.id.toString(),
            semanticType: fragment.semanticType,
          ),
          relevance: 0.6,
          keywords: [keyword],
        ));
      }
    }
    
    return relevant;
  }
   Map<String, List<RelevantContent>> _groupSourcesByTheme(List<RelevantContent> sources) {
    final grouped = <String, List<RelevantContent>>{};
    
    for (final source in sources) {
      final theme = source.keywords.isNotEmpty ? source.keywords.first : 'general';
      if (!grouped.containsKey(theme)) {
        grouped[theme] = [];
      }
      grouped[theme]!.add(source);
    }
    
    return grouped;
  }
  /// Генерация с цитированием конкретных утверждений
  Future<GeneratedContent> _generateWithCitations(
    List<String> keywords, 
    List<RelevantContent> sources
  ) async {
    final citations = <Citation>[];
    final contentBuffer = StringBuffer();
    
    // Группируем источники по темам
    final groupedSources = _groupSourcesByTheme(sources);
    
    for (final theme in groupedSources.entries) {
      contentBuffer.writeln('## ${theme.key}');
      
      for (final source in theme.value.take(3)) {
        final claim = _extractKeyClaim(source.content);
        contentBuffer.writeln('• $claim');
        
        citations.add(Citation(
          claim: claim,
          source: source.source,
          confidence: source.relevance,
          supportingEvidence: _findSupportingEvidence(claim, sources),
        ));
      }
      contentBuffer.writeln();
    }
    
    return GeneratedContent(
      content: contentBuffer.toString(),
      citations: citations,
      sources: sources.map((s) => s.source).toSet().toList(),
    );
  }
  
  /// Извлечение ключевого утверждения из контента
  String _extractKeyClaim(String content) {
    // Используем семантический анализ для извлечения фактов
    final analysis = SemanticAnalyzer1.analyze(content);
    
    if (analysis.isFactual) {
      return content.split('.').firstWhere(
        (s) => s.length > 20,
        orElse: () => content.substring(0, min(100, content.length))
      );
    }
    
    return content.length > 100 ? '${content.substring(0, 100)}...' : content;
  }
  
  /// Поиск подтверждающих доказательств
  List<String> _findSupportingEvidence(String claim, List<RelevantContent> sources) {
    final evidence = <String>[];
    final claimKeywords = network._extractWords(claim);
    
    for (final source in sources) {
      final sourceKeywords = network._extractWords(source.content);
      final commonKeywords = claimKeywords.toSet().intersection(sourceKeywords.toSet());
      
      if (commonKeywords.length >= claimKeywords.length ~/ 2) {
        evidence.add(source.content);
        if (evidence.length >= 3) break;
      }
    }
    
    return evidence;
  }
}

/// Модели данных для цифрового создания
class DigitalCreation {
  final String id;
  final List<String> keywords;
  final String context;
  final DateTime createdAt;
  String content;
  List<Citation> citations;
  double confidence;
  
  DigitalCreation({
    required this.id,
    required this.keywords,
    required this.context,
    required this.createdAt,
    this.content = '',
    this.citations = const [],
    this.confidence = 0.0,
  });
}

class Citation {
  final String claim;
  final ContentSource source;
  final double confidence;
  final List<String> supportingEvidence;
  final DateTime citedAt;
  
  Citation({
    required this.claim,
    required this.source,
    required this.confidence,
    required this.supportingEvidence,
  }) : citedAt = DateTime.now();
}

class ContentSource {
  final String type; // 'neuron', 'fragment', 'external'
  final String id;
  final String? url;
  final String? title;
  final String? semanticType;
  
  ContentSource({
    required this.type,
    required this.id,
    this.url,
    this.title,
    this.semanticType,
  });
}

class RelevantContent {
  final String content;
  final ContentSource source;
  final double relevance;
  final List<String> keywords;
  
  RelevantContent({
    required this.content,
    required this.source,
    required this.relevance,
    required this.keywords,
  });
}

class GeneratedContent {
  final String content;
  final List<Citation> citations;
  final List<ContentSource> sources;
  
  GeneratedContent({
    required this.content,
    required this.citations,
    required this.sources,
  });
}






