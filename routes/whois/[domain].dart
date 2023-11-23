import 'package:dart_frog/dart_frog.dart';
import 'package:xml/xml.dart';

Response onRequest(RequestContext context, String domain) {
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
                        builder.cdata('${domain.toUpperCase()}的域名信息');
                      },
                    )
                    ..element(
                      'description',
                      nest: () {
                        builder.cdata('<p>P标签</p>');
                      },
                    );
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
