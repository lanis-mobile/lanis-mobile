import 'package:dio/dio.dart';
import 'package:sph_plan/core/applet_parser.dart';
import 'package:sph_plan/core/sph/session.dart';
import 'package:sph_plan/models/abitur_helper.dart';

class AbiturParser extends AppletParser<List<AbiturRow>> {


  AbiturParser(super.sph, super.appletDefinition);


  @override
  Future<List<AbiturRow>> getHome() async {
    return _getRows();
  }

  Future<List<AbiturRow>> _getRows() async {
    Response response = await sph.session.dio
        .get('https://start.schulportal.hessen.de/abiturhelfer.php');

    print(response.data);

    return [];
  }

}

