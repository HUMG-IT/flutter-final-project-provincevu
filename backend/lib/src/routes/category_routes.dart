import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/category_service.dart';

/// Routes cho API danh mục
class CategoryRoutes {
  final CategoryService _service;

  CategoryRoutes(this._service);

  Router get router {
    final router = Router();

    // GET /categories - Lấy tất cả danh mục
    router.get('/', (Request req) {
      final categories = _service.getAll();
      return Response.ok(
        jsonEncode({'data': categories.map((c) => c.toJson()).toList()}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // GET /categories/type/<type> - Lấy danh mục theo loại
    router.get('/type/<type>', (Request req, String type) {
      final categories = _service.getByType(type);
      return Response.ok(
        jsonEncode({'data': categories.map((c) => c.toJson()).toList()}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // GET /categories/<id> - Lấy danh mục theo ID
    router.get('/<id>', (Request req, String id) {
      final cat = _service.getById(id);
      if (cat == null) {
        return Response.notFound(
          jsonEncode({'error': 'Không tìm thấy danh mục'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode({'data': cat.toJson()}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // POST /categories - Tạo danh mục mới
    router.post('/', (Request req) async {
      try {
        final body = await req.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final cat = _service.create(data);
        return Response(
          201,
          body: jsonEncode(
              {'message': 'Tạo danh mục thành công', 'data': cat.toJson()}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Dữ liệu không hợp lệ: $e'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    // DELETE /categories/<id> - Xoá danh mục
    router.delete('/<id>', (Request req, String id) {
      final deleted = _service.delete(id);
      if (!deleted) {
        return Response.notFound(
          jsonEncode({'error': 'Không tìm thấy danh mục'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode({'message': 'Xoá danh mục thành công'}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
