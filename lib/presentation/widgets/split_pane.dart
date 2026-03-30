import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

/// A horizontally draggable split pane.
class SplitPane extends StatefulWidget {
  const SplitPane({
    super.key,
    required this.left,
    required this.right,
    this.initialSplit = 0.5,
  });

  final Widget left;
  final Widget right;

  /// Initial split ratio (0 = full left, 1 = full right).
  final double initialSplit;

  @override
  State<SplitPane> createState() => _SplitPaneState();
}

class _SplitPaneState extends State<SplitPane> {
  late double _splitRatio;
  double? _dragStartX;
  double? _dragStartRatio;
  double? _pendingRatio;

  @override
  void initState() {
    super.initState();
    _splitRatio = widget.initialSplit;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final leftWidth = totalWidth * _splitRatio;
        final rightWidth = totalWidth - leftWidth - AppConstants.sashWidth;

        return Row(
          children: [
            // Left pane
            SizedBox(
              width: leftWidth.clamp(
                AppConstants.minEditorWidth,
                totalWidth - AppConstants.minEditorWidth - AppConstants.sashWidth,
              ),
              child: widget.left,
            ),
            // Draggable sash
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                onHorizontalDragStart: (details) {
                  _dragStartX = details.globalPosition.dx;
                  _dragStartRatio = _splitRatio;
                },
                onHorizontalDragUpdate: (details) {
                  if (_dragStartX == null || _dragStartRatio == null) return;
                  final delta = details.globalPosition.dx - _dragStartX!;
                  final newRatio =
                      (_dragStartRatio! + delta / totalWidth).clamp(0.2, 0.8);
                  // Debounce: only store pending ratio, don't rebuild
                  setState(() {
                    _pendingRatio = newRatio;
                  });
                },
                onHorizontalDragEnd: (_) {
                  // Apply ratio on mouse release (performance optimization)
                  if (_pendingRatio != null) {
                    setState(() {
                      _splitRatio = _pendingRatio!;
                      _pendingRatio = null;
                    });
                  }
                  _dragStartX = null;
                  _dragStartRatio = null;
                },
                child: Container(
                  width: AppConstants.sashWidth,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      width: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
              ),
            ),
            // Right pane
            Expanded(child: widget.right),
          ],
        );
      },
    );
  }
}
