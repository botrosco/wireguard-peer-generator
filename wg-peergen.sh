# Set vars
ip="192.168.2." #Root IP Address. Only include first 3 segments, the final one is sorted in exec.
ext_ip="" #URL/IP for the connection to wireguard server
port="55555" #Port for the wireguard server
dns="1.1.1.1,1.0.0.1" #Comma seperated list

# Sort dir stuff
dir=$(pwd);
cd /tmp;

# Collect device configs
read -p "Peer name: " p_name;
read -p "Number of device (3 would be 192.168.2.3/32): " p_ip;

# Generate keys using colleceted info
wg genkey | sudo tee $p_name.key | wg pubkey | sudo tee $p_name.key.pub;

# Keys as vars
keypvt=$(cat $p_name.key);
 #echo "Pvt key: $keypvt"; #For troubleshooting
keypub=$(cat $p_name.key.pub);
 #echo "Pub key: $keypub"; #For troubleshooting
keypubsvr=$(sudo cat /etc/wireguard/publickey);
 #echo "Pub key: $keypubsvr"; #For troubleshooting

#Generate conf
echo "[Interface]
PrivateKey = $keypvt
Address = $ip$p_ip/32
DNS = $dns

[Peer]
PublicKey = $keypubsvr
AllowedIPs = 0.0.0.0/0
Endpoint = $ext_ip:$port" >> "$p_name.conf";
 #cat "$p_name.conf"; #For troubleshooting

# Run "wg set" for the new device
sudo wg set wg0 peer $keypub allowed-ips 192.168.2.$p_ip/32 &&
 #echo "sudo wg set wg0 peer $keypub allowed-ips $ip$p_ip/32"; #For troubleshooting

# Generate QR
qrencode -t ansiutf8 < "$p_name.conf";

# Move stuff to wireguard folder
sudo mv "$p_name.conf" "$p_name.key" "$p_name.key.pub" "/etc/wireguard/clients/"; 

# Return to initial dir
cd "$dir"
