import 'package:hive/hive.dart';

part 'repository_model.g.dart';

@HiveType(typeId: 0)
class GitRepository {
  @HiveField(0)
  final String? username;
  @HiveField(1)
  final String? stargazers;
  @HiveField(2)
  final String? watchers;
  @HiveField(3)
  final String? reposName;
  @HiveField(4)
  final String? userImage;
  @HiveField(5)
  final String? reposUrl;

  GitRepository({
    this.username,
    this.stargazers,
    this.watchers,
    this.reposName,
    this.userImage,
    this.reposUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'owner': {
        'login': username,
        'avatar_url': userImage,
      },
      'stargazers_count': stargazers,
      'watchers_count': watchers,
      'name': reposName,
      'html_url': reposUrl,
    };
  }

  factory GitRepository.fromJson(Map<String, dynamic> json) {
    return GitRepository(
      username: json['owner']?['login'],
      stargazers: json['stargazers_count'].toString(),
      watchers: json['watchers_count'].toString(),
      reposName: json['name'],
      userImage: json['owner']?['avatar_url'],
      reposUrl: json['html_url'],
    );
  }
}
