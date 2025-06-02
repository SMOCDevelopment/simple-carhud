# 🚗 Smoc-Simple-Carhud

A lightweight and standalone-friendly car HUD for FiveM, originally made back in 2024. One of my first 5 scripts ever—now back and re-released!

> 🛠️ SMOC was my personal development label back then—I'm reopening it and bringing back some of the OG scripts, polished and updated.


![Preview](https://media.discordapp.net/attachments/1376026259594940576/1378901214380425316/image.png?ex=683e4954&is=683cf7d4&hm=2e92db2a9f2ccc4e1ca7a9f8b46cb5a3a67a187e22fac7b1aecb3724c71ae4a2&=&format=webp&quality=lossless)

## ✨ Features

- 📍 Displays **Plate** and **VIN** above the minimap
- 🎲 VIN is randomly chosen from a `vin.json` file—great for RP!
- ⛽ Simple fuel gauge with color feedback
- 🧭 Speedometer that supports both **MPH** and **KMH** (configure in `client.lua`)

## 📁 Files

- `client.lua`: Main HUD logic
- `vin.json`: List of possible VINs to randomly assign -- By default, it has 100 listed 6 digit VINs 
- `fxmanifest.lua`: Resource manifest

> ⚠️ If `vin.json` is missing, VINs will default to `UNKNOWN`.

## 🛠️ To-Do (Maybe You?)

I used to have a script that let players "3rd-eye" a vehicle and read its VIN. Can’t find it anymore—might recreate it later!

But if **you** want to make something cooler, cleaner, or re-add that feature…

## 💡 Fork It!

Go ahead! Build your version—cleaner UI, better logic, more features.  
If you do, I’ll proudly post it on my **Discord** and **GitHub**, with **full credit** to you. 🙌

## 📦 Installation

1. Drop the folder into your server's `resources`
2. Add `ensure Smoc-Carhud` to your `server.cfg`
3. Optional: Customize `vin.json` with your own VIN entries

---
SMOC DISCORD - https://discord.gg/pHsTfwAXbF
