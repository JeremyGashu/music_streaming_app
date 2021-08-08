class MetaData {
  MetaData({
    this.page,
    this.perPage,
    this.pageCount,
    this.totalCount,
    this.links,
  });

  int page;
  int perPage;
  int pageCount;
  int totalCount;
  List<Link> links;

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        page: json["page"],
        perPage: json["per_page"],
        pageCount: json["page_count"],
        totalCount: json["total_count"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "page_count": pageCount,
        "total_count": totalCount,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
      };
}

class Link {
  Link({
    this.self,
    this.first,
    this.previous,
    this.next,
    this.last,
  });

  String self;
  String first;
  String previous;
  String next;
  String last;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        self: json["self"] == null ? null : json["self"],
        first: json["first"] == null ? null : json["first"],
        previous: json["previous"] == null ? null : json["previous"],
        next: json["next"] == null ? null : json["next"],
        last: json["last"] == null ? null : json["last"],
      );

  Map<String, dynamic> toJson() => {
        "self": self == null ? null : self,
        "first": first == null ? null : first,
        "previous": previous == null ? null : previous,
        "next": next == null ? null : next,
        "last": last == null ? null : last,
      };
}
