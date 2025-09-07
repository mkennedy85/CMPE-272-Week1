# CMPE-272 Assignment 1 Repository

This repository contains all three assignments for CMPE-272 Cloud Computing coursework.

## Repository Structure

```
Assignment1/
├── README.md                    # This file
├── .github/workflows/ci-cd.yml  # GitHub Actions CI/CD for flask-blog
├── flask-blog/                 # Assignment 2: Docker Development Pipeline
│   ├── app.py                  # Flask application
│   ├── Dockerfile              # Docker containerization
│   ├── Vagrantfile            # VM setup for Assignment 3
│   ├── benchmark.sh           # Performance comparison script
│   ├── build.sh               # Local build script
│   ├── test_app.py            # Unit tests
│   └── README.md              # Flask blog specific documentation
└── serverless-analysis/        # Assignment 1: Serverless Platform Comparison (TBD)
```

## Assignments Overview

### Assignment 1: Serverless Platform Comparison
- **Status**: To be started
- **Deliverable**: 1-page analysis comparing AWS, Google Cloud, Azure serverless offerings
- **Deep dive**: 5-year evolution of one vendor's serverless platform
- **Product feature**: New feature proposal with data-driven arguments

### Assignment 2: Docker Development Pipeline ✅
- **Status**: Complete with CI/CD
- **Location**: `./flask-blog/`
- **Features**:
  - Flask blog application with CRUD operations  
  - Docker containerization with multi-stage builds
  - GitHub Actions CI/CD pipeline
  - Automated testing and Docker Hub deployment
  - uv-based dependency management

### Assignment 3: VM vs Container Performance Analysis
- **Status**: Infrastructure ready, benchmarking needed
- **Location**: `./flask-blog/` (same app, different deployment methods)
- **Features**:
  - Vagrant VM deployment
  - Performance benchmarking scripts
  - Comparative analysis tools

## Quick Start

### Assignment 2 (Docker Pipeline)
```bash
cd flask-blog
./build.sh  # Run tests and build Docker image
```

### Assignment 3 (VM vs Container Comparison)
```bash
cd flask-blog
vagrant up              # Start VM
./benchmark.sh vm       # Benchmark VM
./benchmark.sh docker   # Benchmark Docker
```

## GitHub Actions CI/CD

The repository includes automated CI/CD for the Flask blog application:
- **Triggers**: Push to main, pull requests
- **Pipeline**: Test → Build → Push to Docker Hub
- **Security**: Docker Scout vulnerability scanning

### Required Secrets
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Docker Hub access token

## Academic Context

This repository demonstrates cloud computing concepts including:
- **Containerization**: Docker best practices and multi-stage builds
- **Virtualization**: VM deployment and resource management
- **Performance Analysis**: Systematic benchmarking methodologies
- **CI/CD**: Automated testing and deployment pipelines
- **Cloud Platforms**: Serverless computing analysis

## Usage Instructions

Each assignment folder contains specific instructions and requirements. The Flask blog serves as the common application for both Docker and VM performance comparisons, providing consistent baseline for analysis.

For detailed instructions on each component, see the README files in respective directories.