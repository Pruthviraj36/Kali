import os
import platform
import subprocess
import socket
import requests
import psutil
import whois
import hashlib
import nmap
import json
from cryptography.fernet import Fernet
import pyperclip
import scapy.all as scapy
import customtkinter as ctk
import zipfile

# UI Setup
ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")


class CyberSecurityToolkit(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("Cybersecurity & System Toolkit")
        self.geometry("800x650")
        
        # Add buffer for text updates
        self.text_buffer = []
        self.last_update = 0
        self.update_interval = 100  # milliseconds

        # UI Elements
        self.label = ctk.CTkLabel(self, text="🔐 Cybersecurity Toolkit", font=("Arial", 20))
        self.label.pack(pady=10)

        self.textbox = ctk.CTkTextbox(self, height=300, width=750)
        self.textbox.pack(pady=5)

        # Buttons
        btn_frame = ctk.CTkFrame(self)
        btn_frame.pack(pady=10)

        buttons = [
            ("WiFi Passwords", self.get_wifi_password),
            ("System Info", self.system_info),
            ("Public IP", self.get_public_ip),
            ("Port Scan", self.scan_ports),
            ("Whois Lookup", self.whois_lookup),
            ("Traceroute", self.traceroute),
            ("List Files", self.list_files),
            ("Check Disk", self.check_disk_space),
            ("File Hash", self.check_file_hash),
            ("List Processes", self.list_processes),
            ("Kill Process", self.kill_process),
            ("Network Scan", self.network_scan),
            ("MAC Lookup", self.mac_lookup),
            ("HTTP Headers", self.http_headers),
            ("SSL Info", self.ssl_info),
            ("Encrypt File", self.encrypt_file),
            ("Decrypt File", self.decrypt_file),
            ("Fake Identity", self.fake_identity),
            ("DNS Lookup", self.dns_lookup),
            ("Redirect Scanner", self.redirect_scanner),
            ("Generate Key", self.generate_encryption_key),
            ("Brute Force ZIP", self.brute_force_zip),
            ("Exit", self.quit)
        ]

        for i, (text, command) in enumerate(buttons):
            ctk.CTkButton(btn_frame, text=text, command=command).grid(row=i//3, column=i%3, padx=5, pady=5)

        # Schedule periodic updates
        self.after(self.update_interval, self.update_text_buffer)

    def log_output(self, text):
        self.text_buffer.append(text + "\n")
        current_time = self.winfo_tasks()
        if current_time - self.last_update >= self.update_interval:
            self.update_text_buffer()
            self.last_update = current_time

    def update_text_buffer(self):
        if self.text_buffer:
            text = "".join(self.text_buffer)
            self.textbox.insert("end", text)
            self.textbox.see("end")
            self.text_buffer.clear()
        self.after(self.update_interval, self.update_text_buffer)

    # SYSTEM TOOLS
    def list_processes(self):
        processes = [f"PID: {proc.pid} - Name: {proc.name()}" for proc in psutil.process_iter(['pid', 'name'])]
        self.log_output("Running Processes:\n" + "\n".join(processes))

    def check_disk_space(self):
        disk_info = psutil.disk_usage('/')
        disk_space = f"Total: {disk_info.total / (1024 ** 3):.2f} GB\n" \
                    f"Used: {disk_info.used / (1024 ** 3):.2f} GB\n" \
                    f"Free: {disk_info.free / (1024 ** 3):.2f} GB\n" \
                    f"Percentage: {disk_info.percent}%"
        self.log_output(f"Disk Space Info:\n{disk_space}")

    def kill_process(self):
        pid = ctk.CTkInputDialog(text="Enter Process PID:", title="Kill Process").get_input()
        if pid:
            try:
                os.kill(int(pid), 9)
                self.log_output(f"Process {pid} terminated.")
            except Exception as e:
                self.log_output(f"Error: {e}")

    # NETWORK SECURITY
    def dns_lookup(self):
        domain = ctk.CTkInputDialog(text="Enter Domain:", title="DNS Lookup").get_input()
        if domain:
            try:
                ip_addresses = socket.gethostbyname_ex(domain)
                self.log_output(f"DNS Lookup for {domain}:\n{ip_addresses}")
            except Exception as e:
                self.log_output(f"Error: {e}")

    def redirect_scanner(self):
        url = ctk.CTkInputDialog(text="Enter URL:", title="Redirect Scanner").get_input()
        if url:
            try:
                response = requests.get(url, allow_redirects=True)
                history = "\n".join([resp.url for resp in response.history])
                self.log_output(f"Redirect Chain:\n{history}\nFinal URL: {response.url}")
            except Exception as e:
                self.log_output(f"Error: {e}")

    def generate_encryption_key(self):
        key = Fernet.generate_key()
        with open("encryption_key.key", "wb") as key_file:
            key_file.write(key)
        pyperclip.copy(key.decode())
        self.log_output("Encryption key generated and copied to clipboard!")

    def brute_force_zip(self):
        zip_path = ctk.CTkInputDialog(text="Enter ZIP File Path:", title="Brute Force ZIP").get_input()
        wordlist_path = ctk.CTkInputDialog(text="Enter Wordlist Path:", title="Brute Force ZIP").get_input()

        if zip_path and wordlist_path and os.path.exists(zip_path) and os.path.exists(wordlist_path):
            try:
                # Get total number of lines for progress calculation
                total_lines = sum(1 for _ in open(wordlist_path, 'r', encoding='utf-8', errors='ignore'))
                current_line = 0
                
                with zipfile.ZipFile(zip_path) as zf:
                    with open(wordlist_path, "r", encoding="utf-8", errors="ignore") as wordlist:
                        for line in wordlist:
                            current_line += 1
                            password = line.strip().encode()
                            
                            # Update progress every 1000 attempts
                            if current_line % 1000 == 0:
                                progress = (current_line / total_lines) * 100
                                self.log_output(f"Progress: {progress:.2f}% - Trying password: {password.decode()}")
                            
                            try:
                                zf.extractall(pwd=password)
                                self.log_output(f"Password found: {password.decode()}")
                                return
                            except:
                                continue
                self.log_output("No valid password found in wordlist.")
            except Exception as e:
                self.log_output(f"Error during brute force: {e}")
        else:
            self.log_output("Invalid file paths provided.")

    def list_files(self):
        files = "\n".join(os.listdir("."))
        self.log_output("Files in Current Directory:\n" + files)

    def get_wifi_password(self):
        try:
            result = subprocess.run(['netsh', 'wlan', 'show', 'profiles'], capture_output=True, text=True)
            profiles = [line.split(":")[1].strip() for line in result.stdout.split("\n") if "All User Profile" in line]
            wifi_passwords = []
            for profile in profiles:
                output = subprocess.run(['netsh', 'wlan', 'show', 'profile', profile, 'key=clear'],
                                        capture_output=True, text=True).stdout
                for line in output.split("\n"):
                    if "Key Content" in line:
                        password = line.split(":")[1].strip()
                        wifi_passwords.append(f"{profile}: {password}")
            self.log_output("\n".join(wifi_passwords))
        except Exception as e:
            self.log_output(f"Error retrieving WiFi passwords: {e}")

    def get_public_ip(self):
        try:
            ip = requests.get("https://api64.ipify.org").text
            self.log_output(f"Public IP: {ip}")
        except Exception as e:
            self.log_output(f"Error retrieving IP: {e}")

    def system_info(self):
        sys_info = f"OS: {platform.system()} {platform.release()}\n" \
                   f"Processor: {platform.processor()}\n" \
                   f"Architecture: {platform.architecture()[0]}\n" \
                   f"Machine: {platform.machine()}"
        self.log_output(sys_info)

    def scan_ports(self):
        target = ctk.CTkInputDialog(text="Enter Target IP:", title="Port Scan").get_input()
        if target:
            try:
                nm = nmap.PortScanner()
                nm.scan(target, '1-1024')  # Scans ports 1 to 1024
                scan_results = ""
                for host in nm.all_hosts():
                    scan_results += f"Host: {host} ({nm[host].hostname()})\n"
                    scan_results += f"State: {nm[host].state()}\n"
                    for proto in nm[host].all_protocols():
                        scan_results += f"Protocol: {proto}\n"
                        lport = nm[host][proto].keys()
                        for port in lport:
                            scan_results += f"Port: {port}\tState: {nm[host][proto][port]['state']}\n"
                self.log_output(scan_results)
            except Exception as e:
                self.log_output(f"Error during port scan: {e}")

    def whois_lookup(self):
        domain = ctk.CTkInputDialog(text="Enter Domain:", title="Whois Lookup").get_input()
        if domain:
            try:
                domain_info = whois.whois(domain)
                self.log_output(f"Whois Lookup for {domain}:\n{domain_info}")
            except Exception as e:
                self.log_output(f"Error during Whois lookup: {e}")

    def traceroute(self):
        target = ctk.CTkInputDialog(text="Enter Target IP:", title="Traceroute").get_input()
        if target:
            try:
                ans, unans = scapy.traceroute(target, maxttl=30)
                traceroute_results = ""
                for snd, rcv in ans:
                    traceroute_results += f"TTL: {snd.ttl} - IP: {rcv.src}\n"
                self.log_output(f"Traceroute to {target}:\n{traceroute_results}")
            except Exception as e:
                self.log_output(f"Error during traceroute: {e}")

    def check_file_hash(self):
        file_path = ctk.CTkInputDialog(text="Enter File Path:", title="File Hash").get_input()
        if file_path and os.path.exists(file_path):
            try:
                with open(file_path, 'rb') as file:
                    file_hash = hashlib.md5(file.read()).hexdigest()
                self.log_output(f"MD5 Hash of {file_path}: {file_hash}")
            except Exception as e:
                self.log_output(f"Error calculating file hash: {e}")
        else:
            self.log_output("Invalid file path provided.")

    def network_scan(self):
        target = ctk.CTkInputDialog(text="Enter Target IP Range (e.g., 192.168.1.0/24):", title="Network Scan").get_input()
        if target:
            try:
                arp_request = scapy.ARP(pdst=target)
                broadcast = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")
                arp_request_broadcast = broadcast / arp_request
                answered_list = scapy.srp(arp_request_broadcast, timeout=1, verbose=False)[0]
                network_results = "Network Scan Results:\n"
                for element in answered_list:
                    network_results += f"IP: {element[1].psrc} - MAC: {element[1].hwsrc}\n"
                self.log_output(network_results)
            except Exception as e:
                self.log_output(f"Error during network scan: {e}")

    def mac_lookup(self):
        mac_address = ctk.CTkInputDialog(text="Enter MAC Address:", title="MAC Lookup").get_input()
        if mac_address:
            try:
                # You can use an API to look up the manufacturer of the MAC address
                # For example, using the macvendors API
                response = requests.get(f"https://api.macvendors.com/{mac_address}")
                if response.status_code == 200:
                    manufacturer = response.text
                    self.log_output(f"MAC Address {mac_address} belongs to: {manufacturer}")
                else:
                    self.log_output("MAC address not found in the database.")
            except Exception as e:
                self.log_output(f"Error during MAC lookup: {e}")

    def http_headers(self):
        url = ctk.CTkInputDialog(text="Enter URL:", title="HTTP Headers").get_input()
        if url:
            try:
                response = requests.get(url)
                headers = "\n".join([f"{key}: {value}" for key, value in response.headers.items()])
                self.log_output(f"HTTP Headers for {url}:\n{headers}")
            except Exception as e:
                self.log_output(f"Error retrieving HTTP headers: {e}")

    def ssl_info(self):
        url = ctk.CTkInputDialog(text="Enter URL:", title="SSL Info").get_input()
        if url:
            try:
                response = requests.get(url, verify=True)
                cert = response.raw.connection.sock.getpeercert()
                ssl_info = f"SSL Certificate Info:\n"
                ssl_info += f"Subject: {cert['subject']}\n"
                ssl_info += f"Issuer: {cert['issuer']}\n"
                ssl_info += f"Version: {cert['version']}\n"
                ssl_info += f"Expires: {cert['notAfter']}\n"
                self.log_output(ssl_info)
            except Exception as e:
                self.log_output(f"Error retrieving SSL info: {e}")

    def encrypt_file(self):
        file_path = ctk.CTkInputDialog(text="Enter File Path to Encrypt:", title="Encrypt File").get_input()
        if file_path and os.path.exists(file_path):
            try:
                key = Fernet.generate_key()
                f = Fernet(key)
                with open(file_path, 'rb') as file:
                    file_data = file.read()
                encrypted_data = f.encrypt(file_data)
                with open(file_path + '.encrypted', 'wb') as file:
                    file.write(encrypted_data)
                with open(file_path + '.key', 'wb') as key_file:
                    key_file.write(key)
                self.log_output(f"File encrypted successfully! Key saved to {file_path}.key")
            except Exception as e:
                self.log_output(f"Error encrypting file: {e}")
        else:
            self.log_output("Invalid file path provided.")

    def decrypt_file(self):
        file_path = ctk.CTkInputDialog(text="Enter Encrypted File Path:", title="Decrypt File").get_input()
        key_path = ctk.CTkInputDialog(text="Enter Key File Path:", title="Decrypt File").get_input()
        if file_path and key_path and os.path.exists(file_path) and os.path.exists(key_path):
            try:
                with open(key_path, 'rb') as key_file:
                    key = key_file.read()
                f = Fernet(key)
                with open(file_path, 'rb') as file:
                    encrypted_data = file.read()
                decrypted_data = f.decrypt(encrypted_data)
                with open(file_path + '.decrypted', 'wb') as file:
                    file.write(decrypted_data)
                self.log_output("File decrypted successfully!")
            except Exception as e:
                self.log_output(f"Error decrypting file: {e}")
        else:
            self.log_output("Invalid file paths provided.")

    def fake_identity(self):
        try:
            # Using the Faker library for generating fake identities
            from faker import Faker
            fake = Faker()
            identity = f"Fake Identity:\n"
            identity += f"Name: {fake.name()}\n"
            identity += f"Address: {fake.address()}\n"
            identity += f"Phone: {fake.phone_number()}\n"
            identity += f"Email: {fake.email()}\n"
            identity += f"Company: {fake.company()}\n"
            identity += f"Job: {fake.job()}\n"
            identity += f"SSN: {fake.ssn()}\n"
            self.log_output(identity)
        except Exception as e:
            self.log_output(f"Error generating fake identity: {e}")

# Run Application
if __name__ == "__main__":
    app = CyberSecurityToolkit()
    app.mainloop()
