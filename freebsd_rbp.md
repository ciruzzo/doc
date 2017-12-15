# Raspberry Pi B+, Wifi setup

tested with FreeBSD 10.3

### /boot/loader.confに追加

```
legal.realtek.license_ack=1
```

### create wlan0を作成

```
# ifconfig wlan0 create wlandev urtwn0
```

### /etc/rc.confに追加

```
wlans_urtwn0="wlan0"
ifconfig_wlan0="WPA DHCP"
```

### networkをスキャンして様子を見る

```
# ifconfig wlan0 up scan
```

### /etc/wpa_supplicant.confに自分のネットワークのSSIDとパスワードを記入

```
network={
    ssid="your_ssid"
    psk="your_password"
}
```

### reboot

```
# reboot
```
