import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'dart:core';
import 'package:web_socket_channel/web_socket_channel.dart';

String processJson(String jsonString) {
  Map<String, dynamic> jsonMap = json.decode(jsonString);
  Map<String, dynamic> processedMap = _processMap(jsonMap);
  return json.encode(processedMap);
}

dynamic _processMap(dynamic item) {
  if (item is Map<String, dynamic>) {
    return item.map((key, value) {
      if (key.toLowerCase() == 'x' || key.toLowerCase() == 'y') {
        return MapEntry(key, (value * 0.17).round().toInt());
      }
      return MapEntry(key, _processMap(value));
    });
  } else if (item is List) {
    return item.map((e) => _processMap(e)).toList();
  } else {
    return item;
  }
}

@RoutePage()
class DrawPage extends StatefulWidget {
  const DrawPage({
    super.key,
    @PathParam('className') required this.className,
    @PathParam('username') required this.username,
  });

  final String className;
  final String username;

  @override
  State<DrawPage> createState() => _DrawPageState();
}

String qusetion = "";
String answer = "";

class _DrawPageState extends State<DrawPage> {
  @override
  Widget build(BuildContext context) {
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/ws/chat/${widget.className}/'),
    );
    final DrawingController drawingController = DrawingController();

    return StreamBuilder<Object>(
      stream: channel.stream.cast<Object>(),
      builder: (context, snapshot) {
        if (qusetion == "") {
          channel.sink.add(
              '{"type":"chat_message","id":"${widget.username}","message":"question"}');
        }
        if (snapshot.hasData) {
          final data = jsonDecode(snapshot.data as String);

          if (data["message"] is String) {
            if (data["message"].startsWith("question ")) {
              qusetion = data["message"].substring(8);
            }
            print(data["message"]);

            if (data["message"].startsWith("${widget.username} good")) {
              answer = "good";

              print("정답처리");
            }
            if (data["message"].startsWith("${widget.username} bad")) {
              answer = "bad";

              print("오답처리");
            }
          } else {}
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              qusetion,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StudentCanvas(
                                  channel: channel,
                                  name: widget.username,
                                  drow_json: null,
                                  drawingController: drawingController,
                                  username: widget.username,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.all(55.4),
                                height: 800,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  drawingController.setStyle(
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  );
                                                },
                                                child: Container(
                                                  height: 130,
                                                  width: 130,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SelectColor(
                                                  drawingController:
                                                      drawingController,
                                                  color: Colors
                                                      .pink), /////////////////////// 이런식으로 팔레스 색상 추가
                                              GestureDetector(
                                                onTap: () {
                                                  drawingController.setStyle(
                                                    color: const Color.fromARGB(
                                                        255, 255, 0, 0),
                                                  );
                                                },
                                                child: Container(
                                                  height: 130,
                                                  width: 130,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  drawingController.setStyle(
                                                    color: const Color.fromARGB(
                                                        255, 0, 255, 0),
                                                  );
                                                },
                                                child: Container(
                                                  height: 130,
                                                  width: 130,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              SelectColor(
                                                  drawingController:
                                                      drawingController,
                                                  color: Colors
                                                      .purple), /////////////////////// 이런식으로 팔레스 색상 추가
                                              GestureDetector(
                                                onTap: () {
                                                  drawingController.setStyle(
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 255),
                                                  );
                                                },
                                                child: Container(
                                                  height: 130,
                                                  width: 130,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      if (answer == "")
                                        const Text(" 채점 대기중 ....")
                                      else if (answer == "good")
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Image.asset(
                                                'assets/circle.png'),
                                          ),
                                        )
                                      else if (answer == "bad")
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Image.asset('assets/x.png'),
                                          ),
                                        )
                                      else
                                        Text("채점 결과 : $answer"),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SelectColor extends StatelessWidget {
  const SelectColor({
    super.key,
    required this.drawingController,
    required this.color,
  });

  final Color color;
  final DrawingController drawingController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        drawingController.setStyle(
          color: color,
        );
      },
      child: Container(
        height: 130,
        width: 130,
        decoration: BoxDecoration(
          color: color,
        ),
      ),
    );
  }
}

class StudentCanvas extends StatefulWidget {
  const StudentCanvas({
    super.key,
    required this.channel,
    required this.name,
    required this.drow_json,
    required this.drawingController,
    required this.username,
  });
  final channel;
  final name;
  final drow_json;
  final DrawingController drawingController;
  final String username;

  @override
  State<StudentCanvas> createState() => _StudentCanvasState();
}

class _StudentCanvasState extends State<StudentCanvas> {
  PaintContent contentFromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'StraightLine':
        return StraightLine.fromJson(json);
      case 'SimpleLine':
        return SimpleLine.fromJson(json);
      case 'Rectangle':
        return Rectangle.fromJson(json);
      default:
        throw Exception('Unknown type: ${json['type']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.drawingController.setStyle(
      color: const Color.fromARGB(255, 0, 0, 0),
    );
    // List<PaintContent> contents = [];
    // if (widget.drow_json != null) {
    //   for (var json in widget.drow_json) {
    //     contents.add(contentFromJson(json));
    //   }
    //   widget.drawingController.addContents(contents);
    //   //drawingController.painter.frash();
    // }
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE7E5FF),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Center(
        child: MyCanvas(
          drawingController: widget.drawingController,
          height: 800,
          width: 1500,
          channel: widget.channel,
          requiredshow: true,
          username: widget.username,
        ),
      ),
    );
  }
}

class MyCanvas extends StatelessWidget {
  const MyCanvas({
    super.key,
    required this.drawingController,
    required this.height,
    required this.width,
    required this.channel,
    required this.username,
    this.requiredshow = true,
  });
  final double height;
  final double width;
  final bool requiredshow;
  final channel;
  final username;

  final DrawingController drawingController;

  Future<void> getJsonList() async {
    String jsonString = processJson(
        '{"type":"chat_message","id":"$username","message":${const JsonEncoder.withIndent('').convert(drawingController.getJsonList())}}');
    channel.sink.add(
      jsonString,
    );
  }

  @override
  Widget build(BuildContext context) {
    drawingController.setStyle(
      color: const Color.fromARGB(255, 0, 0, 0),
    );
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      height: height,
      width: width,
      child: DrawingBoard(
        controller: drawingController,
        onPointerDown: (pde) {
          getJsonList();
          print("down");
        },
        onPointerUp: (pue) {
          getJsonList();
          print("up");
        },
        background: Container(
          height: height,
          width: width,
          color: Colors.white,
        ),
        boardPanEnabled: false,
        boardScaleEnabled: false,
        showDefaultActions: requiredshow, // 기본 액션 옵션 활성화
        showDefaultTools: requiredshow,
      ),
    );
  }
}
