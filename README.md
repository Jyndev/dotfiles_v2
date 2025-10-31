<h1 align="center">
  <br>
  <a href="https://www.tiktok.com/@jyndev"><img src="assets/logo/jynprofile.png"alt="JynDev" width="200"></a>
  <br>
  JynDev - Dotfiles 🐱
  <br>
</h1>

<p align="center">
  <i align="center">"No es solo un entorno, es tu reflejo. ¿Te animas a moldearlo? 🩵" - Jyn</i>
  <br>
  Mis redes sociales:
  <br>
  <a href="https://www.tiktok.com/@jyndev">
      <img src="https://img.shields.io/badge/TikTok-000000?style=for-the-badge&logo=tiktok&logoColor=white" /> 
   </a>
   <a href="https://discord.gg/Khkbk4FjsA">
        <img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" />  
   </a>
</p>

<img align="center" src="assets/gifs/demo.gif" alt="JynDev"></img>


<a href="#">
    <img src="assets/logo/rikka.png" alt="JynLogo logo" title="JynDev" align="right" height="40" />
</a>

# Dotfiles - Takanashi Version 🌠

Bienvenido a mi colección de **dotfiles** y configuraciones personalizadas para **Arch Linux** con **Hyprland**.
Este proyecto nació gracias al apoyo en mi cuenta de TikTok. ¡Gracias por hacerlo posible! 🩵

> ⚠️ **Nota:** Esta es una **versión inicial** y puede contener errores o limitaciones. Seguiré mejorándola con el tiempo.

> ⚠️ **Advertencia importante**  
> Estos **dotfiles** están basados en **mi configuración de trabajo personal**.  
> Pueden (y deben) ser modificados según tus necesidades y gustos.  
> Todas las decisiones aquí reflejan mis preferencias como creador, pero no son reglas absolutas.  
> ¡Siéntete libre de mejorarlos y adaptarlos a tu propio flujo de trabajo! 🚀



## 🛡️ Advertencia

No me hago responsable de posibles daños en tu sistema. **Lee y entiende cada paso antes de ejecutarlo.**

---

## 📋 Pre-requisitos

Antes de aplicar los dotfiles, asegúrate de:

* Tener Arch Linux instalado con **Hyprland** funcionando.
* Eliminar cualquier **gestor de notificaciones** previo (este repo incluye su propio daemon).
* Conocer lo básico de copiar/editar configuraciones en `~/.config`.

---

## ⚙️ Instalación paso a paso

### 1️⃣ Paquetes básicos

```bash
sudo pacman -S git zsh
```

Cambia la shell por defecto:

```bash
chsh -s /bin/zsh
```

Instala **yay (AUR helper):**

```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

🔄 Reinicia el sistema.

---

### 2️⃣ Configuración de la terminal

* Instalar **Oh My Zsh** :
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

* Instalar los plugins recomendados:
   ```bash
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   ```
    ```bash
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```
    ```bash
   git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
   ```

* Añadir los plugins recomendados en `~/.zshrc`
  ```zsh
  plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)
  ```

* Instalar **Powerlevel10k** para una terminal más atractiva.
  ```bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
   ```

   Abre `~/.zshrc`, busca la línea que define `ZSH_THEME` y cambia su valor a `"powerlevel10k/powerlevel10k"`.
---

### 3️⃣ Alias útiles (`~/.zshrc`)

```sh
alias install="sudo pacman -S"
alias aur_install="yay -S"
alias update="sudo pacman -Syu"
alias purge="sudo pacman -Rns"
```

---

### 4️⃣ Paquetes necesarios

**Pacman:**

```bash
install gnome-tweaks swww fastfetch rofi-wayland nemo cinnamon-translations \
waybar ttf-jetbrains-mono-nerd zenity bc eog gnome-system-monitor evince \
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ffmpeg ttf-nunito nemo-fileroller
```

**AUR:**

```bash
aur_install hyprshot visual-studio-code-bin mpvpaper eww matugen-bin ttf-fredoka-one hypr-dock
```

**Música:**

```bash
aur_install  youtube-music
```

---

### 5️⃣ Temas y personalización

* 🏙️ **Iconos:** `Magna-Dark-Icons`
* 🖍️ **Tema GTK:** `Lavanda-gtk-theme`
* 🗚 **Fuente principal:** `Fredoka`
* 🖱️ **Cursor:** `Anya-cursor-v3`

Fuentes adicionales (Japonés + Emoji):

```bash
install noto-fonts-cjk noto-fonts-emoji noto-fonts
```

---

### 6️⃣ Pasos finales

1. Copia los archivos de `.config` al directorio `~/.config`.
2. Crea las carpetas necesarias en `~/.cache/`:

   ```
   ~/.cache/hyprlock
   ~/.cache/albumart
   ~/.cache/liveWallpaper
   ```

---

## 🚀 Primer arranque

Inicializa los colores de **matugen** para evitar errores:

```bash
matugen image "ruta_a_la_imagen"
```

---

## 🔒 Tema SDDM

> ⚠️ **Nota:** Todos los creditos y derechos a su respectivo autor: https://github.com/3d3f/ii-sddm-theme

> Dependencias de `sddmii-sddm-theme`:

```bash
aur_install --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg otf-space-grotesk ttf-gabarito-git ttf-material-symbols-variable-git ttf-readex-pro ttf-rubik-vf
```

1. Copiar los archivos de `sddmii-sddm-theme` al directorio `/usr/share/sddm/themes/`

```bash
   sudo cp -r sddmii-sddm-theme /usr/share/sddm/themes/
   ```

2. Otorga permisos:

   ```bash
   sudo chmod 777 /usr/local/etc
   ```

3. Crea directorio y enlaces simbólico:
 ```bash
   mkdir -p /usr/local/etc/sddm
   ```

   ```bash
   sudo ln -s /usr/local/etc/sddm/sddm_background \
       /usr/share/sddm/themes/ii-sddm-theme/Backgrounds/background
   ```

   ```bash
   sudo ln -s /usr/local/etc/sddm/sddm_config_colors \
    /usr/share/sddm/themes/ii-sddm-theme/Components/Colors.qml
   ```

5. Ejecuta el script de cambio de fondo.

---

## 🌎 Configuración de aplicaciones Wayland

Agrega estas opciones a los lanzadores:

```bash
google-chrome-stable --ozone-platform=wayland
code --enable-features=WaylandWindowDecorations --ozone-platform=wayland
```

---

✅ ¡Listo! Tu sistema ahora debería estar **completamente personalizado** con los dotfiles 🚀