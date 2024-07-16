import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/widgets/custom_app_bar.dart';
import 'package:synctours/widgets/custom_drawer.dart';
import 'package:synctours/widgets/loading.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoSearch extends StatefulWidget {
  final String location;

  const VideoSearch({super.key, required this.location});

  @override
  VideoSearchState createState() => VideoSearchState();
}

class VideoSearchState extends State<VideoSearch> {
  final YoutubeExplode _youtubeExplode = YoutubeExplode();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Video> _videos = [];
  Video? _selectedVideo;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool isLoading = true;
  bool isFetchingVideo = false;
  String _searchedLocation = '';

  @override
  void initState() {
    super.initState();
    searchVideos(widget.location);
  }

  @override
  void dispose() {
    _youtubeExplode.close();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> searchVideos(String location) async {
    setState(() {
      isLoading = true;
      _searchedLocation = location;
    });

    String query = "$location travel tourism Kenya";
    var searchResults = await _youtubeExplode.search.search(query);
    setState(() {
      _videos = searchResults;
      isLoading = false;
    });
  }

  Future<void> _selectVideo(Video video) async {
    setState(() {
      isFetchingVideo = true;
      _selectedVideo = video;
    });

    try {
      var manifest =
          await _youtubeExplode.videos.streamsClient.getManifest(video.id);
      var streamInfo = manifest.muxed.withHighestBitrate();
      _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(streamInfo.url.toString()));
      await _videoPlayerController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
      );

      _firestore
          .collection('watch_history')
          .add({'videoId': video.id.value, 'timestamp': Timestamp.now()});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading video: $e')),
      );
    } finally {
      setState(() {
        isFetchingVideo = false;
      });
    }
  }

  void _closeVideoPlayer() {
    setState(() {
      _selectedVideo = null;
      _videoPlayerController?.dispose();
      _chewieController?.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const CustomAppBar(
        title: 'Video Search',
        actions: [],
      ),

      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () => searchVideos(_searchedLocation),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF4EFE6), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter location for videos',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      searchVideos(value);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.video_library,
                        color: Color(0xFF1C160C), size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _searchedLocation.isEmpty
                            ? 'All Videos'
                            : _searchedLocation,
                        style: const TextStyle(
                          color: Color(0xFF1C160C),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (_selectedVideo != null)
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(16.0),
                  child: isFetchingVideo
                      ? const Loading()
                      : Column(
                          children: [
                            Expanded(
                                child: Chewie(controller: _chewieController!)),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: _closeVideoPlayer,
                              icon: const Icon(Icons.close,
                                  color: AppColors.buttonText),
                              label: const Text(
                                'Close',
                                style: TextStyle(
                                  color: AppColors.buttonText,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                ),
              Expanded(
                child: isLoading
                    ? const Loading()
                    : GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: _videos.length,
                        itemBuilder: (context, index) {
                          var video = _videos[index];
                          return GestureDetector(
                            onTap: () => _selectVideo(video),
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15.0)),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        video.thumbnails.highResUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            video.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            video.author,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
