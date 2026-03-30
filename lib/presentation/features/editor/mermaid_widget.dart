import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Widget that renders a Mermaid diagram using an embedded WebView.
class MermaidWidget extends StatefulWidget {
  const MermaidWidget({super.key, required this.code, this.isDark = false});

  final String code;
  final bool isDark;

  @override
  State<MermaidWidget> createState() => _MermaidWidgetState();
}

class _MermaidWidgetState extends State<MermaidWidget> {
  late final WebViewController _controller;
  double _height = 200;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (message) {
          final height = double.tryParse(message.message);
          if (height != null && mounted) {
            setState(() => _height = height + 32);
          }
        },
      )
      ..loadHtmlString(_buildHtml(widget.code, widget.isDark));
  }

  @override
  void didUpdateWidget(MermaidWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code || oldWidget.isDark != widget.isDark) {
      _controller.loadHtmlString(_buildHtml(widget.code, widget.isDark));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: WebViewWidget(controller: _controller),
      ),
    );
  }

  static String _buildHtml(String mermaidCode, bool isDark) {
    final escapedCode = mermaidCode
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');

    final bgColor = isDark ? '#1C1C1E' : '#FAFAFA';
    final mermaidTheme = isDark ? 'dark' : 'default';

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
  <style>
    body {
      margin: 0;
      padding: 16px;
      background: $bgColor;
      display: flex;
      justify-content: center;
      font-family: sans-serif;
    }
    .mermaid { max-width: 100%; }
  </style>
</head>
<body>
  <div class="mermaid">$escapedCode</div>
  <script>
    mermaid.initialize({ 
      startOnLoad: true,
      theme: '$mermaidTheme',
    });
    window.addEventListener('load', function() {
      var el = document.querySelector('.mermaid svg');
      if (el && window.Flutter) {
        window.Flutter.postMessage(el.getBoundingClientRect().height.toString());
      }
    });
  </script>
</body>
</html>
''';
  }
}
