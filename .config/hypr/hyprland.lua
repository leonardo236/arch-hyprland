-- Lua configuration for Hyprland 0.55+ (required by Hyprland 0.57).
-- Keep VirtualBox effects off; preserve a lighter blur/animation profile on hardware.

local function detect_vm()
    local pipe = io.popen("systemd-detect-virt --vm 2>/dev/null")
    if not pipe then return false end
    local result = pipe:read("*l")
    pipe:close()
    return result ~= nil and result ~= ""
end

local is_vm = detect_vm()
local terminal = "kitty"
local script_dir = (os.getenv("HOME") or "") .. "/.config/hypr/scripts/"

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = "rgba(86d1e9ff)",
            inactive_border = "rgba(40484bff)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 8,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 0.94,
        shadow = { enabled = not is_vm },
        blur = {
            enabled = not is_vm,
            size = 3,
            passes = 1,
            new_optimizations = true,
            vibrancy = 0.12,
        },
    },
    animations = { enabled = not is_vm },
    dwindle = { pseudotile = true, preserve_split = true },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",
        touchpad = { natural_scroll = true },
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
    render = { new_render_scheduling = is_vm },
})

if not is_vm then
    hl.animation({ leaf = "global", enabled = true, speed = 8, bezier = "default" })
end

hl.window_rule({
    name = "floating-terminal",
    match = { class = "^kitty$", title = "^floating-terminal$" },
    float = true,
    size = "800 550",
    center = true,
})

hl.on("hyprland.start", function()
    hl.exec_cmd(script_dir .. "startup.sh")
end)

-- Main applications
hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("kitty --title floating-terminal"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("kitty --title Cava -e cava"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + W", hl.dsp.exec_cmd(script_dir .. "wppicker.sh"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(script_dir .. "screenshot.sh"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("kitty yazi"))
hl.bind("SUPER + R", hl.dsp.exec_cmd(script_dir .. "wbrestart.sh"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("xdg-open https://"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + H", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))

hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
for i = 1, 10 do
    local key = i % 10
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
