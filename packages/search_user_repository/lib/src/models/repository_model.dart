class GitRepository {
  final String? username;
  final String? stargazers;
  final String? watchers;
  final String? reposName;
  final String? userImage;
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
