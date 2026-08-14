Stechec2
========

.. image:: https://travis-ci.org/prologin/stechec2.svg?branch=master
    :target: https://travis-ci.org/prologin/stechec2

What is Stechec2
----------------

Stechec2 is a client-server turn-based strategy game match maker used during the
French national computing contest. It is a complete rewrite of Stechec to
achieve a simpler architecture.

Copying
-------

Free use of this software is granted under the terms of the GNU General Public
License version 2 (GPLv2). For details see the files `COPYING` included with
the Stechec2 distribution.

Requirements
------------

* cmake >= 3.23
* gcc >= 4.7 (or clang)
* zeromq
* zeromq C++ wrapper (cppzmq)
* google-gflags
* googletest
* gcovr (for code coverage reports)
* python-yaml
* python-jinja2
* pkg-config

Arch Linux::

  pacman --needed -S cmake gcc zeromq cppzmq gtest python-yaml python-jinja gflags gcovr

Debian/Ubuntu::

  apt-get install build-essential cmake libzmq3-dev libcppzmq-dev python3-yaml \
      python3-jinja2 libgtest-dev libgflags-dev gcovr pkg-config




Installation with CMake
=======================

The goal of installing Stechec2 with CMake is to deploy its libraries and binaries on the system (excluding the tools).  
Only games that support the CMake build system use this method.

Clone the Stechec2 repository::

  git clone https://github.com/prologin/stechec2
  cd stechec2

Build Stechec2::

  cmake -S . -B build_release -DCMAKE_BUILD_TYPE="Release" -DBUILD_TESTING=OFF -DBUILD_GAMES=OFF
  cmake --build build_release
  cmake --install build_release

Stechec2 is now installed on the system.

Contributing with CMake
=======================

The steps are quite similar to those in *Installation with CMake*.

Build Stechec2::

  cmake -S . -B build -DCMAKE_BUILD_TYPE="Debug" -DBUILD_TESTING=ON -DBUILD_GAMES=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
  cd build && make -j$(nproc)

To enable Clang sanitizers, add these flags::

  -DCMAKE_CXX_FLAGS="-fsanitize=address" -DCMAKE_EXE_LINKER_FLAGS="-fsanitize=address"

Run tests::

  cd build
  ctest --output-on-failure .

To use `GDB <https://www.gnu.org/savannah-checkouts/gnu/gdb/index.html>`_ (or other cool tools like `rr <https://rr-project.org/>`_),
you don't need to use ``ctest``. Instead, run the test binaries directly from the build folder.

Generate the player environment
---------------------------------

To generate the player environment (different folders for each supported
languages), you can use the ``stechec2-generator`` script installed by
stechec2::

  stechec2-generator player tictactoe player_env

Install languages dependencies
------------------------------

Requirements:

- php (warning: you may need to add ``open_basedir=/`` to your
  ``/etc/php/php.ini``)
- php-embed
- ocaml
- mono
- jdk-java
- ghc
- rustc
- python-dev
- js91

Archlinux::

  pacman --needed -S php php-embed ocaml mono jdk11-openjdk ghc rust js91

Debian/Ubuntu::

  apt-get install php-cli php-dev libphp-embed ocaml mono-devel ghc \
                  openjdk-11-jdk rustc python3-dev mozjs91

Create your AI
--------------

You should now be able to choose your favorite language folder and begin to
code::

  cd player_env/python/
  $EDITOR prologin.py
  make

To create a tarball containing all your source files (you can add some by
editing the Makefile), do::

  make tar

Launch a match
--------------

To launch a match, you need to launch a ``stechec2-server`` and one
``stechec2-client`` per player. There is a wrapper called ``stechec2-run``
which runs everything you need in separate child processes, and only needs a
tiny YAML configuration file to work.

A simple ``config.yml`` could be::

  rules: /usr/lib/libtictactoe.so
  map: ./simple.map
  verbose: 3
  clients:
    - ./champion.so
    - /path/to/other/champion.so
  names:
    - Player 1
    - Player 2

Then you can just launch the match easily::

  stechec2-run config.yml

Add spectators
--------------

Spectators are players that don't take part of the game, but can watch its
different states during the match (to display it or to log it, for instance).

Make sure to compile your spectator first::

  cd /path/to/prologin2014/gui
  make

Then you just have to add those lines to the ``config.yml``::

  spectators:
   - /path/to/prologin2014/gui/gui.so

Testing The environment
-----------------------

Ensuring the environment is properly set up is crucial for the tools to function correctly.

A first test to check if the environment is properly set up is to compile all the champions.
The tests of stechec2-generator do this effectively.::

  cd ./tools
  python3 -m unittest discover -s ./generator/test
