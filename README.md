# environment

## Setup

Bash config

```
echo ". ~/home/environment/.basrhc" >> ~/.bashrc
```

Update sudoers

```
cp sbw.sudoers /etc/sudoers.d/sbw
```

Add DWM config for the desktop manager

```
sudo cp dwm.desktop /usr/share/xsessions/
```
