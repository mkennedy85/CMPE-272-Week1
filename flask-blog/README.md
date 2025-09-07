# Flask Blog - Docker & VM Deployment Pipeline

This project demonstrates containerization and virtualization workflows for a Flask blog application, designed for CMPE-272 cloud computing coursework.

## Project Structure
```
flask-blog/
├── app.py                      # Main Flask application
├── requirements.txt            # Python dependencies (Docker)
├── pyproject.toml             # uv project configuration
├── schema.sql                 # Database schema
├── init_db.py                 # Database initialization
├── test_app.py                # Unit tests
├── build.sh                   # Local build script with uv
├── Dockerfile                 # Docker image definition
├── Vagrantfile               # VM configuration
├── provision.sh              # VM provisioning script
├── benchmark.sh              # Performance comparison script
├── .github/workflows/ci-cd.yml # GitHub Actions CI/CD
└── templates/                # HTML templates
    ├── base.html
    ├── index.html
    ├── post.html
    ├── create.html
    └── edit.html
```

## Quick Start

### Prerequisites
- **For Docker**: Docker installed and running
- **For VM**: Vagrant and VirtualBox installed
- **For Development**: Python 3.11+ and uv

## Assignment 2: Docker Development Pipeline

### Local Development with uv
```bash
# Install uv if not already installed
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install dependencies and run locally
uv sync
uv run python init_db.py
uv run python app.py
```

Visit http://localhost:5001 to access the blog.

### Local Build and Test
```bash
# Run build script (tests + Docker build)
chmod +x build.sh
./build.sh
```

This script:
1. Initializes uv project if needed
2. Installs dependencies with `uv sync`
3. Runs tests with `uv run python -m unittest`
4. Builds Docker image if tests pass

### Docker Commands
```bash
# Build image manually
docker build -t flask-blog:latest .

# Run container
docker run -p 5001:5001 flask-blog:latest

# Push to registry (after docker login)
docker tag flask-blog:latest yourusername/flask-blog:latest
docker push yourusername/flask-blog:latest
```

### GitHub Actions CI/CD
The workflow (`.github/workflows/ci-cd.yml`) provides:

1. **Automated Testing**: Tests on every push/PR using uv
2. **Docker Build & Push**: Multi-platform builds to Docker Hub
3. **Security Scanning**: Docker Scout vulnerability scanning
4. **AWS Deployment**: Optional ECS deployment (disabled by default)

#### Required GitHub Secrets:
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Docker Hub access token
- `AWS_ACCESS_KEY_ID`: AWS access key (optional)
- `AWS_SECRET_ACCESS_KEY`: AWS secret key (optional)

## Assignment 3: VM vs Container Performance Analysis

### VM Setup with Vagrant
```bash
# Start VM (Ubuntu 22.04, 1GB RAM, 2 CPUs)
vagrant up

# SSH into VM
vagrant ssh

# Stop VM
vagrant halt

# Destroy VM
vagrant destroy
```

The VM automatically:
- Provisions Python 3 and Flask
- Initializes the database
- Starts the Flask app on port 5001
- Installs monitoring tools (htop, sysstat)

### Performance Benchmarking
```bash
# Run VM benchmarks
./benchmark.sh vm

# Run Docker benchmarks  
./benchmark.sh docker

# Compare results in benchmark_results/ directory
```

The benchmark script measures:
- **Startup Time**: Time to boot and run application
- **Memory Usage**: RAM consumption patterns
- **Response Times**: HTTP request performance
- **Resource Utilization**: CPU and system metrics

### Expected Performance Differences
- **Container**: Faster startup, lower memory overhead, shared kernel
- **VM**: Slower startup, higher memory usage, full OS isolation
- **CPU**: Comparable performance between both approaches

## Application Features

The Flask blog supports:
- **View Posts**: Homepage with all blog posts
- **Create Posts**: Form-based post creation with validation
- **Edit Posts**: Modify existing posts
- **Delete Posts**: Remove posts with confirmation
- **SQLite Database**: Persistent storage with automatic initialization

## Port Configuration

- **Application Port**: 5001 (updated from 5000 to avoid macOS conflicts)
- **Docker Port Mapping**: 5001:5001
- **VM Port Forwarding**: 5001 → 5001

## Testing Strategy

Tests cover:
- Route functionality and HTTP responses
- Form validation and error handling
- Database operations (CRUD)
- Application startup and health checks

Run tests locally:
```bash
uv run python -m unittest test_app.py -v
```

## Deployment Options

### Docker Deployment
- **Docker Hub**: Automated builds and registry push
- **AWS ECS**: Container orchestration (configurable)
- **Kubernetes**: K8s deployments with provided manifests
- **Cloud Run**: Serverless container deployment

### VM Deployment
- **Vagrant Cloud**: Box sharing and distribution
- **AWS EC2**: VM instances with automated provisioning
- **Local Development**: Consistent dev environments

## Troubleshooting

### Common Issues
- **Port 5000 conflict**: App uses port 5001 to avoid macOS ControlCenter
- **uv network issues**: Check proxy settings and network connectivity
- **Docker build failures**: Ensure Docker daemon is running
- **VM startup slow**: Allocate more resources in Vagrantfile

### Performance Analysis
Use the benchmark script to systematically compare VM vs Docker metrics. Take multiple measurements and ensure no other applications are running during benchmarks.