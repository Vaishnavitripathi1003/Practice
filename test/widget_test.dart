GestureDetector(
child: Container(
height: 160,
width: 160.0,
color: Colors.blue,
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(Icons.audiotrack, size: 50, color: Colors.white),
SizedBox(height: 10),
Text(
'Audio Player',
style: TextStyle(
color: Colors.white,
fontSize: 18.0,
fontWeight: FontWeight.bold,
),
),
],
),
),
onTap: () {
Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayerPage()));
},
),