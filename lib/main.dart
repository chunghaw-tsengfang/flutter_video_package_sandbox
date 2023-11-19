import 'package:chewie/chewie.dart';
// import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:pod_player/pod_player.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_test/router.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  // late final PodPlayerController controller;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  // late FlickManager flickManager;

  bool isLoading = true;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    // initChewie();
    _initControllers();

    super.initState();
  }

  void initVideoPlayer() {
    //! Video Player
    // _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
    //     'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'))
    //   ..initialize().then((_) {
    //     setState(() {
    //       _videoPlayerController.play();
    //     });
    //   });
  }

  void initFlickPlayer() {
    //! Flick Manager
    // flickManager = FlickManager(
    //   videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(
    //       "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")),
    // );
  }

  void initPodPlayer() {
    //! Pod Player
    // final video = PlayVideoFrom.network(
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    // );
    // setState(() => isLoading = false);

    // controller = PodPlayerController(
    //   playVideoFrom: video,
    //   podPlayerConfig: const PodPlayerConfig(
    //     autoPlay: false,
    //   ),
    // )..initialise();
  }

  void _initControllers() {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'))
      ..initialize().then((value) {
        _videoPlayerController.seekTo(_currentPosition);
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
    )..addListener(_reInitListener);
    if (_isPlaying) {
      _chewieController!.play();
    }
  }

  void _reInitControllers() {
    _chewieController!.removeListener(_reInitListener);
    _currentPosition = _videoPlayerController.value.position;
    _isPlaying = _chewieController!.isPlaying;
    _initControllers();
  }

  void _reInitListener() {
    if (!_chewieController!.isFullScreen) {
      _reInitControllers();
    }
  }

  void initChewie() {
    //! Chewie
    print("Init Chewie");
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'))
      ..initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      allowedScreenSleep: false,
      allowFullScreen: true,
      showControls: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    )..addListener(() {
        if (_chewieController!.isFullScreen) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
        if (_chewieController!.isFullScreen) {
        } else {
          print("Exit fullscreen");
          initChewie();
        }
      });
  }

  @override
  void dispose() {
    // flickManager.dispose();
    _videoPlayerController.dispose();
    print("Dispose");
    _chewieController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      print("Reinit");
      initChewie();
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Test'),
          onPressed: () {
            context.go('/pod_player');
          },
        ),
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child:
                //  VideoPlayer(
                //   _videoPlayerController,
                // ),
                // FlickVideoPlayer(flickManager: flickManager),
                // Chewie(controller: _chewieController!),
                _videoPlayerController.value.isInitialized
                    ? Chewie(controller: _chewieController!)
                    : null,
          ),
          // Center(
          //   child: PodVideoPlayer(
          //     controller: controller,
          //   ),
          // ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    // _videoPlayerController.
                  },
                  child: Text('Fullscreen')),
            ],
          )
        ]));
  }
}
