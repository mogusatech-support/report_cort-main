






import 'package:flutter/material.dart';
// for 4-9
import 'package:http/http.dart' as http;
import 'dart:convert';
enum SortOption { alphabetical, proximity, operational }

//    search_store_old


class SearchStoreOld extends StatefulWidget {
  @override
  _SearchStoreOldState createState() => _SearchStoreOldState();
}

class _SearchStoreOldState extends State<SearchStoreOld> {





  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> mapData = [];

  List<Map<String, String>> appMapData = [];

  List<Map<String, String>> TotalmapData = [
    {
      '마트이름': '아무거나',
      '전화번호': '55555555',
      '스토어거리': '333333',
      '앱설정': 'yes',

    },
    {
      '마트이름': '무작위',
      '전화번호': '77777777',
      '스토어거리': '111111',
      '앱설정': 'no',
    },
    {
      '마트이름': '랜덤마트',
      '전화번호': '99999999',
      '스토어거리': '222222',
      '앱설정': 'yes',
    },
    {
      '마트이름': '테스트마트',
      '전화번호': '12345678',
      '스토어거리': '444444',
      '앱설정': 'yes',
    },
    {
      '마트이름': '홍길동마트',
      '전화번호': '98765432',
      '스토어거리': '555555',
      '앱설정': 'yes',
    },
    {
      '마트이름': '우리마트',
      '전화번호': '11112222',
      '스토어거리': '666666',
      '앱설정': 'yes',
    },
    {
      '마트이름': '무한마트',
      '전화번호': '33334444',
      '스토어거리': '777777',
      '앱설정': 'yes',
    },
    {
      '마트이름': '새로운마트',
      '전화번호': '55556666',
      '스토어거리': '888888',
      '앱설정': 'yes',
    },
    {
      '마트이름': '편의점마트',
      '전화번호': '77778888',
      '스토어거리': '999999',
      '앱설정': 'yes',
    },
    {
      '마트이름': '식자재마트',
      '전화번호': '99991111',
      '스토어거리': '000000',
      '앱설정': 'yes',
    },
    {
      '마트이름': '맛있는마트',
      '전화번호': '22223333',
      '스토어거리': '121212',
      '앱설정': 'yes',
    },
    {
      '마트이름': '좋은마트',
      '전화번호': '44445555',
      '스토어거리': '232323',
      '앱설정': 'no',
    },
    {
      '마트이름': '고객센터마트',
      '전화번호': '66667777',
      '스토어거리': '343434',
      '앱설정': 'no',
    },
    {
      '마트이름': '행복마트',
      '전화번호': '88889999',
      '스토어거리': '454545',
      '앱설정': 'no',
    },
    {
      '마트이름': '마트가게',
      '전화번호': '12121212',
      '스토어거리': '565656',
      '앱설정': 'no',
    },
    {
      '마트이름': '편리마트',
      '전화번호': '34343434',
      '스토어거리': '676767',
      '앱설정': 'no',
    },
    {
      '마트이름': '현대마트',
      '전화번호': '56565656',
      '스토어거리': '787878',
      '앱설정': 'no',
    },
    {
      '마트이름': '훌륭한마트',
      '전화번호': '78787878',
      '스토어거리': '898989',
      '앱설정': 'no',
    },
    {
      '마트이름': '마트왕',
      '전화번호': '11110000',
      '스토어거리': '909090',
      '앱설정': 'no',
    },
    {
      '마트이름': '신선한마트',
      '전화번호': '33332222',
      '스토어거리': '010101',
      '앱설정': 'no',
    },
    {
      '마트이름': '황금마트',
      '전화번호': '55554444',
      '스토어거리': '121212',
      '앱설정': 'no',
    },
    {
      '마트이름': '가장가까운마트',
      '전화번호': '77776666',
      '스토어거리': '232323',
      '앱설정': 'no',
    },
    {
      '마트이름': '한결같은마트',
      '전화번호': '99998888',
      '스토어거리': '343434',
      '앱설정': 'no',
    },
    {
      '마트이름': '행운마트',
      '전화번호': '22221111',
      '스토어거리': '454545',
      '앱설정': 'no',
    },
    {
      '마트이름': '편의점',
      '전화번호': '44443333',
      '스토어거리': '565656',
      '앱설정': 'no',
    },
    {
      '마트이름': '마트세상',
      '전화번호': '66662222',
      '스토어거리': '676767',
      '앱설정': 'no',
    },
    {
      '마트이름': '최고의마트',
      '전화번호': '88881111',
      '스토어거리': '787878',
      '앱설정': 'no',
    },
    {
      '마트이름': '한솔마트',
      '전화번호': '11112222',
      '스토어거리': '898989',
      '앱설정': 'no',
    },
    {
      '마트이름': '마트하나',
      '전화번호': '33334444',
      '스토어거리': '909090',
      '앱설정': 'no',
    },
    {
      '마트이름': '신마트',
      '전화번호': '55556666',
      '스토어거리': '010101',
      '앱설정': 'no',
    },
    {
      '마트이름': '착한마트',
      '전화번호': '77778888',
      '스토어거리': '121212',
      '앱설정': 'no',
    },
    {
      '마트이름': '큰마트',
      '전화번호': '99991111',
      '스토어거리': '232323',
      '앱설정': 'no',
    },
    {
      '마트이름': '빠른마트',
      '전화번호': '22223333',
      '스토어거리': '343434',
      '앱설정': 'no',
    },
    {
      '마트이름': '최신마트',
      '전화번호': '44445555',
      '스토어거리': '454545',
      '앱설정': 'no',
    },
    {
      '마트이름': '가까운마트',
      '전화번호': '66667777',
      '스토어거리': '565656',
      '앱설정': 'no',
    },
    {
      '마트이름': '멋진마트',
      '전화번호': '88889999',
      '스토어거리': '676767',
      '앱설정': 'no',
    },
    {
      '마트이름': '상점마트',
      '전화번호': '12121212',
      '스토어거리': '787878',
      '앱설정': 'no',
    },
    {
      '마트이름': '편의점마트',
      '전화번호': '34343434',
      '스토어거리': '898989',
      '앱설정': 'no',
    },
    {
      '마트이름': '편리한마트',
      '전화번호': '56565656',
      '스토어거리': '909090',
      '앱설정': 'no',
    },
    {
      '마트이름': '무한한마트',
      '전화번호': '78787878',
      '스토어거리': '010101',
      '앱설정': 'no',
    },
    {
      '마트이름': '서울마트',
      '전화번호': '00001111',
      '스토어거리': '121212',
      '앱설정': 'no',
    },
    {
      '마트이름': '행복한마트',
      '전화번호': '22223333',
      '스토어거리': '232323',
      '앱설정': 'no',
    },
    {
      '마트이름': '이상한마트',
      '전화번호': '44445555',
      '스토어거리': '343434',
      '앱설정': 'no',
    },
    {
      '마트이름': '실속마트',
      '전화번호': '66667777',
      '스토어거리': '454545',
      '앱설정': 'no',
    },
    {
      '마트이름': '세련된마트',
      '전화번호': '88889999',
      '스토어거리': '565656',
      '앱설정': 'no',
    },
    {
      '마트이름': '우리동네마트',
      '전화번호': '12121212',
      '스토어거리': '676767',
      '앱설정': 'no',
    },
    {
      '마트이름': '알뜰마트',
      '전화번호': '34343434',
      '스토어거리': '787878',
      '앱설정': 'no',
    },
    {
      '마트이름': '최고마트',
      '전화번호': '56565656',
      '스토어거리': '898989',
      '앱설정': 'no',
    },
    {
      '마트이름': '행복마트',
      '전화번호': '78787878',
      '스토어거리': '909090',
      '앱설정': 'no',
    },
    {
      '마트이름': '행운마트',
      '전화번호': '90909090',
      '스토어거리': '010101',
      '앱설정': 'no',
    },
    {
      '마트이름': '가까운슈퍼마트',
      '전화번호': '12121212',
      '스토어거리': '121212',
      '앱설정': 'no',
    },
    {
      '마트이름': '큰슈퍼마트',
      '전화번호': '34343434',
      '스토어거리': '232323',
      '앱설정': 'no',
    },
    {
      '마트이름': '이쁜슈퍼마트',
      '전화번호': '56565656',
      '스토어거리': '343434',
      '앱설정': 'no',
    },
    {
      '마트이름': '아늑한슈퍼마트',
      '전화번호': '78787878',
      '스토어거리': '454545',
      '앱설정': 'no',
    },
    {
      '마트이름': '상상하는슈퍼마트',
      '전화번호': '90909090',
      '스토어거리': '565656',
      '앱설정': 'no',
    },
    {
      '마트이름': '편리한슈퍼마트',
      '전화번호': '12345678',
      '스토어거리': '123456',
      '앱설정': 'no',
    },
    {
      '마트이름': '행복한슈퍼마트',
      '전화번호': '87654321',
      '스토어거리': '654321',
      '앱설정': 'no',
    },
    {
      '마트이름': '좋은슈퍼마트',
      '전화번호': '11112222',
      '스토어거리': '222222',
      '앱설정': 'no',
    },
    {
      '마트이름': '감사하는슈퍼마트',
      '전화번호': '33334444',
      '스토어거리': '333333',
      '앱설정': 'no',
    },
    {
      '마트이름': '즐거운슈퍼마트',
      '전화번호': '55556666',
      '스토어거리': '444444',
      '앱설정': 'no',
    },
    {
      '마트이름': '신선한슈퍼마트',
      '전화번호': '77778888',
      '스토어거리': '555555',
      '앱설정': 'no',
    },
    {
      '마트이름': '신뢰하는슈퍼마트',
      '전화번호': '99991111',
      '스토어거리': '666666',
      '앱설정': 'no',
    },
    {
      '마트이름': '고마운슈퍼마트',
      '전화번호': '22223333',
      '스토어거리': '777777',
      '앱설정': 'no',
    },
    {
      '마트이름': '강력한슈퍼마트',
      '전화번호': '44445555',
      '스토어거리': '888888',
      '앱설정': 'no',
    },
    {
      '마트이름': '신나는슈퍼마트',
      '전화번호': '66667777',
      '스토어거리': '999999',
      '앱설정': 'no',
    },
    {
      '마트이름': '따뜻한슈퍼마트',
      '전화번호': '88889999',
      '스토어거리': '000000',
      '앱설정': 'no',
    },
    {
      '마트이름': '활기찬슈퍼마트',
      '전화번호': '12121212',
      '스토어거리': '111111',
      '앱설정': 'no',
    },
    {
      '마트이름': '희망하는슈퍼마트',
      '전화번호': '34343434',
      '스토어거리': '222222',
      '앱설정': 'no',
    },
    {
      '마트이름': '즐거운슈퍼마트',
      '전화번호': '56565656',
      '스토어거리': '333333',
      '앱설정': 'no',
    },
    {
      '마트이름': '편안한슈퍼마트',
      '전화번호': '78787878',
      '스토어거리': '444444',
      '앱설정': 'no',
    },
    {
      '마트이름': '안전한슈퍼마트',
      '전화번호': '90909090',
      '스토어거리': '555555',
      '앱설정': 'no',
    },
    {
      '마트이름': '즐거운마트',
      '전화번호': '11112222',
      '스토어거리': '666666',
      '앱설정': 'no',
    },
    {
      '마트이름': '신뢰하는마트',
      '전화번호': '33334444',
      '스토어거리': '777777',
      '앱설정': 'no',
    },
    {
      '마트이름': '상쾌한마트',
      '전화번호': '55556666',
      '스토어거리': '888888',
      '앱설정': 'no',
    },
    {
      '마트이름': '쾌적한마트',
      '전화번호': '77778888',
      '스토어거리': '999999',
      '앱설정': 'no',
    },
    {
      '마트이름': '안심마트',
      '전화번호': '99991111',
      '스토어거리': '000000',
      '앱설정': 'no',
    },
    {
      '마트이름': '친절한마트',
      '전화번호': '22223333',
      '스토어거리': '111111',
      '앱설정': 'no',
    },
    {
      '마트이름': '명실마트',
      '전화번호': '44445555',
      '스토어거리': '222222',
      '앱설정': 'no',
    },
    {
      '마트이름': '밝은마트',
      '전화번호': '66667777',
      '스토어거리': '333333',
      '앱설정': 'no',
    },
    {
      '마트이름': '저렴한마트',
      '전화번호': '88889999',
      '스토어거리': '444444',
      '앱설정': 'no',
    },
    {
      '마트이름': '신비한마트',
      '전화번호': '12121212',
      '스토어거리': '555555',
      '앱설정': 'no',
    },
    {
      '마트이름': '착한마트',
      '전화번호': '34343434',
      '스토어거리': '666666',
    },
    {
      '마트이름': '새로운마트',
      '전화번호': '56565656',
      '스토어거리': '777777',
      '앱설정': 'no',
    },
    {
      '마트이름': '원하는마트',
      '전화번호': '78787878',
      '스토어거리': '888888',
      '앱설정': 'no',
    },
    {
      '마트이름': '상상하는마트',
      '전화번호': '90909090',
      '스토어거리': '5999',
      '앱설정': 'no',
    },
    {
      '마트이름': '즐거운마트',
      '전화번호': '11112222',
      '스토어거리': '342',
      '앱설정': 'no',
    },
    {
      '마트이름': '행복한마트',
      '전화번호': '33334444',
      '스토어거리': '1111',
      '앱설정': 'no',
    },
    {
      '마트이름': '느긋한마트',
      '전화번호': '55556666',
      '스토어거리': '222222',
      '앱설정': 'no',
    },
    {
      '마트이름': '안전한마트',
      '전화번호': '77778888',
      '스토어거리': '333333',
      '앱설정': 'no',
    },
    {
      '마트이름': '고마운마트',
      '전화번호': '99991111',
      '스토어거리': '444',
      '앱설정': 'no',
    },
    {
      '마트이름': '신뢰하는마트',
      '전화번호': '22223333',
      '스토어거리': '5535',
      '앱설정': 'no',
    },
    {
      '마트이름': '상쾌한마트',
      '전화번호': '44445555',
      '스토어거리': '666666',
      '앱설정': 'no',
    },
    {
      '마트이름': '편안한마트',
      '전화번호': '66667777',
      '스토어거리': '777777',
      '앱설정': 'no',
    },
    {
      '마트이름': '명실마트',
      '전화번호': '88889999',
      '스토어거리': '888888',
      '앱설정': 'no',
    },
    {
      '마트이름': '밝은마트',
      '전화번호': '12121212',
      '스토어거리': '999999',
      '앱설정': 'no',
    },
    {
      '마트이름': '신비한마트',
      '전화번호': '34343434',
      '스토어거리': '000000',
      '앱설정': 'no',
    },
    {
      '마트이름': '착한마트',
      '전화번호': '56565656',
      '스토어거리': '111111',
      '앱설정': 'no',
    },
    {
      '마트이름': '새로운마트',
      '전화번호': '78787878',
      '스토어거리': '222222',
      '앱설정': 'no',
    },
    {
      '마트이름': '원하는마트',
      '전화번호': '90909090',
      '스토어거리': '333333',
      '앱설정': 'no',
    },
    {
      '마트이름': '상상하는마트',
      '전화번호': '11112222',
      '스토어거리': '444444',
      '앱설정': 'no',
    },
    {
      '마트이름': '느긋한마트',
      '전화번호': '33334444',
      '스토어거리': '555555',
      '앱설정': 'no',
    },
    {
      '마트이름': '안전한마트',
      '전화번호': '55556666',
      '스토어거리': '666666',
      '앱설정': 'no',
    },
    {
      '마트이름': '고마운마트',
      '전화번호': '77778888',
      '스토어거리': '777777',
      '앱설정': 'no',
    },
    {
      '마트이름': '신뢰하는마트',
      '전화번호': '99991111',
      '스토어거리': '888888',
      '앱설정': 'no',
    },
    {
      '마트이름': '상쾌한마트',
      '전화번호': '22223333',
      '스토어거리': '999999',
      '앱설정': 'no',
    },
    {
      '마트이름': '편안한마트',
      '전화번호': '44445555',
      '스토어거리': '000000',
      '앱설정': 'no',
    },
    {
      '마트이름': '명실마트',
      '전화번호': '66667777',
      '스토어거리': '111111',
      '앱설정': 'no',
    },
    {
      '마트이름': '밝은마트',
      '전화번호': '88889999',
      '스토어거리': '222222',
      '앱설정': 'no',
    },
    {
      '마트이름': '신비한마트',
      '전화번호': '12121212',
      '스토어거리': '333333',
      '앱설정': 'no',
    },
    {
      '마트이름': '착한마트',
      '전화번호': '34343434',
      '스토어거리': '444444',
      '앱설정': 'no',
    },
    {
      '마트이름': '새로운마트',
      '전화번호': '56565656',
      '스토어거리': '555555',
      '앱설정': 'no',
    },
    {
      '마트이름': '원하는마트',
      '전화번호': '78787878',
      '스토어거리': '666666',
      '앱설정': 'no',
    },
    {
      '마트이름': '상상하는마트',
      '전화번호': '90909090',
      '스토어거리': '777777',
      '앱설정': 'no',
    },
    {
      '마트이름': '즐거운마트',
      '전화번호': '11112222',
      '스토어거리': '888888',
      '앱설정': 'no',
    },
    {
      '마트이름': '행복한마트',
      '전화번호': '33334444',
      '스토어거리': '999999',
      '앱설정': 'no',
    },
    {
      '마트이름': '느긋한마트',
      '전화번호': '55556666',
      '스토어거리': '000000',
      '앱설정': 'no',
    },
    {
      '마트이름': '안전한마트',
      '전화번호': '77778888',
      '스토어거리': '111111',
      '앱설정': 'no',
    },
    {
      '마트이름': '고마운마트',
      '전화번호': '99991111',
      '스토어거리': '222222',
      '앱설정': 'no',
    },
    {
      '마트이름': '신뢰하는마트',
      '전화번호': '22223333',
      '스토어거리': '333333',
      '앱설정': 'no',
    },
    {
      '마트이름': '상쾌한마트',
      '전화번호': '44445555',
      '스토어거리': '444444',
      '앱설정': 'no',
    },
    {
      '마트이름': '편안한마트',
      '전화번호': '66667777',
      '스토어거리': '555555',
      '앱설정': 'no',
    },
    {
      '마트이름': '명실마트',
      '전화번호': '88889999',
      '스토어거리': '666666',
      '앱설정': 'no',
    },
    {
      '마트이름': '밝은마트',
      '전화번호': '12121212',
      '스토어거리': '777777',
      '앱설정': 'no',
    },
    {
      '마트이름': '신비한마트',
      '전화번호': '34343434',
      '스토어거리': '888888',
      '앱설정': 'no',
    },
    {
      '마트이름': '착한마트',
      '전화번호': '56565656',
      '스토어거리': '999999',
      '앱설정': 'no',
    },
    {
      '마트이름': '새로운마트',
      '전화번호': '78787878',
      '스토어거리': '000000',
      '앱설정': 'no',
    },
    {
      '마트이름': '원하는마트',
      '전화번호': '90909090',
      '스토어거리': '111111',
      '앱설정': 'no',
    },
    {
      '마트이름': '상상하는마트',
      '전화번호': '11112222',
      '스토어거리': '222222',
      '앱설정': 'no',
    },
    {
      '마트이름': '느긋한마트',
      '전화번호': '33334444',
      '스토어거리': '333333',
      '앱설정': 'no',
    },
    {
      '마트이름': '안전한마트',
      '전화번호': '55556666',
      '스토어거리': '444444',
      '앱설정': 'no',
    },
    {
      '마트이름': '고마운마트',
      '전화번호': '77778888',
      '스토어거리': '555555',
      '앱설정': 'no',
    },
    {
      '마트이름': '신뢰하는마트',
      '전화번호': '99991111',
      '스토어거리': '666666',
      '앱설정': 'no',
    },
    {
      '마트이름': '상쾌한마트',
      '전화번호': '22223333',
      '스토어거리': '777777',
      '앱설정': 'no',
    },
    {
      '마트이름': '편안한마트',
      '전화번호': '44445555',
      '스토어거리': '888888',
      '앱설정': 'no',
    },
    {
      '마트이름': '명실마트',
      '전화번호': '66667777',
      '스토어거리': '999999',
      '앱설정': 'no',
    },
    {
      '마트이름': '밝은마트',
      '전화번호': '88889999',
      '스토어거리': '000000',
      '앱설정': 'no',
    },
    {
      '마트이름': '신비한마트',
      '전화번호': '12121212',
      '스토어거리': '111111',
      '앱설정': 'no',
    },
    {
      '마트이름': '착한마트',
      '전화번호': '34343434',
      '스토어거리': '222222',
    },
    {
      '마트이름': '새로운마트',
      '전화번호': '56565656',
      '스토어거리': '333333',
      '앱설정': 'no',
    },
    {
      '마트이름': '원하는마트',
      '전화번호': '78787878',
      '스토어거리': '444444',
      '앱설정': 'no',
    },
    {
      '마트이름': '상상하는마트',
      '전화번호': '90909090',
      '스토어거리': '555555',
      '앱설정': 'no',
    },
    {
      '마트이름': '즐거운마트',
      '전화번호': '11112222',
      '스토어거리': '666666',
      '앱설정': 'no',
    },
    {
      '마트이름': '행복한마트',
      '전화번호': '33334444',
      '스토어거리': '777777',
      '앱설정': 'no',
    },
    {
      '마트이름': '느긋한마트',
      '전화번호': '55556666',
      '스토어거리': '888888',
      '앱설정': 'no',
    },
    {
      '마트이름': '안전한마트',
      '전화번호': '77778888',
      '스토어거리': '999999',
      '앱설정': 'no',
    },
    {
      '마트이름': '고마운마트',
      '전화번호': '99991111',
      '스토어거리': '000000',
      '앱설정': 'no',
    },
  ];




  int selectedButtonIndex = 0; // 1번 버튼 선택
  SortOption selectedSortOption = SortOption.alphabetical; // 기본 정렬 옵션: 가나다순

  @override
  void initState() {
    super.initState();



    // int selectedButtonIndex = 0; // 1번 버튼 선택
    mapData = List.from(TotalmapData);

    List<Map<String, String>> newMapDataTemp = TotalmapData
        .where((map) => map['앱설정'] == 'yes')
        .toList();
    appMapData = List.from(newMapDataTemp);
      fetchData();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // 이전 버튼 눌렀을 때 동작
                },
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '이전',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  // 막대기 아이콘 클릭 시 동작하는 함수
                },
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          child: Divider(
            color: Colors.black,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(1.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),






        // // 총 칼람 시작 세로방향나열하기
        child: Column(
          children: [
            // 매장검색 텍스트휠드 넣는곳  시작 
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '매장검색',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: _handleSearch,
            ),
            // 매장검색 텍스트휠드 넣는곳  시작
            // 위 아래 간격넣기
            SizedBox(height: 16.0),
            // 지역선택 글자넣기
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                '지역선택',
                style: TextStyle(fontSize: 20, color: Color(0xFF245E57)),
              ),
            ),








            // 열여섯개 넣는곳 시작
            Column(
              children: [








                //   111111111   0830
                Row(
                  children: List.generate(5, (index) {
                    int buttonIndex = index;
                    String location;
                    if (buttonIndex == 0) {
                      location = '전체';
                    } else if (buttonIndex == 1) {
                      location = '서울';
                    } else if (buttonIndex == 2) {
                      location = '인천';
                    } else if (buttonIndex == 3) {
                      location = '대전';
                    } else if (buttonIndex == 4) {
                      location = '세중';
                    } else {
                      location = ''; // 기본적으로 빈 문자열로 초기화
                    }
                    return Expanded(
                      child: Container(
                        height: 30,
                        margin: EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedButtonIndex = buttonIndex;
                              print('selectedButtonIndex::${selectedButtonIndex}');
                            });
                          },
                          child: Text(
                            location,
                            style: TextStyle(
                              color: Colors.black, // 글자색 검은색
                              fontSize: 10, // 글자 크기 10
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              buttonIndex == selectedButtonIndex ? Color(0xFF27675F) : Colors.white,
                            ),
                            elevation: MaterialStateProperty.all<double>(0),
                          ),
                        ),
                      ),
                    );
                  }),
                ),



                
                SizedBox(height: 15.0), // Row와 Row 사이 간격




                 //   22222222   0830
                Row(
                  children: List.generate(5, (index) {
                    int buttonIndex = 5 + index;
                    String location;
                    if (buttonIndex == 5) {
                      location = '대구';
                    } else if (buttonIndex == 6) {
                      location = '부산';
                    } else if (buttonIndex == 7) {
                      location = '울산';
                    } else if (buttonIndex == 8) {
                      location = '광주';
                    } else if (buttonIndex == 9) {
                      location = '경기';
                    } else {
                      location = ''; // 기본적으로 빈 문자열로 초기화
                    }
                    return Expanded(
                      child: Container(
                        height: 30,
                        margin: EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedButtonIndex = buttonIndex;
                              print('selectedButtonIndex::${selectedButtonIndex}');
                            });
                          },
                          child: Text(
                            location,
                            style: TextStyle(
                              color: Colors.black, // 글자색 검은색
                              fontSize: 10, // 글자 크기 10
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              buttonIndex == selectedButtonIndex ? Color(0xFF27675F) : Colors.white,
                            ),
                            elevation: MaterialStateProperty.all<double>(0),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 15.0), // Row와 Row 사이 간격


                 //   33333   0830
                Row(
                  children: List.generate(5, (index) {
                    int buttonIndex = 10 + index;
                    String location;
                    if (buttonIndex == 10) {
                      location = '강원';
                    } else if (buttonIndex == 11) {
                      location = '충청';
                    } else if (buttonIndex == 12) {
                      location = '경상';
                    } else if (buttonIndex == 13) {
                      location = '전라';
                    } else if (buttonIndex == 14) {
                      location = '제주';
                    } else {
                      location = ''; // 기본적으로 빈 문자열로 초기화
                    }
                    return Expanded(
                      child: Container(
                        height: 30,
                        margin: EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedButtonIndex = buttonIndex;
                              print('selectedButtonIndex::${selectedButtonIndex}');
                            });
                          },
                          child: Text(
                            location,
                            style: TextStyle(
                              color: Colors.black, // 글자색 검은색
                              fontSize: 10, // 글자 크기 10
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              // 
                              buttonIndex == selectedButtonIndex ? Color(0xFF27675F) : Colors.white,
                            ),
                            elevation: MaterialStateProperty.all<double>(0),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            // 열여섯개 넣는곳 끝





           // 총개수와 드롭다운  시작 

            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 ${mapData.length} 개소',
                  style: TextStyle(fontSize: 15, color: Color(0xFF245E57)),
                ),
                DropdownButton<SortOption>(
                  value: selectedSortOption,
                  onChanged: (SortOption? newValue) {
                    setState(() {
                      selectedSortOption = newValue!;
                      sortMapData();
                    });
                  },
                  items: [
                    DropdownMenuItem<SortOption>(
                      value: SortOption.alphabetical,
                      child: Text('가나다순'),
                    ),
                    DropdownMenuItem<SortOption>(
                      value: SortOption.proximity,
                      child: Text('가까운순'),
                    ),
                    DropdownMenuItem<SortOption>(
                      value: SortOption.operational,
                      child: Text('앱운영중'),
                    ),
                  ],
                ),
              ],
            ),

            // 총개수와 드롭다운  끝 



            // 리스트부분 시작 
            Expanded(
              child: ListView.separated(
                itemCount: mapData.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.black), // 검은색 Divider 추가
                itemBuilder: (context, index) {
                  Map<String, String> item = mapData[index];


                  bool isApp = false;

                  if(item['앱설정']! == 'yes'){
                    isApp = true;
                  }








                  return ListTile(
                    leading: isApp ? Container(
                      width: 50,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ):Container(
                      width: 50,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    title: Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['마트이름']!),
                              SizedBox(height: 4),
                              Text(item['스토어거리']!),
                            ],
                          ),
                        ),
                        Icon(Icons.star),
                      ],
                    ),
                    subtitle: Text(item['전화번호']!),
                  );
                },
              ),
            ),

            // 리스트부분 끝








          ],
        ),
        // 총 칼람 끝 




      ),
    );
  }

  void _handleSearch(String searchTerm) {
    // 검색어 처리 로직을 구현
    print('검색어: $searchTerm');
  }

  Future<void> fetchData() async {
    String url = 'https://example.com/api/maps'; // 데이터를 가져올 URL
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // 응답이 성공적으로 도착한 경우
        List<dynamic> responseData = json.decode(response.body);
        setState(() {
          // 맵 데이터를 업데이트
          mapData = responseData
              .map<Map<String, String>>(
                  (item) => Map<String, String>.from(item))
              .toList();
          sortMapData();
        });
      } else {
        // 응답이 실패한 경우
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }










  void sortMapData() {
    setState(() {
      switch (selectedSortOption) {
        case SortOption.alphabetical:

          mapData = List.from(TotalmapData);
          mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

          setState(() {});



          break;
        case SortOption.proximity:

          mapData = List.from(TotalmapData);
          mapData.sort((a, b) => a['스토어거리']!.compareTo(b['스토어거리']!));

          setState(() {});

          break;
        case SortOption.operational:

          mapData = List.from(appMapData);



        // mapData에 데이터 추가


          //mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

          setState(() {});



        // 앱운영중 정렬 로직 추가
          break;
      }
    });
  }
}
