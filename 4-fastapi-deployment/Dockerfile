# Using the official Python image from the Docker Hub
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY app/requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the FastAPI application code into the container
COPY app .

# Set environment variables
ENV COGNITO_USER_POOL_ID=xxxx
ENV COGNITO_CLIENT_ID=xxxx
ENV COGNITO_CLIENT_SECRET=xxxx
ENV AWS_REGION=xxxx

# Expose the port the app runs on
EXPOSE 80

# Command to run the FastAPI application using Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]