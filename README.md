# InfluenceRegion

**InfluenceRegion Addon for Godot ⚡📍**  
A lightweight and efficient Godot addon that introduces a custom **InfluenceRegion** node to calculate position-based magnitudes within triangle or circular shapes. Ideal for fast, customizable 3D influence zones that can act as performance-friendly alternatives to `Area3D`. 🧭💨

---

# ✨ Features:

✔️ **New Node Type: InfluenceRegion** – Drop-in node with visual and runtime behavior to determine influence strength based on position.

✔️ **Supports Two Shapes:**  
- 🔺 **Triangle** – Define a triangle influence area customisable sides size.
- ⚪ **Circle** – Define a radial area with customizable radius.
- <img src="https://github.com/user-attachments/assets/3e00417f-4973-474e-bff4-3630b6d5e383" width="200"> <img src="https://github.com/user-attachments/assets/3edfeff3-1b41-4fae-a39a-191256152336" width="200">

✔️ **Regions direction and spacing customisable**
![image](https://github.com/user-attachments/assets/f208f3f8-420f-4989-be03-908670ba765c)
![image](https://github.com/user-attachments/assets/e7403d11-6ac0-4bab-80d0-5ecc85f07764)
![image](https://github.com/user-attachments/assets/7fc8a3c7-5fbb-41c5-9b85-6d52c0ba2483)
![image](https://github.com/user-attachments/assets/e23b7fbd-ba18-4660-b42e-1850f0872035)





✔️ **Use in High-Performance Environments** – Great for crowd simulations, particle control, field effects, and any system where full `Area3D` or collision-based nodes would be too heavy.

✔️ **Customizable Falloff Behavior** – Modify attenuation curves and influence strength directly in the editor.

✔️ **Gizmo Visualization in Editor** – See the shape and extent of your influence region in real time.

✔️ **Tool-Script Ready** – Fully functional in-editor for previews and live tuning.

---

# 📦 Installation

1. **Download the Addon:** Clone or download this repository.
2. **Move the Folder:** Place the `InfluenceRegion` folder inside your `res://addons/` directory.
3. **Enable the Plugin:**

    Open **Godot Editor**  
    → Go to `Project > Project Settings > Plugins`  
    → Enable **InfluenceRegion Addon**

**Note:** Make sure the folder name and script paths remain unchanged.

---

# 🛠️ Usage Guide

## Adding an InfluenceRegion Node

1. Add a new **InfluenceRegion** node to your scene.
2. Choose the **Region Type** in the inspector: `"Circle"` or `"Triangle"`.
3. Adjust shape-specific parameters:

   - **For Circle:**
     - `radius` → Maximum radius of influence.
     - `falloff_curve` → Curve to control the intensity falloff from center to edge.

   - **For Triangle:**
     - `point_a`, `point_b`, `point_c` → Define the triangle's vertices in 3D space.
     - `falloff_mode` → Linear, exponential, or custom falloff.

4. Use the main API method to query influence magnitude from any position.

### Example usage:

```gdscript
var influence = $InfluenceRegion.get_influence_at_position(global_position)
```

Returns a value between `0.0` (outside influence) and `1.0` (full influence).

## 🔍 Example Use Cases

- AI agents reacting to attraction/repulsion zones  
- Lightweight triggers for particle or VFX systems  
- Controlling audio reverb zones  
- Custom gameplay mechanics (e.g., stealth, aura, buff zones)

---

# 📐 Parameters & Inspector

| Property            | Type     | Description                                  |
|---------------------|----------|----------------------------------------------|
| `region_type`       | Enum     | `"Circle"` or `"Triangle"`                   |
| `radius`            | Float    | (Circle) Defines max reach                   |
| `point_a/b/c`       | Vector3  | (Triangle) Triangle corners in 3D space      |
| `falloff_curve`     | Curve    | (Circle) Controls how influence fades        |
| `falloff_mode`      | Enum     | (Triangle) Choose `Linear`, `SmoothStep`, etc.|

---

# 🚀 Performance Note

InfluenceRegion avoids collision checks or physics bodies, and is optimized for direct computation. For performance-demanding systems with hundreds of agents or influence fields, this addon offers a **significant performance gain** over standard `Area3D` nodes.

---

# 🧪 Example Scene

An example scene (`InfluenceRegion_Demo.tscn`) is included to showcase basic usage of both **Triangle** and **Circle** modes with debug UI and interactive input.

---

# 📝 License

This project is licensed under the **MIT License**.  
Free to use, modify, distribute, even commercially. Attribution is appreciated but not required.

---

# 🌟 Support

Need help or want to suggest improvements?  
Feel free to open an issue or reach out — I’d love to hear how you use **InfluenceRegion** in your project!

---

Would you like me to generate example demo images or code snippets to go with this?
