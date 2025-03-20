import 'package:flutter/material.dart';
import 'package:observer/week6/EX-2-START-CODE/model/post.dart';
import 'package:observer/week6/EX-2-START-CODE/repository/mock_post_repository.dart';
import 'package:observer/week6/EX-2-START-CODE/repository/post_repository.dart';
import 'async_value.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repository = MockPostRepository();

  AsyncValue<List<Post>>? postsValue;

  PostProvider({required PostRepository repository}) {
    fetchPosts(); // Load posts when the provider is created
  }

  Future<void> fetchPosts() async {
    // 1-  Set loading state
    postsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2   Fetch the data
      List<Post> posts = await _repository.getPosts();

      // 3  Set success state
      postsValue = AsyncValue.success(posts);
    } catch (error) {
      // 4  Set error state
      postsValue = AsyncValue.error(error);
    }

    notifyListeners();
  }
}