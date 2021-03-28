## CANopen Node for NIOT-E-NPIX-RCAN

Made for [netPI](https://www.netiot.com/netpi/), the Raspberry Pi 3B architecture based industrial suited Open Edge Connectivity Ecosystem

### Docker repository

https://hub.docker.com/r/hilschernetpi/netpi-canopennode-npix-rcan/

### Debian with CANopen Node example for NIOT-E-NPIX-RCAN expansion module, SSH server and user root

The image provided hereunder deploys a container with installed open source CANopen Node protocol stack plus SocketCAN userspace utilities and tools. The example comes precompiled and is ready to run.

Base of this image builds [debian](https://www.balena.io/docs/reference/base-images/base-images/) with enabled [SSH](https://en.wikipedia.org/wiki/Secure_Shell), created user 'root' and precompiled package [CANopenSocket](https://github.com/CANopenNode/CANopenSocket) including a CANopen Node example and installed [can-utils](https://github.com/linux-can/can-utils). A [SocketCAN](https://en.wikipedia.org/wiki/SocketCAN) interface provides the communication channel to the module NIOT-E-NPIX-RCAN. Additional information about programming SocketCAN can be received [here](https://www.can-cia.org/fileadmin/resources/documents/proceedings/2012_kleine-budde.pdf). netPI's host Linux automatically generates a SocketCAN interface named `can0` once a NIOT-E-NPIX-RCAN module was found inserted in the NPIX expansion slot during boot process.

The NIOT-E-NPIX-RCAN module provides two duo LEDs(red/green) that can be freely used. The LED `COM0` is connected to GPIOs 22(green) and 23(red). The LED `COM1` is connected to GPIO 25(green) and 26(red).

#### License

The software includes a third party software from the Github repository [CANopenSocket](https://github.com/CANopenNode/CANopenSocket) which is distributed in accordance with [GNU General Public License v2.0](http://www.gnu.org).

#### Container prerequisites

##### Host network

The container needs to be operated in host networking mode to share all host Linux network interfaces with the container.

Hint: In host networking mode all container ports (e.g. 22 for SSH) are automatically exposed to the host. Explicit port mapping can be omitted.

##### Privileged mode

Only the privileged mode option lifts the enforced container limitations to allow usage of SocketCAN generated interfaces and GPIOs in a container.

#### Getting started

STEP 1. Open netPI's website in your browser (https).

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under *Containers > + Add Container*

Parameter | Value | Remark
:---------|:------ |:------
*Image* | **hilschernetpi/netpi-canopennode-npix-rcan**
*Network > Network* | **Host**
*Adv.con.set. | Restart policy* | **always**
*Adv.con.set. | Runt. & Res. > Privileged mode* | **On** |

STEP 4. Press the button *Actions > Start/Deploy container*

Pulling the image may take a while (5-10mins). Sometimes it may take too long and a time out is indicated. In this case repeat STEP 4.

#### Accessing

The container starts the SSH server automatically. Open a terminal connection to it with an SSH client such as [putty](http://www.putty.org/) using netPI's IP address at port `22`.

Use the credentials `root` as user and `root` as password when asked and you are logged in as root user `root`.

STEP 1: Use a command like `ip link set can0 type can bitrate 1000000 triple-sampling on` to set the CAN controller's baudrate to e.g. 1MBaud.

STEP 2: Bring the `can0` interface up with `ip link set can0 up`.

STEP 3: Move to the CANopen Node example folder `cd CANopenSocket/canopend`

STEP 4: Run the CANopen Node example with `./app/canopend can0 -i 4 -s od4_storage -a od4_storage_auto` at Node-ID 4.

STEP 5: Import sample EDS file from repository folder `\EDS` in your CANopen master engineering software.

STEP 6: Along with the EDS file configure a node at Node-ID 4 in your CANopen Master and run it.

STEP 7: Create a GPIO to control an LED: `echo 22 > /sys/class/gpio/export`. Set this GPIO to type output `echo out > /sys/class/gpio/gpio22/direction`. Switch the LED ON `echo 0 > /sys/class/gpio/gpio11/value`,  Switch the LED OFF `echo 1 > /sys/class/gpio/gpio11/value`.

#### Automated build

The project complies with the scripting based [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build the image output file. Using this method is a precondition for an [automated](https://docs.docker.com/docker-hub/builds/) web based build process on DockerHub platform.

DockerHub web platform is x86 CPU based, but an ARM CPU coded output file is needed for Raspberry systems. This is why the Dockerfile includes the [balena](https://balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/) steps.

#### License

Copyright (c) Hilscher Gesellschaft fuer Systemautomation mbH. All rights reserved.
Licensed under the LISENSE.txt file information stored in the project's source code repository.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
