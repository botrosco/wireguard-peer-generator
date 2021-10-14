# wireguard-peer-generator
This script should be run on the server where wireguard is running

## Prerequisites
### Dependencies
- wireguard (Working and configured ready to configure clients, check out [this](https://serversideup.net/how-to-set-up-wireguard-vpn-server-on-ubuntu-20-04/) guide for more)
- qrencode (If you want to be able to generate QR codes)
### Directories
These are directories that are required/recommended by the script
#### Required
- /etc/wireguard/clients/ 
#### Recomended
- $HOME/wg-clients/ - Used if you would like to keep conf. files in a user accessable location for easier access at a later date

## Notes for running
The inline comments should provide most of the information required.

Updated to provide the exact information requried for the wireguard tools on OpenWRT routers

*Remember to set vars before usign the script*

Feedback is encouraged. I wont be expanding the features of this much/at all as for now it does what I need, however, I fully welcome PRs & forks.
