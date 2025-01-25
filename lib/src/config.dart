/// WordPress site configuration
const String baseUrl = 'https://www.ferbon.com';
const String wordPressUrl = '$baseUrl/wp-json/wp/v2';

/// Default pagination settings
const int defaultPerPage = 10;
const int maxPerPage = 100;

/// Cache settings
const Duration defaultCacheDuration = Duration(hours: 24);

/// Error messages
const String connectionError = 'Internet connection problem';
const String serverError = 'Server error occurred';
const String noPostsError = 'No posts found';

/// UI constants
const double defaultPadding = 16.0;
const double defaultSpacing = 8.0;
const double defaultRadius = 4.0;
const double barIconSize = 40.0;

/// Featured categories
const Map<String, CategoryInfo> categories = {
  'News': CategoryInfo(id: 176, name: 'News'),
  'Technology': CategoryInfo(id: 9875, name: 'Technology'),
  'Culture': CategoryInfo(id: 207, name: 'Culture'),
  'Health': CategoryInfo(id: 208, name: 'Health'),
  'Kurdistan': CategoryInfo(id: 188, name: 'Kurdistan'),
  'Iraq': CategoryInfo(id: 6098, name: 'Iraq'),
  'Woman': CategoryInfo(id: 9102, name: 'Woman'),
  'Jihan': CategoryInfo(id: 195, name: 'Jihan'),
  'Abori': CategoryInfo(id: 196, name: 'Abori'),
};

/// Category information
class CategoryInfo {
  final int id;
  final String name;

  const CategoryInfo({required this.id, required this.name});
}

//Show how many per_page ?
final String perPage = "10";

//Categories ids
final String grngId = "176";
final String grngName = "176";

final String jihanId = "195";
final String jihanName = "195";

final String iraqId = "6098";
final String iraqName = "6098";

final String kurdistanId = "188";
final String kurdistanName = "188";

final String aboriId = "196";
final String aboriName = "196";

final String healthId = "208";
final String healthName = "208";

final String techId = "9875";
final String techName = "9875";

final String cultureId = "207";
final String cultureName = "207";

final String womanId = "9102";
final String womanName = "9102";

final String mainPageId = "";
final String mainApiUrl = "$baseUrl/wp-json";
final String connectionProblemError = ' Internet Connection Problem ';

/// API endpoints
const String postsEndpoint = 'posts';
const String categoriesEndpoint = 'categories';
const String mediaEndpoint = 'media';

/// Query parameters
const String embedParam = '_embed=true';
const String perPageParam = 'per_page=10';
const String statusParam = 'status=publish';
const String orderByDateDesc = 'orderby=date&order=desc';
