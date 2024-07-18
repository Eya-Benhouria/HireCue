import 'dart:convert';
import 'http_client.dart';

class PostsService {
  final HttpClient _httpClient = HttpClient();

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final response = await _httpClient.get('posts.json');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.entries.map((entry) {
        final post = entry.value as Map<String, dynamic>;
        post['id'] = entry.key;  // Add the id to the post map
        return post;
      }).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> addPost(Map<String, dynamic> postData) async {
    await _httpClient.post('posts.json', postData);
  }

  Future<void> updatePost(String id, Map<String, dynamic> postData) async {
    await _httpClient.put('posts/$id.json', postData);
  }

  Future<void> deletePost(String id) async {
    await _httpClient.delete('posts/$id.json');
  }
}
