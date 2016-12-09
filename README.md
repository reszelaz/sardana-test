# sardana-test

[Docker](http://www.docker.com) image configuration for testing [Sardana](http://www.sardna-controls.org).

It is based on a [Debian](http://www.debian.org) stable and it provides the following infrastructure for installing and testing Sardana:

* sardana dependencies and recommended packages (PyTango & itango, taurus, ipython, ...)
* A Tango DB configured and running
* sardana demo environment: Pool and MacroServer populated with sar_demo and some basic MacroServer environment variables

The primary use of this Docker image is to use it in our [Continuous Integration workflow](https://travis-ci.org/sardana-org/sardana).

But you may also run it on your own machine:

~~~~
docker run -d --name=sardana-test -h sardana-test reszelaz/sardana-test
~~~~

... or, if you want to launch GUI apps from the container and do **not mind about X security**:

~~~~
xhost +local:
docker run -d --name=sardana-test -h sardana-test -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix reszelaz/sardana-test
~~~~

Then you can log into the container with:

~~~~
docker exec -it sardana-test bash
~~~~

Note: this image does not contain sardana itself (since it is designed for installing development versions of sardana) but you can install it easilly using any of the following examples in your container (for more details, see http://www.sardana-controls.org/users/getting_started.html).:

- Example 1: installing sardana from the official debian repo:

~~~~
apt-get install python-sardana -y
~~~~

- Example 2: installing the latest develop version from the git repo (you may use any other branch instead of develop):

~~~~
git clone -b develop https://github.com/sardana-org/sardana.git
cd sardana
python setup.py install
~~~~

- Example 3: using pip to do the same as in example 2:

~~~~
apt-get install python-pip -y
pip install git+https://github.com/sardana-org/sardana.git@develop
~~~~
