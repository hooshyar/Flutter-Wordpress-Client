class User {
  int? id;
  String? name;
  String? url;
  String? description;
  String? link;
  String? slug;
  AvatarUrls? avatarUrls;
  List<Null>? meta;


  User(
      {this.id,
      this.name,
      this.url,
      this.description,
      this.link,
      this.slug,
      this.avatarUrls,
      this.meta,
   });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    description = json['description'];
    link = json['link'];
    slug = json['slug'];
    avatarUrls = json['avatar_urls'] != null
        ? new AvatarUrls.fromJson(json['avatar_urls'])
        : null;
   
    
  }

  User.fromMap(Map userMap);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['description'] = this.description;
    data['link'] = this.link;
    data['slug'] = this.slug;
    if (this.avatarUrls != null) {
      data['avatar_urls'] = this.avatarUrls!.toJson();
    }
 
    return data;
  }
}

class AvatarUrls {
  String? s24;
  String? s48;
  String? s96;

  AvatarUrls({this.s24, this.s48, this.s96});

  AvatarUrls.fromJson(Map<String, dynamic> json) {
    s24 = json['24'];
    s48 = json['48'];
    s96 = json['96'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['24'] = this.s24;
    data['48'] = this.s48;
    data['96'] = this.s96;
    return data;
  }
}



class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
