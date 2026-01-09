import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum LoginProvider { kakao, google, apple }

/// 앱의 시작점
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login UI',
      theme: ThemeData(useMaterial3: true),
      home: const StartLoginPage(),
    );
  }
}

/// 너가 그린 "시작(로그인 선택) 페이지"
class StartLoginPage extends StatelessWidget {
  const StartLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const Spacer(),

              const Text(
                '먹잘알일지도',
                style: TextStyle(fontSize: 56, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              const Text(
                '간단한 로그인 선택 화면',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginProcessingPage(provider: LoginProvider.kakao),
                      ),
                  );
                },
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE500),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '카카오로 시작하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginProcessingPage(provider: LoginProvider.google),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  child: const Text(
                    'Google로 시작하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:  (_) => const LoginProcessingPage(provider: LoginProvider.apple),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apple로 시작하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }

  static void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}


class LoginProcessingPage extends StatelessWidget {
  final LoginProvider provider;
  const LoginProcessingPage({super.key, required this.provider});

  String get providerName {
    switch (provider) {
      case LoginProvider.kakao:
        return '카카오';
      case LoginProvider.google:
        return '구글';
      case LoginProvider.apple:
        return '애플';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$providerName 로그인'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                '$providerName 로그인 중...',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                '다음 단계에서 실제 로그인 기능을 연결할 거예요.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('뒤로가기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

