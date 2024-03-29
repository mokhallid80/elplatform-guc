import 'package:flutter/material.dart';
import '../../models/category.dart';

class CategoryElement extends StatefulWidget {
  final int index;
  final Category category;
  final bool asFilter;
  final VoidCallback? updateSheet;

  const CategoryElement(
      {super.key,
      required this.index,
      required this.category,
      required this.asFilter,
      this.updateSheet});

  @override
  State<CategoryElement> createState() => _CategoryElementState();
}

class _CategoryElementState extends State<CategoryElement> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          gradient: widget.category.selected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: widget.category.selected
              ? null
              : Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            widget.category.icon,
            const SizedBox(width: 5),
            Text(widget.category.name),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          widget.category.selected = true;
          widget.category.addCategory(widget.category, widget.asFilter);
          if (widget.updateSheet != null) {
            widget.updateSheet!();
          }
        });
      },
    );
  }
}
