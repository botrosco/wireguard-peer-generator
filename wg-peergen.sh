# Set vars
ip="192.168.2" #Root IP Address. Only include first 3 segments, the final one is sorted in exec.
ext_ip="" #URL/IP for the connection to wireguard server
port="55555" #Port for the wireguard server
al_ip="10.0.0.0/24,192.168.1.0/24" #AllowdIP (Applied if using split tunnel)
dns="1.1.1.1,1.0.0.1" #Comma seperated list
svrkeypub=$(sudo cat "/etc/wireguard/server.key.pub") #Location of server public key, for the provided guide it would be /etc/wireguard/keys/server.key.pub
svrkeypvt=$(sudo cat "/etc/wireguard/server.key") #Location of server private key, for the provided guide it would be /etc/wireguard/keys/server.key
wg_clients_dir="$HOME/wg-clients/" #Location to place conf files for qr scanning at a later date

# Sort dir stuff
dir=$(pwd);
cd /tmp;

# Collect device configs
read -p "Peer name: " p_name;
read -p "Number of device (3 would be $ip.3/32): " p_ip;
read -p "Split tunnel? (y/n): " split;

# Generate keys using colleceted info
wg genkey | sudo tee $p_name.key | wg pubkey | sudo tee $p_name.key.pub;

# Keys as vars
keypvt=$(cat $p_name.key);
 #echo "Pvt key: $keypvt"; #For troubleshooting
keypub=$(cat $p_name.key.pub);
 #echo "Pub key: $keypub"; #For troubleshooting
 #echo "Pub key: $keypubsvr"; #For troubleshooting
 
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
AllowedIPs = $al_ip_fin
Endpoint = $ext_ip:$port" >> "$p_name.conf";
 #cat "$p_name.conf"; #For troubleshooting

# Run "wg set" for the new device
sudo wg set wg0 peer $keypub allowed-ips $ip.$p_ip/32 &&
 #echo "sudo wg set wg0 peer $keypub allowed-ips $ip$p_ip/32"; #For troubleshooting

# Generate QR
qrencode -t ansiutf8 < "$p_name.conf";

# Move stuff to wireguard folder
cp -f "$p_name.conf" "$wg_clients_dir"; #Comment out to only place in /etc/wireguard/clients
sudo mv "$p_name.conf" "$p_name.key" "$p_name.key.pub" "/etc/wireguard/clients/"; 

# Return to initial dir
cd "$dir"
