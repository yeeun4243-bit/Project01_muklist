import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginProvider { kakao, google, apple }

class LoginProcessingPage extends StatefulWidget {
  final LoginProvider provider;
  const LoginProcessingPage({super.key, required this.provider});

  @override
  State<LoginProcessingPage> createState() => _LoginProcessingPageState();
}

class _LoginProcessingPageState extends State<LoginProcessingPage> {
  bool _loading = true;
  String? _error;

  String get providerName {
    switch (widget.provider) {
      case LoginProvider.kakao:
        return '카카오';
      case LoginProvider.google:
        return '구글';
      case LoginProvider.apple:
        return '애플';
    }
  }

  @override
  void initState() {
    super.initState();
    _startLogin();
  }

  Future<void> _startLogin() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      if (widget.provider == LoginProvider.google) {
        await _signInWithGoogle();
      } else {
        throw Exception('$providerName 로그인은 아직 연결 전이에요.');
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('사용자가 구글 로그인을 취소했어요.');
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
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
          child: _loading
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      '$providerName 로그인 중...',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _error == null ? '완료' : '오류 발생',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    if (_error != null)
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('뒤로가기'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _startLogin,
                        child: const Text('다시 시도'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
      body: Center(
        child: Text(
          user == null
              ? '로그인 정보가 없어요'
              : '환영합니다!\n${user.email ?? user.displayName ?? user.uid}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
