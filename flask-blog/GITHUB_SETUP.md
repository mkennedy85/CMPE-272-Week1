# GitHub Actions Setup Instructions

## Required Secrets for CI/CD Pipeline

To enable the automated Docker build and push workflow, add these secrets to your GitHub repository:

### Docker Hub Secrets (Required)
1. **DOCKERHUB_USERNAME**: Your Docker Hub username
2. **DOCKERHUB_TOKEN**: Docker Hub personal access token

### AWS Secrets (Optional - for deployment)
3. **AWS_ACCESS_KEY_ID**: AWS access key ID
4. **AWS_SECRET_ACCESS_KEY**: AWS secret access key

## How to Add Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret with the exact names listed above

## Docker Hub Token Setup

1. Log in to Docker Hub
2. Go to **Account Settings** → **Security**
3. Click **New Access Token**
4. Give it a name (e.g., "GitHub Actions")
5. Select appropriate permissions (Read, Write, Delete)
6. Copy the token and add it as DOCKERHUB_TOKEN secret

## Workflow Behavior

- **Push/PR to any branch**: Runs tests only
- **Push to main branch**: Runs tests + builds and pushes Docker image
- **AWS deployment**: Currently disabled by default (change `&& false` to `&& true` in ci-cd.yml)

## Manual Registry Push (Alternative)

If you prefer manual deployment:

```bash
# Build locally
./build.sh

# Login to Docker Hub
docker login

# Tag and push
docker tag flask-blog:latest yourusername/flask-blog:latest
docker push yourusername/flask-blog:latest
```