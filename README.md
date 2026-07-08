# 🚢PortFlow  
## Azure 기반 부산신항 7개 부두 스케줄 통합 · 작업량 예측 대시보드

> 부산신항 세관 업무 담당자의 현장 니즈를 바탕으로,  
> 7개 부두에 분산된 선석 스케줄을 통합하고  
> 스케줄 변경 이력과 시간대별 작업량을 모니터링하는  
> Azure 기반 항만 운영 데이터 파이프라인 프로젝트입니다.

<br/>

![PortFlow Dashboard Preview](./assets/dashboard_preview.png)

<br/>

---

## ⛴️Project Overview

**PortFlow**는 부산신항 7개 부두의 접안 스케줄을 통합하고,  
스케줄 변경 이력과 부두별 작업량을 한 화면에서 확인할 수 있도록 설계한  
**스마트항만 운영 모니터링 서비스**입니다.

본 프로젝트는 Microsoft Data School 4기 2차 프로젝트로 진행되었으며,  
Azure 환경과 Local/Open-source 환경을 각각 구현하여  
비용, 보안, 운영 효율 측면에서 비교 분석했습니다.

<br/>

---

## 🌊Why Busan New Port?

부산신항은 국내 최대 컨테이너 허브이자,  
스마트항만 전환 수요가 높은 대표적인 항만입니다.

특히 다음과 같은 흐름으로 인해  
해양·항만 데이터 기반 운영 서비스의 필요성이 커지고 있습니다.

- 부산신항 7개 부두 기반 대형 컨테이너 허브
- AI 기반 스마트항만 전환 추진
- 해양수산부 부산 이전에 따른 해양·항만 데이터 활용 수요 확대
- HMM 등 해운·물류 생태계의 부산 집중 흐름
- 세관·검역·항만 운영자가 활용할 수 있는 통합 모니터링 수요 존재

<br/>

---

## 👮Field Requirement

본 프로젝트는 **실제 부산신항 세관 업무 담당자 인터뷰**를 바탕으로 기획되었습니다.

현직자는 외항선 접안 시 직접 선박에 승선하여 세관 검사를 수행하며,  
이를 위해 부두별 접안 스케줄과 변경사항을 빠르게 확인해야 합니다.

그러나 기존 업무에서는 다음과 같은 문제가 있었습니다.

### Pain Points

- 7개 부두 운영사 사이트에 스케줄이 분산되어 있음
- 매일 오전 각 사이트에 접속해 파일을 직접 다운로드해야 함
- 부두별 파일 형식, 컬럼명, 컬럼 순서가 달라 엑셀 수동 취합이 필요함
- 접안·출항 시간이 하루에도 여러 번 변경되지만 즉시 파악하기 어려움
- 부두별 작업량과 물동량 예측 정보를 한 화면에서 보기 어려움

<br/>

### Project Pivot

초기 아이디어는 항만 데이터 품질 가드레일 파이프라인이었습니다.

그러나 현직자 인터뷰를 통해,  
현장의 우선순위는 데이터 품질 리포트 자체보다  
**“7개 부두 스케줄을 한 화면에서 보고, 변경사항을 빠르게 파악하는 것”**임을 확인했습니다.

이에 따라 프로젝트 방향을  
**데이터 품질 점검 중심**에서  
**스케줄 통합 · 변경 감지 · 작업량 예측 대시보드 중심의 PortFlow 서비스**로 전환했습니다.

<br/>

---

## 📌 Key Features

### 1️⃣ 부산신항 7개 부두 스케줄 통합

각 부두 운영사 사이트에 분산된 선석 스케줄을 통합하여  
세관·검역 담당자가 한 화면에서 접안 예정 선박을 확인할 수 있도록 설계했습니다.

<br/>

### 2️⃣ 스케줄 변경 감지

`business_key`, `row_hash`, `snapshot_id`, `parsed_at`을 활용하여  
스케줄 변경 여부를 감지했습니다.

변경 감지 대상은 다음과 같습니다.

- ETA 변경
- ETD 변경
- Closing 변경
- 부두 변경
- 작업량 변경
- 신규 스케줄 추가
- 스케줄 삭제 또는 확인 필요 상태

<br/>

### 3️⃣ 야간 항만 작업 기준 운영일 설계

항만 작업은 자정 이후에도 이어지는 경우가 많기 때문에,  
단순 날짜 기준이 아니라 오전 6시 기준의 `eta_work_date`를 설계했습니다.

이를 통해 밤 11시 30분 스케줄이 다음날 0시 30분으로 변경되어도  
새로운 스케줄이 아니라 같은 운영 스케줄로 추적할 수 있도록 했습니다.

<br/>

### 4️⃣ Gold Layer 서비스 테이블 구축

Power BI와 ML 모델에서 바로 사용할 수 있도록  
Databricks Gold Layer에 서비스 목적별 테이블을 생성했습니다.

- `gold_integrated_schedule`
- `gold_schedule_change_history`
- `gold_today_terminal_schedule`
- `gold_hourly_terminal_workload`
- `gold_monthly_container`
- `gold_ml_feature_table`

<br/>

### 5️⃣ Power BI 관제 대시보드

Azure SQL DB에 적재된 Gold/Mart 데이터를 기반으로  
부두별 스케줄, 변경 이력, 긴급 알림, 시간대별 작업량, 물동량 예측 결과를 시각화했습니다.

<br/>

### 6️⃣ Azure vs Local 운영 비교

동일한 서비스 로직을 기준으로  
Azure 기반 구조와 Local/Open-source 기반 구조를 비교했습니다.

비교 기준은 다음과 같습니다.

- 구축 시간
- 서비스 비용
- 보안
- 운영 효율
- 장애 추적 및 복구 용이성
- 대시보드 공유 방식

<br/>

---

## 🏗️ Architecture

### Azure Architecture

![Azure Architecture](./assets/architecture_azure.png)

```text
Power Automate
    ↓
Azure Blob Storage
    ↓
Azure Databricks
    ├── Bronze Layer
    ├── Silver Layer
    └── Gold Layer
    ↓
Azure SQL Database
    ↓
Power BI
````
### Local Architecture

```text
Power Automate
    ↓
Local Folder
    ↓
PySpark + Delta Lake
    ├── Bronze Layer
    ├── Silver Layer
    └── Gold Layer
    ↓
PostgreSQL
    ↓
Streamlit
```

<br/>

### Medallion Architecture

```text
Raw Data
  ↓
Bronze Layer
  - 원본 보존
  - 수집 메타데이터 추가
  - snapshot_id, row_hash 등 추적 컬럼 관리

  ↓
Silver Layer
  - 부두별 컬럼 표준화
  - 데이터 타입 정제
  - eta_work_date 생성
  - business_key 생성
  - 검증 실패 행 분리 보존

  ↓
Gold Layer
  - 통합 스케줄 테이블
  - 변경 이력 테이블
  - 오늘의 스케줄 테이블
  - 시간대별 작업량 테이블
  - ML Feature Table
  - Power BI 연동용 Mart View
```

<br/>

---

## 🙋‍♀️My Role

본 레포지토리는 팀 프로젝트 결과물을 개인 포트폴리오 관점에서 정리한 저장소입니다.
특히 제가 직접 설계하거나 구현한 영역을 중심으로 정리했습니다.

<br/>

### Owned

* Azure Databricks Gold Layer 구현
* Gold 서비스 테이블 설계 및 SQL 구현
* Azure Blob Storage → Databricks → Azure SQL DB 연동 구조 검토
* Databricks Unity Catalog 권한 설정 실습
* Storage Credential / External Location 권한 관리
* Azure SQL DB 인증 방식 비교

  * Microsoft Entra ID
  * SQL Authentication
* Power BI 관제 대시보드 DAX 일부 구현
* 스케줄 변경 알림 및 운영 지표 정의

<br/>

### Designed

* Bronze / Silver / Gold Medallion Architecture 설계서 작성
* 스케줄 변경 감지를 위한 `business_key` 설계
* 야간 항만 작업을 고려한 `eta_work_date` 설계
* Gold Table → Mart View → Power BI 구조 설계
* Azure SQL DB 권한 분리 방향 설계

<br/>

### Collaborated

* Raw 데이터 수집 자동화
* Bronze Layer 구현
* Silver Layer 구현
* ML 물동량 예측 모델링
* Local/Open-source 파이프라인 구현
* Streamlit 대시보드 구현

<br/>

---

## 💻 Tech Stack

### Cloud & Data Platform

* Azure Blob Storage
* Azure Databricks
* Azure SQL Database
* Microsoft Entra ID
* Unity Catalog
* Azure Storage Credential
* External Location
  
![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Azure Databricks](https://img.shields.io/badge/Azure%20Databricks-FF3621?style=for-the-badge&logo=databricks&logoColor=white)
![Azure Blob Storage](https://img.shields.io/badge/Azure%20Blob%20Storage-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Azure SQL Database](https://img.shields.io/badge/Azure%20SQL%20Database-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Microsoft Entra ID](https://img.shields.io/badge/Microsoft%20Entra%20ID-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)


<br/>

### Data Engineering

* PySpark
* Spark SQL
* Delta Lake
* Medallion Architecture
* Parquet
* SQL View / Mart Table
  
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PySpark](https://img.shields.io/badge/PySpark-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)
![Spark SQL](https://img.shields.io/badge/Spark%20SQL-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)
![Delta Lake](https://img.shields.io/badge/Delta%20Lake-00AEEF?style=for-the-badge&logo=delta&logoColor=white)
![Parquet](https://img.shields.io/badge/Parquet-50ABF1?style=for-the-badge&logo=apache&logoColor=white)

<br/>

### BI & Visualization

* Power BI
* DAX
* Dashboard KPI Design
* Schedule Monitoring Dashboard

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=for-the-badge&logo=streamlit&logoColor=white)

<br/>

### Collaboration

* GitHub
* Notion
* Microsoft Teams

![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)
![Notion](https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white)
![Microsoft Teams](https://img.shields.io/badge/Microsoft%20Teams-6264A7?style=for-the-badge&logo=microsoftteams&logoColor=white)

<br/>

---

## 📂 Repository Structure

```text
portflow-busan-newport-monitoring/
│
├── README.md
│
├── docs/
│   ├── 01_business_context.md
│   ├── 02_requirements_from_field_interview.md
│   ├── 03_architecture_azure_vs_local.md
│   ├── 04_medallion_design.md
│   ├── 05_security_and_permission_design.md
│   ├── 06_powerbi_dashboard_design.md
│   ├── 07_troubleshooting.md
│   └── 08_future_improvements.md
│
├── notebooks/
│   ├── 01_raw_to_temp_parquet_header_standardization.sql
│   ├── 03_silver_to_gold.sql
│   └── exported_html/
│       └── 03_silver_to_gold.html
│
├── sql/
│   ├── databricks/
│   │   ├── create_gold_tables.sql
│   │   ├── grant_external_location_permissions.sql
│   │   └── unity_catalog_permissions.sql
│   │
│   └── azure_sql_db/
│       ├── create_schemas.sql
│       ├── create_mart_views.sql
│       ├── create_users_roles_future_plan.sql
│       └── table_type_mapping.md
│
├── powerbi/
│   ├── dax/
│   │   ├── schedule_alert_measures.dax
│   │   ├── last_refresh_measures.dax
│   │   └── workload_measures.dax
│   ├── screenshots/
│   │   ├── dashboard_schedule_board.png
│   │   ├── dashboard_change_history.png
│   │   └── dashboard_forecast.png
│   └── README.md
│
├── data_samples/
│   ├── sample_gold_today_terminal_schedule.csv
│   ├── sample_gold_schedule_change_history.csv
│   └── README.md
│
└── assets/
    ├── architecture_azure.png
    ├── medallion_architecture.png
    ├── dashboard_preview.png
    └── presentation/
        └── portflow_presentation.pdf
```

<br/>

---

## 🛡️ Security & Permission Design

본 프로젝트에서는 단순히 데이터 파이프라인을 구현하는 것뿐 아니라,
Azure 환경에서 데이터 접근 권한과 인증 방식을 함께 검토했습니다.

<br/>

### Implemented in MVP

* Azure Blob Storage 컨테이너를 Databricks External Location으로 연결
* Storage Credential 생성 및 External Location 권한 설정
* Databricks Unity Catalog 기반 Catalog / Schema / Table 접근 권한 확인
* Azure SQL DB 연결 시 Microsoft Entra ID와 SQL Authentication 방식 모두 실습
* Secret 기반 접속 정보 관리 방향 검토
* 읽기 권한과 관리 권한 분리 필요성 정리

<br/>

### Future Security Improvements

향후 운영 환경에서는 다음과 같은 방식으로 권한을 더 체계적으로 분리할 계획입니다.

* Microsoft Entra ID 그룹 기반 권한 분리

  * Data Engineer Group
  * BI Developer Group
  * Viewer Group
* Azure SQL DB 내부 Role-Based Access Control 적용

  * 조회 전용 Role
  * 적재 전용 Role
  * Mart View 관리 Role
* Gold Table과 Mart View 접근 권한 분리
* 운영용 계정과 개발용 계정 분리
* Secret Scope 기반 접속 문자열 관리
* 감사 로그 및 접근 이력 모니터링 강화

<br/>

---

## 📊 Power BI Dashboard

Power BI 대시보드는 Azure SQL DB의 Gold/Mart 데이터를 Import 방식으로 연결하여 구현했습니다.

<br/>

### Dashboard Pages

1. 부산신항 통합 접안 스케줄 보드
2. 스케줄 변경 이력 및 주의 알림
3. 부두별 작업량 예측 및 물동량 예측

<br/>

### Implemented DAX

* 긴급 변경 스케줄 카운트
* 현재 시각 기준 2시간 이내 접안 예정 선박 필터링
* 마지막 데이터 갱신 시각 표시
* 부두별 예상 작업량 집계
* 변경 유형별 건수 계산
* 부두별 필터링 및 날짜 슬라이서 연동

<br/>

---

## 📋 Result

PortFlow는 현직자의 실제 업무 흐름을 기반으로
다음과 같은 기능을 제공하는 MVP로 구현되었습니다.

* 7개 부두 스케줄 통합 조회
* 1시간 단위 스케줄 갱신 구조
* ETA / ETD / Closing / 부두 변경 감지
* 변경 이력 및 우선순위 알림
* 부두별 시간대별 작업량 시각화
* 물동량 예측 결과 연계
* Azure와 Local 운영 방식 비교 분석

<br/>

---

## 👏 Future Improvements

* Power Automate 유료 플랜 또는 Python 기반 웹 스크래핑으로 수집 자동화 고도화
* Databricks Job Trigger 기반 정기 실행 구조 구축
* Microsoft Entra ID 기반 권한 체계 정리
* Azure SQL DB 내부 Role 기반 접근 제어 적용
* Mart View 중심의 BI 접근 구조 개선
* ML 모델 재학습 자동화 및 MLflow 기반 모델 버전 관리
* 서버리스 컴퓨팅 시나리오 추가 검토
* 변경 알림을 Teams, Email, 사내 포털과 연동

<br/>

---

## 📝 Note

본 레포지토리는 팀 프로젝트 결과물을 개인 포트폴리오 관점에서 정리한 저장소입니다.

Azure 권한·인증 구성, Databricks Gold Layer 구현, SQL/Mart 설계,
Power BI DAX 및 대시보드 구현 등 제가 직접 설계·구현한 영역을 중심으로 정리했습니다.

Raw 수집 자동화, Bronze/Silver 구현, ML 모델링, Local 파이프라인은
팀원들과 역할을 나누어 협업했습니다.

```
```
