import 'package:flutter/material.dart';

class CustomizedViewEditor extends StatefulWidget {
  @override
  _CustomizedViewEditorState createState() => _CustomizedViewEditorState();
}

class _CustomizedViewEditorState extends State<CustomizedViewEditor> {
  List<Widget> elements = [];
  double selectedElementWidth = 150;
  double selectedElementHeight = 50;
  double selectedElementPadding = 8;
  double selectedElementMargin = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customized View Editor'),
      ),
      body: Row(
        children: [
          // Display customized view
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showSidebar();
              },
              child: Container(
                color: Colors.grey[200],
                child: Stack(
                  children: elements,
                ),
              ),
            ),
          ),
          // Editor controls
          FloatingActionButton(
            onPressed: _showAddViewMenu,
            child: Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Customization Options'),
              SizedBox(height: 20),
              Text('Width: $selectedElementWidth'),
              Slider(
                min: 50,
                max: 300,
                value: selectedElementWidth,
                onChanged: (value) {
                  setState(() {
                    selectedElementWidth = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Height: $selectedElementHeight'),
              Slider(
                min: 30,
                max: 150,
                value: selectedElementHeight,
                onChanged: (value) {
                  setState(() {
                    selectedElementHeight = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Padding: $selectedElementPadding'),
              Slider(
                min: 0,
                max: 20,
                value: selectedElementPadding,
                onChanged: (value) {
                  setState(() {
                    selectedElementPadding = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Margin: $selectedElementMargin'),
              Slider(
                min: 0,
                max: 20,
                value: selectedElementMargin,
                onChanged: (value) {
                  setState(() {
                    selectedElementMargin = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSidebar() {
    Scaffold.of(context).openDrawer();
  }

  void _showAddViewMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.text_fields),
                title: Text('Add Text Field'),
                onTap: () {
                  Navigator.pop(context);
                  _addTextField();
                },
              ),
              ListTile(
                leading: Icon(Icons.text_format),
                title: Text('Add Text View'),
                onTap: () {
                  Navigator.pop(context);
                  _addTextView();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addTextField() {
    setState(() {
      elements.add(
        Positioned(
          left: selectedElementMargin,
          top: selectedElementMargin,
          child: Container(
            width: selectedElementWidth,
            height: selectedElementHeight,
            padding: EdgeInsets.all(selectedElementPadding),
            margin: EdgeInsets.all(selectedElementMargin),
            color: Colors.blue,
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _addTextView() {
    setState(() {
      elements.add(
        Positioned(
          left: selectedElementMargin,
          top: selectedElementMargin,
          child: Container(
            width: selectedElementWidth,
            height: selectedElementHeight,
            padding: EdgeInsets.all(selectedElementPadding),
            margin: EdgeInsets.all(selectedElementMargin),
            color: Colors.green,
            child: Center(
              child: Text(
                'Text View',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    });
  }
}
