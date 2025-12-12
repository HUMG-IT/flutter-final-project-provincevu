import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localstore/localstore.dart';

import '../models/category_model.dart';
import '../models/giao_dich_model.dart';

// Map từ String sang IconData để dùng cho Category
const Map<String, IconData> categoryIconMap = {
  'restaurant': Icons.restaurant,
  'directions_car': Icons.directions_car,
  'health_and_safety': Icons.health_and_safety,
  'school': Icons.school,
  'family_restroom': Icons.family_restroom,
  'shopping_cart': Icons.shopping_cart,
  'pets': Icons.pets,
  'more_horiz': Icons.more_horiz,
  'paid': Icons.paid,
  'savings': Icons.savings,
  'card_giftcard': Icons.card_giftcard,
};

class AddExpenseScreen extends StatefulWidget {
  final Transaction? transactionToEdit;

  const AddExpenseScreen({super.key, this.transactionToEdit});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final db = Localstore.instance;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _type = 'expense'; // 'expense' | 'income'
  Category? _selectedCategory;
  bool _isEditMode = false;
  String? _editTransactionId;

  // Chỉ dùng ngày (không dùng giờ/phút). Mặc định là hôm nay.
  DateTime _selectedDate = DateTime.now();

  // Tùy chọn nhanh: 3 ngày gần nhất (hôm nay, hôm qua, hôm kia)
  late final List<DateTime> _quickDates;
  int _selectedQuickIndex = 0; // 0: hôm nay, 1: hôm qua, 2: hôm kia

  List<Category> _categories = []; // dữ liệu từ Localstore

  // Formatter cho TextField số tiền
  final _amountFormatter = ThousandsSeparatorInputFormatter();

  @override
  void initState() {
    super.initState();
    // Khởi tạo 3 ngày gần nhất
    final today = DateTime.now();
    _quickDates = [
      DateTime(today.year, today.month, today.day), // hôm nay
      DateTime(
        today.subtract(const Duration(days: 1)).year,
        today.subtract(const Duration(days: 1)).month,
        today.subtract(const Duration(days: 1)).day,
      ), // hôm qua
      DateTime(
        today.subtract(const Duration(days: 2)).year,
        today.subtract(const Duration(days: 2)).month,
        today.subtract(const Duration(days: 2)).day,
      ), // hôm kia
    ];
    _selectedDate = _quickDates[_selectedQuickIndex];

    // Nếu là chế độ edit, điền sẵn dữ liệu
    if (widget.transactionToEdit != null) {
      _isEditMode = true;
      _editTransactionId = widget.transactionToEdit!.id;
      _type = widget.transactionToEdit!.type;
      _amountController.text = widget.transactionToEdit!.amount
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]}.',
          );
      _noteController.text = widget.transactionToEdit!.note;
      _selectedDate = widget.transactionToEdit!.date;

      // Đồng bộ lựa chọn nhanh nếu trùng
      final idx = _quickDates.indexWhere(
        (d) =>
            d.year == _selectedDate.year &&
            d.month == _selectedDate.month &&
            d.day == _selectedDate.day,
      );
      _selectedQuickIndex = idx >= 0 ? idx : -1;
    }

    _fetchCategories();
  }

  bool get _isFormValid {
    final amount = _parseAmount(_amountController.text);
    return (amount != null && amount > 0) && _selectedCategory != null;
  }

  double? _parseAmount(String raw) {
    final t = raw.trim();
    // Luôn coi dấu chấm là phân cách hàng nghìn (format VN)
    // Loại bỏ tất cả dấu chấm và parse
    final normalized = t.replaceAll('.', '').replaceAll(',', '');
    return double.tryParse(normalized);
  }

  IconData _iconFromMap(String name) {
    return categoryIconMap[name] ?? Icons.category;
  }

  Future<void> _fetchCategories() async {
    final raw = await db.collection('categories').get();
    final cats = raw == null
        ? <Category>[]
        : raw.values.map((e) => Category.fromMap(e)).toList();

    setState(() {
      _categories = cats;

      // Nếu edit mode, tìm category tương ứng
      if (_isEditMode && widget.transactionToEdit != null) {
        final categoryName = widget.transactionToEdit!.category;
        _selectedCategory = cats.firstWhere(
          (c) => c.name == categoryName && c.type == _type,
          orElse: () => cats.firstWhere(
            (c) => c.name == categoryName,
            orElse: () => cats.first,
          ),
        );
      } else if (_selectedCategory != null &&
          _selectedCategory!.type != _type) {
        _selectedCategory = null;
      }
    });
  }

  List<Category> get _categoriesForType {
    return _categories.where((c) => c.type == _type).take(8).toList();
  }

  // Chỉ chọn ngày (không chọn giờ/phút) và KHÔNG được vượt quá ngày hiện tại
  Future<void> _pickDateOnly() async {
    final DateTime today = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(today)
          ? DateTime(today.year, today.month, today.day)
          : _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(
        today.year,
        today.month,
        today.day,
      ), // CHẶN ngày tương lai
    );
    if (!mounted || date == null) return;

    // Đảm bảo ngày chọn không vượt quá hôm nay (phòng trường hợp time zone)
    final safeDate = date.isAfter(today)
        ? DateTime(today.year, today.month, today.day)
        : DateTime(date.year, date.month, date.day);

    setState(() {
      _selectedDate = safeDate;
      // Đồng bộ lại lựa chọn nhanh nếu trùng một trong 3 ngày
      final idx = _quickDates.indexWhere(
        (d) =>
            d.year == _selectedDate.year &&
            d.month == _selectedDate.month &&
            d.day == _selectedDate.day,
      );
      _selectedQuickIndex = idx >= 0 ? idx : -1; // -1: ngày tùy chọn
    });
  }

  void _submit() async {
    if (!_isFormValid) return;

    final amount = _parseAmount(_amountController.text) ?? 0;
    // Nếu edit, giữ nguyên ID; nếu tạo mới, sinh ID mới
    final id = _isEditMode
        ? _editTransactionId!
        : DateTime.now().millisecondsSinceEpoch.toString();

    final transaction = Transaction(
      id: id,
      amount: amount,
      type: _type,
      category: _selectedCategory!.name,
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ), // chỉ ngày (00:00)
      note: _noteController.text.trim(),
    );

    await db.collection('transactions').doc(id).set(transaction.toMap());
    if (!mounted) return;
    Navigator.of(context).pop(transaction);
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categoriesForType;
    final row1 = categories.take(4).toList();
    final row2 = categories.skip(4).take(4).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_isEditMode ? 'Sửa giao dịch' : 'Thêm giao dịch'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            children: [
              // Loại giao dịch
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Chi tiêu'),
                      selected: _type == 'expense',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _type = 'expense';
                            if (_selectedCategory?.type != _type) {
                              _selectedCategory = null;
                            }
                          });
                        }
                      },
                      selectedColor: Colors.red.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: _type == 'expense' ? Colors.red : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Thu nhập'),
                      selected: _type == 'income',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _type = 'income';
                            if (_selectedCategory?.type != _type) {
                              _selectedCategory = null;
                            }
                          });
                        }
                      },
                      selectedColor: Colors.green.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: _type == 'income'
                            ? Colors.green
                            : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Nhập số tiền
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _amountFormatter,
                ],
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  hintText: 'Nhập số tiền',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Categories: 2 rows * 4 expanded each
              if (categories.isNotEmpty) ...[
                _CategoryRow(
                  categories: row1,
                  selected: _selectedCategory,
                  onSelected: (c) => setState(() => _selectedCategory = c),
                  iconResolver: _iconFromMap,
                ),
                const SizedBox(height: 8),
                _CategoryRow(
                  categories: row2,
                  selected: _selectedCategory,
                  onSelected: (c) => setState(() => _selectedCategory = c),
                  iconResolver: _iconFromMap,
                ),
              ] else ...[
                const Center(child: CircularProgressIndicator()),
              ],

              const SizedBox(height: 16),

              // Ghi chú
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  hintText: 'Nhập ghi chú (tuỳ chọn)',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Chọn ngày giao dịch (tùy chọn nhanh + chọn ngày thủ công, KHÔNG vượt quá hôm nay)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ngày giao dịch',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Hôm nay'),
                          selected: _selectedQuickIndex == 0,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedQuickIndex = 0;
                                _selectedDate = _quickDates[0];
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Hôm qua'),
                          selected: _selectedQuickIndex == 1,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedQuickIndex = 1;
                                _selectedDate = _quickDates[1];
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Hôm kia'),
                          selected: _selectedQuickIndex == 2,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedQuickIndex = 2;
                                _selectedDate = _quickDates[2];
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDateOnly,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(_selectedDate),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.edit_calendar,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Nút thêm
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Thêm'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final List<Category> categories;
  final Category? selected;
  final ValueChanged<Category> onSelected;
  final IconData Function(String name) iconResolver;

  const _CategoryRow({
    required this.categories,
    required this.selected,
    required this.onSelected,
    required this.iconResolver,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: categories.map((c) {
        final isSelected = selected?.id == c.id;
        return Expanded(
          child: InkWell(
            onTap: () => onSelected(c),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconResolver(c.icon),
                    color: isSelected ? Colors.blue : Colors.black87,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    c.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.blue : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Định dạng số có dấu chấm ngăn cách hàng nghìn khi nhập
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,##0", "vi_VN");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');
    final formatted = _formatter.format(int.parse(digits));
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
