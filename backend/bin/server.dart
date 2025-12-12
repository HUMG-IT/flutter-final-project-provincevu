import 'dart:convert';
import 'dart:io';

import 'package:backend/src/routes/category_routes.dart';
import 'package:backend/src/routes/transaction_routes.dart';
import 'package:backend/src/services/category_service.dart';
import 'package:backend/src/services/transaction_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

final _jsonHeaders = {'Content-Type': 'application/json; charset=utf-8'};

void main(List<String> args) async {
  // Khởi tạo services
  final transactionService = TransactionService();
  final categoryService = CategoryService();

  // Khởi tạo routes
  final transactionRoutes = TransactionRoutes(transactionService);
  final categoryRoutes = CategoryRoutes(categoryService);

  // Router chính
  final app = Router();

  // Mount các routes
  app.mount('/api/v1/transactions', transactionRoutes.router.call);
  app.mount('/api/v1/categories', categoryRoutes.router.call);

  // Root endpoint
  app.get('/', (Request req) {
    return Response.ok(
      jsonEncode({
        'message': 'Chào mừng đến với API Quản lý Chi tiêu!',
        'version': '1.0.0',
        'endpoints': {
          'transactions': '/api/v1/transactions',
          'categories': '/api/v1/categories',
        }
      }),
      headers: _jsonHeaders,
    );
  });

  // Health check
  app.get('/health', (Request req) {
    return Response.ok(
      jsonEncode(
          {'status': 'ok', 'timestamp': DateTime.now().toIso8601String()}),
      headers: _jsonHeaders,
    );
  });

  // 404 handler
  app.all('/<ignored|.*>', (Request req) {
    return Response.notFound(
      jsonEncode({'error': 'Không tìm thấy đường dẫn ${req.url}'}),
      headers: _jsonHeaders,
    );
  });

  // Pipeline: CORS -> Log -> Router
  final handler = const Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(app.call);

  // Start server
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);

  print('Server đang chạy tại http://${server.address.host}:${server.port}');
  print('API Endpoints:');
  print('   - GET  /api/v1/transactions');
  print('   - POST /api/v1/transactions');
  print('   - GET  /api/v1/categories');
  print('   - GET  /health');

  // Graceful shutdown
  ProcessSignal.sigint.watch().listen((_) async {
    print('Đang tắt server...');
    await server.close(force: true);
    print('Server đã dừng.');
    exit(0);
  });
}
