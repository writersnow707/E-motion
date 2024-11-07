import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'router/app_router.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
            image: AssetImage('/background.png'), // 배경 이미지
          ),
        ),
        child: const Center(
          child: LoginWidget(),
        ),
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    String className = "";
    return Center(
      child: Container(
        height: 352,
        width: 488,
        padding:
            const EdgeInsets.only(left: 60, right: 60, top: 40, bottom: 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              '/logo.png',
            ), // 로고 이미지
            const SizedBox(height: 20),
            const Text(
              "클레스 이름을 작성해주세요.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(Icons.person),
                Text(
                  "이름",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '클레스 이름',
              ),
              onChanged: (text) => className = text,
            ),
            const SizedBox(height: 12),
            GestureDetector(
                onTap: () {
                  context.router.push(MainRoute(className: className));
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 16,
                        width: 368,
                      ),
                      Text(
                        "확인",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
