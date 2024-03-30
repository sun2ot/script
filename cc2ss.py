import argparse
import base64

def generate_ss_subscribe_link(server, port, method, password, name=None, udp=False):
    config = f"{method}:{password}@{server}:{port}"
    if udp:
        config = f"{config}?udp=1"
    base64_config = base64.urlsafe_b64encode(config.encode()).decode().rstrip('=')
    subscribe_link = f"ss://{base64_config}"
    if name:
        subscribe_link = f"{subscribe_link}#{name}"
    return subscribe_link

def main():
    parser = argparse.ArgumentParser(description='Generate Shadowsocks subscription link', formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('-s', '--server', type=str, help='Server IP or domain', required=True)
    parser.add_argument('-p', '--port', type=int, help='Server port', required=True)
    parser.add_argument('-m', '--method', type=str, help='Encryption method\nDefault is chacha20-ietf-poly1305', default='chacha20-ietf-poly1305')
    parser.add_argument('-pwd', '--password', type=str, help='Password', required=True)
    parser.add_argument('-n', '--name', type=str, help='Name for the server', required=True)
    parser.add_argument('-u', '--udp', action='store_true', help='Enable UDP support')    

    args = parser.parse_args()

    ss_subscribe_link = generate_ss_subscribe_link(args.server, args.port, args.method, args.password, args.name, args.udp)
    print(ss_subscribe_link)

if __name__ == "__main__":
    main()

"""
  - {name: whr, server: 172.16.16.242, port: 8388, type: ss, cipher: chacha20-ietf-poly1305, password: nmuwhr666, udp: true}

"""