# A Wordpress client for Flutter 

### This project uses a simple WordPress website as a backend, without any additional plugin.

<p>
<img src="https://www.datacode.app/flutter-wp/wp-content/uploads/2020/01/wordpress_flutter1.gif" alt="gif 1 title="Wordpress-client" />
<img src="https://www.datacode.app/flutter-wp/wp-content/uploads/2020/01/wordpress_flutter2.gif" alt="image 2" title="Wordpress-client" />
</p>
for more information about WordPress rest API visit https://developer.wordpress.org/rest-api/ 

For help getting started with Flutter, view Flutter online
[documentation](https://flutter.io/).

I have used this repository:
https://github.com/kbirch/wordpress_client

## Prerequisites

Flutter

Make sure your WordPress version is greater or equal to 4.7

Clone repository
<code>git clone https://github.com/hooshyar/Flutter-Wordpress-Client.git </code>

and open <code>pubspec.yaml</code>

run 
<code>flutter packages get</code>

open config.dart and change <code>"https://www.mihrabani.com"</code> to your website address for example if my website is wordpress.com you have to change it to this : <code>"http://www.wordpress.com"</code>
Do not add any additional characters like "/".

to your WordPress website address

run app on a simulator
<code>flutter run</code>

## Roadmap
- [x] Sliver app bar
- [x] Sliver list view
- [x] Connectivity status, if offline pop a message
- [ ] Cache on device
- [x] Pull to refresh
- [x] Global perPage
- [ ] Global theming
- [ ] Setting page
- [x] Provider
- [ ] Splash screen 
- [ ] Nice Categories page screen 
- [ ] real time clap button like Medium
- [ ] Share and fav buttons 
