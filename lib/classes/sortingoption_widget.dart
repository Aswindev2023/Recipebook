import 'package:flutter/material.dart';

class SortingOptionsWidget extends StatelessWidget {
  final void Function(bool) onSort;

  const SortingOptionsWidget({Key? key, required this.onSort})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Sort By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Time(Lowest to Highest)'),
            onTap: () {
              Navigator.pop(context);
              onSort(true);
            },
          ),
          ListTile(
            title: const Text('Time(Highest to Lowest)'),
            onTap: () {
              Navigator.pop(context);
              onSort(false);
            },
          ),
        ],
      ),
    );
  }
}
