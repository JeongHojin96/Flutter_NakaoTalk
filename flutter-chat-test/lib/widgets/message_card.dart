import 'package:chat/api/apis.dart';
import 'package:chat/helper/my_date_util.dart';
import 'package:chat/main.dart';
import 'package:chat/models/message.dart';
import 'package:flutter/material.dart';

// 단독 메시지 상세보기
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    // update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      debugPrint('message read updated');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 긴 텍스트 자동 줄바꿈
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04,
                vertical: mq.height * .01), // 메시지 풍선 여백
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255), // 메시지 풍선 색
                border: Border.all(
                    color:
                        const Color.fromARGB(255, 134, 217, 255)), // 메시지 풍선 선
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // for adding some space
            SizedBox(
              width: mq.width * .04,
            ),

            if (widget.message.read.isNotEmpty)

              // double tick blue icon for message read
              const Icon(Icons.check, color: Colors.blueAccent, size: 20),

            // for adding some space
            const SizedBox(width: 2),

            // sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        // 긴 텍스트 자동 줄바꿈
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04,
                vertical: mq.height * .01), // 메시지 풍선 여백
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 255, 221), // 메시지 풍선 색
                border: Border.all(
                    color:
                        const Color.fromARGB(255, 134, 217, 255)), // 메시지 풍선 선
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
