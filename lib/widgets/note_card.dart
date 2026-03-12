import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onFavorite;
  final bool highlight;

  const NoteCard({super.key, required this.note, this.onTap, this.onLongPress, this.onFavorite, this.highlight = false});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails _) {
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = _pressed ? 0.995 : 1.0;
    final boxShadow = _pressed
        ? [
            BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 6, offset: const Offset(0, 3)),
          ]
        : [
            BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4)),
          ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      transform: Matrix4.identity()..scale(scale, scale),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.note.isPinned)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 2.0),
                    child: Icon(Icons.insert_drive_file, size: 18, color: Colors.red),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.note.title.isEmpty ? '(Sin título)' : widget.note.title,
                        style: theme.textTheme.titleMedium?.copyWith(color: widget.highlight ? Colors.white : theme.textTheme.titleMedium?.color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.note.content.isEmpty ? '(Sin descripción)' : widget.note.content,
                        style: theme.textTheme.bodyMedium?.copyWith(color: widget.highlight ? Colors.white70 : theme.textTheme.bodyMedium?.color),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.note.updatedAt.toLocal().toString().split('.').first,
                      style: theme.textTheme.bodySmall?.copyWith(color: widget.highlight ? Colors.white70 : theme.textTheme.bodySmall?.color),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(widget.note.isPinned ? Icons.star : Icons.star_border, size: 20, color: widget.note.isPinned ? Colors.amber : theme.colorScheme.onSurface.withOpacity(0.6)),
                      onPressed: widget.onFavorite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
