import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/transaction_service.dart';

/// Routes cho API giao dịch
class TransactionRoutes {
  final TransactionService _service;

  TransactionRoutes(this._service);

  Router get router {
    final router = Router();

    // GET /transactions - Lấy tất cả giao dịch
    router.get('/', (Request req) {
      final transactions = _service.getAll();
      return Response.ok(
        jsonEncode({'data': transactions.map((t) => t.toJson()).toList()}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // GET /transactions/<id> - Lấy giao dịch theo ID
    router.get('/<id>', (Request req, String id) {
      final tx = _service.getById(id);
      if (tx == null) {
        return Response.notFound(
          jsonEncode({'error': 'Không tìm thấy giao dịch'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode({'data': tx.toJson()}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // POST /transactions - Tạo giao dịch mới
    router.post('/', (Request req) async {
      try {
        final body = await req.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final tx = _service.create(data);
        return Response(
          201,
          body: jsonEncode(
              {'message': 'Tạo giao dịch thành công', 'data': tx.toJson()}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Dữ liệu không hợp lệ: $e'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    // PUT /transactions/<id> - Cập nhật giao dịch
    router.put('/<id>', (Request req, String id) async {
      try {
        final body = await req.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final tx = _service.update(id, data);
        if (tx == null) {
          return Response.notFound(
            jsonEncode({'error': 'Không tìm thấy giao dịch'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
        return Response.ok(
          jsonEncode({'message': 'Cập nhật thành công', 'data': tx.toJson()}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Dữ liệu không hợp lệ: $e'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    // DELETE /transactions/<id> - Xoá giao dịch
    router.delete('/<id>', (Request req, String id) {
      final deleted = _service.delete(id);
      if (!deleted) {
        return Response.notFound(
          jsonEncode({'error': 'Không tìm thấy giao dịch'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode({'message': 'Xoá giao dịch thành công'}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // GET /transactions/stats/summary - Thống kê tổng quan
    router.get('/stats/summary', (Request req) {
      return Response.ok(
        jsonEncode({
          'data': {
            'totalIncome': _service.getTotalIncome(),
            'totalExpense': _service.getTotalExpense(),
            'balance': _service.getBalance(),
          }
        }),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // GET /transactions/stats/last7days - Chi tiêu 7 ngày gần đây
    router.get('/stats/last7days', (Request req) {
      return Response.ok(
        jsonEncode({'data': _service.getLast7DaysExpense()}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // GET /transactions/month/<year>/<month> - Giao dịch theo tháng
    router.get('/month/<year>/<month>',
        (Request req, String year, String month) {
      final txs = _service.getByMonth(int.parse(year), int.parse(month));
      return Response.ok(
        jsonEncode({'data': txs.map((t) => t.toJson()).toList()}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
