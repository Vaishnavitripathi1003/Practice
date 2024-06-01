import 'package:flutter/material.dart';
import 'package:flutter_pdf_text/flutter_pdf_text.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfSearchPage extends StatefulWidget {
  final String pdfPath;

  PdfSearchPage({required this.pdfPath});

  @override
  _PdfSearchPageState createState() => _PdfSearchPageState();
}

class _PdfSearchPageState extends State<PdfSearchPage> {
  late PDFDoc _pdfDoc;
  String _text = '';
  List<int> _foundPages = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  void _initPdf() async {
    setState(() {
      _isLoading = true;
    });

    _pdfDoc = await PDFDoc.fromPath(widget.pdfPath);
    String text = await _pdfDoc.text;

    setState(() {
      _text = text;
      _isLoading = false;
    });
  }

  void _searchInPdf(String query) {
    if (query.isEmpty) return;
    List<int> foundPages = [];
    List<String> pages = _text.split('\n\n');
    for (int i = 0; i < pages.length; i++) {
      if (pages[i].contains(query)) {
        foundPages.add(i + 1); // PDF pages are 1-indexed
      }
    }
    setState(() {
      _foundPages = foundPages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search PDF'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PdfSearchDelegate(_text, _searchInPdf),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _foundPages.isEmpty
          ? PDFView(
        filePath: widget.pdfPath,
        onRender: (_pages) {
          setState(() {
            _isLoading = false;
          });
        },
        onError: (error) {
          print(error.toString());
          setState(() {
            _isLoading = false;
          });
        },
      )
          : ListView.builder(
        itemCount: _foundPages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Page ${_foundPages[index]}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                    pdfPath: widget.pdfPath,
                    initialPage: _foundPages[index] - 1,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String pdfPath;
  final int initialPage;

  PdfViewerPage({required this.pdfPath, this.initialPage = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
        defaultPage: initialPage,
        onRender: (_pages) {
          print('Total pages: $_pages');
        },
        onError: (error) {
          print(error.toString());
        },
      ),
    );
  }
}

class PdfSearchDelegate extends SearchDelegate {
  final String text;
  final Function(String) onSearch;

  PdfSearchDelegate(this.text, this.onSearch);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, null);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
