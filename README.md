# rEFInd Theme Regular

A simplistic clean and minimal theme for rEFInd. This version has a fully black background to reduce color changes during boot time, for a smoother boot sequence.

NOTE: this is a fork of [munlik's theme](https://github.com/munlik/refind-theme-regular/).

 **press F10 to take screenshot**
 
(default settings)
![Screenshot 01](https://raw.githubusercontent.com/vnl6rj/refind-theme-regular-black/master/src/preview.bmp)

### Installation [Quick]:

1. Just paste this command in your terminal and enter your choices.
   ```
   sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/vnl6rj/refind-theme-regular-black/master/install.sh)"
   ```
2. To further adjust icon and font size, edit `/boot/efi/EFI/refind/refind-theme-regular-black/theme.conf` as root/SuperUser.

### Installation [Manual]:

1. Clone git repository to your $HOME directory.
   ```
   git clone https://github.com/vnl6rj/refind-theme-regular-black.git
   ```

2. Remove unused directories and files.
   ```
   sudo rm -rf refind-theme-regular-black/{src,.git}
   ```
   ```
   sudo rm refind-theme-regular-black/install.sh
   ```

3. Locate refind directory under EFI partition. For most Linux based system is commonly `/boot/efi/EFI/refind/`. Copy theme directory to it.

   **Important:** Delete older installed versions of this theme before you proceed any further.

   ```
   sudo rm -rf /boot/efi/EFI/refind/{refind-theme-regular-black}
   ```
   ```
   sudo cp -r refind-theme-regular-black /boot/efi/EFI/refind/
   ```

4. To adjust icon and font size, edit `theme.conf`.
   ```
   sudo vi /boot/efi/EFI/refind/refind-theme-regular-black/theme.conf
   ```

5. To enable the theme add `include refind-theme-regular-black/theme.conf` at the end of `refind.conf`, and comment out or delete any other themes you might have installed.
   ```
   sudo vi /boot/efi/EFI/refind/refind.conf

   ```

**NOTE**: If your not geting your full resolution or have color issues then try disabling the CSM in your UEFI settings.

**More information**

[rEFInd](http://www.rodsbooks.com/refind/) The official rEFInd website
