# AlarmPoet
A basic scalable Alarm application for a hackathon.

The alarm will have a new LLM generate poem each day for the user. The user may enter some words as a theme, e.g, birds, chocolate, mountains. The LLM will use the theme words as an inspiration for the poetry. 

Project: AlarmPoet

Description:
An app that lets a user set alarms at 8 AM in their local timezone (auto-adjusted when they travel), and generates a short poem using LLaMA 3 based on keywords they input. This app has no authentication — it’s designed for a single user who inputs their name, alarm time, timezone, and keywords.

Backend:
- Written in Golang
- REST API with the following endpoints:
    POST /v1/alarms → Create alarm
    GET /v1/alarms → List alarms
    PUT /v1/alarms/{alarm_id} → Update alarm
    DELETE /v1/alarms/{alarm_id} → Delete alarm
    POST /v1/poems/generate → Generate standalone poem

Components:
- Timezone-aware alarm scheduling
- Poem generation with local (C++ LLaMA 3) or remote API option
- PostgreSQL database for storing alarms

Directory structure:
backend/
  cmd/server/main.go → Entry point, sets up routes
  internal/handlers/ → alarm.go, poem.go (API handlers)
  internal/models/ → alarm.go (Alarm struct)
  internal/services/ → llama_service.go, scheduler.go (poem + scheduling logic)
  internal/middleware/ → recovery.go (panic handler)
  internal/db/ → postgres.go (DB connection)
  internal/utils/ → response.go (JSON helpers)
frontend/
  Flutter app, screens, widgets, API service
ai-service/
  C++ LLaMA 3 service, REST/gRPC wrapper over llama.cpp
deploy/
  Kubernetes YAMLs: backend, ai-service, postgres, ingress, secrets
helm-charts/
  Helm charts for backend, ai-service, postgres

Current status:
- Directory structure created
- Backend API design written
- Basic backend logic for alarms and poem generation implemented
- Example Golang template files generated

Next goals:
- Write Dockerfiles for backend and ai-service
- Deploy to Kubernetes using provided manifests
- Implement timezone-aware alarm scheduling
- Enhance poem generation logic with LLaMA 3 integration


UI / Frontend: AlarmPoet

Framework:
- Flutter (cross-platform mobile: iOS + Android)

Screens:
1. Home Screen
   - Shows welcome message (single user, no login)
   - Example: “Hello, Rohan! Ready to set your day?”

2. Alarm Screen
   - Inputs:
     - Name (text)
     - Alarm time (time picker, e.g., 08:00)
     - Timezone (auto-detect or dropdown, e.g., Asia/Kolkata)
     - Keywords (comma-separated, e.g., sunrise, hope)
     - Generation mode (toggle: local / remote)
   - Submit → POST /v1/alarms

3. Alarm List Screen
   - Displays all alarms:
     - Name, time, timezone, keywords, poem preview, status
   - Edit → opens alarm screen prefilled
   - Delete → calls DELETE /v1/alarms/{alarm_id}
   - Refresh / pull-to-refresh

4. Poem Screen
   - Shows generated poem
   - Allows standalone generation → POST /v1/poems/generate

Flutter Directory Structure:
frontend/lib/
  main.dart
  screens/
    home_screen.dart
    alarm_screen.dart
    alarm_list_screen.dart
    poem_screen.dart
  widgets/
    alarm_card.dart
    poem_card.dart
  services/
    api_service.dart → handles REST calls
  models/
    alarm.dart → alarm data model

Features:
- Store user name locally (no backend auth)
- Auto-detect timezone with Flutter plugins
- Use Material / Cupertino widgets
- Show loading indicators and error handling
- Minimal, clean, intuitive UI

API Calls:
- Create alarm → POST /v1/alarms
- List alarms → GET /v1/alarms
- Generate poem → POST /v1/poems/generate

Next Steps:
- Build Flutter widget boilerplates
- Implement api_service.dart
- Create alarm.dart model
- Add animations and UX polish