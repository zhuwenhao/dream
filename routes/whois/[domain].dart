import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dream/models/whois.dart';
import 'package:xml/xml.dart';

const whoisJson = '''
{
    "result": {
        "domain_id": "6e25d31c441a41b68b46f9f279bad93a-DONUTS",
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
<div>注册商</div>
<div>${whois.registrar}</div>
<div>创建时间</div>
<div>${whois.creationDate}</div>
<div>过期时间</div>
<div>${whois.expirationDate}</div>
<div>更新时间</div>
<div>${whois.updatedDate}</div>
''';

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
              ..element(
                'atom:link',
                attributes: {
                  'href': context.request.uri.toString(),
                  'rel': 'self',
                  'type': 'application/rss+xml',
                },
              )
              ..element('description', nest: () => builder.cdata('域名信息查询'))
              ..element('generator', nest: '猪蚊耗')
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
                      nest: () {
                        builder.cdata(description);
                      },
                    )
                    ..element('link', nest: 'https://whois.chinaz.com/$domain');
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
