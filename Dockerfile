FROM python:3.13-slim
WORKDIR /app
COPY temperature.py .
CMD ["python3", "-c", "from temperature import celsius_to_fahrenheit as c; print(c(100))"]
