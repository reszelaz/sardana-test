# sardana-test docker image

[Docker](http://www.docker.com) image configuration for testing [Sardana](http://www.sardna-controls.org) but not only...

It is based on a [Debian](http://www.debian.org) stable and it provides the following infrastructure for installing and testing Sardana:

* sardana dependencies and recommended packages (PyTango & itango, taurus, ipython, ...)
* a Tango DB configured and running
* sardana demo environment: Pool and MacroServer populated with the sar_demo macro and some basic MacroServer environment variables

The primary use of this Docker image is to use it in our [Continuous Integration workflow](https://travis-ci.org/sardana-org/sardana).

But you may also run it on your own machine to simply try sardana or even use it as an execution environment if you plan to develop sardana project.
Before continuing, answer yourself which would be your use case, cause the way you create the container differs and there is no way to change between them other than recreating the container from scratch.

## How to try sardana using this image

To run the container on your host simply execute:

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

Note: this image does not contain sardana itself (since it is designed for installing development versions of sardana) but you can install it easilly using any of the following examples in your container (for more details, see http://www.sardana-controls.org/users/getting_started/index.html).:

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
pip install git+https://github.com/sardana-org/sardana.git@develop
~~~~

## How to develop sardana using this image

This image may be also involved in the development process, for example to execute inside of the container the code under development on the host machine.
In order to make the code available within the container it must be mounted as a volume on the container instantiation (this example uses `/sardana` directory as the mounting point, but it may be any other directory):

~~~~
docker run -d --name=sardana-test -h sardana-test -v <path-to-sardana-code-on-host-machine>:/sardana reszelaz/sardana-test
~~~~

Afterward the sardana should be installed in the develop mode:

~~~~
docker exec sardana-test bash -c "cd /sardana && python setup.py develop"
~~~~

## Start the Sardana system

Regardless of the option that you had chosen for the Sardana installation (simply try Sardana or prepare a development environment) now is the time to start your Sardana system. The Sardana architecture used in this examples assumes Pool and MacroServer as separate servers, but remember that you can [run Sardana as a single server](https://sardana-controls.org/users/getting_started/running_server.html#running-sardana-as-a-tango-server) as well!

You can run the servers using supervisor (it will run them in background and exit):
~~~~
docker exec sardana-test supervisorctl start Pool
docker exec sardana-test supervisorctl start MacroServer
~~~~

Or if you are interested in keeping the processes in foreground, for example to see their stdout or stderr:
~~~~
docker exec sardana-test Pool demo1
docker exec sardana-test MacroServer demo1
~~~~

Right after that it is possible to run any sardana client applications within the container e.g. spock or macroexecutor - see running GUI applications section above:
~~~~
docker exec -it sardana-test bash # start spock inside of this bash session
docker exec sardana-test macroexecutor
~~~~
or any other...
