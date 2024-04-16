import 'package:flutter/material.dart';

class DynamicStepField extends StatefulWidget {
  final List<String> initialFields;
  final String fieldName;
  final Function(List<String>) onStepsChanged;

  const DynamicStepField({
    Key? key,
    required this.initialFields,
    required this.fieldName,
    required this.onStepsChanged,
  }) : super(key: key);

  @override
  State<DynamicStepField> createState() => _DynamicStepFieldState();
}

class _DynamicStepFieldState extends State<DynamicStepField> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = widget.initialFields
        .map((step) => TextEditingController(text: step))
        .toList();

    if (controllers.isEmpty) {
      controllers.add(TextEditingController());
    }
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
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        labelText: 'Step ${index + 1}',
                        hintText: 'Add Step ${index + 1}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                          return 'Please enter a step';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (controllers.length > 1)
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
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: _addField,
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
    final steps = controllers.map((controller) => controller.text).toList();
    widget.onStepsChanged(steps);
  }

  /*void _updateSteps() {
    List<String> steps =
        controllers.map((controller) => controller.text).toList();
    widget.onStepsChanged(steps);
  }*/

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
