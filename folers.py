from flask import Flask, request, send_file, after_this_request
import pandas as pd
import os
import shutil
import tempfile
import traceback

app = Flask(__name__)

@app.route('/')
def upload_form():
    return '''
    <!DOCTYPE html>
    <html lang="zh">
    <head>
        <meta charset="UTF-8">
        <title>Excel 文件夹生成器</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-black">
        <div class="container mt-5 w-1/3">
            <div class="card shadow p-4 bg-gray-700">
                <h2 class="text-center mb-4 text-white">自动生成文件夹</h2>
                <form action="/upload" method="post" enctype="multipart/form-data" class="text-center">
                    <input class="form-control mb-3" type="file" name="file" accept=".xls,.xlsx" required />
                    <button type="submit"
                    class="w-1/3 bg-gradient-to-r from-[#8E354A] to-[#64363C] py-3 text-white font-semibold 
                    rounded-md hover:scale-105 opacity-90 transition">上传并生成</button>
                </form>
            </div>
        </div>
    </body>
    </html>
    '''


@app.route('/upload', methods=['POST'])
def upload_file():
    try:
        file = request.files.get('file')
        if not file:
            return "没有上传文件"

        # 创建临时目录
        temp_dir = tempfile.mkdtemp()

        # 读取 Excel
        df = pd.read_excel(file)

        # 遍历 Excel 第一列生成文件夹
        for folder_name in df.iloc[:, 0].dropna():
            safe_name = str(folder_name).strip()
            safe_name = "".join(c for c in safe_name if c.isalnum() or c in (" ", "_", "-"))
            if not safe_name:
                continue
            os.makedirs(os.path.join(temp_dir, safe_name), exist_ok=True)

        # 打包成 zip
        zip_path = shutil.make_archive(temp_dir, 'zip', temp_dir)

        @after_this_request
        def cleanup(response):
            try:
                if os.path.exists(zip_path):
                    os.remove(zip_path)
                if os.path.exists(temp_dir):
                    shutil.rmtree(temp_dir)
            except Exception as e:
                print("清理失败:", e)
            return response

        return send_file(zip_path, as_attachment=True, download_name="folders.zip")

    except Exception as e:
        traceback.print_exc()
        return f"出错了: {e}"


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
