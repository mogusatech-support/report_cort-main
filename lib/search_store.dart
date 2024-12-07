import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum SortOption { alphabetical, proximity, operational }

class SearchStore extends StatefulWidget {
  const SearchStore({super.key});
  @override
  _SearchStoreState createState() => _SearchStoreState();
}

class _SearchStoreState extends State<SearchStore> {
  // A. 전역변수 넣기  (SearchStore-A)
  final TextEditingController _searchController = TextEditingController();
  // 현재의 클래스전체에서 사용할수 있는 변수 선언
  // 0 을 설정하면 1번 버튼 선택으로 합니다
  int selectedButtonIndex = 0;
  // 지역 선택 버튼의 표시 여부를 제어하는 변수
  bool _showRegionButtons = true;
  // 기본 정렬 옵션: 가나다순
  SortOption selectedSortOption = SortOption.alphabetical;
  List<Map<String, String>> mapData = [];
  List<Map<String, String>> appMapData = [];
  @override
  void initState() {
    super.initState();
    // 초기치설정 : 전체 거리순
    selectedButtonIndex = 0;
    selectedSortOption = SortOption.proximity;
    fetchDataTemp();
  } // initState() end

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

      body: Column(
        children: [
          // B. 각종객체  넣기  (SearchStore-B)
          // 매장검색 텍스트휠드 넣는곳  시작
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
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
          ),
          // 매장검색 텍스트휠드 넣는곳  끝
          // 위 아래 간격넣기
          SizedBox(height: 16.0),
          // 지역선택 글자와 토글 아이콘
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '지역선택',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF245E57),
                    fontWeight: FontWeight.bold,
                  ),
                  //fontWeight: FontWeight.bold,  // 선택된 항목의 글자도 굵게 설정
                ),
                IconButton(
                  icon: Icon(
                    _showRegionButtons
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Color(0xFF245E57),
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _showRegionButtons = !_showRegionButtons;
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 16.0),
          // 지역선택 글자와 토글 아이콘 end
          // 조건부 렌더링을 사용하여 지역 선택 버튼들을 표시하거나 숨김
          if (_showRegionButtons) ...[
            // 버튼여러개(혹은 15개,18개) 넣는곳 시작
            // 하나의 행만들기 시작
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
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
                      // 변경 1
                      //height: 30,  절대치인 40 대신에 화면의 크기에따른 비율을 넣을수도 있음
                      height: 40,
                      //margin: const EdgeInsets.only(right: 8.0),
                      margin: EdgeInsets.only(right: index < 4 ? 8.0 : 0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButtonIndex = buttonIndex;

                            fetchDataTemp();
                          });
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              // 변경 3
                              // borderRadius: BorderRadius.circular(8.0),
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                //color: Colors.black,
                                color: buttonIndex == selectedButtonIndex
                                    ? Color(0xFF27675F)
                                    : Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            buttonIndex == selectedButtonIndex
                                ? Color(0xFF27675F)
                                : Colors.white,
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero), // 패딩을 제거하여 전체 공간 사용
                        ),
                        // 변경 2
                        child: Container(
                          width: double.infinity, // 버튼의 전체 너비를 사용
                          alignment: Alignment.center, // 텍스트를 중앙에 배치
                          child: Text(
                            location,
                            style: TextStyle(
                              // 클릭시 글자색변경하기
                              color: buttonIndex == selectedButtonIndex
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18, // 글자 크기를 18로
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // 하나의 행만들기 끝
            SizedBox(height: 15.0), // Row와 Row 사이 간격
            //두번째의 행만들기 시작
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
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
                      height: 40,
                      //margin: EdgeInsets.only(right: 8.0),
                      margin: EdgeInsets.only(right: index < 4 ? 8.0 : 0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButtonIndex = buttonIndex;
                            fetchDataTemp(); // 2
                            print(
                                'selectedButtonIndex::${selectedButtonIndex}');
                          });
                        },
                        child: Container(
                          width: double.infinity, // 버튼의 전체 너비를 사용
                          alignment: Alignment.center, // 텍스트를 중앙에 배치
                          child: Text(
                            location,
                            style: TextStyle(
                              color: buttonIndex == selectedButtonIndex
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18, // 글자 크기를 15로
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                color: buttonIndex == selectedButtonIndex
                                    ? Color(0xFF27675F)
                                    : Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            buttonIndex == selectedButtonIndex
                                ? Color(0xFF27675F)
                                : Colors.white,
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            //두번째의 행만들기 끝
            SizedBox(height: 15.0), // Row와 Row 사이 간격
            //세번째의 행만들기 시작
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
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
                      height: 40,
                      // margin: EdgeInsets.only(right: 8.0),
                      margin: EdgeInsets.only(right: index < 4 ? 8.0 : 0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButtonIndex = buttonIndex;
                            fetchDataTemp(); //3
                            print(
                                'selectedButtonIndex::${selectedButtonIndex}');
                          });
                        },
                        child: Container(
                          width: double.infinity, // 버튼의 전체 너비를 사용
                          alignment: Alignment.center, // 텍스트를 중앙에 배치
                          child: Text(
                            location,
                            style: TextStyle(
                              color: buttonIndex == selectedButtonIndex
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18, // 글자 크기를 15로
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                color: buttonIndex == selectedButtonIndex
                                    ? Color(0xFF27675F)
                                    : Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            //
                            buttonIndex == selectedButtonIndex
                                ? Color(0xFF27675F)
                                : Colors.white,
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            //세번째의 행만들기 끝

            const SizedBox(height: 15.0), // Row와 Row 사이 간격

            //네번째의 행만들기 시작
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: List.generate(5, (index) {
                  int buttonIndex = 15 + index;
                  String location = '';
                  bool isVisible = true;

                  if (buttonIndex == 15) {
                    location = '부산';
                  } else if (buttonIndex == 16) {
                    location = '광주';
                  } else if (buttonIndex == 17) {
                    location = '대구';
                  } else {
                    isVisible = false;
                  }
                  return Expanded(
                    child: Opacity(
                      opacity: isVisible ? 1.0 : 0.0,
                      child: Container(
                        height: 40, // 높이를 40으로 증가  변경 1
                        //margin: const EdgeInsets.only(right: 8.0),
                        margin: EdgeInsets.only(right: index < 4 ? 8.0 : 0),
                        child: ElevatedButton(
                          onPressed: isVisible
                              ? () {
                                  //  4에서만 변경
                                  setState(() {
                                    selectedButtonIndex = buttonIndex;

                                    fetchDataTemp(); //4
                                  });
                                }
                              : null,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: isVisible
                                      ? buttonIndex == selectedButtonIndex
                                          ? Color(0xFF27675F)
                                          : Colors.black
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              buttonIndex == selectedButtonIndex
                                  ? Color(0xFF27675F)
                                  : Colors.white,
                            ),
                            elevation: MaterialStateProperty.all<double>(0),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.zero), // 패딩을 제거하여 전체 공간 사용
                          ),
                          child: Container(
                            width: double.infinity, // 버튼의 전체 너비를 사용
                            alignment: Alignment.center, // 텍스트를 중앙에 배치
                            child: Text(
                              location,
                              style: TextStyle(
                                color: buttonIndex == selectedButtonIndex
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 18, // 글자 크기를 18로 증가
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            //네번째의 행만들기 끝

            // 버튼여러개(혹은 15개,18개) 넣는곳 끝
          ], //  if (_showRegionButtons) ...[ end

          const SizedBox(height: 25.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 ${mapData.length} 개소',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                 
                  padding: const EdgeInsets.fromLTRB(18, 8, 16, 8),

                  // EdgeInsets.all(16.0),
                  child: DropdownButton<SortOption>(
                    value: selectedSortOption,
                    onChanged: (SortOption? newValue) {
                      setState(() {
                        selectedSortOption = newValue!;
                        sortMapData();
                      });
                    },
                    items: const [
                      DropdownMenuItem<SortOption>(
                        value: SortOption.alphabetical,
                        child: Text('가나다순',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)), // 글자를 굵게 설정
                      ),
                      DropdownMenuItem<SortOption>(
                        value: SortOption.proximity,
                        child: Text('거리순',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      DropdownMenuItem<SortOption>(
                        value: SortOption.operational,
                        child: Text('앱운영중',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // 선택된 항목의 글자도 굵게 설정
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 30),
                    //underline: Container(),
                    //dropdownColor: Colors.white,
                    isDense: true, // 드롭다운 버튼의 내부 패딩을 줄임
                  ),
                ),
              ],
            ),
          ),

          // 리스트부분 시작
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                itemCount: mapData.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.black),
                itemBuilder: (context, index) {
                  Map<String, String> item = mapData[index];

                  // 마트이름과 스토어거리에 적용할 텍스트 스타일 정의
                  TextStyle largeTextStyle = TextStyle(
                    fontSize: 20, // 글자 크기를 18로 설정 (필요에 따라 조정 가능)
                    fontWeight: FontWeight.bold, // 굵은 글씨체
                  );

                  return Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item['앱설정']! == 'yes')
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF27675F),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '앱운영중',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              else
                                Container(
                                  width: 60,
                                  height: 24,
                                  decoration: BoxDecoration(                                   
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Image.asset('assets/store.png',
                                      width: 20, height: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['마트이름']!,
                                    style: largeTextStyle, // 여기에 새로운 스타일 적용
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Image.asset('assets/phone.jpg',
                                      width: 20, height: 20),
                                  const SizedBox(width: 4),
                                  Text(item['전화번호']!,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color:
                                            Color.fromARGB(255, 122, 114, 114),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item['스토어거리']!,
                          style: largeTextStyle, // 여기에도 동일한 스타일 적용
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.star),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
          // 리스트부분 끝
        ],
      ),
      // 총 칼람 끝
    );
  }

  // C. 각종함수  넣기  (SearchStore-C)
  // for 4-9
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

  Future<void> fetchDataTemp() async {
    if (selectedButtonIndex == 0) {
      // 전체얻기
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      mapData = List.from(TotalmapDataTemp);

      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }

      /////////////////////////
    } else if (selectedButtonIndex == 1) {
      mapData = [];

      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();

      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '서울').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 2) {
      mapData = [];

      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '인천').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 3) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '대전').toList();
      mapData = List.from(newMapDataTemp);

      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 4) {
      mapData = [];

      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();

      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '세중').toList();
      mapData = List.from(newMapDataTemp);

      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 5) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '대구').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 6) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '부산').toList();
      mapData = List.from(newMapDataTemp);

      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 7) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '울산').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 8) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '광주').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 9) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '경기').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 10) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '강원').toList();
      mapData = List.from(newMapDataTemp);

      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 11) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '충청').toList();
      mapData = List.from(newMapDataTemp);

      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 12) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '경상').toList();
      mapData = List.from(newMapDataTemp);

      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 13) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '전라').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 14) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '제주').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 15) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '부산').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 16) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '광주').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else if (selectedButtonIndex == 17) {
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();
      List<Map<String, String>> newMapDataTemp =
          TotalmapDataTemp.where((map) => map['지역'] == '대구').toList();
      mapData = List.from(newMapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    } else {
      // 그외는 전체얻기 를 넣는다
      mapData = [];
      List<Map<String, String>> TotalmapDataTemp =
          TotalmapData.map((map) => Map<String, String>.from(map)).toList();

      mapData = List.from(TotalmapDataTemp);
      // 선택되어진 옵션에 따라
      if (selectedSortOption == SortOption.alphabetical) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }

        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));

        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.proximity) {
        for (var item in mapData) {
          item['스토어거리_정수'] = parseDistance(item['스토어거리']!).toString();
        }
        mapData.sort((a, b) =>
            int.parse(a['스토어거리_정수']!).compareTo(int.parse(b['스토어거리_정수']!)));
        for (var item in mapData) {
          int distanceInMeters = int.parse(item['스토어거리_정수']!);
          item['스토어거리'] = convertToKm(distanceInMeters) + ' km';
        }
        for (var item in mapData) {
          item.remove('스토어거리_정수');
        }
      } else if (selectedSortOption == SortOption.operational) {
        List<Map<String, String>> newMapData = [];
        newMapData = List.from(mapData);
        mapData = [];
        List<Map<String, String>> regionalMapDataTemp =
            newMapData.where((map) => map['앱설정'] == 'yes').toList();
        mapData = List.from(regionalMapDataTemp);
      } else {
        mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
      }
    }
  }

  // 먼저 '스토어거리'를 정수로 변환하는 함수를 만듭니다.
  int parseDistance(String distance) {
    return int.tryParse(distance) ?? 0;
  }

// '스토어거리'를 킬로미터로 변환하고 정수로 표시하는 함수를 만듭니다.
  String convertToKm(int meters) {
    return (meters ~/ 1000).toString(); // ~/ 연산자는 나눗셈 후 소수점 이하를 버립니다.
  }


  void sortMapData() {
    setState(() {
      switch (selectedSortOption) {
        case SortOption.alphabetical:
          fetchDataTemp();
          // Old
          //mapData = List.from(TotalmapData);
          //mapData.sort((a, b) => a['마트이름']!.compareTo(b['마트이름']!));
          setState(() {});
          break;

        case SortOption.proximity:
          fetchDataTemp();
          // Old
          //mapData = List.from(TotalmapData);
          //mapData.sort((a, b) => a['스토어거리']!.compareTo(b['스토어거리']!));
          setState(() {});
          break;

        case SortOption.operational:
          fetchDataTemp();
          //  Old
          // mapData = List.from(appMapData);
          // setState(() {});
          // 앱운영중 정렬 로직 추가

          break;
      }
    });
  } // sortMapData  end

  void _handleSearch(String searchTerm) {
    // 검색어 처리 로직을 구현
    print('검색어: $searchTerm');
  }
} // _SearchStoreState  end

List<Map<String, String>> TotalmapData = [
  // 174 / 132

  // 서울 20/13
  {
    '마트이름': '아무거나',
    '전화번호': '55555555',
    '스토어거리': '8733333',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '무작위',
    '전화번호': '77777777',
    '스토어거리': '111911',
    '앱설정': 'no',
    '지역': '서울',
  },
  {
    '마트이름': '랜덤마트',
    '전화번호': '99999999',
    '스토어거리': '228222',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '테스트마트',
    '전화번호': '12345678',
    '스토어거리': '444544',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '홍길동마트',
    '전화번호': '98765432',
    '스토어거리': '5552555',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '우리마트',
    '전화번호': '11112222',
    '스토어거리': '666666',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '무한마트',
    '전화번호': '33334444',
    '스토어거리': '275777',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '새로운마트',
    '전화번호': '55556666',
    '스토어거리': '8883488',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '편의점마트',
    '전화번호': '77778888',
    '스토어거리': '992999',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '식자재마트',
    '전화번호': '99991111',
    '스토어거리': '2121212',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '맛있는마트',
    '전화번호': '22223333',
    '스토어거리': '121212',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '좋은마트',
    '전화번호': '44445555',
    '스토어거리': '232323',
    '앱설정': 'no',
    '지역': '서울',
  },
  {
    '마트이름': '고객센터마트',
    '전화번호': '66777',
    '스토어거리': '2343434',
    '앱설정': 'no',
    '지역': '서울',
  },
  {
    '마트이름': '행복마트',
    '전화번호': '88999',
    '스토어거리': '1454545',
    '앱설정': 'no',
    '지역': '서울',
  },
  {
    '마트이름': '마트가게',
    '전화번호': '128112',
    '스토어거리': '565656',
    '앱설정': 'no',
    '지역': '서울',
  },
  {
    '마트이름': '편리마트',
    '전화번호': '38334',
    '스토어거리': '676767',
    '앱설정': 'no',
    '지역': '서울',
  },
  {
    '마트이름': '현대마트',
    '전화번호': '56656',
    '스토어거리': '787878',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '훌륭한마트',
    '전화번호': '78788',
    '스토어거리': '898989',
    '앱설정': 'no',
    '지역': '서울',
  },
  {
    '마트이름': '마트왕',
    '전화번호': '11110000',
    '스토어거리': '92900',
    '앱설정': 'yes',
    '지역': '서울',
  },
  {
    '마트이름': '신선한마트',
    '전화번호': '33332222',
    '스토어거리': '101051',
    '앱설정': 'yes',
    '지역': '서울',
  },

  // 인천 13/5
  {
    '마트이름': '황금마트',
    '전화번호': '51544',
    '스토어거리': '121212',
    '앱설정': 'yes',
    '지역': '인천',
  },
  {
    '마트이름': '가장가까운마트',
    '전화번호': '77776666',
    '스토어거리': '23323',
    '앱설정': 'yes',
    '지역': '인천',
  },
  {
    '마트이름': '한결같은마트',
    '전화번호': '99998888',
    '스토어거리': '343434',
    '앱설정': 'no',
    '지역': '인천',
  },
  {
    '마트이름': '행운마트',
    '전화번호': '22221111',
    '스토어거리': '454545',
    '앱설정': 'no',
    '지역': '인천',
  },
  {
    '마트이름': '편의점',
    '전화번호': '44443333',
    '스토어거리': '565956',
    '앱설정': 'no',
    '지역': '인천',
  },
  {
    '마트이름': '마트세상',
    '전화번호': '66662222',
    '스토어거리': '67967',
    '앱설정': 'no',
    '지역': '인천',
  },
  {
    '마트이름': '최고의마트',
    '전화번호': '88881111',
    '스토어거리': '787878',
    '앱설정': 'no',
    '지역': '인천',
  },
  {
    '마트이름': '한솔마트',
    '전화번호': '11112222',
    '스토어거리': '89889',
    '앱설정': 'no',
    '지역': '인천',
  },
  {
    '마트이름': '마트하나',
    '전화번호': '33334444',
    '스토어거리': '90090',
    '앱설정': 'no',
    '지역': '인천',
  },
  {
    '마트이름': '가가까운마트',
    '전화번호': '77776666',
    '스토어거리': '23233',
    '앱설정': 'yes',
    '지역': '인천',
  },
  {
    '마트이름': '신마트',
    '전화번호': '55556666',
    '스토어거리': '104101',
    '앱설정': 'yes',
    '지역': '인천',
  },
  {
    '마트이름': '마트하나로',
    '전화번호': '33334444',
    '스토어거리': '96990',
    '앱설정': 'no',
    '지역': '인천',
  },
  {
    '마트이름': '행운마트',
    '전화번호': '22221111',
    '스토어거리': '45445',
    '앱설정': 'yes',
    '지역': '인천',
  },
  // 대전 10/7
  {
    '마트이름': '착한마트',
    '전화번호': '27788',
    '스토어거리': '121212',
    '앱설정': 'yes',
    '지역': '대전',
  },
  {
    '마트이름': '큰마트',
    '전화번호': '99991111',
    '스토어거리': '23223',
    '앱설정': 'yes',
    '지역': '대전',
  },
  {
    '마트이름': '빠른마트',
    '전화번호': '22223333',
    '스토어거리': '34434',
    '앱설정': 'no',
    '지역': '대전',
  },
  {
    '마트이름': '최신마트',
    '전화번호': '44445555',
    '스토어거리': '414515',
    '앱설정': 'yes',
    '지역': '대전',
  },
  {
    '마트이름': '가까운마트',
    '전화번호': '66667777',
    '스토어거리': '15656',
    '앱설정': 'yes',
    '지역': '대전',
  },
  {
    '마트이름': '멋진마트',
    '전화번호': '88889999',
    '스토어거리': '67667',
    '앱설정': 'no',
    '지역': '대전',
  },
  {
    '마트이름': '상점마트',
    '전화번호': '12121212',
    '스토어거리': '77878',
    '앱설정': 'yes',
    '지역': '대전',
  },
  {
    '마트이름': '편의점마트',
    '전화번호': '34343434',
    '스토어거리': '89989',
    '앱설정': 'no',
    '지역': '대전',
  },
  {
    '마트이름': '편리한마트',
    '전화번호': '56565656',
    '스토어거리': '909090',
    '앱설정': 'yes',
    '지역': '대전',
  },
  {
    '마트이름': '무한한마트',
    '전화번호': '78787878',
    '스토어거리': '101201',
    '앱설정': 'yes',
    '지역': '대전',
  },
  // 세중   12/9
  {
    '마트이름': '서울마트',
    '전화번호': '00001111',
    '스토어거리': '121212',
    '앱설정': 'yes',
    '지역': '세중',
  },
  {
    '마트이름': '행복한마트',
    '전화번호': '22223333',
    '스토어거리': '232323',
    '앱설정': 'no',
    '지역': '세중',
  },
  {
    '마트이름': '이상한마트',
    '전화번호': '44445555',
    '스토어거리': '343434',
    '앱설정': 'yes',
    '지역': '세중',
  },
  {
    '마트이름': '실속마트',
    '전화번호': '66667777',
    '스토어거리': '454545',
    '앱설정': 'yes',
    '지역': '세중',
  },
  {
    '마트이름': '세련된마트',
    '전화번호': '88889999',
    '스토어거리': '565656',
    '앱설정': 'no',
    '지역': '세중',
  },
  {
    '마트이름': '우리동네마트',
    '전화번호': '12121212',
    '스토어거리': '676767',
    '앱설정': 'yes',
    '지역': '세중',
  },
  {
    '마트이름': '알뜰마트',
    '전화번호': '34343434',
    '스토어거리': '787878',
    '앱설정': 'yes',
    '지역': '세중',
  },
  {
    '마트이름': '최고마트',
    '전화번호': '56565656',
    '스토어거리': '898989',
    '앱설정': 'yes',
    '지역': '세중',
  },
  {
    '마트이름': '행복마트',
    '전화번호': '78787878',
    '스토어거리': '909090',
    '앱설정': 'no',
    '지역': '세중',
  },
  {
    '마트이름': '행운마트',
    '전화번호': '90909090',
    '스토어거리': '100101',
    '앱설정': 'yes',
    '지역': '세중',
  },
  {
    '마트이름': '행운아마트',
    '전화번호': '90909090',
    '스토어거리': '10201',
    '앱설정': 'yes',
    '지역': '세중',
  },
  {
    '마트이름': '행운고마트',
    '전화번호': '90909090',
    '스토어거리': '510301',
    '앱설정': 'yes',
    '지역': '세중',
  },
  // 대구 11/9
  {
    '마트이름': '가까운슈퍼마트',
    '전화번호': '12121212',
    '스토어거리': '121212',
    '앱설정': 'yes',
    '지역': '대구',
  },
  {
    '마트이름': '큰슈퍼마트',
    '전화번호': '34343434',
    '스토어거리': '232323',
    '앱설정': 'yes',
    '지역': '대구',
  },
  {
    '마트이름': '이쁜슈퍼마트',
    '전화번호': '56565656',
    '스토어거리': '343434',
    '앱설정': 'yes',
    '지역': '대구',
  },
  {
    '마트이름': '아늑한슈퍼마트',
    '전화번호': '78787878',
    '스토어거리': '454545',
    '앱설정': 'yes',
    '지역': '대구',
  },
  {
    '마트이름': '상상하는슈퍼마트',
    '전화번호': '90909090',
    '스토어거리': '565656',
    '앱설정': 'yes',
    '지역': '대구',
  },
  {
    '마트이름': '편리한슈퍼마트',
    '전화번호': '12345678',
    '스토어거리': '123456',
    '앱설정': 'no',
    '지역': '대구',
  },
  {
    '마트이름': '행복한슈퍼마트',
    '전화번호': '87654321',
    '스토어거리': '654321',
    '앱설정': 'yes',
    '지역': '대구',
  },
  {
    '마트이름': '좋은슈퍼마트',
    '전화번호': '11112222',
    '스토어거리': '222222',
    '앱설정': 'yes',
    '지역': '대구',
  },
  {
    '마트이름': '감사하는슈퍼마트',
    '전화번호': '33334444',
    '스토어거리': '333333',
    '앱설정': 'no',
    '지역': '대구',
  },
  {
    '마트이름': '즐거운슈퍼마트',
    '전화번호': '55556666',
    '스토어거리': '44444',
    '앱설정': 'yes',
    '지역': '대구',
  },
  {
    '마트이름': '즐거운슈마트',
    '전화번호': '55556666',
    '스토어거리': '424944',
    '앱설정': 'yes',
    '지역': '대구',
  },
  // 부산 15/13
  {
    '마트이름': '신선한슈퍼마트',
    '전화번호': '77788',
    '스토어거리': '55555',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '신뢰하는슈퍼마트',
    '전화번호': '99991111',
    '스토어거리': '66666',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '고마운슈퍼마트',
    '전화번호': '22223333',
    '스토어거리': '72777',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '강력한슈퍼마트',
    '전화번호': '44445555',
    '스토어거리': '81888',
    '앱설정': 'no',
    '지역': '부산',
  },
  {
    '마트이름': '신나는슈퍼마트',
    '전화번호': '66667777',
    '스토어거리': '92999',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '따뜻한슈퍼마트',
    '전화번호': '88889999',
    '스토어거리': '98999',
    '앱설정': 'no',
    '지역': '부산',
  },
  {
    '마트이름': '활기찬슈퍼마트',
    '전화번호': '12121212',
    '스토어거리': '111111',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '희망하는슈퍼마트',
    '전화번호': '34343434',
    '스토어거리': '23222',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '즐거운슈퍼마트',
    '전화번호': '56565656',
    '스토어거리': '31333',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '편안한슈퍼마트',
    '전화번호': '78787878',
    '스토어거리': '42444',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '편안한슈퍼마',
    '전화번호': '78787878',
    '스토어거리': '44444',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '편안한퍼마트',
    '전화번호': '78787878',
    '스토어거리': '23844',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '편안한슈퍼트',
    '전화번호': '78787878',
    '스토어거리': '23344',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '안한슈퍼마트',
    '전화번호': '78787878',
    '스토어거리': '94744',
    '앱설정': 'yes',
    '지역': '부산',
  },
  {
    '마트이름': '편안슈퍼마트',
    '전화번호': '78787878',
    '스토어거리': '76444',
    '앱설정': 'yes',
    '지역': '부산',
  },
  //울산 9/7

  {
    '마트이름': '즐거운마트',
    '전화번호': '11112222',
    '스토어거리': '8866666',
    '앱설정': 'yes',
    '지역': '울산',
  },
  {
    '마트이름': '신뢰하는마트',
    '전화번호': '33334444',
    '스토어거리': '78777',
    '앱설정': 'yes',
    '지역': '울산',
  },
  {
    '마트이름': '상쾌한마트',
    '전화번호': '55556666',
    '스토어거리': '18888',
    '앱설정': 'no',
    '지역': '울산',
  },
  {
    '마트이름': '쾌적한마트',
    '전화번호': '77778888',
    '스토어거리': '99999',
    '앱설정': 'yes',
    '지역': '울산',
  },
  {
    '마트이름': '안심마트',
    '전화번호': '99991111',
    '스토어거리': '92999',
    '앱설정': 'yes',
    '지역': '울산',
  },
  {
    '마트이름': '친절한마트',
    '전화번호': '22223333',
    '스토어거리': '51111',
    '앱설정': 'yes',
    '지역': '울산',
  },
  {
    '마트이름': '명실마트',
    '전화번호': '44445555',
    '스토어거리': '272222',
    '앱설정': 'no',
    '지역': '울산',
  },
  {
    '마트이름': '밝은마트',
    '전화번호': '66667777',
    '스토어거리': '39333',
    '앱설정': 'yes',
    '지역': '울산',
  },
  {
    '마트이름': '저렴한마트',
    '전화번호': '88889999',
    '스토어거리': '84444',
    '앱설정': 'yes',
    '지역': '울산',
  },
  // 광주 14/12
  {
    '마트이름': '신비한마트',
    '전화번호': '12121212',
    '스토어거리': '85555',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '착한마트',
    '전화번호': '34343434',
    '스토어거리': '616666',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '새로운마트',
    '전화번호': '56565656',
    '스토어거리': '737777',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '원하는마트',
    '전화번호': '78787878',
    '스토어거리': '86888',
    '앱설정': 'no',
    '지역': '광주',
  },
  {
    '마트이름': '상상하는마트',
    '전화번호': '90909090',
    '스토어거리': '5999',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '즐거운마트',
    '전화번호': '11112222',
    '스토어거리': '34222',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '행복한마트',
    '전화번호': '33334444',
    '스토어거리': '122111',
    '앱설정': 'no',
    '지역': '광주',
  },
  {
    '마트이름': '느긋한마트',
    '전화번호': '55556666',
    '스토어거리': '72222',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '안전한마트',
    '전화번호': '77778888',
    '스토어거리': '533333',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '고마운마트',
    '전화번호': '99991111',
    '스토어거리': '44490',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '고마운마트2',
    '전화번호': '99991111',
    '스토어거리': '44488',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '고마운마트3',
    '전화번호': '99991111',
    '스토어거리': '43224',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '고마운마트4',
    '전화번호': '99991111',
    '스토어거리': '41144',
    '앱설정': 'yes',
    '지역': '광주',
  },
  {
    '마트이름': '고마운마트5',
    '전화번호': '99991111',
    '스토어거리': '44434',
    '앱설정': 'yes',
    '지역': '광주',
  },
  //경기  10/8
  {
    '마트이름': '신뢰하는마트',
    '전화번호': '22223333',
    '스토어거리': '59535',
    '앱설정': 'yes',
    '지역': '경기',
  },
  {
    '마트이름': '상쾌한마트',
    '전화번호': '44445555',
    '스토어거리': '64666',
    '앱설정': 'yes',
    '지역': '경기',
  },
  {
    '마트이름': '편안한마트',
    '전화번호': '66667777',
    '스토어거리': '787777',
    '앱설정': 'no',
    '지역': '경기',
  },
  {
    '마트이름': '명실마트',
    '전화번호': '88889999',
    '스토어거리': '88888',
    '앱설정': 'yes',
    '지역': '경기',
  },
  {
    '마트이름': '밝은마트',
    '전화번호': '12121212',
    '스토어거리': '19999',
    '앱설정': 'no',
    '지역': '경기',
  },
  {
    '마트이름': '신비한마트',
    '전화번호': '34343434',
    '스토어거리': '95999',
    '앱설정': 'yes',
    '지역': '경기',
  },
  {
    '마트이름': '착한마트',
    '전화번호': '56565656',
    '스토어거리': '161111',
    '앱설정': 'yes',
    '지역': '경기',
  },
  {
    '마트이름': '새로운마트',
    '전화번호': '78787878',
    '스토어거리': '222222',
    '앱설정': 'yes',
    '지역': '경기',
  },
  {
    '마트이름': '원하는마트',
    '전화번호': '90909090',
    '스토어거리': '83333',
    '앱설정': 'yes',
    '지역': '경기',
  },
  {
    '마트이름': '상상하는마트',
    '전화번호': '11112222',
    '스토어거리': '45444',
    '앱설정': 'yes',
    '지역': '경기',
  },
  // 강원   16/13
  {
    '마트이름': '느긋한마트',
    '전화번호': '33334444',
    '스토어거리': '53555',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '안전한마트',
    '전화번호': '55556666',
    '스토어거리': '69666',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '고마운마트',
    '전화번호': '77778888',
    '스토어거리': '79777',
    '앱설정': 'no',
    '지역': '강원',
  },
  {
    '마트이름': '신뢰하는마트',
    '전화번호': '99991111',
    '스토어거리': '80888',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '상쾌한마트',
    '전화번호': '22223333',
    '스토어거리': '94999',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '편안한마트',
    '전화번호': '44445555',
    '스토어거리': '98999',
    '앱설정': 'no',
    '지역': '강원',
  },
  {
    '마트이름': '명실마트',
    '전화번호': '66667777',
    '스토어거리': '171111',
    '앱설정': 'no',
    '지역': '강원',
  },
  {
    '마트이름': '밝은마트',
    '전화번호': '88889999',
    '스토어거리': '29222',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '신비한마트',
    '전화번호': '12121212',
    '스토어거리': '33433',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '착한마트',
    '전화번호': '34343434',
    '스토어거리': '84444',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '착한마트1',
    '전화번호': '34343434',
    '스토어거리': '67444',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '착한마트2',
    '전화번호': '34343434',
    '스토어거리': '44544',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '착한마트3',
    '전화번호': '34343434',
    '스토어거리': '43444',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '착한마트4',
    '전화번호': '34343434',
    '스토어거리': '443344',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '착한마트5',
    '전화번호': '34343434',
    '스토어거리': '443444',
    '앱설정': 'yes',
    '지역': '강원',
  },
  {
    '마트이름': '착한마트6',
    '전화번호': '34343434',
    '스토어거리': '42444',
    '앱설정': 'yes',
    '지역': '강원',
  },
  // 충청 11/9
  {
    '마트이름': '새로운마트',
    '전화번호': '56565656',
    '스토어거리': '55555',
    '앱설정': 'yes',
    '지역': '충청',
  },
  {
    '마트이름': '원하는마트',
    '전화번호': '78787878',
    '스토어거리': '67666',
    '앱설정': 'yes',
    '지역': '충청',
  },
  {
    '마트이름': '상상하는마트',
    '전화번호': '90909090',
    '스토어거리': '73777',
    '앱설정': 'no',
    '지역': '충청',
  },
  {
    '마트이름': '즐거운마트',
    '전화번호': '11112222',
    '스토어거리': '98888',
    '앱설정': 'yes',
    '지역': '충청',
  },
  {
    '마트이름': '행복한마트',
    '전화번호': '33334444',
    '스토어거리': '49999',
    '앱설정': 'yes',
    '지역': '충청',
  },
  {
    '마트이름': '느긋한마트',
    '전화번호': '55556666',
    '스토어거리': '32999',
    '앱설정': 'no',
    '지역': '충청',
  },
  {
    '마트이름': '안전한마트',
    '전화번호': '77778888',
    '스토어거리': '95999',
    '앱설정': 'yes',
    '지역': '충청',
  },
  {
    '마트이름': '고마운마트',
    '전화번호': '99991111',
    '스토어거리': '222222',
    '앱설정': 'yes',
    '지역': '충청',
  },
  {
    '마트이름': '신뢰하는마트',
    '전화번호': '22223333',
    '스토어거리': '333333',
    '앱설정': 'yes',
    '지역': '충청',
  },
  {
    '마트이름': '상쾌한마트',
    '전화번호': '44445555',
    '스토어거리': '48444',
    '앱설정': 'yes',
    '지역': '충청',
  },
  {
    '마트이름': '상쾌한마트1',
    '전화번호': '44445555',
    '스토어거리': '4444144',
    '앱설정': 'yes',
    '지역': '충청',
  },
  // 경상 10/8
  {
    '마트이름': '편안한마트',
    '전화번호': '66667777',
    '스토어거리': '555555',
    '앱설정': 'yes',
    '지역': '경상',
  },
  {
    '마트이름': '명실마트',
    '전화번호': '88889999',
    '스토어거리': '666666',
    '앱설정': 'yes',
    '지역': '경상',
  },
  {
    '마트이름': '밝은마트',
    '전화번호': '12121212',
    '스토어거리': '777777',
    '앱설정': 'yes',
    '지역': '경상',
  },
  {
    '마트이름': '신비한마트',
    '전화번호': '34343434',
    '스토어거리': '888888',
    '앱설정': 'yes',
    '지역': '경상',
  },
  {
    '마트이름': '착한마트',
    '전화번호': '56565656',
    '스토어거리': '97999',
    '앱설정': 'yes',
    '지역': '경상',
  },
  {
    '마트이름': '새로운마트',
    '전화번호': '78787878',
    '스토어거리': '93999',
    '앱설정': 'no',
    '지역': '경상',
  },
  {
    '마트이름': '원하는마트',
    '전화번호': '90909090',
    '스토어거리': '11111',
    '앱설정': 'yes',
    '지역': '경상',
  },
  {
    '마트이름': '상상하는마트',
    '전화번호': '11112222',
    '스토어거리': '82222',
    '앱설정': 'yes',
    '지역': '경상',
  },
  {
    '마트이름': '느긋한마트',
    '전화번호': '33334444',
    '스토어거리': '63333',
    '앱설정': 'yes',
    '지역': '경상',
  },
  {
    '마트이름': '안전한마트',
    '전화번호': '55556666',
    '스토어거리': '24444',
    '앱설정': 'no',
    '지역': '경상',
  },
  // 전라 13/11
  {
    '마트이름': '고마운마트',
    '전화번호': '77778888',
    '스토어거리': '35555',
    '앱설정': 'yes',
    '지역': '전라',
  },
  {
    '마트이름': '신뢰하는마트',
    '전화번호': '99991111',
    '스토어거리': '66666',
    '앱설정': 'yes',
    '지역': '전라',
  },
  {
    '마트이름': '상쾌한마트',
    '전화번호': '22223333',
    '스토어거리': '77777',
    '앱설정': 'yes',
    '지역': '전라',
  },
  {
    '마트이름': '편안한마트',
    '전화번호': '44445555',
    '스토어거리': '88888',
    '앱설정': 'yes',
    '지역': '전라',
  },
  {
    '마트이름': '명실마트',
    '전화번호': '66667777',
    '스토어거리': '99999',
    '앱설정': 'yes',
    '지역': '전라',
  },
  {
    '마트이름': '밝은마트',
    '전화번호': '88889999',
    '스토어거리': '62999',
    '앱설정': 'no',
    '지역': '전라',
  },
  {
    '마트이름': '신비한마트',
    '전화번호': '12121212',
    '스토어거리': '15111',
    '앱설정': 'yes',
    '지역': '전라',
  },
  {
    '마트이름': '신비한마트1',
    '전화번호': '12121212',
    '스토어거리': '14111',
    '앱설정': 'yes',
    '지역': '전라',
  },
  {
    '마트이름': '신비한마트2',
    '전화번호': '12121212',
    '스토어거리': '13111',
    '앱설정': 'yes',
    '지역': '전라',
  },
  {
    '마트이름': '신비한마트3',
    '전화번호': '12121212',
    '스토어거리': '11111',
    '앱설정': 'yes',
    '지역': '전라',
  },

  // {
  //   '마트이름': '착한마트',
  //   '전화번호': '34343434',
  //   '스토어거리': '222222',
  // },

  {
    '마트이름': '착한마트',
    '전화번호': '34343434',
    '스토어거리': '22222',
    '앱설정': 'yes',
    '지역': '전라',
  },

  {
    '마트이름': '새로운마트',
    '전화번호': '56565656',
    '스토어거리': '33333',
    '앱설정': 'no',
    '지역': '전라',
  },
  {
    '마트이름': '원하는마트',
    '전화번호': '78787878',
    '스토어거리': '42444',
    '앱설정': 'yes',
    '지역': '전라',
  },
  // 제주 10/8
  {
    '마트이름': '상상하는마트',
    '전화번호': '90909090',
    '스토어거리': '55555',
    '앱설정': 'yes',
    '지역': '제주',
  },
  {
    '마트이름': '즐거운마트',
    '전화번호': '11112222',
    '스토어거리': '66666',
    '앱설정': 'yes',
    '지역': '제주',
  },
  {
    '마트이름': '행복한마트',
    '전화번호': '33334444',
    '스토어거리': '77777',
    '앱설정': 'no',
    '지역': '제주',
  },
  {
    '마트이름': '느긋한마트',
    '전화번호': '55556666',
    '스토어거리': '88888',
    '앱설정': 'yes',
    '지역': '제주',
  },
  {
    '마트이름': '안전한마트',
    '전화번호': '77778888',
    '스토어거리': '19999',
    '앱설정': 'no',
    '지역': '제주',
  },
  {
    '마트이름': '고마운마트',
    '전화번호': '99991111',
    '스토어거리': '9299',
    '앱설정': 'yes',
    '지역': '제주',
  },
  {
    '마트이름': '고마운마트1',
    '전화번호': '99991111',
    '스토어거리': '9299',
    '앱설정': 'yes',
    '지역': '제주',
  },
  {
    '마트이름': '고마운마트2',
    '전화번호': '99991111',
    '스토어거리': '92999',
    '앱설정': 'yes',
    '지역': '제주',
  },
  {
    '마트이름': '고마운마트3',
    '전화번호': '99991111',
    '스토어거리': '9599',
    '앱설정': 'yes',
    '지역': '제주',
  },
  {
    '마트이름': '고마운마트4',
    '전화번호': '99991111',
    '스토어거리': '32999',
    '앱설정': 'yes',
    '지역': '제주',
  },
];
