import '../model/post.dart';

abstract class PostRepository {
  Future<Post> getPost(int postId);
}
