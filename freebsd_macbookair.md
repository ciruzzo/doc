Install
===
[installing freebsd on macbook air](https://qiita.com/ShinyaEsu/items/7e020942952bb9259769)

After installation
===
  edit /etc/rc.conf
  pkg install xorg
  Xorg -configure
    edit xorg.conf.new, Driver section "scfb"
    cp xorg.conf.new /usr/local/etc/X11/xorg.conf.d/
        
  cp /usr/local/etc/X11/xinitrc .xinitrc
  edit .Xdefaults to change font size of Xterm

suspend & resume
===
  resume does not work.

sound volume 
===
  ajust by 
        $ mixer -s vol <num>
                num: 0-100

headphone
===
  $ sysctl hw.snd.default_unit=1 # headphone
        $ sysctl hw.snd.default_unit=0 # internal speaker

copy & paste (mouse right bottun) 
===
  use external mouse

japanese font
===
        pkg add IPA font

battery
===
        $ apm 

screen
===
        ctrl-a | # split vertically 
        ctrl-a S # split horizontally 
        ctrl-a c # new shell
        ctrl-a x # delete current region

power saving
===
        added followings to loader.conf
        hint.p4tcc.0.disabled=1
        hint.acpi_throttle.0.disabled=1
        https://wiki.freebsd.org/TuningPowerConsumption

TODO
===
        display brightness
        wifi status and fix after disconnection

