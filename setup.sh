#!/bin/bash

# ML Salary Predictor - Setup Script
# This script sets up the complete CI/CD pipeline environment

echo "🚀 Setting up ML Salary Predictor CI/CD Pipeline..."

# Check if Git is initialized
if [ ! -d ".git" ]; then
    echo "❌ Not a Git repository. Please run 'git init' first."
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "🔍 Checking prerequisites..."

if ! command_exists git; then
    echo "❌ Git is not installed"
    exit 1
fi

if ! command_exists python3; then
    echo "❌ Python 3 is not installed"
    exit 1
fi

if ! command_exists docker; then
    echo "⚠️  Docker is not installed (optional for local development)"
fi

# Create virtual environment
echo "🐍 Creating Python virtual environment..."
python3 -m venv venv

# Activate virtual environment
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi

# Install dependencies
echo "📦 Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Run tests to verify setup
echo "🧪 Running tests to verify setup..."
python -m pytest tests/ -v

# Check code quality
echo "🔍 Running code quality checks..."
flake8 . --count --max-line-length=127 --statistics

# Create necessary directories if they don't exist
echo "📁 Creating necessary directories..."
mkdir -p logs
mkdir -p data/backup

# Set up Git hooks (optional)
echo "🔧 Setting up Git hooks..."
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
# Run tests before commit
python -m pytest tests/ -x
if [ $? -ne 0 ]; then
    echo "❌ Tests failed. Commit aborted."
    exit 1
fi

# Run code quality checks
flake8 . --count --max-line-length=127
if [ $? -ne 0 ]; then
    echo "❌ Code quality checks failed. Commit aborted."
    exit 1
fi
EOF

chmod +x .git/hooks/pre-commit

# Display next steps
echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Configure GitHub repository settings:"
echo "   - Set up branch protection rules for master, test, and dev branches"
echo "   - Add team members and set up admin permissions"
echo ""
echo "2. Configure Jenkins:"
echo "   - Install required plugins (Docker Pipeline, Email Extension)"
echo "   - Add Docker Hub credentials"
echo "   - Create pipeline job using Jenkinsfile"
echo ""
echo "3. Set up Docker Hub:"
echo "   - Create repository: maajidkhan/ml-salary-predictor"
echo "   - Generate access token for Jenkins"
echo ""
echo "4. Test the application:"
echo "   - Run: python application.py"
echo "   - Visit: http://localhost:5000"
echo ""
echo "5. Test Docker build:"
echo "   - Run: docker build -t ml-salary-predictor ."
echo "   - Run: docker run -p 5000:5000 ml-salary-predictor"
echo ""
echo "🎉 Your CI/CD pipeline is ready!"