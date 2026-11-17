# MY HYPRLAND RICE
This rice uses configs from many repos, so it's not 100% pure my creation

La configuración base viene de [binnewbs/arch-hyprland](https://github.com/binnewbs/arch-hyprland); este repositorio añade un instalador para Arch/CachyOS, ajustes de rendimiento para VirtualBox y botones de Waybar para abrir aplicaciones, Kitty y el selector de fondos.

I use Matugen as the color scheme generator, so this dotfiles will work better with Matugen as you don't have to reconfigure every colors in the config file

As for the wallpaper, i use swww. The wallpaper picker script that i made uses swww combined with Matugen, so you need to tweak the script a bit to work with your own system if you use a different wallpaper backend

Special credit to [JaKooLit](https://github.com/JaKooLit), i used some of his scripts and waybar settings

## Instalación rápida en CachyOS / Arch Linux

El instalador instala los programas desde los repositorios configurados de pacman, crea enlaces a estos dotfiles y guarda cualquier configuración previa en `~/.local/state/arch-hyprland-backups/`. Para volver atrás, restaura desde esa carpeta.

Hyprland 0.57 ya no carga los archivos antiguos `hyprland.conf`; este repositorio incluye una configuración Lua para esa versión y siguientes. En una VM desactiva blur, sombras y animaciones, y activa el planificador de renderizado pensado para equipos con menos recursos. En hardware real conserva un blur ligero y animaciones cortas.

```sh
git clone https://github.com/leonardo236/arch-hyprland.git ~/arch-hyprland
cd ~/arch-hyprland
./install.sh
```

No crea otra cuenta: utiliza tu usuario actual y te pedirá su contraseña de sudo para instalar los paquetes. Pacman puede actualizar el sistema como parte de -Syu; revisa y confirma su lista normal de cambios. Después, cierra la sesión, elige Hyprland en el selector de sesiones e inicia sesión. Mantén el clon del repositorio en su sitio: los archivos de configuración se enlazan directamente a esa carpeta.

## Atajos

| Atajo | Acción |
| --- | --- |
| `Super` + `Enter` | Abrir Kitty (terminal) |
| `Super` + `Shift` + `C` | Abrir Cava en Kitty |
| `Super` + `D` | Abrir el menú de aplicaciones |
| `Super` + `E` | Abrir archivos |
| `Super` + `W` | Elegir wallpaper y actualizar colores con Matugen |
| `Super` + `L` | Bloquear la sesión |
| `Super` + `Q` | Cerrar la ventana activa |

Cava muestra el sonido que está reproduciendo el sistema. Si abre pero no aparecen barras, reproduce música y comprueba que PipeWire tenga una salida de audio activa. En VirtualBox también debe estar habilitada la salida de audio de la VM; el sonido no se activa por instalar Cava.

Waybar también muestra botones para abrir el menú de aplicaciones, Kitty y el selector de fondos con el ratón.

## Rendimiento en una VM

La VM necesita compartir memoria y procesador con el sistema anfitrión, y su adaptador gráfico virtual limita los efectos disponibles. Para probar este rice, asigna 4 GB de RAM y 4 CPU virtuales; deja memoria libre para Windows y evita ejecutar otras aplicaciones pesadas al mismo tiempo. El perfil detecta VirtualBox y desactiva automáticamente los efectos más costosos.

Los fondos de pantalla están dentro de `wallpapers/`. El selector muestra una lista simple, sin generar miniaturas grandes, y admite los servicios `awww` y `swww`.

<img width="1920" height="1080" alt="20250720_22h08m02s_grim" src="https://github.com/user-attachments/assets/cdfc60a8-9241-4633-bc23-8d80ebe9f862" />

<img width="1920" height="1080" alt="20250720_22h10m55s_grim" src="https://github.com/user-attachments/assets/66696b8b-d479-4884-b10b-1920ae8b21a2" />


