// ignore_for_file: unreachable_from_main

import 'package:grinder/grinder.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

void main(List<String> args) => grind(args);
final _client = http.Client();

@Task('diff')
Future<void> diff() async {
  final monoUrls = [
    'https://github.com/mono0926/pedantic_mono/blob/main/lib/analysis_options.yaml',
  ];

  final flutterUrls = [
    'https://github.com/flutter/packages/blob/main/packages/flutter_lints/lib/flutter.yaml',
    'https://github.com/dart-lang/lints/blob/main/lib/recommended.yaml',
    'https://github.com/dart-lang/lints/blob/main/lib/core.yaml',
  ];

  final monoRaws = _toRaws(monoUrls);
  final flutterRaws = _toRaws(flutterUrls);
  final monoRules = await _extractMergedRules(monoRaws);
  final flutterRules = await _extractMergedRules(flutterRaws);
  final monoOnlyRules = monoRules.difference(flutterRules);
  final flutterOnlyRules = flutterRules.difference(monoRules);
  final duplicatedRules = flutterRules.intersection(monoRules);

  log('pedantic_mono only: \n${_formatRules(monoOnlyRules)}');
  log('flutter_lints only: \n${_formatRules(flutterOnlyRules)}');
  log('duplicated: \n${_formatRules(duplicatedRules)}');
}

String _formatRules(Set<String> rules) =>
    (rules.toList()..sort()).map((rule) => '    - $rule').join('\n');

List<String> _toRaws(List<String> urls) => urls.map((url) {
  return 'https://raw.githubusercontent.com/${Uri.parse(url).path.replaceFirst('blob/', '')}';
}).toList();

Future<Set<String>> _extractMergedRules(List<String> urls) async {
  final rules = (await Future.wait(
    urls.map(_extractRules),
  )).expand((rules) => rules);
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
