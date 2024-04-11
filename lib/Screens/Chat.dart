import 'package:flutter/material.dart';
import 'package:untitled14/Cubit/cubit.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final AppCubit cubit; // Declare cubit variable

  final TextEditingController messageFromUser = TextEditingController();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    cubit = AppCubit.get(context); // Initialize cubit using context
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch messages every time the dependencies change (e.g., screen shown again)
    fetchMessagesForUser();
  }

  void fetchMessagesForUser() async {
    final List<Map<String, dynamic>> allMessages = await cubit.getAllMessages();
    final List<Map<String, dynamic>> userMessages =
    await cubit.getMessagesForUser(cubit.loggedUserId);
    setState(() {
      messages.clear(); // Clear existing messages
      for (var messageData in userMessages) {
        messages.add(Message(messageData['text'], messageData['type']));
      }
    });
    print(userMessages);
    print(messages.length);
    print(allMessages);
    print(cubit.loggedUserId);
  }

  void _sendMessage(String text, String type) {
    setState(() {
      messages.insert(0, Message(text, type));
      cubit.insertMessage(text, type, cubit.loggedUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  child: Text(
                    "How can we help you?",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _sendMessage(
                          "There is a transaction I did not do it", "true");
                      _sendMessage(
                          "Kindly send the details of issue we will revise it and contact you",
                          "false");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("There is transaction I did not do it"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      _sendMessage("Other", "true");
                      _sendMessage(
                          "Kindly send the details of issue someone will contact you soon",
                          "false");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Other"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  _sendMessage("There is issue on receiving product", "true");
                  _sendMessage(
                      "Kindly send the details of issue and in what order, and we will do the best to fix it",
                      "false");
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("There is issue on receiving product"),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(messages[index]);
                  },
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: messageFromUser,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage(messageFromUser.text, "true");
                      messageFromUser.text = "";
                    },
                  ),
                  hintText: "Contact us!",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(Message message) {
    final alignment = message.type == "true"
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final color = message.type == "true" ? Colors.blue : Colors.grey[300];
    final textColor = message.type == "true" ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: alignment == CrossAxisAlignment.end
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

  class Message {
  final String text;
  String type = "true";

  Message(this.text, this.type);
}
