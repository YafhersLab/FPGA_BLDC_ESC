# ⚙️ BLDC Motor Driver (ESC) – Custom FPGA Shield (Artix-7)

## 📌 Project Overview
This project consists of the design and development of a **custom BLDC motor driver (Electronic Speed Controller, ESC)** implemented as a **hardware shield for the Avanxe 7 FPGA board**, based on an **Artix-7 FPGA**.

The main objective was to control **BLDC thruster motors for an ROV** directly from an FPGA.  
For this purpose, a **BLDC power PCB was designed from scratch**, and all motor control logic was implemented in **VHDL**, demonstrating a complete hardware–software co-design workflow.

This project showcases skills in:
- FPGA-based motor control  
- Power electronics  
- Digital design with VHDL  
- Control system integration and simulation  

---

## 🎯 Motivation
Traditional BLDC motor control is commonly handled by microcontrollers or DSPs.  
In this project, the goal was to explore **FPGA-based BLDC control**, leveraging parallelism and deterministic timing to achieve precise switching and control of power MOSFETs for ROV propulsion systems.

---

## 🧠 System Description
- The FPGA generates commutation and control signals using **VHDL**
- MOSFETs are driven directly from the FPGA logic
- Motor behavior is validated using **MATLAB simulations**
- A **LabVIEW interface** is used for high-level control and monitoring

---

## 🧩 Project Structure

1. **code/**  
   VHDL source files and Vivado project used to implement the BLDC motor control logic on the FPGA.

2. **documentation/**  
   Technical documentation, design notes, and analysis related to the project.

3. **labview/**  
   NI LabVIEW files used for the control interface, monitoring, and user interaction.

4. **matlab/**  
   MATLAB models and simulations for validating control strategies and motor behavior.

5. **schematic/**  
   Electrical schematics of the custom-designed BLDC ESC PCB.
   
---

## 🛠️ Hardware Used
- **FPGA Board:** Avanxe 7 (Artix-7) by Intesc  
- **Custom Hardware:**  
  - Custom-designed BLDC ESC PCB  
  - Power MOSFETs for three-phase motor driving  
  - Gate driver and power stage components  

---

## 💻 Software & Tools
- **VHDL** – Motor control and commutation logic  
- **Vivado** – FPGA design, synthesis, and implementation  
- **MATLAB** – Control modeling and simulation  
- **NI LabVIEW** – User interface and system control  

---

## 🚧 Project Status
**Experimental**

This project is currently in an experimental and exploratory stage.  
Further improvements may include:
- Closed-loop control (current / speed feedback)
- Improved protection circuits
- Optimization of commutation algorithms

---

## 📚 Future Work
- Sensor-based or sensorless BLDC control
- ROV-specific thrust control algorithms
- Integration with additional FPGA-based peripherals
- Thermal and efficiency optimization

---

## 📄 License
This project is intended for **educational and research purposes**.  
License to be defined.

---

## ✍️ Author
**Yafhers Mendoza**  
Custom FPGA & Power Electronics Design