import 'package:flutter/material.dart';
import '../../wordpress_client.dart';
import '../widgets/drawerMain.dart';
import '../widgets/catWidgets.dart';
import '../models/post.dart';
import '../config.dart';
import 'listView.dart';

class HomePage extends StatefulWidget {
  final WordPressClient client;

  const HomePage({Key? key, required this.client}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post>? _posts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final response = await widget.client.getPosts(perPage: defaultPerPage);
      setState(() {
        _posts = response.items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(connectionError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMain(client: widget.client),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _posts == null
              ? Center(child: Text(connectionError))
              : ListViewPosts(posts: _posts, client: widget.client),
    );
  }
}
