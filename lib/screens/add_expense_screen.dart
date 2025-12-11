import 'package:flutter/material.dart';
import 'package:flutter_final_project_provincevu/models/category_model.dart';
import 'package:flutter_final_project_provincevu/models/giao_dich_model.dart';
import 'package:localstore/localstore.dart';

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
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final db = Localstore.instance;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _type = 'expense'; // 'expense' | 'income'
  Category? _selectedCategory;
  DateTime _selectedDateTime = DateTime.now();

  List<Category> _categories = []; // sẽ dùng dữ liệu từ Localstore

  bool get _isFormValid {
    final amount = _parseAmount(_amountController.text);
    return (amount != null && amount > 0) && _selectedCategory != null;
  }

  double? _parseAmount(String raw) {
    final t = raw.trim();
    return double.tryParse(t) ??
        double.tryParse(t.replaceAll('.', '').replaceAll(',', '.')) ??
        double.tryParse(t.replaceAll(',', ''));
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
      if (_selectedCategory != null && _selectedCategory!.type != _type) {
        _selectedCategory = null;
      }
    });
  }

  List<Category> get _categoriesForType {
    return _categories.where((c) => c.type == _type).take(8).toList();
  }

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (!mounted) return;

    setState(() {
      if (time != null) {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      } else {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      }
    });
  }

  void _submit() async {
    if (!_isFormValid) return;

    final amount = _parseAmount(_amountController.text) ?? 0;
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final transaction = Transaction(
      id: id,
      amount: amount,
      type: _type,
      category: _selectedCategory!.name,
      date: _selectedDateTime,
      note: _noteController.text.trim(),
    );

    // Ghi vào Localstore
    await db.collection('transactions').doc(id).set(transaction.toMap());

    Navigator.of(
      context,
    ).pop(transaction); // Có thể trả về cho HomeScreen cập nhật giao diện!
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

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
        title: const Text('Thêm giao dịch'),
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
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  hintText: 'Nhập số tiền',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

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

              // Chọn ngày giờ giao dịch
              InkWell(
                onTap: _pickDateTime,
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedDateTime.year}-${_selectedDateTime.month.toString().padLeft(2, '0')}-${_selectedDateTime.day.toString().padLeft(2, '0')} '
                      '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
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
