import os
import platform
import subprocess
import socket
import requests
import psutil
import whois
import hashlib
import nmap
import time
import zipfile
import argparse
from cryptography.fernet import Fernet
import pyperclip
import scapy.all as scapy
from rich.console import Console
from rich.live import Live
from rich.progress import track
from rich.text import Text
from rich.panel import Panel

console = Console()

def animated_log(text, delay=0.05):
    """ Prints text dynamically like a hacking tool """
    for char in text:
        console.print(char, end="", style="bold green")
        time.sleep(delay)
    console.print()  # Newline

def get_wifi_passwords():
    animated_log("[*] Scanning for saved WiFi passwords...")
    result = subprocess.run(['netsh', 'wlan', 'show', 'profiles'], capture_output=True, text=True)
    profiles = [line.split(":")[1].strip() for line in result.stdout.split("\n") if "All User Profile" in line]

    if not profiles:
        console.print("[!] No WiFi profiles found.", style="bold red")
        return

    for profile in profiles:
        animated_log(f"[*] Checking: {profile}")
        output = subprocess.run(['netsh', 'wlan', 'show', 'profile', profile, 'key=clear'], capture_output=True, text=True).stdout
        for line in output.split("\n"):
            if "Key Content" in line:
                password = line.split(":")[1].strip()
                console.print(f"[+] {profile}: {password}", style="bold cyan")

def system_info():
    animated_log("[*] Gathering system information...")
    info = f"""
    OS: {platform.system()} {platform.release()}
    Processor: {platform.processor()}
    Architecture: {platform.architecture()[0]}
    Machine: {platform.machine()}
    """
    console.print(Panel(info, title="[bold yellow]System Info[/bold yellow]"))

def public_ip():
    animated_log("[*] Fetching public IP address...")
    try:
        ip = requests.get("https://api64.ipify.org").text
        console.print(f"[+] Public IP: {ip}", style="bold cyan")
    except:
        console.print("[!] Failed to retrieve public IP.", style="bold red")

def port_scan(target):
    animated_log(f"[*] Scanning ports on {target}...")
    nm = nmap.PortScanner()
    nm.scan(target, '1-1024')

    for host in nm.all_hosts():
        console.print(f"\n[+] Host: {host} ({nm[host].hostname()})", style="bold yellow")
        console.print(f"    State: {nm[host].state()}", style="bold cyan")

        for proto in nm[host].all_protocols():
            console.print(f"    Protocol: {proto}", style="bold magenta")
            for port, details in nm[host][proto].items():
                console.print(f"    Port: {port} - State: {details['state']}", style="bold green")

def brute_force_zip(zip_path, wordlist_path):
    animated_log(f"[*] Brute forcing ZIP file: {zip_path}")

    if not os.path.exists(zip_path) or not os.path.exists(wordlist_path):
        console.print("[!] Invalid file paths.", style="bold red")
        return

    with zipfile.ZipFile(zip_path) as zf:
        with open(wordlist_path, "r", encoding="utf-8", errors="ignore") as wordlist:
            for password in track(wordlist, description="[*] Trying passwords..."):
                password = password.strip().encode()
                try:
                    zf.extractall(pwd=password)
                    console.print(f"\n[+] Password found: {password.decode()}", style="bold green")
                    return
                except:
                    continue

    console.print("[!] No valid password found in wordlist.", style="bold red")

def whois_lookup(domain):
    animated_log(f"[*] Performing WHOIS lookup on {domain}...")
    try:
        domain_info = whois.whois(domain)
        console.print(Panel(str(domain_info), title=f"[bold yellow]WHOIS: {domain}[/bold yellow]"))
    except:
        console.print("[!] WHOIS lookup failed.", style="bold red")

def traceroute(target):
    animated_log(f"[*] Running traceroute on {target}...")
    ans, _ = scapy.traceroute(target, maxttl=30)
    
    for snd, rcv in ans:
        console.print(f"[+] {snd.ttl} -> {rcv.src}", style="bold green")

def list_files():
    animated_log("[*] Listing files in current directory...")
    files = "\n".join(os.listdir("."))
    console.print(Panel(files, title="[bold yellow]Files[/bold yellow]"))

def generate_encryption_key():
    animated_log("[*] Generating encryption key...")
    key = Fernet.generate_key()
    
    with open("encryption_key.key", "wb") as key_file:
        key_file.write(key)
    
    pyperclip.copy(key.decode())
    console.print("[+] Encryption key generated and copied to clipboard!", style="bold green")

# -----------------------------
# Command-Line Argument Parser
# -----------------------------
parser = argparse.ArgumentParser(description="CyberSecurity Toolkit (Wifite/John Style)")
parser.add_argument("--wifi", action="store_true", help="Get saved WiFi passwords")
parser.add_argument("--sysinfo", action="store_true", help="Get system information")
parser.add_argument("--ip", action="store_true", help="Get public IP address")
parser.add_argument("--portscan", metavar="TARGET", help="Scan ports on a target")
parser.add_argument("--whois", metavar="DOMAIN", help="Perform a WHOIS lookup")
parser.add_argument("--traceroute", metavar="TARGET", help="Perform a traceroute")
parser.add_argument("--listfiles", action="store_true", help="List files in the current directory")
parser.add_argument("--brutezip", nargs=2, metavar=("ZIP", "WORDLIST"), help="Brute force a ZIP file")
parser.add_argument("--genkey", action="store_true", help="Generate an encryption key")

args = parser.parse_args()

# -----------------------------
# Execute Commands
# -----------------------------
if args.wifi:
    get_wifi_passwords()
elif args.sysinfo:
    system_info()
elif args.ip:
    public_ip()
elif args.portscan:
    port_scan(args.portscan)
elif args.whois:
    whois_lookup(args.whois)
elif args.traceroute:
    traceroute(args.traceroute)
elif args.listfiles:
    list_files()
elif args.brutezip:
    brute_force_zip(args.brutezip[0], args.brutezip[1])
elif args.genkey:
    generate_encryption_key()
else:
    console.print("[bold red]Use --help to see available commands.[/bold red]")
