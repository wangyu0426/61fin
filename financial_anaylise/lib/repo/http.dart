import 'package:dio/dio.dart';

class Http {
  final String queryGetInstitutions = "\n{\ninstitutions {\nid\ncompany_zh\ncompany_en\nabout_en\nservices_en\nproducts_en\nwebsite\nlogo {\nurl\n}\ninstitutiontags {\nid\nname_en\n}\n}\n}\n";
  final String  queryGetFinancial="\nquery Financial(\$code: String!, \$reportType: String!){\ngetFinancial(code:\$code, reportType:\$reportType){\ncode\ncurrency\nreport\nindustryType\ndatetime\n}\n}";
  final String  queryGetCoacodeMapping="\nquery {\napi_coacodemapping {\ncode\neng\nchs\n}\n}";
  final String  queryGetFinancialRatio="\nquery Ratio(\$code: String!){\ngetFinancialRatio(code: \$code) {\ncode\ncurrency\ndate\nratioReport\n}\n}";
  final String  queryGetRatiocodeMapping="\nquery {\napi_financialratiocodemapping {\ncode\neng\neng_desc\nchs\nchs_desc\n}\n}";
  final String  queryGetPartnerCodes="\nquery {\napi_translationcode(where: {status: {_eq: 1}}) {\ncode\n}\n}\n";
  void getHttp() async {
    try {
      Response response = await Dio().get("http://www.google.com");
      print(response);
    } catch (e) {
      print(e);
    }
  }
}