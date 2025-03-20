import '../model/post.dart';

import 'post_repository.dart';

class MockPostRepository extends PostRepository {
  @override
  Future<Post> getPost(int postId) {
    return Future.delayed(Duration(seconds: 5), () {
      if (postId != 25) {
        throw Exception("No post found");
      }
      return Post(
        id: 25,
        title: 'Who is the best',
        description: 'teacher ronan',
      );
    });
  }
}
