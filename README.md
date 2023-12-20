# 렙케어

<p width="100%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/b1c0f38b-eb42-424c-8d9c-182d7a28ba07" width="19%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/8b819194-c1d3-4edb-ab7c-018a6b8f2707" width="19%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/fd0d5218-2c17-4cb8-9866-1f39b053b71f" width="19%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/8e94df68-5d9a-4c11-b107-89270d27d3e8" width="19%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/702b671e-bd17-4f38-94ee-cca94c8ea713" width="19%">
</p>

## 프로젝트 한줄 소개
자신이 기르는 희귀애완동물의 관리 기록을 남기고 볼 수 있는 애완동물 케어앱

## 앱스토어 링크

<a href="https://apps.apple.com/kr/app/%EB%A0%99%EC%BC%80%EC%96%B4/id6470812043">앱스토어링크</a>

## 개발기간 및 개발 공수
- 총 개발 기간: 2023년 9월 25일 ~ 2023년 11월 1일 (38일)
- 기획 및 디자인: 2023년 9월 25 ~ 2023년 10월 1일 (7일)
- 기능 개발 및 구현: 2023년 10월 1일 ~ 2023년 10월 30일
- 버그 수정 및 프로젝트 출시: 2023년 10월 31일 ~ 2023년 11월 1일

###### 이터레이션 1은 기획 및 디자인 기간이므로 제외

|회차|내용|상세내용|예상 시간|실제 시간|기간|
|------|----|-----|-----|-----|----|
|이터레이션2|||||~ 2023/10/01|
|||추석 연휴|||28|
|||추석 연휴|||29|
|||프로젝트 생성 및 세팅, 필요 라이브러리 설치|1h|1h|30|
||DB|애완동물 프로필 DB 테이블 구현|1h|2h|30|
||도메인|펫 리스트 가져오는 UseCase, Repository 구현 및 PetEntity 구현|2h|3h|1|
||PetListView|펫 리스트 UI 및 레이아웃 구현|2h|2h|1|
||||||
|이터레이션3|||||~ 2023/10/04|
||PetListView|콜렉션뷰 compositional layout으로 수정했다가 원상복귀|2h|2h|2|
||PetListView|상단 검색바 ,개체 추가 버튼 구현|1h|30m|2|
||PetListView|ViewController와 View 분리|1h|1h|2|
||PetListView|ViewModel 구현|1h|1h|2|
||PetListView|펫 리스트 화면, 레이아웃 오류 수정|30m|30m|3|
||PetListView|펫 등록 화면 기초 UI 구성|2h|4h|4|
||||||
|이터레이션4|||||~ 2023/10/08|
||DB|종 DB 구현|2h|2h|5|
||종 선택 화면|종 선택 화면 기본 UI 구현|2h|2h|5|
||도메인|종을 가져오는 로직 구현|2h|10h|6|
||DB|종 DB에 id값 추가, Entity에 id값 추가|1h|1h|7|
||DB|저장된 종 가져오는 Stroage 구현 및|1h|1h|8|
||||||
|이터레이션5|||||~ 2023/10/11|
||SelectSpeciesView|종 선택시 하위 종 가져오는 기능 구현|2h|4h|9|
||SelectSpeciesView|종선택 섹션 마지막 셀 등록셀로 구현|1h|2h|9|
||SelectSpeciesView|ViewModel 바인딩, 선택된 종이 빈 하위 종을 가져올 경우 등록셀이 안나오던 버그 수정|2h|2h|9|
||RegisterPetView|텍스트필드 툴바 구현|1h|1h|10|
|||Presentation 계층에서 사용할 Model 구현|1h|1h 30m|10|
||RegisterPetView|입양일, 해칭일 날짜 선택시 DatePicker ActionSheet 나오게 구현|2h|1h 30m|10|
||RegisterPetView|ViewModel 구현 및 바인딩|2h|2h|11|
||RegisterPetView|상위 펫 선택시, 선택되었던 하위 종은 사라지는 기능 구현|2h|4h|11|
||||||
|이터레이션6|||||~ 2023/10/15|
||SelectSpeciesView|종 추가 셀 클릭 시 textField Alert 나오게 설정|1h|1h|12|
||RegisterPetView|종 선택화면에서 적용 버튼 누를 시, 펫 등록 화면에서 선택된 종 표시|1h|1h|12|
||SelectSpeciesView|종 추가시 추가한 종 바로 가져오지 못하던 버그 수정|1h|2h|12|
||RegisterPetView|카메라, 앨범에서 이미지 등록 구현|1h|1h|14|
||RegisterPetView|펫 등록시 이미지 다운샘플링 및 FileManager로 저장|1h|3h|14|
||PetListView|펫 리스트 화면에서 저장된 사진이 있다면 가장 첫번째 사진이 나오도록, 사진이 없는 경우 종 이미지를 대신 보여주도록 구현|1h|1h|15|
||PetListView|펫 리스트 화면에서 종 선택시 종 필터링|1h|1h|15|
||||||
|이터레이션7|||||~ 2023/10/18|
||DetailPetView|프로필 화면 탭바 NestedScrollView 구현|2h|30h|16|
||DetailPetView|펫 캘린더 ViewController 구현|2h|10h|16|
||DetailPetView|팻 캘린더 로직 구현|2h|6h|17|
||DetailPetView|펫 캘린더 ViewController 작업 셀 클릭시 캘린더에 이벤트 추가 및 하단 타임라인데 추가|2h|3h|17|
||DetailPetView|펫 상세화면 header ViewController 구현|2h|5h|18|
||||||
|이터레이션8|||||~ 2023/10/22|
||DetailPetView|펫 무게 차트 구현|2h|2h|20|
||DetailPetView|펫 무게 ViewController 구현|2h|3h|20|
||DetailPetView|펫 무게 화면에서 무게 추가시 차트에 추가|2h|3h|21|
||DetailPetView|펫 무게 화면에서 삭제 기능 구현|2h|2h|21|
||DetailPetView|펫 캘린더 화면 버그 수정|2h|10h|22|
||||||
|이터레이션9|||||~ 2023/10/25|
|||Calendar객체가 필요할때마다 생성했던 코드 제거|1h|1h|23|
||RegisterPetView|이미지 저장시 이미지가 회전되던 버그 수정|1h|7h|23|
||PetListView|검색 기능 구현|2h|1h|24|
||PetListView|필터링 기능 구현|4h|3h|24|
||SelectSpeciesView|종 선택화면 UI 변경|1h|1h|24|
|이터레이션10|||||~ 2023/10/30|
||DetailPetView|펫 삭제 기능 구현|2h|1h|25|
||DetailPetView|펫 정보 수정버튼 클릭시, 현재 펫 정보 수정 화면에 바인딩|2h|1h|26|
||SelectSpeciesView|펫 등록화면에서 기존에 선택된 종이 있다면, 종이 선택된 채로 나오는 기능 구현|1h|5h|26|
||DetailPetView|펫 정보 수정버튼시 헤더 뷰 정보 업데이트|2h|2h|27|

## 개발환경
xcode 15.0.1, 최소버전 iOS 15.0, swift 5.9 

## 사용 라이브러리

|라이브러리|사용목적|
|------|---|
|RxSwift, RxCocoa|비동기 처리, MVVM 패턴 및 UI 바인딩|
|RealmSwift|DB|
|Snapkit| 코드베이스UI 구현|
|FirebaseCrashlytics, AnalyticsWithoutAdidSupport|충돌 감지 및 앱 모니터링|
|DGChart, Tabman, FSCalendar|UI 구현|

## 기술 스택
- 아키텍처 패턴: MVVM, MVC
- UI 프레임워크: UIKit
- 라이브러리 설치: Package Manager

# 주요 기능 및 인터페이스

## 펫 리스트 및 필터링
<p width="100%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/430b1c5d-1ef7-49bf-86e2-edd627bf611c" width="20%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/701a78d8-28fa-470b-a88d-14748d65b7b3" width="20%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/1bc94caa-e25e-4ab4-9e74-ed5c6d4899b0" width="20%">
</p>

## 개체 상세화면 및 작업 등록, 무게 추가
<p width="100%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/01a4bd4a-2d02-4323-9df3-9ad27fdaa018" width="19%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/ce2c0193-a657-4549-83f3-a3a2a6b661b1" width="19%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/f11866ac-1016-466d-a4bc-c29e60953156" width="19%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/3dca6ddb-469c-42ad-aacf-03bf49b8c0bf" width="19%">
  <img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/7b8cd3c0-7c60-46eb-bf08-e2438e836101" width="19%">
</p>

## 개체 등록 및 정보 수정
<p width="100%">
<img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/3a374715-b872-43fa-8521-8f89ba29f541" width="20%">
<img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/43b39964-6b2c-4191-879b-eca00e564b87" width="20%">
</p>


## 종 추가 및 수정
<p width="100%">
<img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/468dce80-428d-45b4-b004-2beaf76035c7" width="20%">
<img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/caf41cb7-ed85-4b4d-a69b-7aa3853884a4" width="20%">
<img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/5788d414-99a9-4c23-8198-b204e816ef03" width="20%">
</p>

# 트러블 슈팅 및 도전

## FileManager에 이미지 저장하고, 가져올 때 이미지가 회전된 채로 가지고 오던 문제

<a href="https://sandclock-itblog.tistory.com/233">트러블슈팅 블로그 글</a>

PHPicker로 카메라로 찍은 사진 또는 갤러리에서 가지고 온 이미지를 png() 함수를 통해 이미지 데이터를 디렉토리에 저장한 후, 저장한 이미지를 UIImage로 보여 줄 경우 다음과 같이 사진의 방향이 회전되던 문제가 발생했다. png() 대신에 jpeg()를 사용해서 jpeg 데이터 형식으로 이미지를 저장했더니 정상적으로 이미지가 나왔다.

<p width=100%">
<img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/9388b1b6-adc3-45b3-a822-0a14f59ff3ab" width="20%">
<img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/766ce7dc-268a-48a2-b242-10ad7ed7974a" width="20%">
</p>

이러한 문제가 생긴 원인은 데이터를 읽어올때 파일의 형식 따라서 지원하는 메타데이터가 다르기 때문이다. 

<img src ="https://github.com/Kim-Junhwan/RepCare/assets/58679737/e85bf6d7-1573-46cb-b81c-d4166f1538d8" width="40%">

iOS에서는 사진을 찍을때 왼쪽 사진과 같이 세로모드로 찍어도 실제로는 오른쪽 사진처럼 이미지가 저장된다. 사진이 저장될 때 메타데이터로 회전된 사진의 방향이 함께 저장된다. UIImage에서 사진을 렌더링 하기 이전에 해당 메타데이터를 읽어 비트맵을 회전시킨 후 이미지를 렌더링 한다.
이때 iOS에서 사진이 저장될때 HEIF 또는 JPEG로 사진이 저장되는데, iOS에서 이 파일 형식을 읽어오거나 저장할떄는 exif 데이터가 포함되있지만, png에서는 이를 포함하지 않는다. 기기에서 찍은 사진을 시뮬레이터에 넣고, png, jpeg 데이터로 각각 저장했을때 다음과 같이 메타데이터를 확인 할 수 있었다.

<img width="841" alt="image" src="https://github.com/Kim-Junhwan/RepCare/assets/58679737/88eee940-da47-452b-ad72-6140a1f0b00e">

따라서 png로 저장 할 시 이미지 회전 정보가 제외되어 저장되므로, 원래 저장된 파일 그대로 화면에 나온것이고, jpeg로 저장할 시 회전 정보가 있으므로 이미지가 제대로 나오게 된 것이다.

## 
