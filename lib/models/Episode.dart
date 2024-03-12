class episodes{
  final int? season;
  final int? episode;
  final String? name;
  final String? description;
  final String? thumbnailUrl;
  final double? rating;
  final String? airDate;

  episodes({
    this.season,
    this.episode,
    this.name,
    this.description,
    this.thumbnailUrl,
    this.rating,
    this.airDate
  });

  factory episodes.fromJson(Map<String, dynamic> json) {
    return episodes(
      season: json['season'],
      episode: json['episode'],
      name: json['name'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      rating: json['rating'],
      airDate: json['airDate'],
    );
  }
}