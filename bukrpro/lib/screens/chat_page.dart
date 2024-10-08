import 'dart:io';
import 'package:bukrpro/widgets/chat_text_field.dart';
import 'package:bukrpro/widgets/popup.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../models/conversationModel.dart';
import '../providers/audioProvider.dart';
import '../providers/chatProvider.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final TextEditingController _msgcontroller = TextEditingController();

    ChatProvider chatmodel = context.watch<ChatProvider>();
    final messeges = chatmodel.chatModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(messeges!.name.toString()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return _buildMessageBubble(message, context);
                  },
                );
              },
            ),
          ),
          ChatTextField(msgcontroller: _msgcontroller),
        ],
      ),
    );
  }
}

Widget _buildMessageBubble(ChatMessage message, BuildContext context) {
  if (message.filePath != null) {
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: _buildFileWidget(message, context),
      ),
    );
  }
  final chatPro = context.watch<ChatProvider>();

  return Align(
    alignment:
        message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
    child: message.audiofile != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: VoiceMessageView(
              activeSliderColor: Colors.green,
              controller: VoiceController(
                maxDuration: const Duration(minutes: 5),
                isFile: true,
                audioSrc: message.audiofile ?? "",
                onComplete: () {
                  /// do something on complete
                },
                onPause: () {
                  /// do something on pause
                },
                onPlaying: () {
                  /// do something on playing
                },
                onError: (err) {
                  /// do somethin on error
                },
              ),
              // maxDuration: const Duration(seconds: 10),
              // isFile: false,
              innerPadding: 12,
              cornerRadius: 20,
            ),
          )
        : Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: message.isSentByMe ? Colors.blue[200] : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: FittedBox(
              child: Column(
              mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.message ?? "",
                    style: const TextStyle(color: Colors.black),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat('hh:mm')
                          .format(message.dateTime ?? DateTime.now()),
                      style: const TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
  );
}

Widget _buildFileWidget(ChatMessage message, context) {
  if (message.fileType == FileType.image && message.filePath != null) {
    //   final imageProvider = Image.file(File(message.filePath!)).image;
    return GestureDetector(
      onTap: () {
        // showImageViewer(context, imageProvider, onViewerDismissed: () {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 4, // Add a border
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Image.file(
          File(message.filePath!),
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  } else {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.attach_file, color: Colors.black),
          Text(
            message.fileName ?? 'Unknown file',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
