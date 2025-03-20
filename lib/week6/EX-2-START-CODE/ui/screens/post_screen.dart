import 'package:flutter/material.dart';
import 'package:observer/week6/EX-2-START-CODE/model/post.dart';
import 'package:provider/provider.dart';
import '../providers/async_value.dart';
import '../providers/post_provider.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //  1 - Get the post provider
    final PostProvider postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            // 2- Fetch the post
            onPressed: () => {postProvider.fetchPosts()},
            icon: const Icon(Icons.update),
          ),
        ],
      ),

      // 3 -  Display the post
      body: Center(child: _buildBody(postProvider)),
    );
  }

  Widget _buildBody(PostProvider postProvider) {
    final postsValue = postProvider.postsValue;

    if (postsValue == null) {
      return const Text('Tap refresh to display posts'); // display an empty state
    }

    switch (postsValue.state) {
      case AsyncValueState.loading:
        return const CircularProgressIndicator(); // display a progress

      case AsyncValueState.error:
        return Text('Error: ${postsValue.error}'); // display a error

      case AsyncValueState.success:
        final posts = postsValue.data!;
        if (posts.isEmpty) {
          return const Text('No posts available.');
        } else {
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: posts[index]);
            },
          );
        }
    }
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(post.title), subtitle: Text(post.description));
  }
}