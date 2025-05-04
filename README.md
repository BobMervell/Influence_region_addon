# InfluenceRegion

**InfluenceRegion Addon for Godot ⚡📍**  
A lightweight and efficient Godot addon that introduces a custom **InfluenceRegion** node to calculate position-based magnitudes within triangle or circular shapes. Ideal for fast, customizable 3D influence zones that can act as performance-friendly alternatives to `Area3D`. 🧭💨

---

# ✨ Features:

✔️ **New Node Type: InfluenceRegion** – Drop-in node with visual and runtime behavior to determine influence strength based on position.

✔️ **Use in High-Performance Environments** – Great for crowd simulations, particle control, field effects, and any system where full `Area3D` or collision-based nodes would be too heavy.

✔️ **Tool-Script Ready** – Fully functional in-editor for previews and live tuning.

✔️ **Supports Two Shapes:**  
- 🔺 **Triangle** – Define a triangle influence area customisable sides size.
- ⚪ **Circle** – Define a radial area with customizable radius.
- <img src="https://github.com/user-attachments/assets/3e00417f-4973-474e-bff4-3630b6d5e383" width="200"> <img src="https://github.com/user-attachments/assets/3edfeff3-1b41-4fae-a39a-191256152336" width="200">

✔️ **Regions direction and spacing customisable**

- The plugin gives the possibility to change how the sub-regions are arranged relative to each other
- <img src="https://github.com/user-attachments/assets/f208f3f8-420f-4989-be03-908670ba765c" width="300">
- <img src="https://github.com/user-attachments/assets/e7403d11-6ac0-4bab-80d0-5ecc85f07764" width="300">
- <img src="https://github.com/user-attachments/assets/7fc8a3c7-5fbb-41c5-9b85-6d52c0ba2483" width="300">
- <img src="https://github.com/user-attachments/assets/e23b7fbd-ba18-4660-b42e-1850f0872035" width="300">

✔️ **Customizable Behavior**
– Modify the magnitude variation behavior and the number of sub-regions.
- **Note:** A higher number of sub-regions induce a higher performance impact.

- <img src="https://github.com/user-attachments/assets/9548241d-c600-4b3d-8bc8-32b70f4ffcf1" width="200">
- <img src="https://github.com/user-attachments/assets/faf93707-6962-4c1e-bc3d-088f9174e509" width="200">
- <img src="https://github.com/user-attachments/assets/5b66b69f-22ee-4e87-b706-fcbed35de19e" width="200">

---

# 📦 Installation

1. **Download the Addon:** Clone or download this repository.
2. **Move the Folder:** Place the `InfluenceRegion` folder inside your `res://addons/` directory.
3. **Enable the Plugin:**

    Open **Godot Editor**  
    → Go to `Project > Project Settings > Plugins`  
    → Enable **InfluenceRegion**

**Note:** Make sure the folder name and script paths remain unchanged.

---

# 🛠️ Usage Guide

## Adding an InfluenceRegion Node

1. Add a new **InfluenceRegion** node to your scene.
2. Choose the **Region Type** in the inspector: `"Circle"` or `"Triangle"`.
3. Adjust shape-specific parameters:

   - **For Circle:**
     - `radius` → Maximum radius of influence.

   - **For Triangle:**
     - Define the triangle's sides lengths.

4. Call the dedicated function to query influence magnitude from any position.
```
   func get_distance_magnitude(pos:Vector3) -> float:
```

## 🔍 Example Use Cases

- AI agents reacting to attraction/repulsion zones  
- Lightweight triggers for particle or VFX systems  
- Controlling audio reverb zones  
- Custom gameplay mechanics (e.g., stealth, aura, buff zones)
- Area of effect spells
- Temperature diffusions simulation


# 🚀 Performance Note

- InfluenceRegion avoids collision checks or physics bodies, and is optimized for direct computation. For performance-demanding systems with hundreds of agents or influence fields, this addon trades complex behavior capacities with performance oriented detection over standard `Area3D` nodes.
- However it is important to mention the performance impacting variables:
  - Circles are the least impacting shapes, and for polygons, the more sides, the more impacting.
  - A binary solver is available and is faster than the sequential (default), however it is not reliable when the sub-regions overlap each others (you need to try if it works for each use case).
  - A larger number of sub-regions impacts heavily the performances.


# 📝 License

This project is licensed under the **MIT License**.  
Free to use, modify, distribute, even commercially. Attribution is appreciated but not required.

---

# 🌟 Support

Need help or want to suggest improvements?  
Feel free to open an issue or reach out.

