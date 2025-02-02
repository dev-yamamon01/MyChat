import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  List<Item> items=[];
  late FirebaseFirestore firestore;
  late CollectionReference<Map<String,dynamic>> collection;
  final TextEditingController textEditingController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore=FirebaseFirestore.instance;
    collection=
        firestore.collection('room').doc(widget.room).collection('items');
    watch();
  }

  //データ更新監視
  Future<void> watch () async{
    collection.snapshots().listen((event){
      if(mounted){
        setState(() {
            items=event.docs.reversed.map(
            (docment)=>
            Item.fromSnapshot(
            docment.id,
            docment.data(),
            ),
            )
  .toList(growable: false);
        });

  }
  }
      );
  }

  //保存する
  Future<void> save() async{
    final now=DateTime.now();
    await collection.doc(now.microsecondsSinceEpoch.toString()).set(
{
  "data":Timestamp.fromDate(now),
  "name":widget.name,
  "text":textEditingController.text,
});
    textEditingController.text='';
  }

  send(){
    print("押されました");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.room)),
      body: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                  reverse: true,
                  itemBuilder: (context,index){
                  final item=items[index];
                  return ListTile(
                      subtitle: Text(item.name),
                      title: Text(item.text),
                      );
                  },
                  itemCount: items.length,)
                  ),
                  SafeArea(child:
                  ListTile(
                    title: TextField(
                    ),
                    trailing: ElevatedButton.icon(
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
                  ))


                ],
              ),
    );

  }

}

        class Item{
        const Item({
        required this.id,
        required this.name,
        required this.text,
        });

        final String id;
        final String name;
        final String text;

        factory Item.fromSnapshot(String id, Map<String,dynamic> document){
        return Item(
        id: id,
        name: document['name'].toString() ?? '',
        text: document['text'].toString() ?? '',
        );

        }
        }



