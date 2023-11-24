import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dream/models/whois.dart';
import 'package:dream/utils/ext.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

const whoisJson = '''
{
    "result": {
        "domain_name": "zhuwenhao.me",
        "creation_date": "2022-07-01 03:17:05",
        "updated_date": "2023-06-10 07:56:23",
        "expiration_date": "2024-07-01 03:17:05",
        "registrar": "Cloudflare, Inc",
        "status": "clientTransferProhibited https://icann.org/epp#clientTransferProhibited"
    }
}
''';

Response onRequest(RequestContext context, String domain) {
  final json = jsonDecode(whoisJson) as Map<String, dynamic>;
  final whois = Whois.fromJson(json['result'] as Map<String, dynamic>);

  final description = '''
<b>注册商：</b><br>
${whois.registrar}<br><br>
<b>创建时间：</b><br>
${whois.creationDate}<br><br>
<b>过期时间：</b><br>
${whois.expirationDate}<br><br>
<b>更新时间：</b><br>
${whois.updatedDate}<br><br>
<b>状态：</b><br>
${whois.status}
''';

  final pubDate = DateFormat('yyyy-MM-dd HH:mm:ss')
      .parse(whois.updatedDate, true)
      .toRfc822String();

  final builder = XmlBuilder();
  builder
    ..processing('xml', 'version="1.0" encoding="UTF-8"')
    ..element(
      'rss',
      attributes: {
        'xmlns:atom': 'http://www.w3.org/2005/Atom',
        'version': '2.0',
      },
      nest: () {
        builder.element(
          'channel',
          nest: () {
            builder
              ..element('title', nest: () => builder.cdata('域名信息查询'))
              ..element('link', nest: 'https://apilayer.com')
              ..element('description', nest: () => builder.cdata('域名信息查询'))
              ..element(
                'lastBuildDate',
                nest: DateTime.now().toUtc().toRfc822String(),
              )
              ..element(
                'item',
                nest: () {
                  builder
                    ..element(
                      'title',
                      nest: () {
                        builder.cdata('${whois.domainName.toUpperCase()}的域名信息');
                      },
                    )
                    ..element(
                      'description',
                      nest: () => builder.cdata(description),
                    )
                    ..element(
                      'link',
                      nest: 'https://whois.chinaz.com/${whois.domainName}',
                    )
                    ..element('pubDate', nest: pubDate);
                },
              );
          },
        );
      },
    );

  return Response(
    body: builder.buildDocument().toXmlString(),
    headers: {
      'Content-Type': 'application/xml; charset=utf-8',
    },
  );
}
