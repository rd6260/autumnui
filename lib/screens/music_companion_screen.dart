import 'dart:ui';
import 'dart:async';

import 'package:dart_mpd/dart_mpd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/mpd_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MusicCompanionScreen extends StatefulWidget {
  const MusicCompanionScreen({super.key});

  @override
  State<MusicCompanionScreen> createState() => _MusicCompanionScreenState();
}

class _MusicCompanionScreenState extends State<MusicCompanionScreen>
    with TickerProviderStateMixin {
  static const _gifUrls = [
    'https://i.pinimg.com/originals/a8/09/94/a8099418b2137e113c808fff5df2dc2a.gif',
    'https://i.pinimg.com/originals/79/6d/b5/796db5deaf3ca9a927736d4b12cc3086.gif',
    'https://i.pinimg.com/originals/e0/ec/9f/e0ec9ffbe62f665c7bb3fc9fb968bc61.gif',
    'https://i.pinimg.com/originals/b3/53/dc/b353dcd4eb7b36ae6ce50e83824dc66e.gif',
    'https://i.pinimg.com/originals/8f/38/8e/8f388ee83be2782215f9c931b5d3b67b.gif',
    'https://i.pinimg.com/originals/cf/aa/83/cfaa8339bca1d8af3838aab783fe5675.gif',
    'https://i.pinimg.com/originals/86/5b/90/865b90b2bfc3a208dc040818d9d6952d.gif',
    'https://i.pinimg.com/originals/93/4f/be/934fbeec627b3d1cdba65cd7db3c2fe1.gif',
    'https://i.pinimg.com/originals/b3/e2/2e/b3e22e164a207f353809d20dde261bb8.gif',
    'https://i.pinimg.com/originals/f0/34/24/f03424bd0298f06f09d9299e930abef3.gif',
    'https://i.pinimg.com/originals/5f/38/0e/5f380e2ecbf7d232a7d2e7092d53536d.gif',
    'https://i.pinimg.com/originals/39/53/72/3953725f59702c293be5e887d35196cb.gif',
    'https://i.pinimg.com/originals/ab/54/94/ab5494ae1a83c52d72cded9a3a31d0eb.gif',
    'https://i.pinimg.com/originals/29/1f/b2/291fb25f2395c226b8b8ff4b3f84ef4c.gif',
    'https://i.pinimg.com/originals/55/c6/94/55c694230690258292e51904e80e38f4.gif',
    
  ];

  int _gifIndex = 0;
  int _prevGifIndex = 0;
  ColorScheme? _colorScheme;
  bool _isLoading = true;
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  bool _isConnectingMpd = false;
  bool _showControls = false;
  late final AnimationController _controlsAnimController;
  late final Animation<double> _controlsFade;
  late final AnimationController _gifFadeController;
  late final Animation<double> _gifFade;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controlsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _controlsFade = CurvedAnimation(
      parent: _controlsAnimController,
      curve: Curves.easeInOut,
    );

    _gifFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: 1.0,
    );
    _gifFade = CurvedAnimation(
      parent: _gifFadeController,
      curve: Curves.easeInOut,
    );

    _generateColorScheme();
    _startClock();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkMpdConnection();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controlsAnimController.dispose();
    _gifFadeController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void _toggleControls() {
    if (_showControls) {
      _controlsAnimController.reverse().then((_) {
        if (mounted) setState(() => _showControls = false);
      });
    } else {
      setState(() => _showControls = true);
      _controlsAnimController.forward();
    }
  }

  void _hideControls() {
    if (!_showControls) return;
    _controlsAnimController.reverse().then((_) {
      if (mounted) setState(() => _showControls = false);
    });
  }

  Future<void> _mpdPrevious() async {
    try {
      await MpdRemoteService.instance.client.previous();
    } catch (_) {}
    _hideControls();
  }

  Future<void> _mpdTogglePlay() async {
    try {
      final isPlaying = MpdRemoteService.instance.isPlaying.value;
      await MpdRemoteService.instance.client.pause(isPlaying);
    } catch (_) {}
    _hideControls();
  }

  Future<void> _mpdNext() async {
    try {
      await MpdRemoteService.instance.client.next();
    } catch (_) {}
    _hideControls();
  }

  void _changeGif(int delta) {
    final nextIndex =
        ((_gifIndex + delta) % _gifUrls.length + _gifUrls.length) %
        _gifUrls.length;
    setState(() {
      _prevGifIndex = _gifIndex;
      _gifIndex = nextIndex;
    });
    _gifFadeController.forward(from: 0);
    _generateColorScheme();
  }

  Future<void> _mpdToggleFavorite() async {
    final song = MpdRemoteService.instance.currentSong.value;
    if (song == null) return;

    final favorites = MpdRemoteService.instance.favoriteSongList.value;
    final isFav = favorites.any((s) => s.file == song.file);

    try {
      if (isFav) {
        final idx = favorites.indexWhere((s) => s.file == song.file);
        await MpdRemoteService.instance.client.playlistdelete(
          MpdRemoteService.defaultFavoritePlaylistName,
          MpdPositionOrRange.position(idx),
        );
      } else {
        await MpdRemoteService.instance.client.playlistadd(
          MpdRemoteService.defaultFavoritePlaylistName,
          song.file,
        );
      }
      await MpdRemoteService.instance.refreshStoredPlaylist();
    } catch (e) {
      debugPrint('Failed to toggle favorite: $e');
    }
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  Future<void> _checkMpdConnection() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIp = prefs.getString('mpd_ip') ?? '';
    final savedPort = prefs.getString('mpd_port') ?? '6600';

    if (!mounted) return;

    if (savedIp.isNotEmpty && savedPort.isNotEmpty) {
      setState(() {
        _isConnectingMpd = true;
      });

      final port = int.tryParse(savedPort) ?? 6600;
      try {
        if (!MpdRemoteService.instance.isInitialized) {
          await MpdRemoteService.instance.initialize(host: savedIp, port: port);
        } else if (MpdRemoteService.instance.host != savedIp ||
            MpdRemoteService.instance.port != port) {
          MpdRemoteService.instance.dispose();
          await MpdRemoteService.instance.initialize(host: savedIp, port: port);
        }

        if (mounted) {
          setState(() {
            _isConnectingMpd = false;
          });
        }
        return; // Connected successfully
      } catch (e) {
        if (mounted) {
          setState(() {
            _isConnectingMpd = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Saved connection failed: $e. Please reconfigure.'),
            ),
          );
        }
      }
    }

    _showMpdConnectionDialog(prefs, savedIp, savedPort);
  }

  Future<void> _showMpdConnectionDialog(
    SharedPreferences prefs,
    String savedIp,
    String savedPort,
  ) async {
    if (!mounted) return;

    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final ipController = TextEditingController(text: savedIp);
        final portController = TextEditingController(text: savedPort);
        return AlertDialog(
          backgroundColor: _colorScheme?.surface ?? const Color(0xFFD4A574),
          title: Text(
            'Connect to MPD',
            style: GoogleFonts.inter(
              color: _colorScheme?.onSurface ?? Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ipController,
                style: TextStyle(
                  color: _colorScheme?.onSurface ?? Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'IP Address',
                  labelStyle: TextStyle(
                    color: (_colorScheme?.onSurface ?? Colors.black).withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: portController,
                style: TextStyle(
                  color: _colorScheme?.onSurface ?? Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Port',
                  labelStyle: TextStyle(
                    color: (_colorScheme?.onSurface ?? Colors.black).withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: _colorScheme?.primary ?? Colors.brown),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'ip': ipController.text.trim(),
                  'port': portController.text.trim(),
                });
              },
              child: Text(
                'Connect',
                style: TextStyle(color: _colorScheme?.primary ?? Colors.brown),
              ),
            ),
          ],
        );
      },
    );

    if (result != null &&
        result['ip']!.isNotEmpty &&
        result['port']!.isNotEmpty) {
      await prefs.setString('mpd_ip', result['ip']!);
      await prefs.setString('mpd_port', result['port']!);

      final host = result['ip']!;
      final port = int.tryParse(result['port']!) ?? 6600;

      if (!mounted) return;
      setState(() {
        _isConnectingMpd = true;
      });

      try {
        if (!MpdRemoteService.instance.isInitialized) {
          await MpdRemoteService.instance.initialize(host: host, port: port);
        } else {
          if (MpdRemoteService.instance.host != host ||
              MpdRemoteService.instance.port != port) {
            MpdRemoteService.instance.dispose();
            await MpdRemoteService.instance.initialize(host: host, port: port);
          }
        }

        if (mounted) {
          setState(() {
            _isConnectingMpd = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isConnectingMpd = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to connect: $e')));
          _showMpdConnectionDialog(prefs, host, port.toString());
        }
      }
    }
  }

  Future<void> _generateColorScheme() async {
    final url = _gifUrls[_gifIndex];
    try {
      final ImageProvider imageProvider = NetworkImage(url);
      final ColorScheme colorScheme = await ColorScheme.fromImageProvider(
        provider: imageProvider,
        brightness: Brightness.dark,
      );
      if (mounted && _gifUrls[_gifIndex] == url) {
        setState(() {
          _colorScheme = colorScheme;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback color scheme if image loading fails
      debugPrint("DEV: color set to fallback option");
      setState(() {
        _colorScheme =
            ColorScheme.fromSeed(
              seedColor: const Color(0xFFD4A574),
              brightness: Brightness.dark,
            ).copyWith(
              surface: const Color(0xFFD4A574),
              primary: const Color(0xFF8B4513),
              secondary: const Color(0xFFA0522D),
              tertiary: const Color(0xFF654321),
            );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _colorScheme == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Theme(
      data: ThemeData.from(colorScheme: _colorScheme!),
      child: Scaffold(
        body: Stack(
          children: [
            // Background GIF for the entire screen (previous, fading out)
            Image.network(
              _gifUrls[_prevGifIndex],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // New GIF fading in
            FadeTransition(
              opacity: _gifFade,
              child: Image.network(
                _gifUrls[_gifIndex],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: _colorScheme!.primary,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: _colorScheme!.onPrimary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'GIF unavailable',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: _colorScheme!.onPrimary.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: _colorScheme!.primary,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: _colorScheme!.onPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Right-side tap zone to show controls / swipe to change gif
            Positioned(
              left: 280,
              top: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _toggleControls,
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity == null) return;
                  if (details.primaryVelocity! < -200) {
                    _changeGif(1); // swipe left → next
                  } else if (details.primaryVelocity! > 200) {
                    _changeGif(-1); // swipe right → previous
                  }
                },
                child: const SizedBox.expand(),
              ),
            ),

            // Glassmorphism Panel
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 280,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border(
                    right: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: _buildLandscapeContent(),
                    ),
                  ),
                ),
              ),
            ),

            // Playback controls overlay (centered in right area)
            if (_showControls)
              Positioned(
                left: 280,
                top: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: FadeTransition(
                    opacity: _controlsFade,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.18),
                                Colors.white.withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ControlButton(
                                icon: Icons.skip_previous_rounded,
                                onTap: _mpdPrevious,
                              ),
                              const SizedBox(width: 24),
                              ValueListenableBuilder<bool>(
                                valueListenable:
                                    MpdRemoteService.instance.isPlaying,
                                builder: (context, playing, _) {
                                  return _ControlButton(
                                    icon: playing
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 48,
                                    onTap: _mpdTogglePlay,
                                  );
                                },
                              ),
                              const SizedBox(width: 24),
                              _ControlButton(
                                icon: Icons.skip_next_rounded,
                                onTap: _mpdNext,
                              ),
                              const SizedBox(width: 24),
                              ValueListenableBuilder<MpdSong?>(
                                valueListenable:
                                    MpdRemoteService.instance.currentSong,
                                builder: (context, song, _) {
                                  return ValueListenableBuilder<List<MpdSong>>(
                                    valueListenable: MpdRemoteService
                                        .instance
                                        .favoriteSongList,
                                    builder: (context, favs, _) {
                                      final isFav =
                                          song != null &&
                                          favs.any((s) => s.file == song.file);
                                      return _ControlButton(
                                        icon: isFav
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        onTap: _mpdToggleFavorite,
                                        iconColor: isFav
                                            ? const Color(0xFFFF6B8A)
                                            : null,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with dropdown
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                Icons.expand_more,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'R E V E R I E',
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 16,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Clock/Time Display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    DateFormat('HH:mm').format(_currentTime),
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    DateFormat('ss').format(_currentTime),
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd.MM EEEE').format(_currentTime),
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const Spacer(flex: 2),

        // Music Info
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isConnectingMpd
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Connecting...',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : ValueListenableBuilder<MpdSong?>(
                  valueListenable: MpdRemoteService.instance.currentSong,
                  builder: (context, song, _) {
                    final title = song?.title?.firstOrNull ?? 'No Song';
                    final artist = song?.artist?.join(', ') ?? 'Unknown Artist';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '-$artist',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Future<void> Function() onTap;
  final Color? iconColor;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.size = 36,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size + 20,
        height: size + 20,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.white.withValues(alpha: 0.9),
          size: size,
        ),
      ),
    );
  }
}
