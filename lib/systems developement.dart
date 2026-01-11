
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:elliptic/elliptic.dart';
import 'package:flutter/material.dart';

class WalletUI extends StatefulWidget {
  final CryptocurrencySystem cryptoSystem;

  const WalletUI({Key? key, required this.cryptoSystem}) : super(key: key);

  @override
  _WalletUIState createState() => _WalletUIState();
}

class _WalletUIState extends State<WalletUI> {
  String _currentAddress = '';
  String _privateKey = '';
  double _balance = 0.0;
  final TextEditingController _sendAmountController = TextEditingController();
  final TextEditingController _sendAddressController = TextEditingController();
  final TextEditingController _contributeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateWallet();
  }

  void _generateWallet() {
    final keyPair = widget.cryptoSystem.generateKeyPair();
    setState(() {
      _privateKey = keyPair['privateKey']!;
      _currentAddress = keyPair['address']!;
      _balance = widget.cryptoSystem.getBalance(_currentAddress);
    });
  }

  void _sendTransaction() {
    final amount = double.tryParse(_sendAmountController.text) ?? 0.0;
    final toAddress = _sendAddressController.text.trim();

    if (amount <= 0 || toAddress.isEmpty) {
      _showMessage('Please enter valid amount and address');
      return;
    }

    try {
      final transaction = widget.cryptoSystem.createTransfer(
        fromPrivateKey: _privateKey,
        toAddress: toAddress,
        amount: amount,
      );

      widget.cryptoSystem.addTransaction(transaction);
      widget.cryptoSystem.minePendingTransactions(_currentAddress);

      setState(() {
        _balance = widget.cryptoSystem.getBalance(_currentAddress);
        _sendAmountController.clear();
        _sendAddressController.clear();
      });

      _showMessage('Transaction sent successfully!');
    } catch (e) {
      _showMessage('Error: $e');
    }
  }

  void _contribute() {
    final contribution = _contributeController.text.trim();
    if (contribution.isEmpty) return;

    // Награда за контрибьюшн
    final rewardTransaction = Transaction(
      from: 'contribution_reward',
      to: _currentAddress,
      amount: 10.0, // Награда за контрибьюшн
      type: 'contribution',
      metadata: {'content': contribution},
    );

    widget.cryptoSystem.addTransaction(rewardTransaction);
    widget.cryptoSystem.minePendingTransactions(_currentAddress);

    setState(() {
      _balance = widget.cryptoSystem.getBalance(_currentAddress);
      _contributeController.clear();
    });

    _showMessage('Contribution rewarded!');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showTransactionHistory() {
    final history = widget.cryptoSystem.getTransactionHistory(_currentAddress);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction History'),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final tx = history[index];
              return ListTile(
                title: Text('${tx.type.toUpperCase()} - ${tx.amount} ${widget.cryptoSystem.coinName}'),
                subtitle: Text('To: ${tx.to}\n${DateTime.fromMillisecondsSinceEpoch(tx.timestamp)}'),
                trailing: Text(tx.amount > 0 ? '+' : '-'),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.cryptoSystem.getBlockchainStats();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.cryptoSystem.coinName} Wallet'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _showTransactionHistory,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {
              _balance = widget.cryptoSystem.getBalance(_currentAddress);
            }),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Баланс
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Your Balance',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${_balance.toStringAsFixed(2)} ${widget.cryptoSystem.coinName}',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _currentAddress,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Отправка
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send ${widget.cryptoSystem.coinName}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _sendAmountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _sendAddressController,
                      decoration: InputDecoration(
                        labelText: 'Recipient Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _sendTransaction,
                      child: Text('Send Transaction'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Контрибьюшн
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contribute to Network',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _contributeController,
                      decoration: InputDecoration(
                        labelText: 'Share content or file info',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _contribute,
                      child: Text('Contribute'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Статистика блокчейна
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blockchain Stats',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Blocks: ${stats['blocks']}'),
                    Text('Total Transactions: ${stats['transactions']}'),
                    Text('Pending: ${stats['pendingTransactions']}'),
                    Text('Chain Valid: ${stats['isValid'] ? 'Yes' : 'No'}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// Расширение для интеграции блокчейна с нейросетью
extension NeuralBlockchainIntegration on OptimizedNeuralNetwork {
  final CryptocurrencySystem cryptoSystem = CryptocurrencySystem();
  
  // Награда за нейро-активность
  void rewardNeuralActivity(String userId, double rating) {
    final reward = rating * 0.1; // 10% от рейтинга как награда
    
    final transaction = Transaction(
      from: 'neural_reward',
      to: userId,
      amount: reward,
      type: 'neural_activity',
      metadata: {
        'rating': rating,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    
    cryptoSystem.addTransaction(transaction);
  }
  
  // Награда за качественный контент
  void rewardContentCreation(String userId, String contentHash, double qualityScore) {
    final reward = qualityScore * 5.0;
    
    final transaction = Transaction(
      from: 'content_reward', 
      to: userId,
      amount: reward,
      type: 'content_creation',
      metadata: {
        'content_hash': contentHash,
        'quality_score': qualityScore,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    
    cryptoSystem.addTransaction(transaction);
  }
  
  // Валидация и награда
  void rewardValidation(String validatorId, String contentHash, bool isValid) {
    if (isValid) {
      final transaction = Transaction(
        from: 'validation_reward',
        to: validatorId,
        amount: 2.0,
        type: 'validation',
        metadata: {
          'content_hash': contentHash,
          'valid': true,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      
      cryptoSystem.addTransaction(transaction);
    }
  }
  
  // Получение баланса на основе нейро-рейтинга
  double getNeuralBalance(String userId) {
    final baseBalance = cryptoSystem.getBalance(userId);
    
    // Дополнительный бонус от нейро-рейтинга
    final neuralBonus = _calculateNeuralRating(userId) * 0.01;
    
    return baseBalance + neuralBonus;
  }
  
  double _calculateNeuralRating(String userId) {
    // Расчет рейтинга на основе активности в нейросети
    double rating = 0.0;
    
    // Активность в словах
    for (final word in words.values) {
      if (word.ratings.containsKey(int.tryParse(userId))) {
        rating += word.allRating * 0.001;
      }
    }
    
    // Активность в нейронах  
    for (final neuron in neurons.values) {
      if (neuron.id == int.tryParse(userId)) {
        rating += neuron.allRating * 0.01;
      }
    }
    
    return rating;
  }
}

// Основное приложение
class NeuralBlockchainApp extends StatelessWidget {
  final OptimizedNeuralNetwork neuralNetwork = OptimizedNeuralNetwork();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neural Blockchain System',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: WalletUI(cryptoSystem: neuralNetwork.cryptoSystem),
    );
  }
}


// ========== БАЗОВЫЕ СТРУКТУРЫ БЛОКЧЕЙНА ==========
class Transaction {
  final String id;
  final String from;
  final String to;
  final double amount;
  final int timestamp;
  final String signature;
  final String type; // 'transfer', 'contribution', 'validation'
  final Map<String, dynamic> metadata;

  Transaction({
    required this.from,
    required this.to,
    required this.amount,
    required this.type,
    this.metadata = const {},
    this.id = '',
    this.timestamp = 0,
    this.signature = '',
  }) : id = id.isEmpty ? _generateId() : id,
       timestamp = timestamp == 0 ? DateTime.now().millisecondsSinceEpoch : timestamp;

  static String _generateId() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return sha256.convert(bytes).toString();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'from': from,
    'to': to,
    'amount': amount,
    'timestamp': timestamp,
    'signature': signature,
    'type': type,
    'metadata': metadata,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    from: json['from'],
    to: json['to'],
    amount: (json['amount'] as num).toDouble(),
    timestamp: json['timestamp'],
    signature: json['signature'],
    type: json['type'],
    metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
  );

  String get hashData => '$from$to$amount$timestamp$type${jsonEncode(metadata)}';
}

class Block {
  final int index;
  final String previousHash;
  final int timestamp;
  final List<Transaction> transactions;
  final String hash;
  final int nonce;
  final String merkleRoot;

  Block({
    required this.index,
    required this.previousHash,
    required this.timestamp,
    required this.transactions,
    required this.hash,
    required this.nonce,
  }) : merkleRoot = _calculateMerkleRoot(transactions);

  static String _calculateMerkleRoot(List<Transaction> transactions) {
    if (transactions.isEmpty) return sha256.convert([]).toString();
    
    List<String> hashes = transactions.map((tx) => tx.id).toList();
    
    while (hashes.length > 1) {
      List<String> newHashes = [];
      for (int i = 0; i < hashes.length; i += 2) {
        if (i + 1 < hashes.length) {
          newHashes.add(sha256.convert(utf8.encode(hashes[i] + hashes[i + 1])).toString());
        } else {
          newHashes.add(hashes[i]);
        }
      }
      hashes = newHashes;
    }
    
    return hashes.first;
  }

  Map<String, dynamic> toJson() => {
    'index': index,
    'previousHash': previousHash,
    'timestamp': timestamp,
    'transactions': transactions.map((tx) => tx.toJson()).toList(),
    'hash': hash,
    'nonce': nonce,
    'merkleRoot': merkleRoot,
  };

  factory Block.fromJson(Map<String, dynamic> json) => Block(
    index: json['index'],
    previousHash: json['previousHash'],
    timestamp: json['timestamp'],
    transactions: (json['transactions'] as List)
        .map((tx) => Transaction.fromJson(tx))
        .toList(),
    hash: json['hash'],
    nonce: json['nonce'],
  );
}

// ========== КРИПТОВАЛЮТНАЯ СИСТЕМА ==========
class CryptocurrencySystem {
  final List<Block> blockchain = [];
  final List<Transaction> pendingTransactions = [];
  final Map<String, double> balances = {};
  final int difficulty = 4;
  final double miningReward = 50.0;
  final String coinName = 'NEUROCOIN';

  // Криптография
  final ec = getP256();
  final Random random = Random.secure();

  CryptocurrencySystem() {
    _createGenesisBlock();
  }

  void _createGenesisBlock() {
    final genesisTransactions = [
      Transaction(
        from: 'genesis',
        to: 'foundation',
        amount: 1000000,
        type: 'genesis',
        timestamp: 1640995200000, // 1 Jan 2022
      )
    ];

    final genesisBlock = Block(
      index: 0,
      previousHash: '0',
      timestamp: 1640995200000,
      transactions: genesisTransactions,
      hash: _calculateHash(0, '0', 1640995200000, genesisTransactions, 0),
      nonce: 0,
    );

    blockchain.add(genesisBlock);
    _updateBalances(genesisTransactions);
  }

  String _calculateHash(int index, String previousHash, int timestamp, 
                       List<Transaction> transactions, int nonce) {
    final data = '$index$previousHash$timestamp${transactions.map((t) => t.id).join()}${transience}';
    return sha256.convert(utf8.encode(data)).toString();
  }

  Block _mineBlock(List<Transaction> transactions) {
    final previousBlock = blockchain.last;
    final previousHash = previousBlock.hash;
    final index = previousBlock.index + 1;
    int nonce = 0;
    String hash = '';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Proof of Work
    final target = '0' * difficulty;
    while (true) {
      hash = _calculateHash(index, previousHash, timestamp, transactions, nonce);
      if (hash.substring(0, difficulty) == target) {
        break;
      }
      nonce++;
    }

    // Mining reward
    final miningTransaction = Transaction(
      from: 'mining_reward',
      to: _getMinerAddress(), // В реальной системе это адрес майнера
      amount: miningReward,
      type: 'mining',
    );

    final blockTransactions = [miningTransaction, ...transactions];

    return Block(
      index: index,
      previousHash: previousHash,
      timestamp: timestamp,
      transactions: blockTransactions,
      hash: hash,
      nonce: nonce,
    );
  }

  String _getMinerAddress() {
    // В реальной системе это будет адрес текущего узла
    return 'miner_${DateTime.now().millisecondsSinceEpoch}';
  }

  void addTransaction(Transaction transaction) {
    // Проверка подписи
    if (!_verifyTransaction(transaction)) {
      throw Exception('Invalid transaction signature');
    }

    // Проверка баланса
    if (transaction.type == 'transfer') {
      final senderBalance = getBalance(transaction.from);
      if (senderBalance < transaction.amount) {
        throw Exception('Insufficient balance');
      }
    }

    pendingTransactions.add(transaction);
  }

  bool _verifyTransaction(Transaction transaction) {
    if (transaction.type == 'mining' || transaction.type == 'genesis') {
      return true;
    }

    try {
      final publicKey = ec.keyFromPublic(transaction.from);
      final signature = ECSignature.fromBase64(transaction.signature);
      final message = utf8.encode(transaction.hashData);
      return ec.verify(publicKey, message, signature);
    } catch (e) {
      return false;
    }
  }

  void minePendingTransactions(String minerAddress) {
    if (pendingTransactions.isEmpty) return;

    final block = _mineBlock(List.from(pendingTransactions));
    blockchain.add(block);
    _updateBalances(block.transactions);
    pendingTransactions.clear();
  }

  void _updateBalances(List<Transaction> transactions) {
    for (final transaction in transactions) {
      if (transaction.type != 'genesis' && transaction.from != 'mining_reward') {
        balances[transaction.from] = (balances[transaction.from] ?? 0) - transaction.amount;
      }
      balances[transaction.to] = (balances[transaction.to] ?? 0) + transaction.amount;
    }
  }

  double getBalance(String address) {
    return balances[address] ?? 0.0;
  }

  bool isChainValid() {
    for (int i = 1; i < blockchain.length; i++) {
      final currentBlock = blockchain[i];
      final previousBlock = blockchain[i - 1];

      // Проверка хеша предыдущего блока
      if (currentBlock.previousHash != previousBlock.hash) {
        return false;
      }

      // Проверка хеша текущего блока
      final calculatedHash = _calculateHash(
        currentBlock.index,
        currentBlock.previousHash,
        currentBlock.timestamp,
        currentBlock.transactions,
        currentBlock.nonce,
      );

      if (currentBlock.hash != calculatedHash) {
        return false;
      }

      // Проверка Merkle root
      if (currentBlock.merkleRoot != Block._calculateMerkleRoot(currentBlock.transactions)) {
        return false;
      }
    }
    return true;
  }

  // Генерация ключевой пары
  Map<String, String> generateKeyPair() {
    final privateKey = ec.generatePrivateKey();
    final publicKey = privateKey.publicKey;
    
    return {
      'privateKey': privateKey.toHex(),
      'publicKey': publicKey.toHex(),
      'address': _publicKeyToAddress(publicKey),
    };
  }

  String _publicKeyToAddress(PublicKey publicKey) {
    final publicKeyHex = publicKey.toHex();
    return '0x${sha256.convert(utf8.encode(publicKeyHex)).toString().substring(0, 40)}';
  }

  // Подпись транзакции
  String signTransaction(String privateKeyHex, Transaction transaction) {
    final privateKey = ec.keyFromPrivate(privateKeyHex);
    final message = utf8.encode(transaction.hashData);
    final signature = ec.sign(privateKey, message);
    return signature.toBase64();
  }

  // Создание транзакции перевода
  Transaction createTransfer({
    required String fromPrivateKey,
    required String toAddress,
    required double amount,
    Map<String, dynamic> metadata = const {},
  }) {
    final keyPair = generateKeyPair();
    final fromAddress = _publicKeyToAddress(ec.keyFromPrivate(fromPrivateKey).publicKey);
    
    final transaction = Transaction(
      from: fromAddress,
      to: toAddress,
      amount: amount,
      type: 'transfer',
      metadata: metadata,
    );

    final signature = signTransaction(fromPrivateKey, transaction);
    
    return Transaction(
      from: fromAddress,
      to: toAddress,
      amount: amount,
      type: 'transfer',
      metadata: metadata,
      id: transaction.id,
      timestamp: transaction.timestamp,
      signature: signature,
    );
  }

  // Получение истории транзакций для адреса
  List<Transaction> getTransactionHistory(String address) {
    final history = <Transaction>[];
    
    for (final block in blockchain) {
      for (final transaction in block.transactions) {
        if (transaction.from == address || transaction.to == address) {
          history.add(transaction);
        }
      }
    }
    
    for (final transaction in pendingTransactions) {
      if (transaction.from == address || transaction.to == address) {
        history.add(transaction);
      }
    }
    
    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return history;
  }

  Map<String, dynamic> getBlockchainStats() {
    final totalTransactions = blockchain.fold(0, (sum, block) => sum + block.transactions.length);
    final totalCoins = balances.values.fold(0.0, (sum, balance) => sum + balance);
    
    return {
      'blocks': blockchain.length,
      'transactions': totalTransactions,
      'pendingTransactions': pendingTransactions.length,
      'totalCoins': totalCoins,
      'difficulty': difficulty,
      'miningReward': miningReward,
      'isValid': isChainValid(),
      'coinName': coinName,
    };
  }
}




class TorrentFile {
  final String hash;
  final String filename;
  final int size;
  final List<String> trackers;
  final Map<String, dynamic> info;
  final List<FilePiece> pieces;
  final DateTime createdAt;
  final List<String> tags;
  final double qualityRating;
  final String author;

  TorrentFile({
    required this.filename,
    required this.size,
    required this.trackers,
    required this.tags,
    required this.author,
    this.qualityRating = 0.0,
    String? hash,
    Map<String, dynamic>? info,
    List<FilePiece>? pieces,
    DateTime? createdAt,
  }) : hash = hash ?? _generateHash(filename + size.toString()),
       info = info ?? {},
       pieces = pieces ?? [],
       createdAt = createdAt ?? DateTime.now();

  static String _generateHash(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  Map<String, dynamic> toJson() => {
    'hash': hash,
    'filename': filename,
    'size': size,
    'trackers': trackers,
    'info': info,
    'pieces': pieces.map((p) => p.toJson()).toList(),
    'createdAt': createdAt.millisecondsSinceEpoch,
    'tags': tags,
    'qualityRating': qualityRating,
    'author': author,
  };

  factory TorrentFile.fromJson(Map<String, dynamic> json) => TorrentFile(
    filename: json['filename'],
    size: json['size'],
    trackers: List<String>.from(json['trackers']),
    tags: List<String>.from(json['tags']),
    author: json['author'],
    hash: json['hash'],
    info: Map<String, dynamic>.from(json['info']),
    pieces: (json['pieces'] as List).map((p) => FilePiece.fromJson(p)).toList(),
    qualityRating: (json['qualityRating'] ?? 0.0).toDouble(),
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
  );
}

class FilePiece {
  final int index;
  final String hash;
  final int size;
  final List<String> peers;

  FilePiece({
    required this.index,
    required this.hash,
    required this.size,
    List<String>? peers,
  }) : peers = peers ?? [];

  Map<String, dynamic> toJson() => {
    'index': index,
    'hash': hash,
    'size': size,
    'peers': peers,
  };

  factory FilePiece.fromJson(Map<String, dynamic> json) => FilePiece(
    index: json['index'],
    hash: json['hash'],
    size: json['size'],
    peers: List<String>.from(json['peers']),
  );
}

class Peer {
  final String id;
  final String address;
  final int port;
  final DateTime lastSeen;
  final Map<String, double> sharedFiles; // fileHash -> progress
  final double trustRating;

  Peer({
    required this.address,
    required this.port,
    required this.trustRating,
    String? id,
    DateTime? lastSeen,
    Map<String, double>? sharedFiles,
  }) : id = id ?? _generateId(address + port.toString()),
       lastSeen = lastSeen ?? DateTime.now(),
       sharedFiles = sharedFiles ?? {};

  static String _generateId(String data) {
    return sha256.convert(utf8.encode(data)).toString().substring(0, 16);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'address': address,
    'port': port,
    'lastSeen': lastSeen.millisecondsSinceEpoch,
    'sharedFiles': sharedFiles,
    'trustRating': trustRating,
  };

  factory Peer.fromJson(Map<String, dynamic> json) => Peer(
    address: json['address'],
    port: json['port'],
    trustRating: (json['trustRating'] ?? 0.0).toDouble(),
    id: json['id'],
    lastSeen: DateTime.fromMillisecondsSinceEpoch(json['lastSeen']),
    sharedFiles: Map<String, double>.from(json['sharedFiles'] ?? {}),
  );
}

class P2PNetwork {
  final List<Peer> peers = [];
  final Map<String, TorrentFile> sharedFiles = {};
  final Map<String, List<String>> fileLocations = {}; // fileHash -> peerIds
  final Map<String, double> downloadProgress = {};
  final String localPeerId;
  final int localPort;
  final Random random = Random();

  P2PNetwork({this.localPort = 6881}) : localPeerId = Peer._generateId('local_${DateTime.now().millisecondsSinceEpoch}');

  // Публикация файла в сети
  Future<TorrentFile> shareFile(File file, List<String> tags, String author) async {
    final stat = await file.stat();
    final content = await file.readAsBytes();
    final fileHash = sha256.convert(content).toString();

    // Создание кусков файла
    final pieceSize = _calculatePieceSize(stat.size);
    final pieces = <FilePiece>[];

    for (int i = 0; i < content.length; i += pieceSize) {
      final end = min(i + pieceSize, content.length);
      final pieceData = content.sublist(i, end);
      final pieceHash = sha256.convert(pieceData).toString();

      pieces.add(FilePiece(
        index: i ~/ pieceSize,
        hash: pieceHash,
        size: end - i,
        peers: [localPeerId],
      ));
    }

    final torrentFile = TorrentFile(
      filename: path.basename(file.path),
      size: stat.size,
      trackers: ['tracker.neuro.net:8080', 'backup.neuro.net:8081'],
      tags: tags,
      author: author,
      pieces: pieces,
    );

    sharedFiles[fileHash] = torrentFile;
    fileLocations[fileHash] = [localPeerId];

    // Анонсируем файл трекерам
    for (final tracker in torrentFile.trackers) {
      _announceFile(tracker, fileHash);
    }

    return torrentFile;
  }

  int _calculatePieceSize(int fileSize) {
    if (fileSize < 1024 * 1024) return 16 * 1024; // 16KB для маленьких файлов
    if (fileSize < 10 * 1024 * 1024) return 64 * 1024; // 64KB для средних
    if (fileSize < 100 * 1024 * 1024) return 256 * 1024; // 256KB для больших
    return 1024 * 1024; // 1MB для очень больших
  }

  void _announceFile(String tracker, String fileHash) {
    // В реальной системе здесь будет HTTP запрос к трекеру
    print('Announcing file $fileHash to tracker $tracker');
  }

  // Поиск файлов по тегам
  List<TorrentFile> searchFiles(List<String> tags, {int limit = 50}) {
    return sharedFiles.values.where((file) {
      return tags.any((tag) => file.tags.contains(tag));
    }).take(limit).toList();
  }

  // Загрузка файла
  Future<File?> downloadFile(String fileHash, String downloadPath) async {
    final torrentFile = sharedFiles[fileHash];
    if (torrentFile == null) {
      print('File not found: $fileHash');
      return null;
    }

    downloadProgress[fileHash] = 0.0;
    final outputFile = File(downloadPath);
    final randomAccessFile = await outputFile.open(mode: FileMode.write);

    try {
      int downloadedPieces = 0;
      final totalPieces = torrentFile.pieces.length;

      for (final piece in torrentFile.pieces) {
        final pieceData = await _downloadPiece(fileHash, piece.index);
        if (pieceData != null) {
          await randomAccessFile.writeFrom(pieceData);
          downloadedPieces++;
          downloadProgress[fileHash] = downloadedPieces / totalPieces;
        } else {
          print('Failed to download piece ${piece.index}');
          return null;
        }
      }

      await randomAccessFile.close();
      downloadProgress.remove(fileHash);

      // Валидация скачанного файла
      final downloadedContent = await outputFile.readAsBytes();
      final downloadedHash = sha256.convert(downloadedContent).toString();

      if (downloadedHash == fileHash) {
        print('File downloaded and validated successfully');
        return outputFile;
      } else {
        print('File validation failed');
        await outputFile.delete();
        return null;
      }
    } catch (e) {
      await randomAccessFile.close();
      await outputFile.delete();
      rethrow;
    }
  }

  Future<Uint8List?> _downloadPiece(String fileHash, int pieceIndex) async {
    final torrentFile = sharedFiles[fileHash]!;
    final piece = torrentFile.pieces[pieceIndex];

    // Пробуем скачать с разных пиров
    for (final peerId in piece.peers) {
      try {
        final peer = peers.firstWhere((p) => p.id == peerId);
        final data = await _requestPieceFromPeer(peer, fileHash, pieceIndex);
        
        if (data != null) {
          // Проверяем хеш куска
          final dataHash = sha256.convert(data).toString();
          if (dataHash == piece.hash) {
            // Становимся источником для этого куска
            piece.peers.add(localPeerId);
            return data;
          }
        }
      } catch (e) {
        print('Failed to download piece from peer $peerId: $e');
      }
    }

    return null;
  }

  Future<Uint8List?> _requestPieceFromPeer(Peer peer, String fileHash, int pieceIndex) async {
    // В реальной системе здесь будет сетевое соединение с пиром
    // Имитируем загрузку
    await Future.delayed(Duration(milliseconds: 100 + random.nextInt(400)));
    
    // В реальной системе здесь будут реальные данные
    return Uint8List(1024); // Заглушка
  }

  // Обновление рейтинга доверия
  void updateTrustRating(String peerId, bool successfulDownload, double qualityScore) {
    final peerIndex = peers.indexWhere((p) => p.id == peerId);
    if (peerIndex != -1) {
      final peer = peers[peerIndex];
      final change = successfulDownload ? 0.1 : -0.2;
      final qualityBonus = qualityScore * 0.05;
      
      final newRating = (peer.trustRating + change + qualityBonus).clamp(0.0, 1.0);
      
      peers[peerIndex] = Peer(
        address: peer.address,
        port: peer.port,
        trustRating: newRating,
        id: peer.id,
        lastSeen: DateTime.now(),
        sharedFiles: peer.sharedFiles,
      );
    }
  }

  // Получение статистики сети
  Map<String, dynamic> getNetworkStats() {
    final totalFiles = sharedFiles.length;
    final totalPeers = peers.length;
    final totalSize = sharedFiles.values.fold<int>(0, (sum, file) => sum + file.size);
    final avgTrust = peers.isEmpty ? 0.0 : 
        peers.map((p) => p.trustRating).reduce((a, b) => a + b) / peers.length;

    return {
      'totalFiles': totalFiles,
      'totalPeers': totalPeers,
      'totalSize': totalSize,
      'averageTrust': avgTrust,
      'activeDownloads': downloadProgress.length,
      'localPeerId': localPeerId,
    };
  }
}


class FileConverter {
  static final Map<String, List<String>> supportedFormats = {
    'ebook': ['fb2', 'epub', 'pdf', 'mobi'],
    'document': ['docx', 'doc', 'txt', 'rtf'],
    'spreadsheet': ['xlsx', 'xls', 'csv'],
    'presentation': ['pptx', 'ppt'],
  };

  // Конвертация любого файла в HTML
  static Future<ConvertedFile> convertToHtml(File inputFile, {Map<String, dynamic>? options}) async {
    final extension = path.extension(inputFile.path).toLowerCase().replaceAll('.', '');
    final content = await inputFile.readAsBytes();
    
    switch (extension) {
      case 'txt':
        return _convertTxtToHtml(content, options);
      case 'fb2':
        return _convertFb2ToHtml(content, options);
      case 'pdf':
        return _convertPdfToHtml(content, options);
      case 'docx':
        return _convertDocxToHtml(content, options);
      case 'xlsx':
        return _convertXlsxToHtml(content, options);
      case 'epub':
        return _convertEpubToHtml(content, options);
      default:
        throw Exception('Unsupported file format: $extension');
    }
  }

  static Future<ConvertedFile> _convertTxtToHtml(List<int> content, Map<String, dynamic>? options) async {
    final text = utf8.decode(content);
    final lines = text.split('\n');
    
    final htmlBuffer = StringBuffer()
      ..write('<!DOCTYPE html><html><head><meta charset="utf-8">')
      ..write('<style>${_getDefaultStyles()}</style></head><body>')
      ..write('<div class="text-content">');
    
    for (final line in lines) {
      if (line.trim().isEmpty) {
        htmlBuffer.write('<br>');
      } else if (line.trim().length < 60 && !line.contains('.') && !line.contains(',')) {
        // Возможно заголовок
        htmlBuffer.write('<h2>${_escapeHtml(line)}</h2>');
      } else {
        htmlBuffer.write('<p>${_escapeHtml(line)}</p>');
      }
    }
    
    htmlBuffer.write('</div></body></html>');
    
    return ConvertedFile(
      content: utf8.encode(htmlBuffer.toString()),
      format: 'html',
      originalFormat: 'txt',
      metadata: {
        'lines': lines.length,
        'characters': text.length,
        'convertedAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static Future<ConvertedFile> _convertFb2ToHtml(List<int> content, Map<String, dynamic>? options) async {
    final text = utf8.decode(content);
    
    // Простой парсинг FB2
    final htmlBuffer = StringBuffer()
      ..write('<!DOCTYPE html><html><head><meta charset="utf-8">')
      ..write('<style>${_getDefaultStyles()}</style></head><body>')
      ..write('<div class="fb2-content">');
    
    // Извлекаем заголовок
    final titleMatch = RegExp(r'<title>([^<]+)</title>').firstMatch(text);
    if (titleMatch != null) {
      htmlBuffer.write('<h1>${_escapeHtml(titleMatch.group(1)!)}</h1>');
    }
    
    // Извлекаем параграфы
    final paragraphMatches = RegExp(r'<p[^>]*>([^<]+)</p>').allMatches(text);
    for (final match in paragraphMatches) {
      htmlBuffer.write('<p>${_escapeHtml(match.group(1)!)}</p>');
    }
    
    htmlBuffer.write('</div></body></html>');
    
    return ConvertedFile(
      content: utf8.encode(htmlBuffer.toString()),
      format: 'html',
      originalFormat: 'fb2',
      metadata: {
        'paragraphs': paragraphMatches.length,
        'convertedAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static Future<ConvertedFile> _convertPdfToHtml(List<int> content, Map<String, dynamic>? options) async {
    // Заглушка для PDF конвертации - в реальной системе используйте pdf.js или подобное
    return ConvertedFile(
      content: utf8.encode('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <style>${_getDefaultStyles()}</style>
        </head>
        <body>
          <div class="pdf-notice">
            <h2>PDF Conversion Notice</h2>
            <p>PDF files require external libraries for proper conversion.</p>
            <p>File size: ${content.length} bytes</p>
            <p>Consider using browser-based PDF.js for better results.</p>
          </div>
        </body>
        </html>
      '''),
      format: 'html',
      originalFormat: 'pdf',
      metadata: {
        'size': content.length,
        'convertedAt': DateTime.now().millisecondsSinceEpoch,
        'note': 'PDF conversion requires external libraries',
      },
    );
  }

  static Future<ConvertedFile> _convertDocxToHtml(List<int> content, Map<String, dynamic>? options) async {
    // Заглушка для DOCX конвертации
    return ConvertedFile(
      content: utf8.encode('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <style>${_getDefaultStyles()}</style>
        </head>
        <body>
          <div class="docx-notice">
            <h2>DOCX File</h2>
            <p>DOCX conversion requires specialized libraries.</p>
            <p>File size: ${content.length} bytes</p>
            <p>Consider using mammoth.js or similar libraries.</p>
          </div>
        </body>
        </html>
      '''),
      format: 'html',
      originalFormat: 'docx',
      metadata: {
        'size': content.length,
        'convertedAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static Future<ConvertedFile> _convertXlsxToHtml(List<int> content, Map<String, dynamic>? options) async {
    // Заглушка для Excel конвертации
    return ConvertedFile(
      content: utf8.encode('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <style>
            ${_getDefaultStyles()}
            table { border-collapse: collapse; width: 100%; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #f2f2f2; }
          </style>
        </head>
        <body>
          <div class="xlsx-notice">
            <h2>Spreadsheet File</h2>
            <p>Excel file conversion requires specialized parsing.</p>
            <p>File size: ${content.length} bytes</p>
            <table>
              <tr><th>Format</th><th>Status</th></tr>
              <tr><td>XLSX</td><td>Requires external library</td></tr>
            </table>
          </div>
        </body>
        </html>
      '''),
      format: 'html',
      originalFormat: 'xlsx',
      metadata: {
        'size': content.length,
        'convertedAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static Future<ConvertedFile> _convertEpubToHtml(List<int> content, Map<String, dynamic>? options) async {
    // Заглушка для EPUB конвертации
    return ConvertedFile(
      content: utf8.encode('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <style>${_getDefaultStyles()}</style>
        </head>
        <body>
          <div class="epub-notice">
            <h2>EPUB eBook</h2>
            <p>EPUB is a container format that requires specialized unpacking.</p>
            <p>File size: ${content.length} bytes</p>
            <p>Consider using epub.js for proper conversion.</p>
          </div>
        </body>
        </html>
      '''),
      format: 'html',
      originalFormat: 'epub',
      metadata: {
        'size': content.length,
        'convertedAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static String _getDefaultStyles() {
    return '''
      body { 
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        line-height: 1.6; 
        margin: 0; 
        padding: 20px; 
        background-color: #f5f5f5; 
      }
      .text-content, .fb2-content { 
        max-width: 800px; 
        margin: 0 auto; 
        background: white; 
        padding: 40px; 
        border-radius: 8px; 
        box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
      }
      h1, h2, h3 { 
        color: #333; 
        border-bottom: 2px solid #eee; 
        padding-bottom: 10px; 
      }
      p { 
        margin-bottom: 1em; 
        color: #555; 
      }
      .pdf-notice, .docx-notice, .xlsx-notice, .epub-notice {
        max-width: 600px;
        margin: 50px auto;
        background: white;
        padding: 30px;
        border-radius: 8px;
        text-align: center;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }
    ''';
  }

  static String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#039;');
  }
}

class ConvertedFile {
  final List<int> content;
  final String format;
  final String originalFormat;
  final Map<String, dynamic> metadata;

  ConvertedFile({
    required this.content,
    required this.format,
    required this.originalFormat,
    this.metadata = const {},
  });

  String get htmlContent => utf8.decode(content);
  
  Future<File> saveToFile(String filePath) async {
    final file = File(filePath);
    await file.writeAsBytes(content);
    return file;
  }
}


class TaggingSystem {
  static final Map<String, List<String>> genreTags = {
    // Книги
    'books': [
      'fiction', 'non-fiction', 'science-fiction', 'fantasy', 'mystery',
      'romance', 'thriller', 'horror', 'historical', 'biography',
      'self-help', 'science', 'technology', 'philosophy', 'poetry',
      'drama', 'comedy', 'adventure', 'young-adult', 'children',
      'classic', 'contemporary', 'literary', 'crime', 'western',
      'dystopian', 'utopian', 'magical-realism', 'graphic-novel', 'manga',
      // Поджанры фантастики
      'space-opera', 'cyberpunk', 'steampunk', 'alternate-history',
      'post-apocalyptic', 'military-sf', 'social-sf', 'hard-sf', 'soft-sf',
      // Поджанры фэнтези
      'high-fantasy', 'low-fantasy', 'urban-fantasy', 'dark-fantasy',
      'epic-fantasy', 'sword-and-sorcery', 'mythology', 'fairy-tale',
      // Поджанры детектива
      'police-procedural', 'cozy-mystery', 'noir', 'legal-thriller',
      'medical-thriller', 'spy-thriller', 'psychological-thriller',
    ],
    
    // Фильмы и сериалы
    'movies_tv': [
      'action', 'adventure', 'animation', 'comedy', 'crime',
      'documentary', 'drama', 'family', 'fantasy', 'film-noir',
      'historical', 'horror', 'musical', 'mystery', 'romance',
      'sci-fi', 'sport', 'thriller', 'war', 'western',
      'biographical', 'disaster', 'superhero', 'zombie', 'vampire',
      'martial-arts', 'slasher', 'found-footage', 'mockumentary',
      // Телевизионные жанры
      'reality-tv', 'talk-show', 'game-show', 'news', 'cooking',
      'travel', 'home-and-garden', 'true-crime', 'docuseries',
      // Анимационные жанры
      'anime', 'cartoon', 'stop-motion', 'cgi', 'claymation',
    ],
    
    // Игры
    'games': [
      'action', 'adventure', 'role-playing', 'simulation', 'strategy',
      'sports', 'racing', 'puzzle', 'idle', 'arcade',
      'platformer', 'shooter', 'fighting', 'survival', 'horror',
      'stealth', 'rhythm', 'educational', 'visual-novel', 'dating-sim',
      'mmorpg', 'moba', 'battle-royale', 'sandbox', 'open-world',
      'roguelike', 'metroidvania', 'souls-like', 'retro', 'indie',
      // Поджанры RPG
      'jrpg', 'wrpg', 'action-rpg', 'tactical-rpg', 'mmorpg',
      // Поджанры стратегий
      'rts', 'tbs', '4x', 'tower-defense', 'grand-strategy',
    ],
    
    // Музыка
    'music': [
      'rock', 'pop', 'hip-hop', 'rap', 'jazz', 'blues', 'classical',
      'electronic', 'dance', 'country', 'r&b', 'soul', 'reggae',
      'folk', 'world', 'latin', 'metal', 'punk', 'indie',
      'alternative', 'ambient', 'chillout', 'dubstep', 'house',
      'techno', 'trance', 'drum-and-bass', 'hardcore', 'opera',
      'orchestral', 'soundtrack', 'game-music', 'chiptune', 'lo-fi',
      // Поджанры рока
      'classic-rock', 'hard-rock', 'progressive-rock', 'psychedelic-rock',
      'alternative-rock', 'grunge', 'post-rock', 'math-rock',
      // Поджанры метала
      'heavy-metal', 'death-metal', 'black-metal', 'power-metal',
      'progressive-metal', 'doom-metal', 'folk-metal', 'symphonic-metal',
    ],
    
    // Научные и образовательные
    'academic': [
      'mathematics', 'physics', 'chemistry', 'biology', 'astronomy',
      'geology', 'meteorology', 'oceanography', 'ecology', 'genetics',
      'neuroscience', 'psychology', 'sociology', 'anthropology',
      'economics', 'political-science', 'history', 'archaeology',
      'linguistics', 'philosophy', 'computer-science', 'engineering',
      'medicine', 'public-health', 'education', 'law', 'business',
      'art-history', 'music-theory', 'literary-criticism', 'cultural-studies',
      // Уровни образования
      'elementary', 'middle-school', 'high-school', 'undergraduate',
      'graduate', 'phd', 'research', 'textbook', 'reference',
    ],
  };

  static final Map<String, double> genreWeights = {
    // Веса для разных жанров (влияют на рейтинг)
    'scientific': 1.5,
    'educational': 1.3,
    'classic': 1.2,
    'research': 1.4,
    'academic': 1.3,
    'fiction': 0.8,
    'entertainment': 0.7,
    'game': 0.6,
  };

  // Автоматическое определение тегов по контенту
  static List<String> autoTagContent(String content, {String contentType = 'text'}) {
    final tags = <String>[];
    final lowerContent = content.toLowerCase();
    
    // Поиск по всем жанрам
    for (final category in genreTags.entries) {
      for (final tag in category.value) {
        if (_containsTag(lowerContent, tag)) {
          tags.add(tag);
        }
      }
    }
    
    // Определение языка
    if (_containsCyrillic(content)) tags.add('russian');
    if (RegExp(r'\b(the|and|is|in|it|you|that|he|was|for)\b', caseSensitive: false).hasMatch(content)) {
      tags.add('english');
    }
    
    // Определение типа контента
    if (contentType == 'book') tags.addAll(['literature', 'reading']);
    if (contentType == 'movie') tags.addAll(['video', 'entertainment']);
    if (contentType == 'game') tags.addAll(['interactive', 'gaming']);
    if (contentType == 'music') tags.addAll(['audio', 'listening']);
    
    // Уникальные теги
    return tags.toSet().toList();
  }

  static bool _containsTag(String content, String tag) {
    final variations = [
      tag,
      tag.replaceAll('-', ' '),
      tag.replaceAll('-', ''),
    ];
    
    return variations.any((variation) => content.contains(variation));
  }

  static bool _containsCyrillic(String text) {
    return RegExp(r'[а-яА-ЯёЁ]').hasMatch(text);
  }

  // Расчет рейтинга качества на основе тегов
  static double calculateQualityRating(List<String> tags, int contentLength) {
    double baseRating = 0.5;
    
    // Бонус за научные/образовательные теги
    final academicTags = tags.where((tag) => 
      genreTags['academic']?.contains(tag) == true ||
      tag.contains('science') || 
      tag.contains('research') ||
      tag.contains('educational')
    ).length;
    
    baseRating += academicTags * 0.1;
    
    // Бонус за длину контента (логарифмический)
    if (contentLength > 1000) {
      baseRating += log(contentLength / 1000) * 0.05;
    }
    
    // Бонус за разнообразие тегов
    final uniqueCategories = _countUniqueCategories(tags);
    baseRating += uniqueCategories * 0.02;
    
    return baseRating.clamp(0.0, 1.0);
  }

  static int _countUniqueCategories(List<String> tags) {
    final categories = <String>{};
    
    for (final tag in tags) {
      for (final category in genreTags.entries) {
        if (category.value.contains(tag)) {
          categories.add(category.key);
          break;
        }
      }
    }
    
    return categories.length;
  }

  // Получение рекомендуемых тегов на основе существующих
  static List<String> getRecommendedTags(List<String> currentTags) {
    final recommendations = <String>{};
    
    for (final tag in currentTags) {
      // Ищем связанные теги в той же категории
      for (final category in genreTags.entries) {
        if (category.value.contains(tag)) {
          // Берем несколько случайных тегов из той же категории
          final relatedTags = category.value
            .where((t) => t != tag)
            .toList()
            ..shuffle();
          
          recommendations.addAll(relatedTags.take(3));
          break;
        }
      }
    }
    
    return recommendations.toList();
  }
}



class WikipediaSystem {
  static final String apiUrl = 'https://en.wikipedia.org/api/rest_v1/page/summary/';
  
  // Получение статьи из Wikipedia
  static Future<WikipediaArticle?> fetchArticle(String title) async {
    try {
      final response = await http.get(Uri.parse(apiUrl + Uri.encodeFull(title)));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WikipediaArticle.fromJson(data);
      }
    } catch (e) {
      print('Error fetching Wikipedia article: $e');
    }
    
    return null;
  }
  
  // Поиск статей
  static Future<List<WikipediaSearchResult>> searchArticles(String query) async {
    try {
      final searchUrl = 'https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=${Uri.encodeFull(query)}&format=json&srlimit=10';
      final response = await http.get(Uri.parse(searchUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = (data['query']['search'] as List).map((item) {
          return WikipediaSearchResult.fromJson(item);
        }).toList();
        
        return results;
      }
    } catch (e) {
      print('Error searching Wikipedia: $e');
    }
    
    return [];
  }
}

class WikipediaArticle {
  final String title;
  final String extract;
  final String? thumbnailUrl;
  final String fullUrl;
  final DateTime? timestamp;
  final List<String> categories;

  WikipediaArticle({
    required this.title,
    required this.extract,
    this.thumbnailUrl,
    required this.fullUrl,
    this.timestamp,
    this.categories = const [],
  });

  factory WikipediaArticle.fromJson(Map<String, dynamic> json) {
    return WikipediaArticle(
      title: json['title'] ?? '',
      extract: json['extract'] ?? '',
      thumbnailUrl: json['thumbnail']?['source'],
      fullUrl: json['content_urls']?['desktop']?['page'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      categories: List<String>.from(json['categories'] ?? []),
    );
  }

  // Преобразование в красивый HTML
  String toFormattedHtml() {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
          ${_getWikipediaStyles()}
        </style>
      </head>
      <body>
        <article class="wikipedia-article">
          <header>
            <h1>$title</h1>
            ${thumbnailUrl != null ? '<img src="$thumbnailUrl" alt="$title" class="article-thumbnail">' : ''}
          </header>
          <div class="article-content">
            ${_formatExtract(extract)}
          </div>
          <footer>
            <p class="source-link">
              Source: <a href="$fullUrl" target="_blank">Wikipedia</a>
            </p>
          </footer>
        </article>
      </body>
      </html>
    ''';
  }

  String _formatExtract(String extract) {
    // Простое форматирование текста
    return extract
        .split('\n')
        .map((paragraph) => paragraph.trim().isNotEmpty ? '<p>$paragraph</p>' : '')
        .join('');
  }

  static String _getWikipediaStyles() {
    return '''
      body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        line-height: 1.6;
        margin: 0;
        padding: 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
      }
      .wikipedia-article {
        max-width: 800px;
        margin: 0 auto;
        background: white;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        overflow: hidden;
      }
      .wikipedia-article header {
        background: linear-gradient(135deg, #36d1dc 0%, #5b86e5 100%);
        color: white;
        padding: 30px;
        text-align: center;
      }
      .wikipedia-article h1 {
        margin: 0 0 15px 0;
        font-size: 2.2em;
        font-weight: 300;
      }
      .article-thumbnail {
        max-width: 200px;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
      }
      .article-content {
        padding: 40px;
        color: #333;
      }
      .article-content p {
        margin-bottom: 1.2em;
        font-size: 1.1em;
        text-align: justify;
      }
      .article-content p:first-child {
        font-size: 1.2em;
        font-weight: 500;
        color: #2c3e50;
      }
      .source-link {
        text-align: center;
        padding: 20px;
        background: #f8f9fa;
        margin: 0;
        border-top: 1px solid #e9ecef;
      }
      .source-link a {
        color: #3498db;
        text-decoration: none;
        font-weight: 500;
      }
      .source-link a:hover {
        text-decoration: underline;
      }
    ''';
  }
}

class WikipediaSearchResult {
  final String title;
  final String snippet;
  final int pageId;
  final DateTime? timestamp;

  WikipediaSearchResult({
    required this.title,
    required this.snippet,
    required this.pageId,
    this.timestamp,
  });

  factory WikipediaSearchResult.fromJson(Map<String, dynamic> json) {
    return WikipediaSearchResult(
      title: json['title'] ?? '',
      snippet: _cleanSnippet(json['snippet'] ?? ''),
      pageId: json['pageid'] ?? 0,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  static String _cleanSnippet(String snippet) {
    // Удаление HTML тегов из сниппета
    final document = html_parser.parse(snippet);
    return document.body?.text ?? snippet.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}

// Виджет для встраивания Wikipedia тултипов
class WikipediaTooltipWidget extends StatefulWidget {
  final String word;
  final WikipediaArticle? article;
  final VoidCallback? onTap;

  const WikipediaTooltipWidget({
    Key? key,
    required this.word,
    this.article,
    this.onTap,
  }) : super(key: key);

  @override
  _WikipediaTooltipWidgetState createState() => _WikipediaTooltipWidgetState();
}

class _WikipediaTooltipWidgetState extends State<WikipediaTooltipWidget> {
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _showTooltip = true),
        onExit: (_) => setState(() => _showTooltip = false),
        child: Stack(
          children: [
            // Основной текст
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(3),
                color: Colors.blue.withOpacity(0.1),
              ),
              child: Text(
                widget.word,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue.withOpacity(0.5),
                ),
              ),
            ),
            
            // Всплывающий тултип
            if (_showTooltip && widget.article != null)
              Positioned(
                top: -10,
                left: 0,
                child: _buildTooltipContent(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltipContent() {
    return Container(
      width: 300,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.article!.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.article!.extract.length > 150
                ? '${widget.article!.extract.substring(0, 150)}...'
                : widget.article!.extract,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.source, size: 12, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Wikipedia',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Spacer(),
              Text(
                'Tap for details',
                style: TextStyle(fontSize: 10, color: Colors.blue, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }
}