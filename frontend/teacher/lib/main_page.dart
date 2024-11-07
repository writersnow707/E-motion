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

List<QuestionData> questionData = [
  QuestionData(
    "퀴즈 문항",
    "문제 미리보기 위젯",
    "해당 대기화면 링크",
    DateTime.now(),
    0,
  ),
];

class QuestionData {
  String questionTitle;
  String backgroundImage;
  String memo;
  DateTime createdTime;
  int index;

  QuestionData(
    this.questionTitle,
    this.backgroundImage,
    this.memo,
    this.createdTime,
    this.index,
  );
}

int quiz_block_index = 0;
TextEditingController _controller =
    TextEditingController(text: questionData[0].questionTitle);

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    @PathParam('className') required this.className,
  });

  final String className;

  @override
  State<MainPage> createState() => _MainPageState();
}

bool show_all = false;

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    String classLink = "https://emotion.com/${widget.className}";
    List<String> studentList = [];
    Map<String, dynamic> drowJsons = {};

    final DrawingController drawingController = DrawingController();
    drawingController.setStyle(
      color: const Color.fromARGB(255, 0, 0, 0),
    );

    void updateQuestions() {
      setState(() {
        // 여기에 questionData를 변경하는 로직을 추가합니다.
        questionData.add(
          QuestionData(
              "새로운 퀴즈 문항", "None", "None", DateTime.now(), questionData.length),
        );
        print(quiz_block_index);
      });
    }

    final channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/ws/chat/${widget.className}/'),
    );

    return StreamBuilder<Object>(
        stream: channel.stream.cast<Object>(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = jsonDecode(snapshot.data as String);

            if (data["message"] is String) {
              if (data["message"] == "question") {
                channel.sink.add(
                    '{"type":"chat_message","id":"teacher","message":"question ${questionData[quiz_block_index].questionTitle}"}');
              }
            } else {
              if (!studentList.contains(data['id'])) {
                studentList.add(data['id']);
              }
              if (data['id'] != " ") {
                drowJsons[data['id']] = data['message'];
              }
            }
          }
          if (show_all) {
            return Scaffold(
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ShowAllStudents(
                          studentList: studentList,
                          channel: channel,
                          drowJsons: drowJsons,
                        ),
                       
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          show_all = false;
                        });
                      },
                      child: const Text("돌아가기"),
                    ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          '/logo.png',
                          width: 137,
                          height: 31,
                        ),
                        const SizedBox(
                          height: 34,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 203,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE7E5FF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                "퀴즈 : 총 ${questionData.length}문항",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF9994F8)),
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE7E5FF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF9994F8),
                                  weight: 700,
                                  size: 15,
                                ),
                                onPressed: () {
                                  updateQuestions();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ///////////////////  퀴즈 블럭/////////////////////
                        for (int i = 0; i < questionData.length; i++)
                          QuizBlock(
                              index: i,
                              questionData: questionData[i],
                              onPressed: () {
                                quiz_block_index = i;
                                channel.sink.add(
                                    '{"type":"chat_message","id":"teacher","message":"question ${questionData[i].questionTitle}"}');
                              }),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            PlayLinkWidget(classLink: classLink),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFFDADADA),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("퀴즈*"),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFF3F9FF),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: SizedBox(
                                                    height: 25,
                                                    child: TextField(
                                                      controller: _controller,
                                                      onChanged: (value) {
                                                        questionData[
                                                                quiz_block_index]
                                                            .questionTitle = value;
                                                        setState(() {});
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "퀴즈 문항을 입력하세요",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                Container(),
                                                const Text("퀴즈 문항"),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 23,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  MyCanvas(
                                    drawingController: drawingController,
                                    height: 470,
                                    width: 1200,
                                    channel: channel,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    height: 474,
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text("참가자"),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Container(
                                          height: 144,
                                          width: 256,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFE7E5FF),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              studentList.join("\n"),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  const Text("참가자"),
                                  const Expanded(child: SizedBox()),
                                  TextButton(
                                    child: const Text(
                                      "모두 보기",
                                    ),
                                    onPressed: () {
                                      show_all = !show_all;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      /////////////////////////// 참가자 리스트 //////////////////////////
                                      for (String name in studentList)
                                        if (name != " ")
                                          Column(
                                            children: [
                                              Text(name),
                                              StudentCanvas(
                                                channel: channel,
                                                name: name,
                                                drow_json: drowJsons[name],
                                              )
                                            ],
                                          ),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class ShowAllStudents extends StatelessWidget {
  const ShowAllStudents({
    super.key,
    required this.studentList,
    required this.channel,
    required this.drowJsons,
  });

  final List<String> studentList;
  final channel;
  final drowJsons;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          children: [
            for (String name in studentList)
              if (name != " ")
                Column(
                  children: [
                    StudentCanvas(
                      channel: channel,
                      name: name,
                      drow_json: drowJsons[name],
                    ),
                    Row(
                      children: [
                        Text(name),
                        IconButton(
                          icon: const Icon(Icons.circle),
                          onPressed: () {
                            // channel.sink.add() 학생에게 맞았다구 한다.
                            channel.sink.add(
                                '{"type":"chat_message","id":" ","message":"$name good"}');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            // channel.sink.add() 학생에게 틀렸다구 한다.
                            channel.sink.add(
                                '{"type":"chat_message","id":" ","message":"$name bad"}');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
          ],
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
  });
  final channel;
  final name;
  final drow_json;

  @override
  State<StudentCanvas> createState() => _StudentCanvasState();
}

class _StudentCanvasState extends State<StudentCanvas> {
  final DrawingController drawingController = DrawingController();

  PaintContent contentFromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'StraightLine':
        return StraightLine.fromJson(json);
      case 'SimpleLine':
        return SimpleLine.fromJson(json);
      case 'Rectangle':
        return Rectangle.fromJson(json);
      // 다른 타입들에 대해서도 같은 방식으로 처리
      default:
        throw Exception('Unknown type: ${json['type']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    drawingController.setStyle(
      color: const Color.fromARGB(255, 0, 0, 0),
    );
    List<PaintContent> contents = [];
    if (widget.drow_json != null) {
      for (var json in widget.drow_json) {
        contents.add(contentFromJson(json));
      }
      drawingController.addContents(contents);
    }
    return Container(
      height: 140,
      width: 256,
      decoration: const BoxDecoration(
        color: Color(0xFFE7E5FF),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: MyCanvas(
          drawingController: drawingController,
          height: 140,
          width: 256,
          channel: widget.channel,
          requiredshow: false),
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
    this.requiredshow = true,
  });
  final double height;
  final double width;
  final bool requiredshow;
  final channel;

  final DrawingController drawingController;

  Future<void> getJsonList() async {
    // channel.sink.add(
    //     '{"type":"chat_message","id":"teacher","message":${const JsonEncoder.withIndent('').convert(drawingController.getJsonList())}}');
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

class PlayLinkWidget extends StatelessWidget {
  const PlayLinkWidget({
    super.key,
    required this.classLink,
  });

  final String classLink;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const Text("플레이 링크: "),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: classLink,
                        style: const TextStyle(
                          color: Color(0xFF9994F8),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(classLink);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class QuizBlock extends StatelessWidget {
  const QuizBlock(
      {super.key,
      required this.index,
      required this.questionData,
      required this.onPressed});

  final int index;
  final QuestionData questionData;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        quiz_block_index = index;
        _controller.text = questionData.questionTitle;
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$index",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 87,
                    width: 8,
                  )
                ],
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 220,
                height: 106,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: Color(0xFFF7F7F7),
                ),
                child: Stack(children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Text(
                      questionData.questionTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3F3F3F),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Text(
                      questionData.createdTime.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFFADADAD),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class WhiteboardPage extends StatefulWidget {
  final String sessionId;

  const WhiteboardPage({super.key, required this.sessionId});

  @override
  _WhiteboardPageState createState() => _WhiteboardPageState();
}

class _WhiteboardPageState extends State<WhiteboardPage> {
  late WebSocketChannel channel;
  List<Offset> points = [];

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/ws/chat/${widget.sessionId}/'),
    );

    channel.stream.listen((message) {
      setState(() {
        // Assume message is a JSON string with x and y coordinates.
        final data = jsonDecode(message);
        points.add(Offset(data['x'], data['y']));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final point = details.localPosition;

        setState(() {
          points.add(point);
          channel.sink.add(jsonEncode({
            'type': "chat_message",
            "message": {'x': point.dx, 'y': point.dy}
          }));
        });
      },
      onPanEnd: (details) => (),
      child: CustomPaint(
        painter: WhiteboardPainter(points),
        size: Size.infinite,
        child: Container(),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class WhiteboardPainter extends CustomPainter {
  final List<Offset> points;

  WhiteboardPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(WhiteboardPainter oldDelegate) =>
      oldDelegate.points != points;
}
