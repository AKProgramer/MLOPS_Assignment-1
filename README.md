# ML Salary Predictor - CI/CD Pipeline

A Flask web application that predicts employee salaries using machine learning, complete with a comprehensive CI/CD pipeline.

## Project Structure

```
├── .github/
│   └── workflows/
│       ├── code-quality.yml    # Code quality checks with flake8
│       └── test.yml           # Automated testing workflow
├── static/
│   └── css/
│       └── style.css
├── templates/
│   └── index.html
├── tests/
│   ├── __init__.py
│   └── test_application.py    # Unit tests
├── application.py             # Flask application
├── model.py                   # ML model training
├── model.pkl                  # Trained model
├── hiring.csv                 # Dataset
├── Dockerfile                 # Container configuration
├── Jenkinsfile               # Jenkins pipeline
├── requirements.txt          # Python dependencies
└── README.md
```

## CI/CD Pipeline Workflow

### Branch Strategy
- **master**: Production branch (protected)
- **test**: Testing branch (protected)
- **dev**: Development branch (protected)

### Pipeline Flow

1. **Development Phase**
   - Developers work on feature branches
   - Create pull requests to `dev` branch
   - Admin approval required for merge

2. **Code Quality Check (GitHub Actions)**
   - Triggers on push/PR to `dev` branch
   - Runs flake8 linting
   - Checks code formatting standards

3. **Testing Phase**
   - PR from `dev` to `test` branch triggers testing workflow
   - Runs pytest unit tests
   - Generates coverage report
   - Tests application startup

4. **Production Deployment**
   - PR from `test` to `master` triggers Jenkins pipeline
   - Builds Docker image
   - Pushes to Docker Hub
   - Sends email notification to admin

## Setup Instructions

### Prerequisites
- Python 3.9+
- Docker
- Jenkins
- Git

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/MaajidKhan/DeployMLModel-Flask.git
   cd DeployMLModel-Flask
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the application**
   ```bash
   python application.py
   ```

### Docker Setup

1. **Build Docker image**
   ```bash
   docker build -t ml-salary-predictor .
   ```

2. **Run container**
   ```bash
   docker run -p 5000:5000 ml-salary-predictor
   ```

### Jenkins Configuration

1. **Install required plugins**
   - Docker Pipeline
   - Email Extension
   - GitHub Integration

2. **Configure credentials**
   - Add Docker Hub credentials with ID: `docker-hub-credentials`
   - Configure email settings for notifications

3. **Create pipeline job**
   - Use `Jenkinsfile` from repository
   - Set up webhook for master branch

### GitHub Repository Setup

1. **Branch Protection Rules**
   - Protect `master`, `test`, and `dev` branches
   - Require pull request reviews
   - Require status checks to pass

2. **Secrets Configuration**
   - No secrets required for current workflows
   - Add Docker Hub credentials if needed for GitHub Actions

## Testing

### Run Unit Tests
```bash
pytest tests/ -v
```

### Run Code Quality Checks
```bash
flake8 . --count --max-line-length=127 --statistics
```

### Test Coverage
```bash
coverage run -m pytest tests/
coverage report -m
```

## API Endpoints

- **GET /**: Home page with prediction form
- **POST /predict**: Submit prediction request
  - Parameters: experience, test_score, interview_score
  - Returns: Predicted salary

## Model Information

- **Algorithm**: Linear Regression
- **Features**: Experience, Test Score, Interview Score
- **Target**: Salary prediction
- **Dataset**: hiring.csv (unique dataset for assignment)

## Workflow Triggers

### Code Quality Check
- **Trigger**: Push or PR to `dev` branch
- **Actions**: Linting, code quality validation

### Testing Workflow  
- **Trigger**: PR to `test` branch
- **Actions**: Unit tests, coverage report

### Jenkins Pipeline
- **Trigger**: Push to `master` branch
- **Actions**: Docker build, push to registry, email notification

## Email Notifications

Admin receives email notifications for:
- ✅ Successful Jenkins pipeline execution
- ❌ Failed pipeline execution
- 📊 Build status and Docker image details

## Contributing

1. Create feature branch from `dev`
2. Make changes and commit
3. Create PR to `dev` branch
4. Wait for admin approval and quality checks
5. After merge to `dev`, create PR to `test`
6. After successful testing, create PR to `master`

## Original Project Structure
This project has four major parts :
1. model.py - This contains code fot our Machine Learning model to predict employee salaries absed on trainign data in 'hiring.csv' file.
2. app.py - This contains Flask APIs that receives employee details through GUI or API calls, computes the precited value based on our model and returns it.
3. template - This folder contains the HTML template (index.html) to allow user to enter employee detail and displays the predicted employee salary.
4. static - This folder contains the css folder with style.css file which has the styling required for out index.html file.

### Running the project
1. Ensure that you are in the project home directory. Create the machine learning model by running below command from command prompt -
```
python model.py
```
This would create a serialized version of our model into a file model.pkl

2. Run app.py using below command to start Flask API
```
python app.py
```
By default, flask will run on port 5000.

3. Navigate to URL http://127.0.0.1:5000/ (or) http://localhost:5000

You should be able to view the homepage.

Enter valid numerical values in all 3 input boxes and hit Predict.

If everything goes well, you should  be able to see the predcited salary vaule on the HTML page!
check the output here: http://127.0.0.1:5000/predict

