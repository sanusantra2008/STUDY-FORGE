# StudyForge AI — Production Container Image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000 \
    DATA_DIR=/app/data \
    UPLOADS_DIR=/app/uploads

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency definition and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application directories and files
COPY backend/ ./backend/
COPY brand/ ./brand/
COPY static/ ./static/
COPY tests/ ./tests/

# Create persistent storage directories
RUN mkdir -p /app/data /app/uploads

# Expose server port
EXPOSE 8000

# Healthcheck probe
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/api/health || exit 1

# Start production server
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
