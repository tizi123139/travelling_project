class CultureItem {
  final String id;
  final String name;
  final String category; // 传统技艺/表演艺术/民俗活动等
  final String region; // 华中/华东/华南等
  final String description;
  final List<String> images;
  final List<String> tags;
  final int likes;
  final int shares;
  final int viewCount;
  final List<CulturePost> posts;
  final String? experienceLocation;
  final String? experienceContact;
  final double? experiencePrice;
  final DateTime createdAt;

  CultureItem({
    required this.id,
    required this.name,
    required this.category,
    required this.region,
    required this.description,
    required this.images,
    required this.tags,
    required this.likes,
    required this.shares,
    required this.viewCount,
    required this.posts,
    this.experienceLocation,
    this.experienceContact,
    this.experiencePrice,
    required this.createdAt,
  });

  factory CultureItem.fromJson(Map<String, dynamic> json) {
    return CultureItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      region: json['region'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      likes: json['likes'] ?? 0,
      shares: json['shares'] ?? 0,
      viewCount: json['view_count'] ?? 0,
      posts: (json['posts'] as List? ?? [])
          .map((post) => CulturePost.fromJson(post))
          .toList(),
      experienceLocation: json['experience_location'],
      experienceContact: json['experience_contact'],
      experiencePrice: (json['experience_price'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  CultureItem copyWith({
    String? id,
    String? name,
    String? category,
    String? region,
    String? description,
    List<String>? images,
    List<String>? tags,
    int? likes,
    int? shares,
    int? viewCount,
    List<CulturePost>? posts,
    String? experienceLocation,
    String? experienceContact,
    double? experiencePrice,
    DateTime? createdAt,
  }) {
    return CultureItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      region: region ?? this.region,
      description: description ?? this.description,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      viewCount: viewCount ?? this.viewCount,
      posts: posts ?? this.posts,
      experienceLocation: experienceLocation ?? this.experienceLocation,
      experienceContact: experienceContact ?? this.experienceContact,
      experiencePrice: experiencePrice ?? this.experiencePrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CulturePost {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String title;
  final String content;
  final List<String> images;
  final List<String> videos;
  final int likes;
  final int comments;
  final int shares;
  final DateTime createdAt;
  final List<CultureComment> commentsList;

  CulturePost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.title,
    required this.content,
    required this.images,
    required this.videos,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.createdAt,
    required this.commentsList,
  });

  factory CulturePost.fromJson(Map<String, dynamic> json) {
    return CulturePost(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userAvatar: json['user_avatar'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      commentsList: (json['comments_list'] as List? ?? [])
          .map((comment) => CultureComment.fromJson(comment))
          .toList(),
    );
  }
}

class CultureComment {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final int likes;
  final DateTime createdAt;

  CultureComment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.likes,
    required this.createdAt,
  });

  factory CultureComment.fromJson(Map<String, dynamic> json) {
    return CultureComment(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userAvatar: json['user_avatar'],
      content: json['content'] ?? '',
      likes: json['likes'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}