import random
from datetime import datetime, timedelta

def generate_log_line():
    timestamp = datetime.now() - timedelta(days=random.randint(1, 365), hours=random.randint(1, 24), minutes=random.randint(1, 60), seconds=random.randint(1, 60))
    timestamp_str = timestamp.strftime("[%Y-%m-%d %H:%M:%S]")

    log_levels = ["INFO", "ERROR", "WARNING"]
    log_level = random.choice(log_levels)

    user_agents = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/91.0.864.59 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    ]
    user_agent = random.choice(user_agents)

    event_types = ["LOGIN", "LOGOUT", "REQUEST", "ERROR", "API_CALL"]
    event_type = random.choice(event_types)

    messages = {
        "LOGIN": f"User logged in - User: {generate_user()}",
        "LOGOUT": f"User logged out - User: {generate_user()}",
        "REQUEST": f"Page accessed - Path: {generate_path()} - Device: {generate_device()} - Response Time: {generate_response_time()} ms",
        "ERROR": f"Internal Server Error - Path: {generate_path()} - Error Code: {generate_error_code()}",
        "API_CALL": f"API Call made - Endpoint: {generate_api_endpoint()} - Method: {generate_http_method()} - Response: {generate_api_response()} - Response Time: {generate_response_time()} ms"
    }

    message = messages.get(event_type, "Unknown Event")

    return f"{timestamp_str} {log_level}: {message} - UserAgent: {user_agent}"

def generate_user():
    users = ["user123", "admin", "guest", "developer", "manager", "tester", "analyst"]
    return random.choice(users)

def generate_path():
    paths = ["/path/to/resource1", "/path/to/resource2", "/path/to/resource3", "/path/to/nonexistent/file"]
    return random.choice(paths)

def generate_device():
    devices = ["Desktop", "Mobile", "Tablet"]
    return random.choice(devices)

def generate_error_code():
    error_codes = [400, 401, 403, 404, 500]
    return random.choice(error_codes)

def generate_api_endpoint():
    endpoints = ["/api/v1/users", "/api/v1/products", "/api/v1/orders", "/api/v1/error"]
    return random.choice(endpoints)

def generate_http_method():
    methods = ["GET", "POST", "PUT", "DELETE"]
    return random.choice(methods)

def generate_api_response():
    responses = ["200 OK", "201 Created", "400 Bad Request", "401 Unauthorized", "500 Internal Server Error"]
    return random.choice(responses)

def generate_response_time():
    return random.randint(1, 1000)

# Générer 3000 lignes de logs
logs = [generate_log_line() for _ in range(3000)]

# Enregistrer les logs dans un fichier texte
with open("sample_logs.txt", "w") as file:
    file.write("\n".join(logs))
