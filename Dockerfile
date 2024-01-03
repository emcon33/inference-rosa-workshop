# Use an official Python runtime as a parent image
FROM python:3.6-slim

# Copy the requirements file into the image
COPY ./requirements.txt /app/requirements.txt

ENV TORCH_HOME=/app

#RUN useradd -ms /bin/bash admin
#RUN chown -R admin:admin /app
#USER admin

# Set the working directory to /app
WORKDIR /app
RUN chmod 777 /app

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Copy every content from the local folder to the image
#COPY . /app
COPY . .

# Run server
CMD ["uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]
