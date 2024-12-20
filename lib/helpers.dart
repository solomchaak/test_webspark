import 'package:http/http.dart' as http;
import 'package:test_webspark/model/response_data.dart';


Future<ResponseData> fetchData(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    ResponseData responseData = ResponseData.fromRawJson(response.body);
    return responseData;
  } else {
    throw Exception('Error ${response.statusCode}: ${response.body}');
  }
}

Future<void> sendResults() async {

}