# StudyForge AI — Intelligent Learning Platform

> **Powered by Google Gemma (`gemma-4-26b-a4b-it`) and Local Ollama (`gemma4`)**  
> Built with academic precision and Google DeepMind architecture principles.

---

## 🌟 Executive Summary

**StudyForge AI** is a full-stack, production-ready intelligent study workspace designed to accelerate student learning and long-term retention. By coupling **Active Recall testing**, **Spaced Repetition Flashcards**, and **Automated Document Synthesis**, StudyForge empowers students to master complex lecture materials in record time.

### Core Capabilities
1. **Multi-Format Ingestion**: Ingests `.pdf`, `.docx`, `.txt`, and `.md` files up to 15MB with virtual section/page chunking. Gracefully detects scanned bitmaps and alerts users regarding OCR requirements.
2. **AI Summary Studio**: Synthesizes notes into three tailored formats:
   - *Concise Executive Brief*: High-level takeaway for rapid pre-exam review.
   - *Detailed Study Guide*: Comprehensive section-by-section breakdown.
   - *Key Points & Bullets Checklist*: Rapid revision checklist with highlighted academic keywords and glossary definitions.
3. **Multi-Format Quiz Arena**:
   - Multiple Choice questions with distractors.
   - True / False questions with direct textual verification.
   - Short Answer conceptual recall questions.
   - Real-time single-question runner with question timers, score calculation, and celebration confetti.
4. **Interactive 3D Flashcards**:
   - 3D card-flip animations powered by GPU hardware acceleration.
   - Spaced Repetition ratings: `Again`, `Hard`, `Good`, and `Easy`.
   - Previous, Next, and Shuffle controls with persistent mastery tracking.
5. **Study Planner & Progress Analytics**:
   - Create, prioritize, and check off study tasks.
   - Visual analytics: Flashcard Mastery Donut, Quiz Score Performance Trend, and Task Completion gauges.
6. **Grounded AI Assistant**:
   - Q&A grounded strictly in uploaded documents with verifiable source note and page/section citations.
7. **Production Authentication**:
   - PBKDF2-HMAC-SHA256 password hashing with unique random 16-byte salts.
   - Stateless JWT tokens (`HS256`) with 7-day expiration.
   - Multi-tenant data isolation: all notes, summaries, quizzes, and tasks are strictly scoped to the authenticated user.
   - 1-Click Demo Account for frictionless instant evaluation.

---

## 🛠️ Architecture & Tech Stack

- **Frontend**: React 18, Tailwind CSS, Google Fonts (`Outfit` & `Inter`), Canvas Confetti, Vanilla CSS Theme Engine (`brand/theme.css`).
- **Backend**: Python 3.12, FastAPI, Pydantic v2, PyJWT, Cryptography.
- **Document Processing**: `pypdf`, `python-docx`, unicode normalizers.
- **Database**: SQLite (default local development) and PostgreSQL-ready configuration.
- **AI Integrations**:
  - Google Gemini API: `gemma-4-26b-a4b-it` (per https://ai.google.dev/gemma/docs/core/gemma_on_gemini_api).
  - Local Edge Ollama: `gemma4` at `http://127.0.0.1:11434/api/chat`.
  - Academic Heuristic Engine: High-fidelity local fallback ensuring zero downtime when offline.
- **Testing**: `pytest` & `pytest-asyncio` with 100% endpoint pass rate.
- **Deployment**: Docker containerization, `docker-compose.yml`, and `render.yaml`.

---

## 🚀 Quick Start Guide

### 1. Prerequisites
- Python 3.10+ (Python 3.12 recommended)
- `pip` package manager

### 2. Installation
Clone the repository and install dependencies:
```bash
git clone https://github.com/your-username/studyforge-ai.git
cd studyforge-ai
pip install -r requirements.txt
```

### 3. Environment Configuration
Copy the sample environment file:
```bash
cp .env.example .env
```
Open `.env` and configure your credentials:
```env
AI_PROVIDER=google
GEMINI_API_KEY=AIzaSy...your_gemini_api_key
GEMINI_MODEL=gemma-4-26b-a4b-it
JWT_SECRET=your_custom_jwt_secret_here
```

### 4. Running the Application

#### Option A: Native Server (Recommended for All Features)
Launch the FastAPI development server which serves both the API and frontend simultaneously:
```bash
uvicorn backend.main:app --host 0.0.0.0 --port 8000 --reload
```
Navigate to: **http://localhost:8000**

#### Option B: VS Code Live Server
You can also preview and develop the frontend using VS Code Live Server:
1. Open the workspace root `c:\STUDYFROGEE` in VS Code.
2. Click **Go Live** at the bottom right (opens `http://127.0.0.1:5500/index.html`).
3. Start the backend API server in a terminal:
   ```bash
   uvicorn backend.main:app --port 8000 --reload
   ```
4. The frontend automatically detects port 5500 and points all API requests (`/api/...`) to `http://localhost:8000` with full CORS support.

---

## 🧪 Automated Testing

StudyForge includes a comprehensive pytest suite covering authentication, document parsing, notes CRUD, AI quiz formulation, flashcard reviews, and study planner tasks:

```bash
python -m pytest tests/test_api.py -v
```

Expected output:
```
tests/test_api.py::test_auth_registration_and_login PASSED
tests/test_api.py::test_demo_login PASSED
tests/test_api.py::test_document_parser PASSED
tests/test_api.py::test_notes_crud PASSED
tests/test_api.py::test_summary_generation_and_delete PASSED
tests/test_api.py::test_quiz_generation_and_submission PASSED
tests/test_api.py::test_flashcards_crud_and_spaced_repetition PASSED
tests/test_api.py::test_study_tasks_planner PASSED
tests/test_api.py::test_health_and_settings PASSED
======================== 9 passed in 9.56s =========================
```

---

## 🐳 Docker Deployment

### Using Docker
Build and run the container with isolated persistent storage:
```bash
docker build -t studyforge-ai .
docker run -d -p 8000:8000 \
  -e GEMINI_API_KEY="your_api_key_here" \
  -e JWT_SECRET="your_secure_jwt_secret" \
  -v studyforge_uploads:/app/uploads \
  -v studyforge_db:/app/data \
  --add-host host.docker.internal:host-gateway \
  --name studyforge-container \
  studyforge-ai
```

### Using Docker Compose
Run with `docker-compose`:
```bash
docker-compose up -d --build
```
> **Volume Isolation Note**: Uploads are stored in `studyforge_uploads` (`/app/uploads`) and the SQLite database in `studyforge_db` (`/app/data`), ensuring that container volumes never overwrite or hide `/app` application code. Local Ollama instances on the host are accessible via `host.docker.internal:host-gateway`.

---

## ☁️ Live Cloud Deployment (Render)

This repository includes a native `render.yaml` blueprint. To deploy on Render:
1. Push code to your GitHub/GitLab repository.
2. Log into [Render Dashboard](https://dashboard.render.com).
3. Click **New** > **Blueprint** and select your repository.
4. Set the `GEMINI_API_KEY` secret in the environment variables.
5. Render will automatically build and deploy your containerized service.

---

## 📋 API Reference

| Endpoint | Method | Description |
|---|---|---|
| `/` | `GET` | Serves the StudyForge application interface |
| `/api/auth/register` | `POST` | Registers new user account with hashed password |
| `/api/auth/login` | `POST` | Authenticates user and returns JWT Bearer token |
| `/api/auth/demo-login`| `POST` | Instant 1-click test drive as Demo Scholar |
| `/api/auth/me` | `GET` | Returns current user profile |
| `/api/upload` | `POST` | Uploads and parses PDF, DOCX, TXT, or MD note |
| `/api/notes` | `GET` | Lists user's study notes (with search query) |
| `/api/summaries/generate` | `POST` | Synthesizes note into Short, Detailed, or Bullet summary |
| `/api/quizzes/generate` | `POST` | Generates MCQ, True/False, and Short Answer quiz |
| `/api/quizzes/{id}/submit` | `POST` | Grades quiz attempt, calculates score, logs history |
| `/api/flashcards` | `GET` | Lists flashcards filtered by note or mastery status |
| `/api/flashcards/{id}/review` | `POST` | Records spaced repetition rating (`again`, `hard`, `good`, `easy`) |
| `/api/tasks` | `GET/POST`| Manages study planner tasks with priorities and deadlines |
| `/api/health` | `GET` | Health diagnostics for database, Google API, and Ollama |

---

## 🔒 Security & Best Practices

- **Zero Plaintext Secrets**: API keys and secrets are never committed to git or exposed to client browsers.
- **Strict Input Validation**: Pydantic schemas enforce type safety and sanitize inputs against SQL injection and path traversal.
- **Scoped Multi-Tenancy**: All database queries enforce `user_id = ?` scoping to ensure strict data privacy.
- **File Integrity**: Enforces a 15MB file size ceiling and validates file structure before processing.

---

## 📄 License
MIT License &bull; StudyForge AI is open-source and built for student empowerment.
