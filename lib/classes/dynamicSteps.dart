import 'package:flutter/material.dart';

class DynamicStepField extends StatefulWidget {
  final List<String> initialFields;
  final String fieldName;
  final Function(List<String>)
      onStepsChanged; // Callback for user-entered steps

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
        .map((field) => TextEditingController(text: field))
        .toList();

    if (controllers.isEmpty) {
      controllers
          .add(TextEditingController()); // Add an initial empty step field
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a step';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: controllers.length > 1
                        ? () {
                            setState(() {
                              controllers.removeAt(index);
                              _updateSteps();
                            });
                          }
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 4),
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
    });
  }

  void _updateSteps() {
    List<String> steps =
        controllers.map((controller) => controller.text).toList();
    widget.onStepsChanged(steps); // Call the callback to update the steps
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
