import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyChat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MyChat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String name='';
  String room='';

  void showError(String message){}
  void enter(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.title)),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                hintText: 'room-1',
                labelText: '部屋名', // ラベルとして表示するテキスト
                border: OutlineInputBorder(), // 枠線を追加
              ),
              onChanged: (value) {
                this.room = value;
              },
            ),
          ),
          ListTile(
            title: TextField(
                decoration: InputDecoration(
                  hintText: 'ヤマモン',
                  labelText: 'あなたの名前', // ラベルとして表示するテキスト
                  border: OutlineInputBorder(), // 枠線を追加
                ),
                onChanged: (value) {
                  this.name = value;
                }),
          ),
          ListTile(
            title:ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.green,
                iconColor: Colors.white,
              ),
                onPressed: enter,
              icon: Image.asset(
                'assets/enter.png',
                width: 30, // アイコンの幅
                height: 30,
              ), // アイコンの高さ),
                label: Text(
                  '入室する',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:FontWeight.bold,
                    fontSize: 20
                  ),
                ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  ChatPage({required this.name,required this.room,super.key});
  String name;
  String room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.room)),
    );
  }
}

