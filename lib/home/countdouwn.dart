import 'package:flutter/material.dart';

class CountdownWidget2 extends StatefulWidget {
  final Map<String, dynamic> pangan;
  final int count;
  final void Function(int) onCountChanged;

  const CountdownWidget2({
    Key? key,
    required this.pangan,
    required this.count,
    required this.onCountChanged,
  }) : super(key: key);

  @override
  State<CountdownWidget2> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget2> {
  // Remove the 'price' variable

  void increment() {
    setState(() {
      widget.onCountChanged(widget.count + 1);
    });
  }

  void decrement() {
    setState(() {
      if (widget.count > 1) {
        widget.onCountChanged(widget.count - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: decrement,
          icon: const Icon(Icons.remove),
        ),
        Text(
          '${widget.count}',
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          onPressed: increment,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
