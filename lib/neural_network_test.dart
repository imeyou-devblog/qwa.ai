


class QuantumNeuralNetworkForBites {
  final int inputSize;
  final int hiddenSize;
  final int outputSize;
  
  List<List<double>> weightsInputHidden;
  List<List<double>> weightsHiddenOutput;
  
  QuantumNeuralNetworkForBites({
    required this.inputSize,
    required this.hiddenSize,
    required this.outputSize,
  })  : weightsInputHidden = _initializeWeights(inputSize, hiddenSize),
        weightsHiddenOutput = _initializeWeights(hiddenSize, outputSize);

  static List<List<double>> _initializeWeights(int rows, int cols) {
    final Random random = Random();
    return List.generate(rows, (_) => 
        List.generate(cols, (_) => random.nextDouble() * 2 - 1));
  }

  List<double> predict(List<double> input) {
    // Прямое распространение через скрытый слой
    final List<double> hiddenLayer = List.filled(hiddenSize, 0.0);
    
    for (int i = 0; i < hiddenSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        hiddenLayer[i] += input[j] * weightsInputHidden[j][i];
      }
      hiddenLayer[i] = _quantumActivation(hiddenLayer[i]);
    }
    
    // Прямое распространение через выходной слой
    final List<double> outputLayer = List.filled(outputSize, 0.0);
    
    for (int i = 0; i < outputSize; i++) {
      for (int j = 0; j < hiddenSize; j++) {
        outputLayer[i] += hiddenLayer[j] * weightsHiddenOutput[j][i];
      }
      outputLayer[i] = _quantumActivation(outputLayer[i]);
    }
    
    return outputLayer;
  }

  double _quantumActivation(double x) {
    // Квантовая функция активации на основе синуса
    return sin(x * pi);
  }

  void train(List<double> input, List<double> target, double learningRate) {
    // Простая реализация обратного распространения
    final List<double> hiddenOutputs = List.filled(hiddenSize, 0.0);
    final List<double> finalOutputs = predict(input);
    
    // Обновление весов
    for (int i = 0; i < outputSize; i++) {
      for (int j = 0; j < hiddenSize; j++) {
        final double error = target[i] - finalOutputs[i];
        weightsHiddenOutput[j][i] += learningRate * error * hiddenOutputs[j];
      }
    }
  }
}

class QuantumNeuralNetwork {
  final Map<int, DataPacket> dataPackets = {};
  final Map<String, Word> words = {};
  final Map<int, Fragment> fragments = {};
  final Map<String, double> tagWeights = {};
  final List<int> bitPool = [];
  final Random random = Random();
  
  final SequenceProcessor sequenceProcessor = SequenceProcessor();
  final TensorNetwork tensorNetwork = TensorNetwork();
  final NeuralLogger logger = NeuralLogger();
  
  int nextPacketId = 1;
  int nextFragmentId = 1;
  int lshDim = 1024;

  final Map<String, double> physicalConstants = {
    'planck': 6.62607015e-34,
    'boltzmann': 1.380649e-23,
    'speedOfLight': 299792458.0,
    'gravitational': 6.67430e-11,
  };

  void initialize() {
    logger.log("🔄 Квантовая нейросеть инициализирована");
  }

  Future<void> ingestFile(PlatformFile file) async {
    await logger.log("Загрузка файла в квантовую сеть: ${file.name}");
    final content = String.fromCharCodes(file.bytes!);
    
    final textFragments = _splitIntoFragments(content);
    await logger.log("Разбито на ${textFragments.length} квантовых фрагментов");
    
    for (final fragmentText in textFragments) {
      await _processFragment(fragmentText);
    }
    
    await sequenceProcessor.processText(content);
    await tensorNetwork.trainOnData(content);
    
    await logger.log("Файл ${file.name} ассимилирован в квантовую сеть");
  }

  List<String> _splitIntoFragments(String text) {
    final fragments = <String>[];
    
    final sentences = text.split(RegExp(r'[.!?]+'));
    
    for (final sentence in sentences) {
      final trimmed = sentence.trim();
      if (trimmed.length > 10) {
        fragments.add(trimmed);
        
        final words = trimmed.split(RegExp(r'\s+'));
        for (final word in words) {
          if (word.length > 2) {
            fragments.add(word);
          }
        }
        
        for (int i = 0; i < trimmed.length - 3; i++) {
          fragments.add(trimmed.substring(i, i + 3));
        }
      }
    }
    
    return fragments;
  }

  Future<void> _processFragment(String text) async {
    final fragmentId = nextFragmentId++;
    final tags = await _extractSemCore(text);
    
    final fragment = Fragment(
      id: fragmentId,
      text: text,
      semcore: tags,
      featureVector: _createFeatureVector(tags),
    );
    
    fragments[fragmentId] = fragment;
    
    final packet = DataPacket(
      id: nextPacketId++,
      tags: tags,
      payload: text,
      featureVector: fragment.featureVector,
    );
    
    dataPackets[packet.id] = packet;
    await _processWords(text, tags, fragmentId);
    _addToBitPool(text);
  }

  Future<List<String>> _extractSemCore(String text) async {
    final words = text.toLowerCase().split(RegExp(r'\W+'));
    final tags = <String>[];
    
    for (final word in words) {
      if (word.length > 3 && !_isStopWord(word)) {
        tags.add(word);
        final stemmed = _stemWord(word);
        if (stemmed != word) {
          tags.add(stemmed);
        }
      }
    }
    
    return tags.take(5).toList();
  }

  bool _isStopWord(String word) {
    const stopWords = {
      'the', 'and', 'or', 'to', 'is', 'in', 'a', 'an', 'of', 'for', 
      'on', 'with', 'as', 'at', 'by'
    };
    return stopWords.contains(word.toLowerCase());
  }

  String _stemWord(String word) {
    if (word.endsWith('ing')) return word.substring(0, word.length - 3);
    if (word.endsWith('ed')) return word.substring(0, word.length - 2);
    if (word.endsWith('s')) return word.substring(0, word.length - 1);
    return word;
  }

  FeatureVector _createFeatureVector(List<String> tags) {
    final data = List<double>.filled(lshDim, 0.0);
    
    for (final tag in tags) {
      final hash = _hashString(tag);
      final index = hash % lshDim;
      data[index] += 1.0;
      tagWeights[tag] = (tagWeights[tag] ?? 0.0) + 1.0;
    }
    
    return FeatureVector(data: data);
  }

  Future<void> _processWords(String text, List<String> tags, int fragmentId) async {
    final wordList = text.split(RegExp(r'\W+'));
    
    for (final wordText in wordList) {
      if (wordText.length > 2) {
        final word = words.putIfAbsent(wordText, () => Word(
          id: words.length,
          text: wordText,
          tags: tags,
          featureVector: _createFeatureVector(tags),
        ));
        
        word.fragmentWeights[fragmentId] = 
            (word.fragmentWeights[fragmentId] ?? 0.0) + 1.0;
        word.totalCounter++;
        word.updateWeights();
      }
    }
  }

  void _addToBitPool(String text) {
    final bytes = utf8.encode(text);
    for (final byte in bytes) {
      for (int i = 7; i >= 0; i--) {
        final bit = (byte >> i) & 1;
        bitPool.add(bit);
        
        if (bitPool.length > 1000000) {
          bitPool.removeRange(0, 100000);
        }
      }
    }
  }

  // ========== КВАНТОВЫЕ ФУНКЦИИ ==========

  Future<String> processWithHeisenberg(String input) async {
    await logger.log("🔮 Применение принципа неопределенности Гейзенберга к: '$input'");
    
    // Схлопывание волновой функции - преобразование ввода
    final words = input.split(' ');
    final collapsedWords = <String>[];
    
    for (final word in words) {
      // Квантовая суперпозиция - рассматриваем все возможные состояния слова
      final possibleStates = await _getQuantumStates(word);
      
      // Схлопывание в материальную точку
      final collapsedState = _collapseWaveFunction(possibleStates);
      collapsedWords.add(collapsedState);
    }
    
    final result = collapsedWords.join(' ');
    await logger.log("Волновая функция схлопнута: '$input' → '$result'");
    
    return result;
  }

  Future<List<String>> _getQuantumStates(String word) async {
    final states = <String>[word];
    
    // Добавляем семантические вариации
    if (sequenceProcessor.matrices.containsKey(word)) {
      final matrix = sequenceProcessor.matrices[word]!;
      states.addAll(matrix.nextWords.keys.take(3));
    }
    
    // Добавляем фонетические вариации
    states.addAll(_getPhoneticVariations(word));
    
    // Добавляем случайные квантовые флуктуации
    if (random.nextDouble() > 0.7) {
      states.add(_applyQuantumFluctuation(word));
    }
    
    return states;
  }

  List<String> _getPhoneticVariations(String word) {
    final variations = <String>[];
    if (word.length > 3) {
      variations.add(word.substring(1)); // без первой буквы
      variations.add(word.substring(0, word.length - 1)); // без последней буквы
      if (word.contains('e')) variations.add(word.replaceAll('e', 'a'));
      if (word.contains('o')) variations.add(word.replaceAll('o', 'a'));
    }
    return variations;
  }

  String _applyQuantumFluctuation(String word) {
    final chars = word.split('');
    if (chars.length > 2) {
      final pos = random.nextInt(chars.length);
      chars[pos] = String.fromCharCode(random.nextInt(26) + 97);
    }
    return chars.join();
  }

  String _collapseWaveFunction(List<String> states) {
    // Принцип неопределенности Гейзенберга - случайный выбор с весами
    final weights = List.generate(states.length, (index) => random.nextDouble());
    final totalWeight = weights.reduce((a, b) => a + b);
    
    var randomValue = random.nextDouble() * totalWeight;
    for (int i = 0; i < states.length; i++) {
      if (randomValue < weights[i]) {
        return states[i];
      }
      randomValue -= weights[i];
    }
    
    return states.last;
  }

  Future<SequenceVector> generateSequenceVector(String startingWord, {int depth = 3}) async {
    await logger.log("Генерация квантовой последовательности от слова: '$startingWord'");
    
    final matrix = await sequenceProcessor.buildPredictionMatrix(startingWord, depth);
    final collapsedVector = matrix.collapseWithRandom(random);
    
    await logger.log("Сгенерирована квантовая последовательность: ${collapsedVector.words}");
    
    return collapsedVector;
  }

  Future<TensorResult> processWithTensorNetwork(String input, {bool training = false}) async {
    await logger.log("Тензорная обработка: '$input'");
    
    final result = await tensorNetwork.process(input, training: training);
    
    await logger.log("Тензорный результат: ${result.confidence.toStringAsFixed(3)}");
    
    return result;
  }

  Future<Uint8List> generateQuantumImage(int width, int height, String prompt) async {
    await logger.log("Генерация квантового изображения $width x $height для: '$prompt'");
    
    final image = img.Image(width: width, height: height);
    final promptHash = _hashString(prompt);
    final random = Random(promptHash);
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // Квантовые состояния пикселей
        final quantumState = _calculateQuantumState(x, y, prompt, random);
        final r = (quantumState['r']! * 255).round().clamp(0, 255);
        final g = (quantumState['g']! * 255).round().clamp(0, 255);
        final b = (quantumState['b']! * 255).round().clamp(0, 255);
        
        // Исправленные методы для работы с изображениями
        final color = img.ColorRgb8(r, g, b);
        image.setPixel(x, y, color);
      }
    }
    
    final imageData = Uint8List.fromList(img.encodePng(image));
    await logger.log("Квантовое изображение сгенерировано");
    
    return imageData;
  }

  Map<String, double> _calculateQuantumState(int x, int y, String prompt, Random random) {
    // Квантовая механика пикселей
    final positionUncertainty = sin(x * y * physicalConstants['planck']!);
    final momentumUncertainty = cos(x + y * physicalConstants['speedOfLight']!);
    
    // Принцип неопределенности Гейзенберга для цветов
    final r = (0.5 + positionUncertainty * 0.3 + random.nextDouble() * 0.2).clamp(0.0, 1.0);
    final g = (0.5 + momentumUncertainty * 0.3 + random.nextDouble() * 0.2).clamp(0.0, 1.0);
    final b = (0.5 + (positionUncertainty + momentumUncertainty) * 0.2 + random.nextDouble() * 0.1).clamp(0.0, 1.0);
    
    return {'r': r, 'g': g, 'b': b};
  }

  int predictFromProbability() {
    if (bitPool.isEmpty) return random.nextInt(2);
    final zeros = bitPool.where((bit) => bit == 0).length;
    final ones = bitPool.length - zeros;
    final zeroProbability = zeros / bitPool.length;
    return random.nextDouble() < zeroProbability ? 0 : 1;
  }

  int predictWithPhysics() {
    if (bitPool.isEmpty) return random.nextInt(2);
    final entropyProb = _calculateEntropyProbability();
    final physicsInfluence = _applyPhysicalLaws();
    final combined = (entropyProb + physicsInfluence) / 2.0;
    final prediction = random.nextDouble() < combined ? 1 : 0;
    bitPool.add(prediction);
    return prediction;
  }

  double _calculateEntropyProbability() {
    if (bitPool.length < 2) return 0.5;
    final uniqueValues = bitPool.toSet().length;
    final entropy = uniqueValues / 2.0;
    return 1.0 / (entropy + 0.0001);
  }

  double _applyPhysicalLaws() {
    double result = 0.5;
    final quantumState = bitPool.length * physicalConstants['planck']!;
    final quantumUncertainty = sin(quantumState);
    result += quantumUncertainty * 0.1;
    final entropy = bitPool.toSet().length / bitPool.length;
    final entropyFactor = entropy * physicalConstants['boltzmann']!;
    result += entropyFactor * 0.05;
    return result.clamp(0.0, 1.0);
  }

  int _hashString(String input) {
    return input.hashCode.abs();
  }
}

// ========== ВСПОМОГАТЕЛЬНЫЕ КЛАССЫ ==========

class SequenceProcessor {
  final Map<String, SequenceMatrix> matrices = {};
  final Map<String, List<SequenceVector>> sequences = {};

  Future<void> processText(String text) async {
    final words = text.split(RegExp(r'\W+')).where((w) => w.length > 2).toList();
    
    for (int i = 0; i < words.length - 1; i++) {
      final currentWord = words[i].toLowerCase();
      final nextWord = words[i + 1].toLowerCase();
      
      final sequenceKey = 'seq_${currentWord}';
      if (!sequences.containsKey(sequenceKey)) {
        sequences[sequenceKey] = [];
      }
      sequences[sequenceKey]!.add(SequenceVector(words: [currentWord, nextWord]));
      
      if (!matrices.containsKey(currentWord)) {
        matrices[currentWord] = SequenceMatrix(rootWord: currentWord);
      }
      matrices[currentWord]!.addNextWord(nextWord);
    }
  }

  Future<SequenceMatrix> buildPredictionMatrix(String startingWord, int depth) async {
    final matrix = SequenceMatrix(rootWord: startingWord);
    await _buildMatrixRecursive(matrix, startingWord, depth, 0);
    return matrix;
  }

  Future<void> _buildMatrixRecursive(SequenceMatrix matrix, String currentWord, int maxDepth, int currentDepth) async {
    if (currentDepth >= maxDepth) return;
    
    if (matrices.containsKey(currentWord)) {
      final currentMatrix = matrices[currentWord]!;
      
      for (final nextWord in currentMatrix.nextWords.keys) {
        matrix.addNextWord(nextWord);
        await _buildMatrixRecursive(matrix, nextWord, maxDepth, currentDepth + 1);
      }
    }
  }
}

class SequenceMatrix {
  final String rootWord;
  final Map<String, int> nextWords = {};
  final Map<String, SequenceMatrix> subMatrices = {};

  SequenceMatrix({required this.rootWord});

  void addNextWord(String word) {
    nextWords[word] = (nextWords[word] ?? 0) + 1;
    
    if (!subMatrices.containsKey(word)) {
      subMatrices[word] = SequenceMatrix(rootWord: word);
    }
  }

  SequenceVector collapseWithRandom(Random random) {
    final selectedWords = <String>[rootWord];
    var currentMatrix = this;
    
    while (currentMatrix.nextWords.isNotEmpty) {
      final nextWord = currentMatrix.getRandomNextWord(random);
      if (nextWord != null) {
        selectedWords.add(nextWord);
        currentMatrix = currentMatrix.subMatrices[nextWord] ?? SequenceMatrix(rootWord: nextWord);
      } else {
        break;
      }
    }
    
    return SequenceVector(words: selectedWords);
  }

  String? getRandomNextWord(Random random) {
    if (nextWords.isEmpty) return null;
    
    final total = nextWords.values.reduce((a, b) => a + b);
    var randomValue = random.nextInt(total);
    
    for (final entry in nextWords.entries) {
      if (randomValue < entry.value) {
        return entry.key;
      }
      randomValue -= entry.value;
    }
    
    return nextWords.keys.first;
  }
}

class SequenceVector {
  final List<String> words;
  final DateTime createdAt;

  SequenceVector({required this.words}) : createdAt = DateTime.now();

  @override
  String toString() => words.join(' → ');
}

class TensorNetwork {
  final Map<String, TensorNode> nodes = {};
  final Map<String, double> weights = {};
  final List<TrainingExample> trainingData = [];

  Future<TensorResult> process(String input, {bool training = false}) async {
    final words = input.split(RegExp(r'\W+')).where((w) => w.length > 2).toList();
    var totalConfidence = 0.0;
    final List<String> predictions = [];

    for (final word in words) {
      final node = nodes.putIfAbsent(word, () => TensorNode(word));
      final prediction = node.predict();
      
      predictions.add(prediction);
      totalConfidence += node.confidence;
      
      if (training) {
        trainingData.add(TrainingExample(input: word, expected: prediction));
      }
    }

    final avgConfidence = words.isNotEmpty ? totalConfidence / words.length : 0.0;

    return TensorResult(
      input: input,
      output: predictions.join(' '),
      confidence: avgConfidence,
      timestamp: DateTime.now(),
    );
  }

  Future<void> trainOnData(String text) async {
    final words = text.split(RegExp(r'\W+')).where((w) => w.length > 2).toList();
    
    for (int i = 0; i < words.length - 1; i++) {
      final input = words[i];
      final expected = words[i + 1];
      
      final node = nodes.putIfAbsent(input, () => TensorNode(input));
      node.learn(expected);
    }
  }

  Future<void> backpropagate() async {
    for (final example in trainingData) {
      final node = nodes[example.input];
      if (node != null) {
        node.adjustWeights(example.expected);
      }
    }
    
    trainingData.clear();
  }
}

class TensorNode {
  final String value;
  final Map<String, double> connections = {};
  double confidence = 0.5;
  int trainingCount = 0;

  TensorNode(this.value);

  String predict() {
    if (connections.isEmpty) return value;
    
    final sorted = connections.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    confidence = sorted.first.value;
    return sorted.first.key;
  }

  void learn(String nextWord) {
    connections.update(
      nextWord, 
      (value) => value + 0.1, 
      ifAbsent: () => 0.1
    );
    
    trainingCount++;
    
    final total = connections.values.reduce((a, b) => a + b);
    for (final key in connections.keys) {
      connections[key] = connections[key]! / total;
    }
  }

  void adjustWeights(String expected) {
    if (connections.containsKey(expected)) {
      connections[expected] = connections[expected]! + 0.05;
      confidence += 0.01;
    } else {
      confidence -= 0.01;
    }
    
    confidence = confidence.clamp(0.0, 1.0);
  }
}

class TensorResult {
  final String input;
  final String output;
  final double confidence;
  final DateTime timestamp;

  TensorResult({
    required this.input,
    required this.output,
    required this.confidence,
    required this.timestamp,
  });
}

class TrainingExample {
  final String input;
  final String expected;

  TrainingExample({required this.input, required this.expected});
}

class NeuralLogger {
  static final String logFilePath = 'qwa_neural_log.txt';
  
  Future<void> log(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $message\n';
    
    try {
      final file = File(logFilePath);
      if (await file.exists()) {
        await file.writeAsString(logEntry, mode: FileMode.append);
      } else {
        await file.writeAsString(logEntry);
      }
    } catch (e) {
      print('Ошибка записи в лог: $e');
    }
  }
  
  Future<List<String>> readLogs({int lines = 100}) async {
    try {
      final file = File(logFilePath);
      if (await file.exists()) {
        final content = await file.readAsString();
        final allLines = content.split('\n');
        return allLines.reversed.take(lines).toList();
      }
    } catch (e) {
      print('Ошибка чтения лога: $e');
    }
    return [];
  }
}

// Классы данных
class DataPacket {
  final int id;
  final List<String> tags;
  final String payload;
  final FeatureVector featureVector;
  final double weight;

  DataPacket({
    required this.id,
    required this.tags,
    required this.payload,
    required this.featureVector,
    this.weight = 1.0,
  });
}

class Fragment {
  final int id;
  final String text;
  final List<String> semcore;
  final FeatureVector featureVector;

  Fragment({
    required this.id,
    required this.text,
    required this.semcore,
    required this.featureVector,
  });
}

class Word {
  final int id;
  final String text;
  final List<String> tags;
  final FeatureVector featureVector;
  final Map<int, double> fragmentWeights = {};
  int totalCounter = 0;
  double semanticWeight = 0.0;
  double rating = 0.0;

  Word({
    required this.id,
    required this.text,
    required this.tags,
    required this.featureVector,
  });

  void updateWeights() {
    semanticWeight = rating / (totalCounter > 0 ? totalCounter : 1);
  }
}

class FeatureVector {
  final List<double> data;

  FeatureVector({required this.data});
}


class QuantumVector {
  List<double> materialVector; // Завершенные вычисления (0..1)
  List<double> probabilityVector; // Текущие вероятности
  List<double> computationalVector; // Предиктивный вектор
  List<List<double>> computationHistory; // История всех вычислений
  
  static final Random _random = Random();
  
  QuantumVector({
    required this.materialVector,
    required this.probabilityVector,
    required this.computationalVector,
    required this.computationHistory,
  });

  factory QuantumVector.initialize(int dimensions) {
    return QuantumVector(
      materialVector: List.filled(dimensions, 0.0),
      probabilityVector: List.filled(dimensions, 1.0 / dimensions),
      computationalVector: List.filled(dimensions, 0.0),
      computationHistory: [],
    );
  }

  // Вычисление точки из другой точки (квантовое спутывание)
  double computePointFromPoint(int targetIndex, int sourceIndex, double deltaT) {
    final double sourceValue = probabilityVector[sourceIndex];
    final double vectorLength = _calculateVectorLength();
    
    // Закон природы: нормализованное расстояние
    final double naturalLaw = vectorLength / (probabilityVector.length * 1.0);
    
    // Вычисление целевой точки
    double targetProbability = (sourceValue + naturalLaw * deltaT) % 1.0;
    
    // Учет истории вычислений (материальный слой)
    if (computationHistory.isNotEmpty) {
      final List<double> lastComputation = computationHistory.last;
      final double historicalInfluence = lastComputation[sourceIndex] * 0.1;
      targetProbability = (targetProbability + historicalInfluence) % 1.0;
    }
    
    // Схлопывание вероятности
    return _collapseProbability(targetProbability);
  }

  // Схлопывание всего вектора на основе токенов
  Map<String, dynamic> collapseVector(List<String> tokens) {
    final List<double> tokenWeights = _calculateTokenWeights(tokens);
    final List<double> newProbabilities = List.from(probabilityVector);
    
    // Применение весов токенов к вероятностному вектору
    for (int i = 0; i < newProbabilities.length; i++) {
      final double tokenInfluence = tokenWeights[i % tokenWeights.length];
      newProbabilities[i] = (newProbabilities[i] + tokenInfluence) % 1.0;
    }
    
    // Нормализация
    final double sum = newProbabilities.reduce((a, b) => a + b);
    for (int i = 0; i < newProbabilities.length; i++) {
      newProbabilities[i] /= sum;
    }
    
    // Обновление материального вектора (схлопывание)
    for (int i = 0; i < materialVector.length; i++) {
      if (newProbabilities[i] > 0.8) {
        materialVector[i] = 1.0; // Коллапс в материальное состояние
      } else if (newProbabilities[i] < 0.2) {
        materialVector[i] = 0.0; // Коллапс в нулевое состояние
      }
    }
    
    // Вычисление предиктивного вектора
    computationalVector = _computePredictiveVector(newProbabilities);
    
    // Сохранение в историю
    computationHistory.add(List.from(newProbabilities));
    
    // Обновление вероятностного вектора
    probabilityVector = newProbabilities;
    
    return {
      'collapsed_vector': probabilityVector,
      'material_state': materialVector,
      'predictive_vector': computationalVector,
      'computation_id': computationHistory.length,
      'entropy': _calculateEntropy(),
    };
  }

  double _calculateVectorLength() {
    return probabilityVector.map((p) => p * p).reduce((a, b) => a + b);
  }

  double _collapseProbability(double probability) {
    // Детерминированное схлопывание на основе математических законов
    return (sin(probability * pi) + 1) / 2;
  }

  List<double> _calculateTokenWeights(List<String> tokens) {
    // Преобразование токенов в числовые веса
    return tokens.map((token) {
      final int hash = token.hashCode.abs();
      return (hash % 1000) / 1000.0;
    }).toList();
  }

  List<double> _computePredictiveVector(List<double> currentProbabilities) {
    // Нейросетевая предиктивная функция
    return currentProbabilities.map((p) {
      // Простая предиктивная модель - можно заменить на настоящую нейросеть
      return (p * 1.1) % 1.0;
    }).toList();
  }
double _calculateEntropy() {
  return -probabilityVector.map((p) => p > 0 ? p * log(p) : 0.0).reduce((a, b) => a + b);
}
  // Сохранение состояния
  Map<String, dynamic> toJson() {
    return {
      'material_vector': materialVector,
      'probability_vector': probabilityVector,
      'computational_vector': computationalVector,
      'computation_history': computationHistory,
    };
  }

  factory QuantumVector.fromJson(Map<String, dynamic> json) {
    return QuantumVector(
      materialVector: List<double>.from(json['material_vector']),
      probabilityVector: List<double>.from(json['probability_vector']),
      computationalVector: List<double>.from(json['computational_vector']),
      computationHistory: List<List<double>>.from(
        json['computation_history'].map((history) => List<double>.from(history))),
    );
  }
}

class QuantumApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  final QuantumVector quantumVector;
  
  QuantumApiService(this.quantumVector);

  // API endpoint для схлопывания вектора
  Future<Map<String, dynamic>> collapseProbabilityVector(Map<String, dynamic> request) async {
    try {
      final List<String> tokens = List<String>.from(request['tokens_all']);
      
      // Схлопывание вектора
      final Map<String, dynamic> result = quantumVector.collapseVector(tokens);
      
      // Сохранение в историю
      await _saveComputationHistory(result);
      
      return {
        'status': 'success',
        'computation_id': result['computation_id'],
        'collapsed_probabilities': result['collapsed_vector'],
        'material_state': result['material_state'],
        'predictive_future': result['predictive_vector'],
        'system_entropy': result['entropy'],
        'quantum_state': 'collapsed',
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
        'quantum_state': 'entangled',
      };
    }
  }

  // API для вычисления конкретной точки
  Future<Map<String, dynamic>> computePoint(Map<String, dynamic> request) async {
    final int targetIndex = request['target_index'];
    final int sourceIndex = request['source_index'];
    final double deltaT = request['delta_t'] ?? 0.1;
    
    final double result = quantumVector.computePointFromPoint(
      targetIndex, sourceIndex, deltaT);
    
    return {
      'target_point': targetIndex,
      'source_point': sourceIndex,
      'computed_value': result,
      'quantum_entanglement': 'resolved',
    };
  }

  // Сохранение истории вычислений
  Future<void> _saveComputationHistory(Map<String, dynamic> result) async {
    final Map<String, dynamic> historyEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'computation_id': result['computation_id'],
      'entropy': result['entropy'],
      'vector_dimension': quantumVector.probabilityVector.length,
    };
    
    // Здесь можно добавить сохранение в файл или базу данных
    if (kDebugMode) {
      print('Computation saved: $historyEntry');
    }
  }
}


class QuantumVectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QWa Neural Quantum Computer',
      theme: ThemeData.dark(),
      home: QuantumVectorPage(),
    );
  }
}

class QuantumVectorPage extends StatefulWidget {
  @override
  _QuantumVectorPageState createState() => _QuantumVectorPageState();
}

class _QuantumVectorPageState extends State<QuantumVectorPage> {
  final QuantumVector quantumVector = QuantumVector.initialize(10);
  final QuantumApiService apiService = QuantumApiService(QuantumVector.initialize(10));
  final QuantumNeuralNetworkForBites neuralNetwork = QuantumNeuralNetworkForBites(
    inputSize: 10,
    hiddenSize: 8,
    outputSize: 10,
  );
  
  final TextEditingController _tokensController = TextEditingController();
  String _computationResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QWa Neural Quantum System'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tokensController,
              decoration: InputDecoration(
                labelText: 'Введите токены (через запятую)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _collapseVector,
              child: Text('Схлопнуть Вектор Вероятности'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _computationResult,
                  style: TextStyle(fontFamily: 'Monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _collapseVector() async {
    final String tokensText = _tokensController.text;
    final List<String> tokens = tokensText.split(',').map((e) => e.trim()).toList();
    
    final Map<String, dynamic> request = {
      'tokens_all': tokens,
    };
    
    final Map<String, dynamic> result = await apiService.collapseProbabilityVector(request);
    
    setState(() {
      _computationResult = '''
Результат квантового вычисления:
Статус: ${result['status']}
ID вычисления: ${result['computation_id']}
Энтропия системы: ${result['system_entropy']?.toStringAsFixed(4)}
Квантовое состояние: ${result['quantum_state']}

Схлопнутые вероятности:
${_formatVector(result['collapsed_probabilities'])}

Материальное состояние:
${_formatVector(result['material_state'])}

Предиктивный вектор:
${_formatVector(result['predictive_future'])}
''';
    });
  }

  String _formatVector(List<dynamic> vector) {
    return vector.map((v) => v.toStringAsFixed(4)).join(' | ');
  }
}