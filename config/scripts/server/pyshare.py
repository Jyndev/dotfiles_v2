import os
import sys
import http.server
import socket

if len(sys.argv) > 1:
    UPLOAD_DIRECTORY = sys.argv[1]
    os.chdir(UPLOAD_DIRECTORY)
else:
    UPLOAD_DIRECTORY = os.getcwd()
    
# Diccionario de iconos según la extensión
ICON_MAP = {
    "folder": "bi-folder-fill",  # Carpetas 📂
    "text": "bi-file-earmark-text-fill",  # Documentos 📄
    "image": "bi-file-earmark-image-fill",  # Imágenes 🖼️
    "video": "bi-file-earmark-play-fill",  # Videos 🎬
    "audio": "bi-file-earmark-music-fill",  # Audios 🎵
    "code": "bi-file-earmark-code-fill",  # Código 💻
    "zip": "bi-file-earmark-zip-fill",  # Archivos comprimidos 📦
    "binary": "bi-file-earmark-binary-fill",  # Ejecutables ⚙️
    "android": "bi-android",  # Archivos APK 🤖
    "default": "bi-file-earmark-fill",  # Otro tipo 📄
}

# Extensiones por categoría
EXTENSIONS = {
    "text": [".txt", ".pdf", ".docx", ".odt"],
    "image": [".jpg", ".jpeg", ".png", ".gif", ".svg"],
    "video": [".mp4", ".avi", ".mov", ".mkv"],
    "audio": [".mp3", ".wav", ".ogg"],
    "code": [".py", ".html", ".css", ".js", ".java", ".c", ".cpp"],
    "zip": [".zip", ".rar", ".tar.gz", ".7z"],
    "binary": [".exe", ".msi", ".bat", ".sh", ".deb", ".rpm", ".AppImage"],
    "android": [".apk"]
}

def get_icon(filename):
    """Devuelve el icono según la extensión del archivo"""
    if os.path.isdir(filename):
        return ICON_MAP["folder"]  # 📂

    ext = os.path.splitext(filename)[1].lower()
    for category, extensions in EXTENSIONS.items():
        if ext in extensions:
            return ICON_MAP[category]

    return ICON_MAP["default"]  # 📄 (si no coincide con nada)

def get_local_ip():
    """Obtiene la IP local del equipo"""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(0)
    try:
        s.connect(('8.8.8.8', 1))  # No importa la IP, solo conectarse a una IP de la red
        ip = s.getsockname()[0]
    except Exception:
        ip = '127.0.0.1'  # Si no se puede obtener la IP, usar localhost
    finally:
        s.close()
    return ip

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def list_directory(self, path):
        """Genera una lista de archivos con Bootstrap y iconos personalizados"""
        try:
            file_list = sorted(os.listdir(path), key=lambda f: (not os.path.isdir(f), f.lower()))
            response = """<!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Mis Archivos</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
                <style>
                    body { background: #f8f9fa; }
                    .container { max-width: 800px; margin-top: 50px; }
                    .list-group-item { display: flex; align-items: center; }
                    .icon { font-size: 1.5rem; margin-right: 10px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1 class="text-center my-4">Lista de Archivos</h1>
                    
                    <!-- Formulario para subir archivos -->
                    <form action="/" method="post" enctype="multipart/form-data" class="mb-4">
                        <div class="input-group">
                            <input type="file" name="file" class="form-control" required>
                            <button type="submit" class="btn btn-primary">Subir</button>
                        </div>
                    </form>

                    <div class="list-group">"""
            
            for file in file_list:
                icon = get_icon(file)
                response += f'<a href="{file}" class="list-group-item list-group-item-action">'
                response += f'<i class="bi {icon} icon"></i> {file}</a>'
            
            response += """</div></div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body></html>"""

            self.send_response(200)
            self.send_header("Content-type", "text/html; charset=utf-8")
            self.end_headers()
            self.wfile.write(response.encode("utf-8"))
            return None
        except Exception as e:
            self.send_error(500, f"Error al generar la lista: {e}")

    def do_POST(self):
        """Maneja la subida de archivos sin usar cgi"""
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        
        # Obtener el límite del multipart/form-data
        boundary = self.headers['Content-Type'].split("boundary=")[-1]
        boundary_bytes = f"--{boundary}".encode()

        # Separar los datos en partes
        parts = body.split(boundary_bytes)
        for part in parts:
            if b"filename=" in part:
                headers, file_data = part.split(b"\r\n\r\n", 1)
                file_data = file_data.rsplit(b"\r\n", 1)[0]

                # Extraer el nombre del archivo
                headers_str = headers.decode(errors="ignore")
                filename = None
                for line in headers_str.split("\r\n"):
                    if "filename=" in line:
                        filename = line.split("filename=")[-1].strip('"')

                if filename:
                    file_path = os.path.join(UPLOAD_DIRECTORY, filename)
                    with open(file_path, "wb") as f:
                        f.write(file_data)
                    print(f"Archivo recibido: {filename}")

        self.send_response(303)
        self.send_header("Location", "/")
        self.end_headers()

if __name__ == "__main__":
    local_ip = get_local_ip()
    print(f"Servidor corriendo en http://{local_ip}:8080")
    server_address = (local_ip, 8080)
    httpd = http.server.HTTPServer(server_address, CustomHandler)
    httpd.serve_forever()
