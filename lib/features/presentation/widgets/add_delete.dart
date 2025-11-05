
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_web_dashboard/features/models/products_model.dart';
import 'package:products_web_dashboard/features/presentation/blocs/products_cubit.dart';

class AddEditProductDialog extends StatefulWidget {
  final Product? existing; // ✅ must match the constructor parameter

  const AddEditProductDialog({Key? key, this.existing}) : super(key: key);

  @override
  _AddEditProductDialogState createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtr;
  late TextEditingController _categoryCtr;
  late TextEditingController _priceCtr;
  late TextEditingController _stockCtr;

  @override
  void initState() {
    super.initState();
    _titleCtr = TextEditingController(text: widget.existing?.title ?? '');
    _categoryCtr =
        TextEditingController(text: widget.existing?.category ?? 'general');
    _priceCtr = TextEditingController(
        text:
            widget.existing != null ? widget.existing!.price.toString() : '0');
    _stockCtr = TextEditingController(
        text:
            widget.existing != null ? widget.existing!.stock.toString() : '0');
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Product' : 'Add Product'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
                controller: _titleCtr,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null),
            TextFormField(
                controller: _categoryCtr,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null),
            TextFormField(
                controller: _priceCtr,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    double.tryParse(v ?? '') == null ? 'Enter number' : null),
            TextFormField(
                controller: _stockCtr,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    int.tryParse(v ?? '') == null ? 'Enter integer' : null),
          ]),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final title = _titleCtr.text.trim();
            final category = _categoryCtr.text.trim();
            final price = double.parse(_priceCtr.text);
            final stock = int.parse(_stockCtr.text);
            final cubit = context.read<ProductCubit>();
            if (isEdit) {
              final updated = widget.existing!.copyWith(
                  title: title, category: category, price: price, stock: stock);
              cubit.updateProduct(updated);
            } else {
              final created = cubit.createLocalProduct(
                  title: title, category: category, price: price, stock: stock);
              cubit.addProduct(created);
            }
            Navigator.of(context).pop();
          },
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
