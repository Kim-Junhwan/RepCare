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
||펫 리스트 화면|펫 리스트 UI 및 레이아웃 구현|2h|2h|1|
||||||
|이터레이션3|||||~ 2023/10/04|
||펫 리스트 화면|콜렉션뷰 compositional layout으로 수정했다가 원상복귀|2h|2h|2|
||펫 리스트 화면|상단 검색바 ,개체 추가 버튼 구현|1h|30m|2|
||펫 리스트 화면|ViewController와 View 분리|1h|1h|2|
||펫 리스트 화면|ViewModel 구현|1h|1h|2|
||펫 리스트 화면|펫 리스트 화면, 레이아웃 오류 수정|30m|30m|3|
||펫 등록 화면|펫 등록 화면 기초 UI 구성|2h|4h|4|
|이터레이션4|||||~ 2023/10/08|
||DB|종 DB 구현|2h|2h|5|
||종 선택 화면|종 선택 화면 기본 UI 구현|2h|2h|5|
||도메인|종을 가져오는 로직 구현|2h|1h|6|
||DB|종 DB에 id값 추가, Entity에 id값 추가|2h|1h|6|
||DB|저장된 종 가져오는 Stroage 구현 및|2h|1h|6|
|이터레이션5|||||~ 2023/10/11|
|이터레이션6|||||~ 2023/10/15|
|이터레이션7|||||~ 2023/10/18|
|이터레이션8|||||~ 2023/10/22|
|이터레이션9|||||~ 2023/10/25|

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
