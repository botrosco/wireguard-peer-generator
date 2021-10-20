# Set vars
ip="10.1.1" #Root IP Address. Only include first 3 segments, the final one is sorted in exec.
ext_ip="" #URL/IP for the connection to wireguard server
port="" #Port for the wireguard server
al_ip="10.1.1.0/24,192.168.0.0/24" #AllowdIP (Applied if using split tunnel)
dns="10.1.1.1" #Comma seperated list
svrkeypub=$(cat "/etc/wireguard/server.key.pub") #Location of server public key
svrkeypvt=$(cat "/etc/wireguard/server.key") #Location of server private key
wg_clients_dir="$HOME/wg-clients/" #Location to place conf files for qr scanning at a later date

# Sort dir stuff
dir=$(pwd);
cd /wg-tmp;

# Collect device configs
read -p "Peer name: " p_name;
read -p "Number of device (3 would be $ip.3/32): " p_ip;
read -p "Split tunnel? (y/n): " split;

# Generate keys using colleceted info
wg genkey | tee $p_name.key | wg pubkey > $p_name.key.pub;

# Keys as vars
keypvt=$(cat $p_name.key);
 #echo "Pvt key: $keypvt"; #For troubleshooting
keypub=$(cat $p_name.key.pub);
 #echo "Pub key: $keypub"; #For troubleshooting
 #echo "Pub key: $svrkeypub"; #For troubleshooting

# Sort tunnel type settings
case $split in
y)
	al_ip_fin="$al_ip"
	;;
n)
	al_ip_fin="0.0.0.0/0"
	;;
esac

#Generate conf
echo "[Interface]
PrivateKey = $keypvt
Address = $ip.$p_ip/32
DNS = $dns

[Peer]
PublicKey = $svrkeypub
AllowedIPs = "$al_ip_fin"
Endpoint = $ext_ip:$port" >> "$p_name.conf";

# Generate QR
 #echo ""
 #qrencode -t ansiutf8 < "$p_name.conf";

# Print data for wireguard on router
echo ""
echo "Information for the WireGuard peer interface:"
echo "- Description: $p_name"
echo "- Public Key: $keypub"
echo "- Allowed IPs: $ip.$p_ip/32"

# Move stuff to wireguard folder
cp -f "$p_name.conf" "$p_name.key" "$p_name.key.pub" "$wg_clients_dir";

# Return to initial dir
cd "$dir"
rm -r /wg-tmp/*
