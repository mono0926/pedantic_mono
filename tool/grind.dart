import 'package:grinder/grinder.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

void main(List<String> args) => grind(args);
final _client = http.Client();

@Task('diff')
Future<void> diff() async {
  final monoUrls = [
    'https://github.com/mono0926/pedantic_mono/blob/main/lib/analysis_options.yaml',
    'https://github.com/mono0926/pedantic_mono/blob/main/lib/analysis_options_flutter_samples.yaml',
    'https://github.com/google/pedantic/blob/master/lib/analysis_options.1.11.0.yaml'
  ];

  final flutterUrls = [
    'https://github.com/flutter/packages/blob/master/packages/flutter_lints/lib/flutter.yaml',
    'https://github.com/dart-lang/lints/blob/main/lib/recommended.yaml',
    'https://github.com/dart-lang/lints/blob/main/lib/core.yaml',
  ];

  final monoRaws = _toRaws(monoUrls);
  final flutterRaws = _toRaws(flutterUrls);
  final monoRules = await _extractMergedRules(monoRaws);
  final flutterRules = await _extractMergedRules(flutterRaws);
  final monoOnlyRules = monoRules.difference(flutterRules);
  final flutterOnlyRules = flutterRules.difference(monoRules);
  log('monoOnlyRules: $monoOnlyRules');
  log('flutterOnlyRules: $flutterOnlyRules');

  log((monoOnlyRules.toList()..sort()).map((rule) => '    - $rule').join('\n'));
}

List<String> _toRaws(List<String> urls) => urls.map((url) {
      return 'https://raw.githubusercontent.com/${Uri.parse(url).path.replaceFirst('blob/', '')}';
    }).toList();

Future<Set<String>> _extractMergedRules(List<String> urls) async {
  final rules = (await Future.wait(
    urls.map(_extractRules),
  ))
      .expand((rules) => rules);
  return Set.from(rules);
}

Future<List<String>> _extractRules(String url) async {
  final res = await _client.get(Uri.parse(url));
  final body = res.body;
  final yaml = (loadYaml(body) as Map).cast<String, dynamic>();
  final linter = (yaml['linter'] as Map).cast<String, dynamic>();
  final rules = (linter['rules'] as YamlList).value.cast<String>();
  log('$rules');
  return rules;
}
