import 'package:flutter/material.dart';

class DynamicIngredientField extends StatefulWidget {
  final List<String> initialIngredients;
  final String fieldName;
  final Function(List<String>) onIngredientsChanged;

  const DynamicIngredientField({
    Key? key,
    required this.initialIngredients,
    required this.fieldName,
    required this.onIngredientsChanged,
  }) : super(key: key);

  @override
  State<DynamicIngredientField> createState() => _DynamicIngredientFieldState();
}

class _DynamicIngredientFieldState extends State<DynamicIngredientField> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  @override
  void didUpdateWidget(DynamicIngredientField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIngredients != oldWidget.initialIngredients) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    setState(() {
      controllers = widget.initialIngredients
          .map((ingredient) => TextEditingController(text: ingredient))
          .toList();

      if (controllers.isEmpty) {
        controllers.add(TextEditingController());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fieldName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: controllers.length,
          itemBuilder: (context, index) {
            final controller = controllers[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Ingredient ${index + 1}',
                        hintText: 'Add Ingredient ${index + 1}',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (_) {
                        _notifyParent();
                      },
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an ingredient';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (controllers.length > 1 && index > 0)
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: controllers.length > 1
                          ? () {
                              setState(() {
                                controllers.removeAt(index);
                                _notifyParent();
                              });
                            }
                          : null,
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _addField,
            ),
          ],
        ),
      ],
    );
  }

  void _addField() {
    setState(() {
      controllers.add(TextEditingController());
      _notifyParent();
    });
  }

  void _notifyParent() {
    final ingredients =
        controllers.map((controller) => controller.text).toList();

    widget.onIngredientsChanged(ingredients);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
