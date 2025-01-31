import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  void showError(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
          );
        });
  }

  void enter() {
    if (room.isEmpty) {
      showError('部屋名を入力してください');
      return;
    }
    if (name.isEmpty) {
      showError('あなたの名前を入力してください');
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChatPage(name: name, room: room);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.title)),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                hintText: '例：room-1',
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
                  hintText: '例：ヤマモン',
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

  send(){
    print("押されました");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.room)),
      body: ListView(
            children: [
              ListTile(
                title: Text("test"),
              )
              ,Column(
                children: [
                  TextField(

                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      iconColor: Colors.white,
                    ),
                    onPressed: send,
                    icon: SvgPicture.asset('assets/send.svg',
                      width: 20,
                      height: 20),

                  label: Text(
                      '送信',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight:FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
    );
  }
}

