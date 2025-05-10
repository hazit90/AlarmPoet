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
- Example Golang template files generated

Next goals:
- Implement backend logic for alarms and poem generation
- Write Dockerfiles for backend and ai-service
- Deploy to Kubernetes using provided manifests
