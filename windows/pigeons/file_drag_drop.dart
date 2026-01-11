import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class FileDragDropApi {
  void onDragStart();
  void onDragEnd();
}