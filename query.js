function(e,t,n){
    "use strict";
    Object.defineProperty(t,"__esModule",{value:!0});
    t.queryGetInstitutions=function(){
        var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:"en";
        return"\n{\ninstitutions {\nid\n"+("zh"===e?"company_zh":"")+
        "\ncompany_en\nabout_"+e+"\nservices_"+e+"\nproducts_"+e+
        "\nwebsite\nlogo {\nurl\n}\ninstitutiontags {\nid\nname_"+e+"\n}\n}\n}\n"
    }}
    t.queryGetFinancial="\nquery Financial($code: String!, $reportType: String!){\ngetFinancial(code:$code, reportType:$reportType){\ncode\ncurrency\nreport\nindustryType\ndatetime\n}\n}",
    t.queryGetCoacodeMapping="\nquery {\napi_coacodemapping {\ncode\neng\nchs\n}\n}",
    t.queryGetFinancialRatio="\nquery Ratio($code: String!){\ngetFinancialRatio(code: $code) {\ncode\ncurrency\ndate\nratioReport\n}\n}",
    t.queryGetRatiocodeMapping="\nquery {\napi_financialratiocodemapping {\ncode\neng\neng_desc\nchs\nchs_desc\n}\n}",
    t.queryGetPartnerCodes="\nquery {\napi_translationcode(where: {status: {_eq: 1}}) {\ncode\n}\n}\n"
}