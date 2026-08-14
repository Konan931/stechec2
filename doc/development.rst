.. _development:

===========
Development
===========

If you intend to contribute to Stechec2 or if you want to write your own game,
here are useful tricks to ease your task. As a general note: you may be
interested in looking at the available CMake options (``cmake -S . -B build -LH``)
to discover available build options.

To build with debugging information (to use GDB or any other debugger):

.. code-block:: bash

  cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON -DBUILD_GAMES=ON
  cmake --build build -j$(nproc)


Using Clang
-----------

If you prefer Clang over GCC (for error messages, for instance), you can
configure Stechec2 the following way (assuming you properly installed Clang++):

.. code-block:: bash

  cmake -S . -B build -DCMAKE_CXX_COMPILER=clang++

Then build the project as usual.


Code coverage
-------------

`Code coverage <http://en.wikipedia.org/wiki/Code_coverage>`_ is basically the
answer to "what part of the code is really executed?". It is particularly
useful in the context of a testsuite. When some code is not covered (i.e. never
executed), two conclusions can be drawed:

* either your testsuite misses testcases;

* either you have code that is useless... and thus that uselessly complexifies
  your codebase.

In order to compute code coverage reports, build Stechec2 with coverage
instrumentation, run the tests, then generate a report with ``gcovr``:

.. code-block:: bash

  cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
      -DCMAKE_CXX_FLAGS="--coverage" -DCMAKE_EXE_LINKER_FLAGS="--coverage"
  cmake --build build -j$(nproc)
  cd build && ctest --output-on-failure
  gcovr -r .. --html --html-details -o coverage/gcov-report.html

At this point, you can open the ``build/coverage/gcov-report.html`` file in your
favorite browser and discover what parts of your code are not tested/useless!

Note that code coverage does not work very well when using another compiler
than G++. So please use G++ when you want to compute code coverage. :-)


Address sanitizer
-----------------

GCC or LLVM's `address sanitizer
<http://en.wikipedia.org/wiki/AddressSanitizer>`_ is as useful as Valgrind when
programming with manual memory management (such as in C or C++) to detect
various memory issues. To enable it:

.. code-block:: bash

  cmake -S . -B build -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_CXX_FLAGS="-fsanitize=address" \
      -DCMAKE_EXE_LINKER_FLAGS="-fsanitize=address"

ASAN will output messages on Stechec2's standard error output if it detects
any issue. Note that when this happens in our testsuite, the corresponding
testcases fail (which is good! such issues must be fixed!).
