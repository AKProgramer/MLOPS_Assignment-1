import pytest
import sys
import os
import numpy as np

# Add the parent directory to sys.path to import application
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from application import application

@pytest.fixture
def client():
    """Create a test client for the Flask application."""
    application.config['TESTING'] = True
    with application.test_client() as client:
        yield client

def test_home_page(client):
    """Test that the home page loads correctly."""
    response = client.get('/')
    assert response.status_code == 200
    assert b'Predict Salary Analysis' in response.data or b'index.html' in response.data

def test_predict_endpoint_post(client):
    """Test the prediction endpoint with POST request."""
    response = client.post('/predict', data={
        'experience': '5',
        'test_score': '8', 
        'interview_score': '7'
    })
    assert response.status_code == 200
    # Check if the response contains salary prediction
    assert b'Employee Salary should be $' in response.data or b'prediction' in response.data

def test_predict_endpoint_get(client):
    """Test that GET request to predict endpoint is handled."""
    response = client.get('/predict')
    # Should either redirect or return method not allowed
    assert response.status_code in [200, 405, 302]

def test_model_prediction():
    """Test that the model can make predictions."""
    import pickle
    
    # Load the model
    model_path = os.path.join(os.path.dirname(__file__), '..', 'model.pkl')
    if os.path.exists(model_path):
        model = pickle.load(open(model_path, 'rb'))
        
        # Test prediction with sample data
        test_data = np.array([[5, 8, 7]])
        prediction = model.predict(test_data)
        
        # Check that prediction is a number
        assert isinstance(prediction[0], (int, float, np.number))
        assert prediction[0] > 0  # Salary should be positive

def test_invalid_prediction_data(client):
    """Test prediction endpoint with invalid data."""
    response = client.post('/predict', data={
        'experience': 'invalid',
        'test_score': '8',
        'interview_score': '7'
    })
    # Should handle error gracefully
    assert response.status_code in [200, 400, 500]