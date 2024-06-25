# Summary

* [Introduction](README.md)
* [Glossary](glossary.md)
* [Safety tips](safety.md)
* [Assembly](assembly.md)
  * [Clover 4.2 assembly](assemble_4_2.md)
  * [Clover 4.2 WorldSkills](assemble_4_2_ws.md)
  * [Clover 4 assembly](assemble_4.md)
  * [Clover 3 assembly](assemble_3.md)
  * [Clover 2 assembly](assemble_2.md)
* [Configuration](setup.md)
  * [Sensor calibration](calibration.md)
  * [RC setup](radio.md)
    * [Using FS-A8S](rc_flysky_a8s.md)
  * [Flight modes](modes.md)
  * [Power setup](power.md)
  * [Failsafe configuration](failsafe.md)
* [Manual flight](flight.md)
  * [Basics](flight.md)
  * [Exercises](flight_exercises.md)
* [Working with Raspberry Pi](raspberry.md)
  * [RPi Image](image.md)
  * [Wi-Fi connection](wifi.md)
  * [Connection to the Pixracer](connection.md)
  * [Using QGroundControl over Wi-Fi](gcs_bridge.md)
  * [Remote shell](ssh.md)
  * [Command line interface](cli.md)
  * [Automated self-checks](selfcheck.md)
  * [Viewing images from cameras](web_video_server.md)
* [Programming](programming.md)
  * [Camera setup](camera_setup.md)
  * [Fiducial markers (ArUco)](aruco.md)
    * [Marker detection](aruco_marker.md)
    * [Map-based navigation](aruco_map.md)
  * [Optical Flow](optical_flow.md)
  * [Autonomous flight (OFFBOARD)](simple_offboard.md)
  * [Coordinate systems (frames)](frames.md)
  * [Code examples](snippets.md)
  * [Interfacing with a laser rangefinder](laser.md)
  * [LED strip](leds.md)
  * [Working with GPIO](gpio.md)
  * [Interfacing with a sonar](sonar.md)
  * [Computer vision basics](camera.md)
  * [Using rviz and rqt](rviz.md)
  * [Software autorun](autolaunch.md)
  * [Using JavaScript](javascript.md)
  * [Blocks programming](blocks.md)
  * [Simulation](simulation.md)
    * [Native setup](simulation_native.md)
    * [VM setup](simulation_vm.md)
    * [Usage](simulation_usage.md)
    * [Setup on M1 computers](simulation_m1.md)
  * [ROS](ros.md)
  * [MAVROS](mavros.md)
* [Supplementary materials](supplementary.md)
  * [COEX Pix](coex_pix.md)
  * [COEX PDB](coex_pdb.md)
  * [COEX GPS](coex_gps.md)
  * [Using SSH keys](ssh_keys.md)
  * [Guide on autonomous flight](auto_setup.md)
  * [Hostname](hostname.md)
  * [PX4 Simulation](sitl.md)
  * [Navigation using vertical ArUco-markers](wall_aruco.md)
  * [PID Setup](calibratePID.md)
  * [Model files for parts](models.md)
  * [ROS Melodic installation](ros-install.md)
  * [Camera calibration](camera_calibration.md)
  * [VPN ZeroTier Connection](zerotier_vpn.md)
  * [Quadcopter control with 4G communication](4g.md)
  * [Clover and Jetson Nano](jetson_nano.md)
  * [Remote control app](rc.md)
  * [Wi-Fi Configuration](network.md)
  * [UART settings](uart.md)
  * [PX4 Parameters](parameters.md)
  * [PX4 Logs and Topics](flight_logs.md)
  * [PX4 Firmware](firmware.md)
  * [MAVLink](mavlink.md)
  * [Multimeter usage](test_connection.md)
  * [RC Troubleshooting](radioerrors.md)
  * [Flashing ESCs](esc_firmware.md)
  * [Interfacing with Arduino](arduino.md)
  * [Connecting GPS](gps.md)
  * [Working with IR sensors](ir_sensors.md)
  * [FPV Setup](fpv_clover_4_2.md)
  * [FPV Setup (Clover 3)](fpv.md)
  * [Magnetic grip](magnetic_grip.md)
  * [Mechanical grip](mechanical_grip.md)
  * [Trainer mode](trainer_mode.md)
  * [Tinning](tinning.md)
  * [Types of power connectors](connectortypes.md)
  * [Connecting 4 in 1 ESCs](4in1.md)
  * [Soldering safety](tb.md)
  * [LED strip (legacy)](leds_old.md)
  * [Contribution Guidelines](contributing.md)
  * [COEX packages repository](packages.md)
  * [Migration to v0.20](migrate20.md)
  * [Migration to v0.22](migrate22.md)
* [Events](events.md)
  * [CopterHack-2023](copterhack2023.md)
  * [CopterHack-2022](copterhack2022.md)
  * [CopterHack-2021](copterhack2021.md)
  * [CopterHack-2019](copterhack2019.md)
  * [CopterHack-2018](copterhack2018.md)
  * [CopterHack-2017](copterhack2017.md)
  * [Video contest](video_contest.md)
  * [Educational contests](educational_contests.md)
* [Clover-based projects](projects.md)
  * [Clover Cloud Platform](clover-cloud-platform.md)
  * [Autonomous Racing Drone](djs_phoenix_chetak.md)
  * [Motion Capture System](mocap_clover.md)
  * [Swarm in Blocks 2](swarm_in_blocks_2.md)
  * [Advanced Clover 2](advanced_clover_simulator_platform.md)
  * [Network of charging stations](liceu128.md)
  * [Swarm-in-blocks](swarm_in_blocks.md)
  * [Obstacle avoidance using artificial potential fields method](obstacle-avoidance-potential-fields.md)
  * [The Clover Rescue Project](clover-rescue-team.md)
  * [CopterCat CM4](copter_cat.md)
  * [Autonomous valet parking drone assistance](djs_phoenix_ikshana.md)
  * [Autonomous Multirotor Landing System (AMLS)](amls.md)
  * [Drone show](clever-show.md)
  * [Innopolis Open 2020 (L22_ÆRO)](innopolis_open_L22_AERO.md)
  * [Copter spheric guard](shield.md)
  * [Face recognition system](face_recognition.md)
  * [Android RC app](android.md)
  * [3D-scanning drone](3dscan.md)
  * [Human pose estimation drone control](human_pose_estimation_drone_control.md)
  * [Robocross-2019](robocross2019.md)
  * [Camera calibration (legacy)](camera_calib.md)
  * [Recognition of crop types in agriculture](agriculture.md)
  * [Drones to fight Coronavirus](anticorona_drones.md)
  * [D-drone Copter Hack 2021 by AT Makers](ddrone.md)
  * [3D-printed Generative Design Frame](generative_design_frame.md)
  * [Retail Drone](bennie.md)
  * [The Indoor Mapping Drone](dromap.md)
  * [Seeding Drone](seeding_drone.md)
  * [Blue Jay Eindhoven](blue_jay_eindhoven.md)